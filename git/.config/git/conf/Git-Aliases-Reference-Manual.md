# Git Aliases Configuration Guide

This document provides a detailed explanation of all configurations and commands in `aliases.gitconfig`.

## Core Architecture

**Lines 3-4: Custom Variables**
```gitconfig
[gitalias "topic.base.branch"]
    name = main
```
Defines the base branch for the topic workflow, defaulting to `main`. This is the anchor point for the entire workflow.

## Topic Workflow Core Commands

### Branch Management (Lines 18-22)

```gitconfig
set-global-base-branch = config --global gitalias.topic.base.branch.name
set-local-base-branch = config --local gitalias.topic.base.branch.name
set-bb = "!git set-local-base-branch"
bb = "!git base-branch"
```
- `set-bb`: Set the base branch for the current repository
- `bb`: Query the current base branch

### topic-new-remote (Lines 39-52)

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

**Function Flow:**
1. Accept parameters: topic branch name (required), base branch (optional, defaults to configured base-branch)
2. **Safety Check**: If working directory is dirty (has uncommitted changes), automatically stash
3. **Sync Check**: If base branch exists remotely and local is behind, pull first
4. **Create Branch**: Create new topic branch from base branch and push to remote
5. **Set Tracking**: `-u` flag makes local branch track remote branch

**Alias:** `tnr`

### topic-new-local (Lines 56-65)

Local version, does not push to remote, simpler logic:
- Check working directory → Autosave → Create local branch

**Alias:** `tn`

### topic-merge (Lines 72-87)

```bash
topic-merge = "!f() { \
    topic_branch=$(git current-branch); \
    base_branch=${1:-$(git base-branch)}; \
    ...
    git checkout $base_branch && git merge --no-ff $topic_branch && git topic-delete $topic_branch; \
    };f"
```

**Key Design:**
- Uses `--no-ff` (no fast-forward): Forces creation of merge commit, preserving branch history
- **Defensive Checks**: Cannot merge main or base branch into itself
- **Working Directory Check**: Refuses operation when working directory is dirty
- **Automatic Cleanup**: Immediately deletes topic branch after merge (safe because merge history is preserved)

**Alias:** `tmg`

### topic-delete (Lines 91-117)

Most complex cleanup logic:

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

**Smart Sync:**
1. If remote branch exists:
   - Local behind → Pull first
   - Local ahead → Push first
2. Delete remote branch
3. Cleanup local tracking references (`remote-prune-all`)
4. Switch to base branch
5. Delete local branch

**Alias:** `td`

## Auxiliary Tool Commands

### fixup (Lines 125-128)

```bash
fixup = "!f() { \
    target=$(git fzf-commit $(git oldest-changeable-commit) $(git current-branch)); \
    git commit --fixup=$target && GIT_EDITOR=true git rebase --interactive --autosquash $target~; \
    }; f"
```

Elegant way to modify historical commits:
- Use `fzf` to select target commit
- Create fixup commit
- Automatically rebase and squash into target commit
- `GIT_EDITOR=true` skips editor (when no conflicts)

### branch-diff / bdf (Lines 131-136)

```bash
branch-diff = "!f(){ \
    base_branch=${1:-$(git base-branch)}; \
    common_ancestor=$(git merge-base $base_branch $(git current-branch)); \
    git diff $common_ancestor HEAD; \
    };f"
```

Shows **all differences** of the current branch relative to the base branch (from the divergence point to HEAD).

### branch-log / blg (Lines 140-146)

Similar to `branch-diff`, but shows commit log instead of file differences:
- Only shows commits unique to the topic branch
- `--boundary` marks the divergence point (displayed as a circle)
- Custom format: date, hash, author, GPG signature status

### edit-unmerged / add-unmerged (Lines 160-161)

Shortcut tools for conflict resolution:

```bash
edit-unmerged = "!f() { git diff --name-status --diff-filter=U | cut -f2 ; }; ${EDITOR:-vi} `f`"
add-unmerged = "!f() { git diff --name-status --diff-filter=U | cut -f2 ; }; git add `f`"
```

