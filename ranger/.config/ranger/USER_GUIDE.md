# Ranger 文件管理器使用指南

## 📖 简介

Ranger 是一个基于 Vim 键位的终端文件管理器，采用 Miller Columns 布局（三列视图），提供快速高效的文件操作体验。

## 🎯 核心理念

- **Vim 键位**：hjkl 导航，Vim 式命令
- **Miller Columns**：左列（父目录）、中列（当前目录）、右列（预览）
- **键盘驱动**：所有操作通过快捷键完成
- **可扩展**：支持自定义命令、插件、脚本

---

## 🚀 快速开始

### 启动 Ranger
```bash
ranger                    # 在当前目录启动
ranger /path/to/dir       # 在指定目录启动
ranger --choosedir=/tmp/lastdir  # 退出后保存最后的目录
```

### 界面布局
```
┌─────────────┬─────────────┬─────────────┐
│  父目录     │  当前目录   │   预览/子目录│
│  (左列)     │  (中列)     │   (右列)    │
│             │             │             │
│  ..         │  file1.txt  │  文件内容   │
│  dir1/      │ >file2.py   │  或子目录   │
│  dir2/      │  dir3/      │  列表       │
└─────────────┴─────────────┴─────────────┘
     ↑              ↑              ↑
  按 h 返回    当前位置      按 l 进入
```

---

## ⌨️ 核心快捷键

### 导航 (Navigation)

| 键位 | 功能 | 说明 |
|------|------|------|
| `h` | 返回上级目录 | 移动到左列 |
| `j` | 下移 | 选择下一个文件 |
| `k` | 上移 | 选择上一个文件 |
| `l` | 进入目录/打开文件 | 移动到右列 |
| `gg` | 跳到顶部 | 列表第一项 |
| `G` | 跳到底部 | 列表最后一项 |
| `gh` | 进入 HOME 目录 | `cd ~` |
| `H` | 查看历史记录 | 浏览访问过的目录 |
| `/` | 搜索 | 输入关键词搜索 |
| `n` / `N` | 下一个/上一个搜索结果 | 快速跳转 |
| `f` | 快速查找 | 输入字母快速定位 |

### 文件操作 (File Operations)

| 键位 | 功能 | 说明 |
|------|------|------|
| `Space` | 选择/取消选择 | 标记多个文件 |
| `v` | 全选/反选 | 切换所有文件选择状态 |
| `yy` | 复制 (yank) | 类似 Vim 的 yank |
| `dd` | 剪切 (cut) | 类似 Vim 的 delete |
| `pp` | 粘贴 | 粘贴复制/剪切的文件 |
| `po` | 覆盖粘贴 | 强制覆盖同名文件 |
| `dD` | 删除文件 | 需要确认 |
| `cw` | 重命名 | 修改当前文件名 |
| `I` | 重命名（光标在开头） | 从文件名开始编辑 |
| `A` | 重命名（光标在扩展名前） | 在扩展名前编辑 |
| `:mkdir` | 创建目录 | 命令模式创建文件夹 |
| `:touch` | 创建文件 | 命令模式创建文件 |

### 视图与显示 (View & Display)

| 键位 | 功能 | 说明 |
|------|------|------|
| `zh` | 显示/隐藏文件 | 切换 dotfiles 可见性 |
| `zp` | 切换预览 | 开关右列预览 |
| `zP` | 切换目录预览 | 预览目录内容 |
| `zi` | 切换预览图片 | 在支持的终端显示图片 |
| `i` | 查看文件详情 | 文件大小、权限、时间等 |
| `E` | 编辑文件 | 使用 $EDITOR 打开 |
| `S` | 在当前目录打开 Shell | 退出 shell 返回 ranger |

### 标签与书签 (Tabs & Bookmarks)

| 键位 | 功能 | 说明 |
|------|------|------|
| `gn` / `^N` | 新建标签 | 类似浏览器标签 |
| `gc` / `^W` | 关闭标签 | 关闭当前标签 |
| `Tab` | 下一个标签 | 切换标签 |
| `Shift+Tab` | 上一个标签 | 反向切换 |
| `m<key>` | 创建书签 | 如 `ma` 创建书签 a |
| `` `<key>`` | 跳转到书签 | 如 `` `a`` 跳转到书签 a |
| `um<key>` | 删除书签 | 删除指定书签 |

### 排序 (Sorting)

| 键位 | 功能 |
|------|------|
| `on` | 按名称排序 |
| `os` | 按大小排序 |
| `ot` | 按修改时间排序 |
| `oc` | 按创建时间排序 |
| `oe` | 按扩展名排序 |
| `or` | 反转排序 |

### 其他常用 (Miscellaneous)

| 键位 | 功能 | 说明 |
|------|------|------|
| `?` | 帮助文档 | 查看所有快捷键 |
| `q` | 退出 | 退出 ranger |
| `Q` | 强制退出 | 不保存退出 |
| `R` | 刷新 | 重新加载当前目录 |
| `!` | 执行 Shell 命令 | 如 `!ls -la` |
| `r` | 打开方式 | 选择程序打开文件 |
| `Ctrl+C` | 中止操作 | 取消当前操作 |

---

## 🔥 高级功能

### 1. 批量重命名 (Bulkrename)
```bash
# 在 ranger 中
:bulkrename

# 这会在你的编辑器中打开文件列表
# 修改文件名后保存即可批量重命名
```

