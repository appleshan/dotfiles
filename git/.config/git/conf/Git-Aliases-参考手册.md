# Git Aliases 配置详解

本文档详细解释 `aliases.gitconfig` 中的所有配置和命令。

## 核心架构

**第 3-4 行：自定义变量**
```gitconfig
[gitalias "topic.base.branch"]
    name = main
```
定义了 topic 工作流的基础分支，默认为 `main`。这是整个工作流的锚点。

## Topic 工作流核心命令

### 分支管理相关（18-21 行）

```gitconfig
set-global-base-branch = config --global gitalias.topic.base.branch.name
set-local-base-branch = config --local gitalias.topic.base.branch.name
set-bb = "!git set-local-base-branch"
bb = "!git base-branch"
```
- `set-bb`: 设置当前仓库的 base 分支
- `bb`: 查询当前 base 分支

### topic-new-remote（39-52 行）

```bash
topic-new-remote = "!f(){ \
    topic_branch=$1; \
    base_branch=${2:-$(git base-branch)}; \
    base_exists_in_remote=$(git remote-branch $base_branch); \
    current_branch=$(git current-branch); \
    if [ -n \"$(git working-dir-dirty)\" ]; then \
        echo \"============= Autosaving current working directory in branch: $current_branch ============\" \
        git save \"Autosave on topic-new-remote: $topic_branch\"; \
    fi; \
    if [ -n \"$base_exists_in_remote\" ] && [ $(git behind-count $base_branch) -gt 0 ] ; then \
        git pull origin $base_branch ; \
    fi; \
    git checkout -b $topic_branch $base_branch && git push -u origin $topic_branch; \
    };f"
```

**功能流程：**
1. 接受参数：topic 分支名（必需）、base 分支（可选，默认用配置的 base-branch）
2. **安全检查**：如果工作区脏（有未提交修改），自动 stash 保存
3. **同步检查**：如果 base 分支在远程存在且本地落后，先 pull
4. **创建分支**：从 base 分支创建新的 topic 分支并推送到远程
5. **设置追踪**：`-u` 参数让本地分支追踪远程分支

**别名：** `tnr`

### topic-new-local（56-65 行）

本地版本，不推送到远程，逻辑更简单：
- 检查工作区 → 自动保存 → 创建本地分支

**别名：** `tn`

### topic-merge（72-87 行）

```bash
topic-merge = "!f() { \
    topic_branch=$(git current-branch); \
    base_branch=${1:-$(git base-branch)}; \
    ...
    git checkout $base_branch && git merge --no-ff $topic_branch && git topic-delete $topic_branch; \
    };f"
```

**关键设计：**
- 使用 `--no-ff`（no fast-forward）：强制创建 merge commit，保留分支历史
- **防御性检查**：不能 merge main 或 base 分支自己
- **工作区检查**：脏工作区时拒绝操作
- **自动清理**：merge 后立即删除 topic 分支（安全，因为有 merge 历史）

**别名：** `tmg`

### topic-delete（91-117 行）

最复杂的清理逻辑：

```bash
if [ -n "$topic_exists_in_remote" ]; then
    if [ $(git behind-count $base_branch) -gt 0 ] ; then
        git pull origin $topic_branch;
    elif [ $(git ahead-count $base_branch) -gt 0 ] ; then
        git push origin $topic_branch;
    fi;
    git push origin --delete $topic_branch && git remote-prune-all;
fi;
```

**智能同步：**
1. 如果远程分支存在：
   - 本地落后 → 先 pull
   - 本地领先 → 先 push
2. 删除远程分支
3. 清理本地追踪引用（`remote-prune-all`）
4. 切换到 base 分支
5. 删除本地分支

**别名：** `td`

## 辅助工具命令

### fixup（125-128 行）

```bash
fixup = "!f() { \
    target=$(git fzf-commit $(git oldest-changeable-commit) $(git current-branch)); \
    git commit --fixup=$target && GIT_EDITOR=true git rebase --interactive --autosquash $target~; \
    }; f"
```

修改历史 commit 的优雅方式：
- 用 `fzf` 选择目标 commit
- 创建 fixup commit
- 自动 rebase 并合并到目标 commit
- `GIT_EDITOR=true` 跳过编辑器（无冲突时）

