#!/bin/bash

# 显示：天气图标 + 体感温度，整合和风天气信息

# ==================== 天气配置区域 ====================
# 和风天气API配置
WEATHER_LOCATION="101280101"  # 城市代码，广州
WEATHER_LANG="zh"             # 语言设置
WEATHER_UNIT="m"              # 单位制：m=公制，i=英制
WEATHER_TIMEOUT=2             # API请求超时时间（秒）

# JWT Token配置（用于和风天气API认证）
PRIVATE_KEY="MC4CAQAwBQYDK2VwBCIEIMY01MmC3hDLAI9VceCc6yNktI/S1tsRW6DbC7KZQtFG"
KEY_ID="CNGTB5BHGN"
PROJECT_ID="2K2BUG5QKA"

# 默认天气显示（当API访问失败时使用）
DEFAULT_WEATHER_EMOJI="🌤️"
DEFAULT_WEATHER_TEMP="--"

# 检查系统依赖
check_system_dependencies() {
    local missing_deps=()

    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi

    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi

    if ! command -v timeout &> /dev/null; then
        missing_deps+=("timeout")
    fi

    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo "缺少必要工具：${missing_deps[*]}" >&2
        echo "请安装这些工具后重新运行脚本" >&2
        return 1
    fi

    return 0
}

# 检查系统依赖（如果缺少必要工具，给出警告但继续运行）
if ! check_system_dependencies; then
    echo "警告：由于缺少必要工具，某些功能可能无法正常工作" >&2
fi

# === 获取天气信息 ===
get_weather_emoji() {
    local icon_code="$1"
    case "$icon_code" in
        100) echo "🌞" ;; # 晴
        101) echo "☁️" ;; # 多云
        102|103) echo "⛅" ;; # 少云/晴间多云
        104) echo "☁️" ;; # 阴
        150) echo "🌙" ;; # 晴(夜间)
        151) echo "☁️" ;; # 多云(夜间)
        152|153) echo "🌤️" ;; # 少云(夜间)
        300) echo "🌦️" ;; # 阵雨
        301|302|303|304) echo "⛈️" ;; # 强阵雨/雷阵雨
        305) echo "🌦️" ;; # 小雨
        306|307|308|309|310|311|312|313|314|315|316|317|318|399) echo "🌧️" ;; # 各种雨
        400|401) echo "🌨️" ;; # 小雪/中雪
        402|403) echo "❄️" ;; # 大雪/暴雪
        404|405|406|407|408|409|410|499) echo "🌨️" ;; # 雨雪相关
        500|501|502|503|504|507|508|509|510|511|512|513|514|515) echo "🌁" ;; # 雾/霾/沙尘
        900) echo "🥵" ;; # 热
        901) echo "🥶" ;; # 冷
        *) echo "🌤️" ;; # 默认
    esac
}

# 检查Python依赖
check_python_dependencies() {
    if ! command -v python3 &> /dev/null; then
        echo "未找到python3，无法生成JWT token" >&2
        return 1
    fi

    if ! python3 -c "import jwt" 2>/dev/null; then
        echo "缺少Python库：PyJWT，请运行：pip3 install PyJWT" >&2
        return 1
    fi

    return 0
}

# 生成JWT token的内联函数
generate_jwt_token() {
    if ! check_python_dependencies; then
        return 1
    fi

    python3 -c "
import jwt
import time

PRIVATE_KEY = \"\"\"-----BEGIN PRIVATE KEY-----
$PRIVATE_KEY
-----END PRIVATE KEY-----\"\"\"

KEY_ID = \"$KEY_ID\"
PROJECT_ID = \"$PROJECT_ID\"

try:
    iat = int(time.time()) - 30
    exp = iat + 900
    headers = {'alg': 'EdDSA', 'kid': KEY_ID}
    payload = {'sub': PROJECT_ID, 'iat': iat, 'exp': exp}
    token = jwt.encode(payload, PRIVATE_KEY, algorithm='EdDSA', headers=headers)
    print(token)
except Exception as e:
    exit(1)
" 2>/dev/null
}

weather_info=""
weather_emoji="$DEFAULT_WEATHER_EMOJI"
feels_like="$DEFAULT_WEATHER_TEMP"

# 调用和风天气API获取数据
jwt_token=$(generate_jwt_token)
if [ -n "$jwt_token" ]; then
    weather_json=$(timeout ${WEATHER_TIMEOUT}s curl -s --compressed -H "Authorization: Bearer $jwt_token" \
        "https://kw59fc43yp.re.qweatherapi.com/v7/weather/now?location=${WEATHER_LOCATION}&lang=${WEATHER_LANG}&unit=${WEATHER_UNIT}" 2>/dev/null)

    # 检查API调用是否成功
    if [ $? -eq 0 ] && [ -n "$weather_json" ]; then
        # 解析天气JSON
        api_code=$(echo "$weather_json" | jq -r '.code // ""' 2>/dev/null)

        case "$api_code" in
            "200")
                # API调用成功，解析天气数据
                feels_like=$(echo "$weather_json" | jq -r '.now.feelsLike // "--"' 2>/dev/null)
                icon_code=$(echo "$weather_json" | jq -r '.now.icon // "999"' 2>/dev/null)
                fx_link=$(echo "$weather_json" | jq -r '.fxLink // ""' 2>/dev/null)
                weather_emoji=$(get_weather_emoji "$icon_code")

                # 如果成功获取天气，构建天气信息部分
                if [ "$feels_like" != "--" ] && [ "$feels_like" != "null" ]; then
                    weather_info="${weather_emoji} ${feels_like}°C"
                fi
                ;;
            "401"|"403")
                # Token认证失败
                echo "天气API认证失败，请检查配置" >&2
                ;;
            "404")
                # 城市代码无效
                echo "天气API：城市代码无效，请检查WEATHER_LOCATION配置" >&2
                ;;
            "429")
                # API调用频率限制
                echo "天气API调用频率超限" >&2
                ;;
            *)
                # 其他API错误
                echo "天气API返回错误代码: $api_code" >&2
                ;;
        esac
    else
        # 网络请求失败
        echo "天气API网络请求失败，可能原因：网络连接问题或API服务器不可达" >&2
    fi
else
    # JWT Token生成失败
    echo "JWT Token生成失败，请检查PRIVATE_KEY、KEY_ID、PROJECT_ID配置" >&2
fi

# === 输出状态栏 ===
# 格式：天气图标 体感温度 • 
printf "$weather_info"