- `--diff-filter=U`: Only select Unmerged files
- Workflow: `git edit-unmerged` → Edit → `git add-unmerged` → `git commit`

## Common Command Shortcuts

### Branch Operations (Lines 236-272)

```gitconfig
b = branch
bl = "!git branch -av; git remote-prune-all &"  # Show all branches and clean up in background
blf = "!git branch --all | fzf"                  # fzf branch selection

z = checkout    # Named z because it's easier to press than co on keyboard
zz = "!git checkout $(git base-branch)"          # Quick return to base
zm = checkout main
```

**branch-move / bmv (Lines 257-266):**
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
Rename branch, and if remote branch exists, rename it synchronously.

**branch-clean-local/remote (Lines 269-271):**
```bash
branch-clean-local = "!git branch --merged | egrep -v \"(^\\*|main|dev|$(git base-branch))\" | xargs git branch -d"
branch-clean-remote = "!git branch -r --merged | egrep -v \"(^\\*|main|dev|$(git base-branch))\" | sed 's/origin\\///' | xargs -n 1 git push origin --delete"
```
Delete all local/remote branches merged into main, protecting main/dev/base-branch.

### Commit Operations (Lines 274-313)

**Basic Aliases:**
```gitconfig
c = commit
ca = commit -a
cam = commit -a --message
```

**safe-commit-amend Series:**

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

**Safety Guarantee:** Only allows amending commits that have not been pushed, preventing rewriting remote history.

**Shortcut Combinations:**
- `cmd = safe-commit-amend-no-edit` → Safe amend without editing message
- `cmde = safe-commit-amend` → Safe amend with message editing
- `cmu = "!git add --update && git safe-commit-amend-no-edit"` → Add modified files to last commit
- `cmue = "!git add --update && git safe-commit-amend"` → Add modified files to last commit (editable)
- `cma = "!git add --all && git safe-commit-amend-no-edit"` → Add all changes to last commit
- `cmae = "!git add --all && git safe-commit-amend"` → Add all changes to last commit (editable)

### Checkout Operations (Lines 315-321)

```gitconfig
co = checkout
cob = checkout -b
co-rs = checkout --    # Restore file to HEAD state
```

### cherry-pick (Lines 323-334)

```gitconfig
pi = cherry-pick
pif = "!git fzf-commit-multi | xargs -n 1 git cherry-pick"  # fzf multi-select commits
pia = cherry-pick --abort
picc = cherry-pick --continue
pi-nx = cherry-pick --no-commit -x
```

`pif` uses fzf to multi-select commits and batch cherry-pick them.

### Clean Operations (Lines 336-343)

```gitconfig
dry = clean -d --dry-run  # Preview what will be deleted
cl = clean -d -i          # Interactively delete untracked files and empty directories
clx = clean -d -x -i      # Also delete ignored files
```

**ignore-untracked (Line 342):**
```bash
ignore-untracked = "!git status | grep -P \"^\\t\" | grep -vF .gitignore | sed \"s/^\\t//\" >> .gitignore"
```
Add all untracked files to `.gitignore`.

### Diff Operations (Lines 345-351)

```gitconfig
d = diff
df = diff
dc = diff --cached    # View staged changes
```

### grep / ripgrep (Lines 353-359)

```gitconfig
rg = !rg $(git rev-parse --show-toplevel) --column --smart-case -e
rg-ls = !rg $(git rev-parse --show-toplevel) --files
rg-all = !rg $(git rev-parse --show-toplevel) --column --smart-case --no-ignore --hidden -g '!.git' -e
rg-all-ls = !rg $(git rev-parse --show-toplevel) --no-ignore --hidden -g '!.git' --files
```

Run ripgrep from repository root, regardless of current subdirectory.
- `rg`: Normal search (respects .gitignore)
- `rg-all`: Search all files (including ignored and hidden)

### Log Viewing (Lines 361-370)