### branch-diff / bdf（131-136 行）

```bash
branch-diff = "!f(){ \
    base_branch=${1:-$(git base-branch)}; \
    common_ancestor=$(git merge-base $base_branch $(git current-branch)); \
    git diff $common_ancestor HEAD; \
    };f"
```

显示当前分支相对于 base 分支的**所有差异**（从分叉点到 HEAD）。

### branch-log / blg（140-146 行）

类似 `branch-diff`，但显示 commit 日志而非文件差异：
- 只显示 topic 分支独有的 commit
- `--boundary` 标记分叉点（用圆圈表示）
- 自定义格式：日期、哈希、作者、GPG 签名状态

### edit-unmerged / add-unmerged（160-161 行）

解决冲突的快捷工具：

```bash
edit-unmerged = "!f() { git diff --name-status --diff-filter=U | cut -f2 ; }; ${EDITOR:-vi} `f`"
add-unmerged = "!f() { git diff --name-status --diff-filter=U | cut -f2 ; }; git add `f`"
```

- `--diff-filter=U`：只选择未合并（Unmerged）的文件
- 工作流：`git edit-unmerged` → 编辑 → `git add-unmerged` → `git commit`

## 常用命令简化

### 分支操作（232-268 行）

```gitconfig
b = branch
bl = "!git branch -av; git remote-prune-all &"  # 显示所有分支并后台清理
blf = "!git branch --all | fzf"                  # fzf 选择分支

z = checkout    # 取名 z 是因为键盘上 z 比 co 好按
zz = "!git checkout $(git base-branch)"          # 快速回 base
zm = checkout main
```

**branch-move / bmv（253-262 行）：**
```bash
branch-move = "!f(){ \
    new_branch=$1; \
    old_branch=$(git current-branch); \
    exists_in_remote=$(git remote-branch); \
    git branch --move $old_branch $new_branch; \
    if [ -n \"$exists_in_remote\" ]; then \
        git push origin :$old_branch $new_branch; \
    fi; \
    };f"
```
重命名分支，如果存在远程分支则同步重命名。

**branch-clean-local/remote（265-267 行）：**
```bash
branch-clean-local = "!git branch --merged | egrep -v \"(^\\*|main|dev|$(git base-branch))\" | xargs git branch -d"
branch-clean-remote = "!git branch -r --merged | egrep -v \"(^\\*|main|dev|$(git base-branch))\" | sed 's/origin\\///' | xargs -n 1 git push origin --delete"
```
删除所有已合并到 main 的本地/远程分支，保护 main/dev/base-branch。

### commit 操作（270-309 行）

**基本别名：**
```gitconfig
c = commit
ca = commit -a
cam = commit -a --message
```

**safe-commit-amend 系列：**

```bash
safe-commit-amend = "!f() { \
    HEAD_commit_exists_in_remote=$(git branch -r --contains HEAD); \
    if [ -n \"$HEAD_commit_exists_in_remote\" ]; then \
       echo 'HEAD commit exists in remote and you should not amend it. Please make another commit.'; \
       return; \
    fi; \
    git commit --amend; \
}; f"
```

**安全保证：**只允许 amend 尚未推送的 commit，防止改写远程历史。

**快捷组合：**
- `cmd = safe-commit-amend-no-edit` → 安全 amend，不编辑消息
- `cmde = safe-commit-amend` → 安全 amend，可编辑消息
- `cmu = "!git add --update && git safe-commit-amend-no-edit"` → 修改文件加到上次 commit
- `cmue = "!git add --update && git safe-commit-amend"` → 修改文件加到上次 commit（可编辑）
- `cma = "!git add --all && git safe-commit-amend-no-edit"` → 所有变更加到上次 commit
- `cmae = "!git add --all && git safe-commit-amend"` → 所有变更加到上次 commit（可编辑）

### checkout 操作（311-317 行）

```gitconfig
co = checkout
cob = checkout -b
co-rs = checkout --    # 恢复文件到 HEAD 状态
```

### cherry-pick（319-330 行）

