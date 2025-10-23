# Git 别名使用手册

# 概览

- 核心设定: gitalias.topic.base.branch.name 默认值为 main，可用 git set-global-base-branch（全局）或 git set-bb（当前仓库）修改。
- 使用前提: 仅支持单一远程 origin，且本地分支名称必须与远程一致。
- 别名来源: 主要取自 GitAlias 项目并结合定制脚本，全部集中在 [alias] 区块。
- 基线管理:
  - `git set-bb <branch>` 设置当前仓库的 Topic 基线；
  - `git bb` 随时查看；
  - `git zz` 一键回到基线分支。

# Topic 工作流

- 启动分支:
  - `git tnr <topic> [base]` 创建并推送 Topic 分支；
  - `git tn` 只在本地创建，必要时自动调用 `git save` 保存未提交工作。
- 合并分支:
  - `git tmg [base]` 将当前 Topic 分支以 `--no-ff` 合并进基线分支并自动清理 Topic 分支。
- 清理分支:
  - `git td [topic]` 安全删除本地与远程 Topic 分支，删除前会先同步远程状态。
- 差异与历史:
  - `git bdf [base]` 对比当前分支与基线公共祖先差异；
  - `git blg [count|base]` 展示 Topic 分支独有提交的拓扑图。

# 分支与历史

- 快捷切换:
  - `git zz` 回到 base-branch；
  - `git zm` 切回 main；
  - `git zd` 指向 dev；
  - `git zb <name>` 新建分支。
- 分支管理:
  - `git bmv <new>` 重命名分支；
  - `git bd <name>` / `git bdd <name>` 删除分支；
  - `git bl` 查看分支并清理远程；
  - `git blf` 筛选分支；
  - `git bm` / `git bnm` 检查合并状态。
- 日志查看:
  - `git lg [n]` 输出彩色图形化日志；
  - `git ll` 调用编辑器的日志界面；
  - `git ahead`、`git ahead-count`、`git behind-count` 查看领先/落后远程的提交。
- 查看标签:
  - `git tags <pattern>` 查看标签。
- 回顾 reflog:
  - `git ref` 回顾 `reflog`。
- 贡献统计:
  - `git whorank` 统计贡献。
- 查询哈希:
  - `git abbr <prefix>` 查询完整哈希。
- 历史改写:
  - `git ri [base]` 自“最早可安全改写提交”向后交互式 rebase；
  - `git fixup` 借助 FZF 选择目标提交并自动执行 `--autosquash`。
- Rebase 操作:
  - `git rc` 继续 Rebase；
  - `git ra` 终止 Rebase。

# 提交与暂存

- 添加文件:
  - `git a` 普通添加；
  - `git aa` 全部添加；
  - `git ap` 交互补丁；
  - `git au` 仅更新追踪文件。
- 常规提交:
  - `git c` / `git ca` / `git caa`。
- 安全 amend:
  - `git cmd` / `git cmde` 禁止修改已推送提交；
  - `git cmu` / `git cmue`、`git cma` / `git cmae` 搭配自动添加。
- 组合操作:
  - `git cap` 一条命令完成提交并推送。
- 工作区暂存:
  - `git save "注释"` 保存工作区修改；`git sapply` 应用最近的 stash；`git pop` 应用并删除最近的 stash。
- 快照管理:
  - `git snapshot [注释]` 创建快照；
  - `git sh` / `git sl` 浏览最近快照；
  - `git drop` 删除快照。
- 状态查看:
  - `git s` 查看精简状态。
- 回滚提交:
  - `git uncommit` / `git uncommit-n` / `git uncommit-h` / `git uncommit-hn` 回滚最近提交。
- 撤销更改:
  - `git unadd` / `git untrack` / `git unstage` / `git discard` 撤销暂存区或工作区更改。
- 重置模式:
  - `git rs` / `git rss` / `git rsh` 快速重置。
- 撤销提交:
  - `git rv` / `git rvn` 撤销历史提交。
- 拣选提交:
  - `git pi` / `git pif` / `git pia` / `git picc` / `git pi-nx` 完整覆盖 cherry-pick 流程。
- 冲突处理:
  - `git edit-unmerged` 打开冲突文件编辑；
  - `git add-unmerged` 一键暂存所有冲突文件。

# 检索与其他功能

- 检索内容:
  - `git rg`、`git rg-all` 在仓库根目录执行 ripgrep，支持隐藏文件及忽略规则开关；
  - `git rg-ls`、`git rg-all-ls` 列出文件。
- 查看差异:
  - `git d` / `git df` / `git dc` / `git df-staged` / `git df-fzf` 从不同角度查看 diff。
- 维护忽略文件:
  - `git adig` / `ignore-untracked` 将未追踪文件添加至 .gitignore。
- 清理未追踪文件:
  - `git dry` 预览；
  - `git cl` / `git clx` 清理未追踪文件。
- 同步远程:
  - `git get` 拉取并同步子模块；
  - `git ps` 推送当前分支到远程；
  - `git ft` 从远程仓库抓取最新提交；
  - `git pl` 拉取远程分支并合并；
  - `git push-to-all-remotes` 推送所有本地分支到所有远程仓库；
  - `git publish` / `git unpublish` 发布/删除远程分支；
  - `git ro` / `git ros` 查看远程信息。
- 子模块:
  - `git sm`、`git smi`、`git sma`、`git sms`、`git smu`、`git smui`、`git smuir` 快速处理子模块。
- 其他维护:
  - `git code-review` 打开审阅工具；
  - `git expunge <path>` 清除敏感文件；
  - `git recreate <branch>` 以 `main` 重建分支。

# 辅助函数

- 状态检测:
  - `git working-dir-dirty` 判断目录是否干净，为多数别名的安全前置检查。
- 上下文信息:
  - `git current-branch` 获取当前分支名称；
  - `git remote-branch [name]` 获取远程分支名称；
  - `git upstream-name` 获取上游分支名称；
  - `git root-dir` 获取仓库根目录；
  - `git top-name` 获取顶层目录名称；
  - `git base-branch` 获取 Topic 基线分支。
- 范围确认:
  - `git oldest-changeable-commit [base]` 定位可安全修改的最旧提交。
- 工具集成:
  - `git fzf-commit(*)` 借助 FZF 交互选 commit；
  - `git exec <命令>` 强制从仓库根目录执行脚本。