```gitconfig
lg = "!git log -${1:-10} --all --color=always --abbrev=12 --graph --topo-order --date=format:'%Y-%m-%d %H:%M:%S' --boundary \
            --pretty=format:'%C(yellow)%d%Creset %s %Cblue[%cn] %Cgreen%ad - %C(magenta)%h'; #"
ll = "!${EDITOR:-vi} --git-log"  # Requires editor support (e.g., nvim's Flog plugin)
```

**lg Features:**
- Defaults to show last 10 entries (can be changed with parameter)
- Graphical branch display
- Custom color format: branch (yellow), message, author (blue), date (green), hash (magenta)

### Merge Operations (Lines 372-389)

```gitconfig
mg = merge
mgnf = merge --no-ff
mgc = "!git add --update && git merge --continue"
mgt = mergetool
mgd = "!git merge $1 && git branch -d $1; #"  # Merge and delete branch
```

**Log Viewing:**
```gitconfig
merge-log = log --oneline --left-right HEAD...MERGE_HEAD      # Show all commits from both branches
conflict-log = log --oneline --left-right --merge             # Show only conflicting commits
```

### Rebase Operations (Lines 391-410)

```gitconfig
r = rebase
ra = rebase --abort
rc = "!git add --update && git rebase --continue"
```

**branch-rebase / ri (Lines 398-406):**
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

**Smart Boundaries:**
- On topic branch: rebase to divergence point with base
- On base branch: rebase to unpushed commits (divergence point between origin and local)

### Remote Operations (Lines 412-429)

```gitconfig
ro = remote
ros = "!git remote show ${1:-origin}"
remote-prune-all = !git remote | xargs -n 1 git remote prune  # Clean up stale tracking for all remotes
```

**Branch Publish/Unpublish:**
```gitconfig
publish = "!git push -u origin ${1:-$(git current-branch)}"
unpublish = "!git push origin --delete ${1:-$(git current-branch)} && git branch --unset-upstream ${1:-$(git current-branch)}"
remote-untrack = "!git branch --unset-upstream ${1:-$(git current-branch)}"
```

**code-review (Line 428):**
```bash
code-review = "!git difftool origin/$(git current-branch)"
```
Use difftool to view all changes of local branch relative to remote.

### Reset Operations (Lines 431-435)

```gitconfig
rs = reset
rss = reset --soft
rsh = reset --hard
```

### Revert Operations (Lines 437-443)

```gitconfig
rv = revert
rvn = revert --no-commit  # Revert but don't auto-commit, allow manual editing
```

### stash/save/snapshot (Lines 445-492)

**save (Lines 452-459):**
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

Enhanced stash that automatically records:
- Timestamp
- Base commit information
- Custom message (optional)

**Other Aliases:**
```gitconfig
sapply = "!git stash apply $1"
pop = stash pop
drop = stash drop
sl = stash list
```

**snapshot (Lines 476-483):**
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

**Clever Feature:** Creates stash but doesn't clear working tree (restores immediately with apply). Used for "insurance backup" scenarios.

**stash-history / sh (Lines 488-491):**
```bash
stash-history = "!f() { \
    git fsck --unreachable | grep commit | cut -d\\  -f3 | xargs git log -15 --oneline --merges --no-walk --grep=WIP; \
};f"
```

Recover "lost" stashes (can restore even after `stash drop`, since they remain until Git garbage collection).

### Submodule Operations (Lines 494-506)

```gitconfig
sm = submodule
smi = submodule init
sma = submodule add
sms = submodule sync
smu = submodule update
smui = submodule update --init
smuir = submodule update --init --recursive
```

### Undo Operations (Lines 508-522)

```gitconfig
uncommit = reset --soft HEAD~1              # Undo commit, keep staged changes
uncommit-n = "!git reset --soft HEAD~$1; #" # Undo n commits
uncommit-h = reset --hard HEAD~1            # Undo commit and clear working tree
uncommit-hn = "!git reset --hard HEAD~$1; #"

unadd = reset HEAD
untrack = rm --cache --
unstage = reset HEAD
discard = checkout --    # Discard changes in working tree
```

### Worktree Operations (Lines 524-533)