```gitconfig
pi = cherry-pick
pif = "!git fzf-commit-multi | xargs -n 1 git cherry-pick"  # fzf 多选 commit
pia = cherry-pick --abort
picc = cherry-pick --continue
pi-nx = cherry-pick --no-commit -x
```

`pif` 用 fzf 多选 commit 然后批量 cherry-pick。

### clean 操作（332-338 行）

```gitconfig
dry = clean -d --dry-run  # 预览会删除什么
cl = clean -d -i          # 交互式删除未追踪文件和空目录
clx = clean -d -x -i      # 同时删除 ignored 文件
```

**ignore-untracked（338 行）：**
```bash
ignore-untracked = "!git status | grep -P \"^\\t\" | grep -vF .gitignore | sed \"s/^\\t//\" >> .gitignore"
```
将所有未追踪文件添加到 `.gitignore`。

### diff 操作（341-347 行）

```gitconfig
d = diff
df = diff
dc = diff --cached    # 查看已暂存的变更
```

### grep / ripgrep（349-355 行）

```gitconfig
rg = !rg $(git rev-parse --show-toplevel) --column --smart-case -e
rg-ls = !rg $(git rev-parse --show-toplevel) --files
rg-all = !rg $(git rev-parse --show-toplevel) --column --smart-case --no-ignore --hidden -g '!.git' -e
rg-all-ls = !rg $(git rev-parse --show-toplevel) --no-ignore --hidden -g '!.git' --files
```

在仓库根目录运行 ripgrep，无论当前在哪个子目录。
- `rg`: 普通搜索（遵守 .gitignore）
- `rg-all`: 搜索所有文件（包括 ignored 和 hidden）

### log 查看（357-364 行）

```gitconfig
lg = "!git log -${1:-10} --all --color=always --abbrev=12 --graph --topo-order --date=format:'%Y-%m-%d %H:%M:%S' --boundary \
            --pretty=format:'%C(yellow)%d%Creset %s %Cblue[%cn] %Cgreen%ad - %C(magenta)%h'; #"
ll = "!${EDITOR:-vi} --git-log"  # 需要编辑器支持（如 nvim 的 Flog 插件）
```

**lg 特性：**
- 默认显示最近 10 条（可传参数改变）
- 图形化显示分支
- 自定义颜色格式：分支（黄）、消息、作者（蓝）、日期（绿）、哈希（洋红）

### merge 操作（366-383 行）

```gitconfig
mg = merge
mgnf = merge --no-ff
mgc = "!git add --update && git merge --continue"
mgt = mergetool
mgd = "!git merge $1 && git branch -d $1; #"  # merge 并删除分支
```

**日志查看：**
```gitconfig
merge-log = log --oneline --left-right HEAD...MERGE_HEAD      # 显示两条分支的所有提交
conflict-log = log --oneline --left-right --merge             # 只显示冲突的提交
```

### rebase 操作（385-404 行）

```gitconfig
r = rebase
ra = rebase --abort
rc = "!git add --update && git rebase --continue"
```

**branch-rebase / ri（392-400 行）：**
```bash
branch-rebase = "!f(){ \
    base_branch=${1:-$(git base-branch)}; \
    common_ancestor=$(git merge-base $base_branch $(git current-branch)); \
    if [ $base_branch = $(git current-branch) ]; then \
        common_ancestor=$(git merge-base origin/$(git remote-branch) $(git current-branch)); \
    fi; \
    git rebase -i $common_ancestor; \
};f"
```

**智能边界：**
- 在 topic 分支上：rebase 到与 base 的分叉点
- 在 base 分支上：rebase 到未推送的 commit（origin 和本地的分叉点）

### remote 操作（406-423 行）

```gitconfig
ro = remote
ros = "!git remote show ${1:-origin}"
remote-prune-all = !git remote | xargs -n 1 git remote prune  # 清理所有远程的失效追踪
```

**分支发布/撤销：**
```gitconfig
publish = "!git push -u origin ${1:-$(git current-branch)}"
unpublish = "!git push origin --delete ${1:-$(git current-branch)} && git branch --unset-upstream ${1:-$(git current-branch)}"
remote-untrack = "!git branch --unset-upstream ${1:-$(git current-branch)}"
```

**code-review（422 行）：**
```bash
code-review = "!git difftool origin/$(git current-branch)"
```
用 difftool 查看本地分支相对于远程的所有变更。

