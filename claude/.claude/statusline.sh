#!/bin/bash

# 彩色表情符号状态栏

# 检查系统依赖
check_system_dependencies() {
    local missing_deps=()

    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi

    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi

    if ! command -v gtimeout &> /dev/null && ! command -v timeout &> /dev/null; then
        missing_deps+=("timeout/gtimeout")
    fi

    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo "缺少必要工具：${missing_deps[*]}" >&2
        echo "请安装这些工具后重新运行脚本" >&2
        return 1
    fi

    return 0
}

# 读取JSON输入
input=$(cat)

# 检查系统依赖（如果缺少必要工具，给出警告但继续运行）
if ! check_system_dependencies; then
    echo "警告：由于缺少必要工具，某些功能可能无法正常工作" >&2
fi

# 提取：工作目录、模型名称、ID、成本信息和转录文件路径
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "unknown"' 2>/dev/null | sed "s|^$HOME|~|g")
model_name=$(echo "$input" | jq -r '.model.display_name' 2>/dev/null || echo "")
model_id=$(echo "$input" | jq -r '.model.id' 2>/dev/null || echo "")
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd' 2>/dev/null || echo "0.00")
transcript_path=$(echo "$input" | jq -r '.transcript_path' 2>/dev/null || echo "")
exceeds_200k=$(echo "$input" | jq -r '.exceeds_200k_tokens' 2>/dev/null || echo "false")

# 如果没有获取到模型名，使用默认值
if [ -z "$model_name" ] || [ "$model_name" = "null" ]; then
    model_name="Sonnet 4"
fi

# 如果没有获取到成本信息，设置默认值
if [ -z "$total_cost" ] || [ "$total_cost" = "null" ]; then
    total_cost="0.00"
fi

# 判断模型是否有1M上下文
has_1m_context=false
if [[ "$model_name" == *"[1m]"* ]] || [[ "$model_name" == *"1m"* ]] || [[ "$model_id" == *"1m"* ]] || [[ "$model_id" == *"-1m-"* ]]; then
    has_1m_context=true
fi

# 构建模型名部分
formatted_cost=$(printf "%.2f" "$total_cost")
if [ "$has_1m_context" = true ] && [[ "$model_name" != *"(with 1M token context)"* ]]; then
    model_name_only="${model_name} (with 1M token context)"
elif [[ "$model_name" == *"(with 1M token context)"* ]]; then
    model_name_only="${model_name}"
else
    model_name_only="${model_name}"
fi

# === 获取上下文使用量信息 ===
get_context_usage() {
    local transcript_path="$1"
    local context_length=0

    if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
        # 读取JSONL文件的最后几行，寻找最新的usage信息
        context_length=$(tail -20 "$transcript_path" | while IFS= read -r line; do
            if [ -n "$line" ]; then
                # 提取message.usage信息并计算上下文长度
                input_tokens=$(echo "$line" | jq -r '.message.usage.input_tokens // 0' 2>/dev/null)
                cache_read=$(echo "$line" | jq -r '.message.usage.cache_read_input_tokens // 0' 2>/dev/null)
                cache_creation=$(echo "$line" | jq -r '.message.usage.cache_creation_input_tokens // 0' 2>/dev/null)

                if [ "$input_tokens" != "0" ] || [ "$cache_read" != "0" ] || [ "$cache_creation" != "0" ]; then
                    echo $((input_tokens + cache_read + cache_creation))
                fi
            fi
        done | tail -1)
    fi

    echo "${context_length:-0}"
}

# 计算上下文使用量和进度
context_tokens=$(get_context_usage "$transcript_path")
context_max=200000  # 200k tokens
context_percentage=0

if [ "$context_tokens" -gt 0 ]; then
    context_percentage=$((context_tokens * 100 / context_max))
    if [ "$context_percentage" -gt 100 ]; then
        context_percentage=100
    fi
fi

# ---- basic colors ----
rst='\033[0m'
dot_color='\033[38;2;128;128;128m' # cyan
dir_color='\033[1;36m'
# 用户信息渐变色 (荧光绿)
username_colors=("174;155;2" "174;180;2" "174;205;2" "174;230;2" "174;255;2")
# 模型信息渐变色 (橙色到黄色)
model_colors=(
    "255;165;0" "255;175;0" "255;185;0" "255;195;0" "255;205;0"
    "255;215;0" "255;225;0" "255;235;0" "255;245;0" "255;255;0"
    "255;255;0" "255;255;0" "255;255;0" "255;255;0" "255;255;0"
    "255;255;0" "255;255;0" "255;255;0" "255;255;0" "255;255;0"
)

big_dot="${dot_color}•${rst}"
small_dot="${dot_color}·${rst}"

# ---- git colors ----
git_color='\e[0;33m' # Yellow

# ---- git ----
git_branch=""
if git rev-parse --git-dir >/dev/null 2>&1; then
    git_branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
fi

# 格式化上下文显示 - 显示百分比和颜色
format_context_display() {
    local percentage="$1"
    local exceeds="$2"

    # 根据百分比设置颜色
    local color
    if [ "$exceeds" = "true" ] || [ "$percentage" -ge 90 ]; then
        color="248;18;81"    # 红色 #F81251
    elif [ "$percentage" -ge 50 ]; then
        color="252;228;43"   # 黄色 #FCE42B
    else
        color="165;254;0"    # 绿色 #A5FE00
    fi

    echo $'\033[38;2;'"${color}"'m'"${percentage}%""${rst}"
}

context_display=$(format_context_display "$context_percentage" "$exceeds_200k")

# 成本部分
cost_text="\$${formatted_cost}"

# === 构建渐变色 ===

gradient_model=""
for i in $(seq 0 $((${#model_name_only} - 1))); do
    char="${model_name_only:$i:1}"
    color_index=$((i % ${#model_colors[@]}))
    color="${model_colors[$color_index]}"
    gradient_model="${gradient_model}\033[38;2;${color}m${char}"
done

# 成本部分 (橙色)
gradient_cost="\033[38;2;255;165;0m${cost_text}${rst}"

# 程序员名字
username="程序员Alan(alans.top)"
username_gradient=""
for i in $(seq 0 $((${#username} - 1))); do
    char="${username:$i:1}"
    if [ $i -lt ${#username_colors[@]} ]; then
        color="${username_colors[$i]}"
    else
        color="174;255;2"
    fi
    username_gradient="${username_gradient}\033[1;38;2;${color}m${char}"
done
gradient_username="${username_gradient}"

# === 输出状态栏 ===
# 格式：工作目录 • 程序员Alan(alans.top) • ✨ 模型名 · $成本 · 上下文百分比
printf "📁 %b 🌿 %b $big_dot %b $big_dot ✨ %b $small_dot %b $small_dot %b\n" \
    "$dir_color$current_dir" "$git_color$git_branch" "$gradient_username" "$gradient_model" "$gradient_cost" "$context_display"