```gitconfig
W = worktree
Wa = worktree add
Wls = worktree list
Wmv = worktree move
Wp = worktree prune
Wrm = worktree remove
Wrmf = worktree remove --force
```

### Short Aliases (Lines 536-546)

```gitconfig
ps = push
ft = fetch
pl = pull
ref = reflog --no-abbrev
s = status --short --branch
```

## Shell Script Helper Functions (Lines 548-626)

These are low-level tools used by other aliases:

### Basic Tools

**root-dir (Line 552):**
```gitconfig
root-dir = rev-parse --show-toplevel
```
Get Git repository root directory.

**first-commit (Line 555):**
```gitconfig
first-commit = rev-list --max-parents=0 HEAD
```
Get the first commit hash of the repository.

**current-branch (Line 602):**
```gitconfig
current-branch = rev-parse --abbrev-ref HEAD
```

**base-branch (Lines 623-625):**
```bash
base-branch = "!f(){ \
    git config --get gitalias.topic.base.branch.name || printf '%s\\n' main; \
};f"
```
Get configured base branch, defaulting to main.

### Status Check Tools

**working-dir-dirty (Line 578):**
```bash
working-dir-dirty = "!git diff --stat | head -n -1"
```
If there are uncommitted changes, returns non-empty string (for use in if statements).

**remote-branch (Lines 606-609):**
```bash
remote-branch = "!f() { \
    current_branch=${1:-$(git current-branch)}; \
    git branch -r | awk '{print $1}' | awk -F '/' '{if($2~/'$current_branch'/)print $2}'; \
}; f"
```
Check if local branch exists on remote, returns remote branch name.

**ahead-count / behind-count (Lines 613-615):**
```bash
ahead-count = "!local_branch=${1:-$(git current-branch)} && git rev-list --count origin/$local_branch..$local_branch"
behind-count = "!local_branch=${1:-$(git current-branch)} && git rev-list --count $local_branch..origin/$local_branch"
```
Calculate how many commits local branch is ahead of/behind remote.

### Interactive Tools

**fzf-commit (Lines 558-565):**
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
Interactively select **single** commit with fzf, returns full hash.

**fzf-commit-multi (Lines 568-574):**
```bash
fzf-commit-multi = "!f() { \
    left=${1:-$(git first-commit)}; \
    right=${2:-$(git current-branch)}; \
    git log --all --color=always --graph --topo-order --date=format:'%Y-%m-%d %H:%M:%S' --abbrev-commit \
            --pretty=format:' %Cgreen%ad %C(yellow)%d%Creset %s %Cblue[%cn]%Creset %Cblue%G?%Creset - %Cred%H%Creset' \
            | fzf | awk '{print $NF}' | xargs -n 1 echo; \
    };f"
```
Select **multiple** commits with fzf (Tab for multi-select).
**Usage:** `git fzf-commit-multi | xargs -n 1 <command>`

### Boundary Calculation

**oldest-changeable-commit (Lines 582-597):**
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

Calculate the oldest commit that can be safely changed (for rebase/fixup):
1. If current branch has remote branch → Cannot change pushed commits
2. Otherwise if base branch has remote → Cannot change pushed commits of base
3. If neither has remote → Can change up to divergence point

### Other Helpers

**top-name (Line 600):**
```gitconfig
top-name = rev-parse --show-toplevel
```
Get repository root directory full path.

**upstream-name (Line 618):**
```bash
upstream-name = "!git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD)"
```
Get upstream branch name of current branch.

**exec (Line 621):**
```gitconfig
exec = ! exec
```
Execute shell command in repository root directory.

## Other Utility Commands (Lines 629-686)

### Repository Initialization

**init-empty (Lines 632-634):**
```bash
init-empty = "!f() { \
    git init && git commit --allow-empty --allow-empty-message --message ''; \
}; f"
```
Initialize repository and create empty initial commit (makes rebase easier).

### File Listing

```gitconfig
ls = ls-files
ls-ignored = ls-files --others -i --exclude-standard
```

### Dangerous Operations