### reset 操作（425-429 行）

```gitconfig
rs = reset
rss = reset --soft
rsh = reset --hard
```

### revert 操作（431-437 行）

```gitconfig
rv = revert
rvn = revert --no-commit  # 撤销但不自动提交，可手动编辑
```

### stash/save/snapshot（439-486 行）

**save（446-453 行）：**
```bash
save = "!f() { \
    custom_message=$1; \
    WIP_message=WIP; \
    if [ -n \"$custom_message\" ]; then \
        WIP_message=\"$WIP_message: $custom_message\"; \
    fi; \
    git stash push -m \"$WIP_message - $(date '+%Y-%m-%d %H:%M:%S') - Base commit: $(git log -1 HEAD --pretty=format:'%h %s') \"; \
};f"
```

增强版 stash，自动记录：
- 时间戳
- 基础 commit 信息
- 自定义消息（可选）

**其他别名：**
```gitconfig
sapply = "!git stash apply $1"
pop = stash pop
drop = stash drop
sl = stash list
```

**snapshot（470-477 行）：**
```bash
snapshot = "!f() { \
    custom_message=$1; \
    Snapshot_message=Snapshot; \
    if [ -n \"$custom_message\" ]; then \
        Snapshot_message=\"$Snapshot_message $custom_message\"; \
    fi; \
    git save \"Snapshot $1\" && git stash apply 0 >/dev/null 2>&1; \
};f"
```

**妙处：**创建 stash 但不清空工作区（apply 后立即恢复）。用于"保险备份"场景。

**stash-history / sh（482-485 行）：**
```bash
stash-history = "!f() { \
    git fsck --unreachable | grep commit | cut -d\\  -f3 | xargs git log -15 --oneline --merges --no-walk --grep=WIP; \
};f"
```

找回"丢失"的 stash（即使 `stash drop` 了也能恢复，因为 Git 垃圾回收前它们仍在）。

### submodule 操作（488-500 行）

```gitconfig
sm = submodule
smi = submodule init
sma = submodule add
sms = submodule sync
smu = submodule update
smui = submodule update --init
smuir = submodule update --init --recursive
```

### undo 操作（502-516 行）

```gitconfig
uncommit = reset --soft HEAD~1              # 撤销 commit，保留 add
uncommit-n = "!git reset --soft HEAD~$1; #" # 撤销 n 个 commit
uncommit-h = reset --hard HEAD~1            # 撤销 commit 并清空工作区
uncommit-hn = "!git reset --hard HEAD~$1; #"

unadd = reset HEAD
untrack = rm --cache --
unstage = reset HEAD
discard = checkout --    # 放弃工作区的修改
```

### Worktree 操作（518-527 行）

```gitconfig
W = worktree
Wa = worktree add
Wls = worktree list
Wmv = worktree move
Wp = worktree prune
Wrm = worktree remove
Wrmf = worktree remove --force
```

### 短别名（530-540 行）

```gitconfig
ps = push
ft = fetch
pl = pull
ref = reflog --no-abbrev
s = status --short --branch
```

## Shell 脚本辅助函数（542-620 行）

这些是给其他 alias 用的底层工具：

### 基础工具

**root-dir（546 行）：**
```gitconfig
root-dir = rev-parse --show-toplevel
```
获取 Git 仓库根目录。

**first-commit（549 行）：**
```gitconfig
first-commit = rev-list --max-parents=0 HEAD
```
获取仓库的第一个 commit 哈希。

**current-branch（596 行）：**
```gitconfig
current-branch = rev-parse --abbrev-ref HEAD
```

**base-branch（617-619 行）：**
```bash
base-branch = "!f(){ \
    git config --get gitalias.topic.base.branch.name || printf '%s\\n' main; \
};f"
```
获取配置的 base 分支，默认为 main。

### 状态检查工具

**working-dir-dirty（572 行）：**
```bash
working-dir-dirty = "!git diff --stat | head -n -1"
```
如果有未提交更改，返回非空字符串（用于 if 判断）。