### 2. 快速预览
你的配置启用了 `scope.sh` 预览脚本，支持：
- 文本文件：语法高亮（需要 highlight 或 pygmentize）
- 图片：在终端显示（需要 w3m-img 或 ueberzug）
- PDF：转为文本预览（需要 pdftotext）
- 压缩包：列出内容（需要 atool）
- 视频：显示元数据（需要 mediainfo）

### 3. 选择模式
```bash
# 多选文件
Space     # 选择当前文件
v         # 切换全选
uv        # 取消所有选择

# 对选中文件执行操作
yy        # 复制所有选中文件
dd        # 剪切所有选中文件
dD        # 删除所有选中文件
```

### 4. 过滤与搜索
```bash
/pattern    # 搜索包含 pattern 的文件
n           # 下一个结果
N           # 上一个结果

# 过滤（只显示匹配的文件）
zf          # 启用过滤模式
            # 输入正则表达式
zz          # 取消过滤
```

### 5. 自定义命令模式
```bash
:           # 进入命令模式
:shell ls -la          # 执行 shell 命令
:mkdir new_folder      # 创建文件夹
:touch newfile.txt     # 创建文件
:rename newname.txt    # 重命名
:delete                # 删除
```

---

## 🛠️ 你的自定义配置

根据你的 `rc.conf` 配置：

| 设置 | 值 | 说明 |
|------|-----|------|
| `viewmode` | miller | 三列视图（经典模式） |
| `column_ratios` | 3,4 | 左列:中列 = 3:4 比例 |
| `show_hidden` | false | 默认隐藏 dotfiles（按 `zh` 切换） |
| `confirm_on_delete` | multiple | 删除多个文件时需确认 |
| `use_preview_script` | true | 启用 scope.sh 预览增强 |

---

## 💡 实用技巧

### 1. 与 Shell 集成
在 `.zshrc` 或 `.bashrc` 添加：
```bash
# 退出 ranger 后跳转到最后访问的目录
ranger_cd() {
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    if [ -f "$tempfile" ]; then
        local dest="$(cat "$tempfile")"
        rm -f "$tempfile"
        [ -d "$dest" ] && [ "$dest" != "$(pwd)" ] && cd "$dest"
    fi
}

# 使用别名
alias r='ranger_cd'
```

### 2. 快速文件操作流程
```bash
# 复制文件到其他目录
1. 用 Space 选择多个文件
2. 按 yy 复制
3. 导航到目标目录
4. 按 pp 粘贴

# 移动文件
1. 选择文件
2. 按 dd 剪切（而非 yy）
3. 导航到目标目录
4. 按 pp 粘贴
```

### 3. 查找大文件
```bash
:shell du -sh * | sort -hr | head -10
```

### 4. 创建书签常用目录
```bash
# 在常用目录按下
ma      # 创建书签 a（如 ~/Downloads）
mb      # 创建书签 b（如 ~/projects）
md      # 创建书签 d（如 ~/dotfiles）

# 快速跳转
`a      # 跳转到 Downloads
`b      # 跳转到 projects
`d      # 跳转到 dotfiles
```

### 5. 压缩与解压
```bash
# 需要安装 atool
:compress archive.zip      # 压缩选中文件
:extracthere              # 解压到当前目录
```

---

## 🔧 扩展与定制

### 添加自定义命令
编辑 `~/.config/ranger/commands.py`（如不存在则创建）：
```python
from ranger.api.commands import Command

class my_edit(Command):
    """
    :my_edit <filename>
    用 vim 编辑文件
    """
    def execute(self):
        self.fm.edit_file(self.rest(1))
```

### 修改快捷键
编辑 `rc.conf` 末尾添加：
```bash
# 自定义快捷键
map <C-f> fzf_select      # Ctrl+F 使用 fzf 搜索
map <C-g> shell lazygit   # Ctrl+G 打开 lazygit
map DD shell trash %s     # DD 移到回收站而非删除
```

---

## 📚 常见问题

### Q: 如何显示图片预览？
A: 安装 `w3m` 或 `ueberzug`：
```bash
sudo pacman -S w3m          # Arch Linux
```

### Q: 如何语法高亮预览？
A: 安装 `highlight` 或 `pygmentize`：
```bash
sudo pacman -S highlight
```

### Q: 如何在 ranger 中使用 fzf？
A: 添加自定义命令：
```bash
map <C-f> fzf_select
```

### Q: 删除的文件能恢复吗？
A: 默认删除是永久的。建议：
1. 安装 `trash-cli` 或 `gio trash`
2. 将 `DD` 映射为移到回收站

---

## 🎓 学习路径

1. **第一天**：熟悉 hjkl 导航、l 进入、h 返回
2. **第二天**：学会 yy/dd/pp 复制粘贴、Space 选择
3. **第三天**：使用 / 搜索、f 快速定位、书签跳转
4. **第四天**：掌握标签管理、排序功能
5. **第五天**：自定义配置、添加快捷键

---

## 🚀 进阶资源

- 官方文档：`man ranger`
- GitHub: https://github.com/ranger/ranger
- Wiki: https://github.com/ranger/ranger/wiki
- 帮助：在 ranger 中按 `?` 或 `:help`

---

**记住**：Ranger 的核心是 Vim 键位 + Miller Columns。一旦熟悉 Vim，ranger 就是水到渠成。

**Linus 的建议**：别他妈的用鼠标，键盘才是王道。用 ranger 比图形文件管理器快十倍。
