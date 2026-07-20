# Aliases and small shell shortcuts, sourced from ~/.zshrc.

# ── Shell ─────────────────────────────────────────────────────────────────
alias ".."="cd .."
alias "..."="cd ../.."
alias "...."="cd ../../.."
alias as="alias | grep "
alias c="clear"
alias cat="bat"
alias cd="z"
alias cd-="z -"
alias z-="z -"
alias zz="z -"
alias copy="rsync -ah --info=progress2"
alias cwd="pwd"
alias htop="btop"
alias top="btop"
alias la="eza -laF --git --icons --group-directories-first"
alias ll="eza -lF --git --icons --group-directories-first"
alias ls="eza -F --git --icons --group-directories-first"
# Tree view with icons, limited to 2 levels deep
alias lst="eza -lF --git --tree --icons --level=2"
# Print each element of PATH on its own line
alias trail="<<<${(F)path}"
alias python="python3"
alias vsc="code ."
alias oc="opencode"
# Update all package managers and system software
alias update="brew update && brew upgrade && tldr --update && mas upgrade && system_update"
alias system_update="sudo softwareupdate --install --all --verbose"

# ── Editor / dotfiles ─────────────────────────────────────────────────────
alias zshrc="code ~/.dotfiles && code ~/.zshrc"

# ── Git ───────────────────────────────────────────────────────────────────
# Resolve the repo's default branch (main or master), falling back to main.
function get_default_branch() {
  if git show-ref --verify --quiet refs/heads/main; then
    echo "main"
  elif git show-ref --verify --quiet refs/heads/master; then
    echo "master"
  else
    echo "main"
  fi
}

# Shared pretty format for graph logs (DRY).
typeset -g _git_log_pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"

alias gac="git add -A && git commit -m"
alias gca="git commit --amend --no-edit"
alias gdel="git branch -D"
# Branch list with subject, relative date and author, newest first
alias gbr+="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
# Prune remotes, switch to default branch and delete merged local branches
alias gclean="git remote prune origin && git switch \$(get_default_branch) && git branch --merged | grep -Ev '(^\*|master|main|dev|staging)' | xargs git branch -d"

# Checkout shortcuts
alias gco="git checkout"
alias gco-="git checkout -"
alias gco--="git checkout @{-2}"
alias gco---="git checkout @{-3}"
alias gco-2="gco--"
alias gco-3="gco---"
alias gcod="git checkout dev"
alias gcom="git checkout \$(get_default_branch)"
alias gcb="git checkout -b"
alias gcos="git checkout staging"

# Commit
alias gca="git commit --amend --no-edit"
alias gmsg="git commit --message"
alias gaa="git add -A"

# Pull / sync
alias gl="git pull"
alias gla="git pull --all && git fetch --all"
alias gmu="git switch \$(get_default_branch) && git pull --all && git fetch --all"
alias gmm="git merge \$(get_default_branch)"
alias gsu="git switch staging && git pull --all && git fetch --all"

# Push / tag
alias gp="git push"
alias gpo="git push --set-upstream origin \$(git branch --show-current)"
alias gpf="git push --force-with-lease"
alias gt="git tag"
alias gta="git tag -a"
alias gundo="git reset --soft HEAD^"
# Work in progress commit (add all changes, including deletions, and commit with a skip-ci message)
alias gwip="git add -A; git rm \$(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message \"--wip-- [skip ci]\""
alias gunwip="git log -n 1 | grep -q -c \"\\-\\-wip\\-\\-\" && git reset HEAD~1"

# Log
alias glast="git log -1 --pretty=\"$_git_log_pretty\""
alias gstat="git shortlog -sne --since='1 year ago'"
alias glol="git log --graph --pretty=\"$_git_log_pretty\""
alias glols="glol --stat"
alias glolg-="glol --grep="
alias glol1w="glol --since='1 week ago'"
alias glol1m="glol --since='1 month ago'"
alias glol1y="glol --since='1 year ago'"
# Graph/stat log of default-branch..HEAD
function glm()    { git log "$(get_default_branch)..HEAD" --graph --pretty="$_git_log_pretty" }
function glolsm() { git log "$(get_default_branch)..HEAD" --stat  --pretty="$_git_log_pretty" }
alias glolm="glm"

# Status
alias gst="git status"
alias gsts="git status --short"

# ── Homebrew ──────────────────────────────────────────────────────────────
alias bbd="brew bundle dump --force --file=\"\$HOME/.dotfiles/Brewfile\""
alias bubu="brew update && brew upgrade"

# ── pnpm ──────────────────────────────────────────────────────────────────
alias pm="pnpm"
alias pad="pnpm add -d"
alias pb="pnpm build"
alias pd="pnpm dev"
alias pdev="pnpm dev"
alias pf="pnpm format"
alias pin="pnpm install"
alias plf="pnpm lint:fix"
alias pln="pnpm lint"
alias prm="pnpm remove"
alias prun="pnpm run"
alias pst="pnpm start"
alias pt="pnpm test"

# ── Bun ───────────────────────────────────────────────────────────────────
alias b="bun"
alias ba="bun add"
alias bad="bun add -d"
alias bb="bun run build"
alias bdev="bun run dev"
alias bf="bun run format"
alias bi="bun install"
alias blf="bun run lint:fix"
alias bln="bun run lint"
alias brm="bun remove"
alias brun="bun run"
alias bst="bun run start"
alias bt="bun test"

# ── Deno ──────────────────────────────────────────────────────────────────
alias dd="deno doc"
alias df="deno fmt"
alias dl="deno lint"
alias dr="deno run"
alias dt="deno test"
alias dta="deno task"
alias dtw="deno test --watch"
alias dtc="deno task check" # e.g. "deno lint && deno fmt && deno test --reporter=dot --coverage --parallel"
alias dtd="deno task dev"   # e.g. "deno lint --watch & deno fmt --watch & deno run ... --watch ./entry.ts"
alias dtdoc="deno task docs" # e.g. "deno doc --html --name='my-app' ./entry.ts"
alias dtl="deno task cache" # e.g. "deno cache --lock=deno.lock --lock-write ./entry.ts"

# --- Vite --------------------------------------------------------------------
alias vrun="vp run"