**remote-branch（600-603 行）：**
```bash
remote-branch = "!f() { \
    current_branch=${1:-$(git current-branch)}; \
    git branch -r | awk '{print $1}' | awk -F '/' '{if($2~/'$current_branch'/)print $2}'; \
}; f"
```
检查本地分支在远程是否存在，返回远程分支名。

**ahead-count / behind-count（607-609 行）：**
```bash
ahead-count = "!local_branch=${1:-$(git current-branch)} && git rev-list --count origin/$local_branch..$local_branch"
behind-count = "!local_branch=${1:-$(git current-branch)} && git rev-list --count $local_branch..origin/$local_branch"
```
计算本地分支与远程的领先/落后 commit 数。

### 交互式工具

**fzf-commit（552-559 行）：**
```bash
fzf-commit = "!f() { \
    left=${1:-$(git first-commit)}; \
    right=${2:-$(git current-branch)}; \
    commit_hash=$(git log $left..$right --color=always --topo-order --date=format:'%Y-%m-%d %H:%M:%S' --abbrev-commit \
            --pretty=format:'%Cgreen%ad %C(yellow)%d%Creset %s %Cblue[%cn]%Creset %Cblue%G?%Creset - %Cred%H%Creset' \
            | fzf | awk '{print $NF}'); \
    echo $commit_hash; \
    };f"
```
用 fzf 交互式选择**单个** commit，返回完整哈希。

**fzf-commit-multi（562-568 行）：**
```bash
fzf-commit-multi = "!f() { \
    left=${1:-$(git first-commit)}; \
    right=${2:-$(git current-branch)}; \
    git log --all --color=always --graph --topo-order --date=format:'%Y-%m-%d %H:%M:%S' --abbrev-commit \
            --pretty=format:' %Cgreen%ad %C(yellow)%d%Creset %s %Cblue[%cn]%Creset %Cblue%G?%Creset - %Cred%H%Creset' \
            | fzf | awk '{print $NF}' | xargs -n 1 echo; \
    };f"
```
用 fzf 选择**多个** commit（支持 Tab 多选）。
**调用方式：** `git fzf-commit-multi | xargs -n 1 <command>`

### 边界计算

**oldest-changeable-commit（575-591 行）：**
```bash
oldest-changeable-commit = "!f() { \
    oldest_commit='' \
    current_branch=$(git current-branch); \
    base_branch=${1:-$(git base-branch)}; \
    common_ancestor=$(git merge-base $base_branch $current_branch); \
    current_exists_in_remote=$(git remote-branch); \
    base_exists_in_remote=$(git remote-branch $base_branch); \
    if [ -n \"$current_exists_in_remote\" ]; then \
        oldest_commit=origin/$current_branch; \
    elif [ -n \"$base_exists_in_remote\" ]; then \
        oldest_commit=origin/$base_branch; \
    else \
        oldest_commit=$common_ancestor; \
    fi; \
    echo $oldest_commit; \
    };f"
```

计算最远的可以安全改变的 commit（用于 rebase/fixup）：
1. 如果当前分支有远程分支 → 不能改变已推送的 commit
2. 否则如果 base 分支有远程 → 不能改变 base 的已推送 commit
3. 都没有 → 可以改变到分叉点

### 其他辅助

**top-name（594 行）：**
```gitconfig
top-name = rev-parse --show-toplevel
```
获取仓库根目录完整路径。

**upstream-name（612 行）：**
```bash
upstream-name = "!git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD)"
```
获取当前分支的上游分支名。

**exec（615 行）：**
```gitconfig
exec = ! exec
```
在仓库根目录执行 shell 命令。

## 其他实用命令（623-680 行）

### 仓库初始化

**init-empty（626-628 行）：**
```bash
init-empty = "!f() { \
    git init && git commit --allow-empty --allow-empty-message --message ''; \
}; f"
```
初始化仓库并创建空的初始 commit（让 rebase 更容易）。

### 文件列表

```gitconfig
ls = ls-files
ls-ignored = ls-files --others -i --exclude-standard
```

### 危险操作

**expunge（640-646 行）：**
```bash
expunge = "!f() { \
    git filter-branch \
    --force \
    --index-filter \"git rm --cached --ignore-unmatch $1\" \
    --prune-empty \
    --tag-name-filter cat -- --all \
}; f"
```
**警告：**从整个历史中彻底删除文件（用于误提交敏感数据）。需要 force push。