**expunge (Lines 646-652):**
```bash
expunge = "!f() { \
    git filter-branch \
    --force \
    --index-filter \"git rm --cached --ignore-unmatch $1\" \
    --prune-empty \
    --tag-name-filter cat -- --all \
}; f"
```
**Warning:** Completely remove file from entire history (for accidentally committed sensitive data). Requires force push.

**recreate (Lines 660-668):**
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
Delete and rebuild branch (based on latest state of main).

### Information Queries

```gitconfig
ahead = "!git log --oneline origin/$(git current-branch)..HEAD"  # Show unpushed commits
last = log -1 HEAD                                               # Last commit
whorank = shortlog --summary --numbered --no-merges             # Contributor rankings
```

**abbr (Line 681):**
```bash
abbr = "!sh -c 'git rev-list --all | grep ^$1 | while read commit; do git --no-pager log -n1 --pretty=format:\"%H\" $commit; done' -"
```
Expand abbreviated hash to full hash (handles hash collisions).

**aliases (Lines 683-685):**
```bash
aliases = "!f() { \
    git config list | grep '^alias\\.' | cut -c 7-; \
}; f"
```
List all defined aliases.

### Sync and Update

```gitconfig
get = !git pull --rebase && git submodule update --init --recursive
push-to-all-remotes = !git remote | xargs -I% -n1 git push %
```

## Workflow Summary

This configuration implements a complete **feature branch workflow**:

### Typical Development Flow

```bash
# 1. Create new feature branch
git tnr feature/user-auth

# 2. Save work in progress during development
git save "WIP: implementing login"

# 3. View branch-specific changes
git blg           # Log
git bdf           # Diff

# 4. Modify historical commits
git fixup         # Interactively select commit to modify

# 5. Merge back to main branch
git tmg           # Merge and auto-delete feature branch

# 6. Clean up merged branches
git branch-clean-local
```

### Advanced Operations

```bash
# Rename branch (local + remote)
git bmv new-feature-name

# Recover lost stash
git sh

# Resolve conflicts
git edit-unmerged    # Edit conflicting files
git add-unmerged     # Mark as resolved
git mgc              # Continue merge

# View unpushed commits
git ahead

# Code review
git code-review
```

### Safety Features

1. **Prevent rewriting remote history:** `safe-commit-amend` series only allows amending unpushed commits
2. **Auto-save working tree:** Topic series commands automatically stash before switching branches
3. **Smart sync:** `topic-delete` automatically push/pull before deletion
4. **Branch protection:** `branch-clean-*` never deletes main/dev/base-branch

### Design Philosophy

1. **Safety First**: Check working tree and remote state before all destructive operations
2. **Automation**: Reduce manual operations (auto stash, auto sync, auto cleanup)
3. **Traceability**: `--no-ff` merge preserves branch history
4. **Interactive Friendly**: fzf integration makes selections more intuitive
5. **Pattern Matching**: DRY principle, reusing low-level helper functions

## Best Practices

1. **Use `save` instead of native `stash`**: Better comments, includes timestamp and base commit
2. **Use `safe-commit-amend` series**: Prevents rewriting remote history
3. **Regularly clean branches**: `git branch-clean-local`
4. **Use `fixup` to modify history**: More elegant than manual rebase
5. **Use `snapshot` for insurance backup**: Safe snapshot without affecting working tree
6. **Use `blg` to view branch history**: Only shows commits unique to branch
7. **Use `bdf` to view cumulative diff**: All changes from divergence point to now

## Dependencies

- **ripgrep (rg)**: High-performance text search
- **fzf**: Fuzzy finder tool
- **git-extras**: Additional Git command set (partial functionality)

## Configuration Recommendations

### Set Project Base Branch

```bash
# Global setting (all repositories)
git set-global-base-branch main

# Current repository setting
git set-bb develop
```

### View Current Base Branch

```bash
git bb
```

---

**Summary:** This is a production-grade Git configuration, clearly refined through real-world experience. The author has deep understanding of Git and emphasizes both safety and efficiency in engineering practices. Each alias in the configuration has been carefully considered, balancing convenience with safety.