**recreate（654-662 行）：**
```bash
recreate = "!f() { \
    [[ -n $@ ]] && \
    git checkout \"$@\" && \
    git unpublish && \
    git checkout main && \
    git branch -D \"$@\" && \
    git checkout -b \"$@\" && \
    git publish; \
}; f"
```
删除并重建分支（基于 main 的最新状态）。

### 信息查询

```gitconfig
ahead = "!git log --oneline origin/$(git current-branch)..HEAD"  # 显示未推送的 commit
last = log -1 HEAD                                               # 最后一个 commit
whorank = shortlog --summary --numbered --no-merges             # 贡献者排行
```

**abbr（675 行）：**
```bash
abbr = "!sh -c 'git rev-list --all | grep ^$1 | while read commit; do git --no-pager log -n1 --pretty=format:\"%H\" $commit; done' -"
```
将缩写哈希扩展为完整哈希（处理哈希冲突）。

**aliases（677-679 行）：**
```bash
aliases = "!f() { \
    git config list | grep '^alias\\.' | cut -c 7-; \
}; f"
```
列出所有已定义的 alias。

### 同步与更新

```gitconfig
get = !git pull --rebase && git submodule update --init --recursive
push-to-all-remotes = !git remote | xargs -I% -n1 git push %
```

## 工作流总结

这套配置实现了完整的 **feature branch workflow**：

### 典型开发流程

```bash
# 1. 创建新功能分支
git tnr feature/user-auth

# 2. 开发中临时保存
git save "WIP: implementing login"

# 3. 查看分支独有的修改
git blg           # 日志
git bdf           # 差异

# 4. 修改历史 commit
git fixup         # 交互式选择要修改的 commit

# 5. 合并回主分支
git tmg           # merge 并自动删除 feature 分支

# 6. 清理已合并的分支
git branch-clean-local
```

### 高级操作

```bash
# 重命名分支（本地+远程）
git bmv new-feature-name

# 找回丢失的 stash
git sh

# 解决冲突
git edit-unmerged    # 编辑冲突文件
git add-unmerged     # 标记已解决
git mgc              # 继续 merge

# 查看未推送的提交
git ahead

# 代码审查
git code-review
```

### 安全特性

1. **防止改写远程历史：** `safe-commit-amend` 系列只允许 amend 未推送的 commit
2. **自动保存工作区：** topic 系列命令在切换分支前自动 stash
3. **智能同步：** `topic-delete` 在删除前自动 push/pull
4. **分支保护：** `branch-clean-*` 永远不会删除 main/dev/base-branch

### 设计思想

1. **安全第一**：所有破坏性操作前检查工作区、远程状态
2. **自动化**：减少手动操作（自动 stash、自动同步、自动清理）
3. **可追溯**：`--no-ff` merge 保留分支历史
4. **交互友好**：fzf 集成让选择更直观
5. **模式匹配**：DRY 原则，复用底层辅助函数

## 最佳实践

1. **用 `save` 而非原生 `stash`**：更好的注释，包含时间戳和 base commit
2. **用 `safe-commit-amend` 系列**：防止改写远程历史
3. **定期清理分支**：`git branch-clean-local`
4. **用 `fixup` 修改历史**：比手动 rebase 更优雅
5. **用 `snapshot` 做保险备份**：不影响工作区的安全快照
6. **用 `blg` 查看分支历史**：只显示分支独有的 commit
7. **用 `bdf` 查看累积差异**：从分叉点到现在的所有变更

## 依赖工具

- **ripgrep (rg)**：高性能文本搜索
- **fzf**：模糊查找工具
- **git-extras**：额外的 Git 命令集（部分功能）

## 配置建议

### 设置项目的 base 分支

```bash
# 全局设置（所有仓库）
git set-global-base-branch main

# 当前仓库设置
git set-bb develop
```

### 查看当前 base 分支

```bash
git bb
```

---

**总结：**这是一套生产级的 Git 配置，明显经过实战打磨。作者对 Git 的理解很深，且注重工程实践中的安全性和效率。配置中的每个 alias 都经过深思熟虑，既考虑了便利性，也考虑了安全性。
