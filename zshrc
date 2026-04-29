# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Shell integrations (load early for plugins and aliases that depend on them)
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# FUNCTIONS (autoloaded from ~/.dotfiles/zsh/functions/autoload/)
# Functions are lazy-loaded on first use for faster startup
FPATH_FUNCS="$HOME/.dotfiles/zsh/functions/autoload"
fpath+=("$FPATH_FUNCS")
# Declare functions to autoload
typeset -a my_functions=(
  gmove killport mkcd cl kebabify run
  list_deno_tasks is_script_in_deno_json
  is_script_in_package_json list_scripts_in_package_json get_package_manager
)

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'

# fzf-tab previews: use eza when available, fallback to ls
if command -v eza >/dev/null 2>&1; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -G $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -G $realpath'
fi

# Load completions
autoload -Uz compinit $my_functions && compinit

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
# Common escape sequences emitted by VS Code / different renderers / meta settings
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Variables
# Disable gatekeeper for Homebrew
export HOMEBREW_CASK_OPTS="--no-quarantine"
# Set default "viewer" (from cat => bat)
export NULLCMD=bat

# PATH configuration
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/.local/share/pnpm"

# Build PATH efficiently
export PATH="$BUN_INSTALL/bin:$PNPM_HOME:$HOME/.local/bin:$HOME/.local/share/jupyter/runtime:$HOME/Projects/code/scripts/bin:$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Aliases

# Shell
alias ".."="cd .."
alias "..."="cd ../.."
alias "...."="cd ../../.."
alias as="alias | grep "
alias c="clear"
alias cat="bat"
alias cd-="z -"
alias cd="z"
alias copy="rsync -ah --info=progress2"
alias cwd="pwd"
alias htop="btop"
alias la="eza -laF --git  --icons --group-directories-first"
alias ll="eza -lF --git --icons --group-directories-first"
alias ls="eza -F --git --icons --group-directories-first"
# List directory in tree format with icons and limit depth to 2
alias lst="eza -lF --git --tree --icons --level=2"
alias top="btop"
# Print each element of PATH on a new line
alias trail="<<<${(F)path}"
alias z-="z -"
alias zz="z -"
# Update all package managers and system software
alias update="brew update && brew upgrade && tldr --update && mas upgrade && system_update"
alias system_update="sudo softwareupdate --install --all --verbose"
alias python="python3"
alias vsc="code ."

# ZSH
alias zshrc="code ~/.dotfiles && code ~/.zshrc"

# GIT
alias gac="git add -A && git commit -m"
# List git branches with detailed formatted information
alias gbr+="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias gca="git commit --amend --no-edit"
# Clean merged local git branches excluding main, master, and dev
alias gclean="git remote prune origin && git switch main && git branch --merged | grep -Ev '(^\*|master|main|dev)' | xargs git branch -d"
alias gco---="git checkout @{-3}"
alias gco--="git checkout @{-2}"
alias gco-="git checkout -"
alias gco-2="gco--"
alias gco-3="gco---"
alias gcod="git checkout dev"
alias gcom="git checkout main"
alias gdel="git branch -D"
alias gla="git pull --all && git fetch --all"
alias glm="glol main..HEAD"
alias gstat="git shortlog -sne --since='1 year ago'"
# Show last commit with formatted details
alias glast="git log -1 --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\""
# Display a graphical git log for commits on current branch with formatting
function glm() {
  git log "$(get_default_branch)..HEAD" --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"
}
alias glolm="glm"
# Graphical git log with commit stats
function glolsm() {
    git log "$(get_default_branch)..HEAD" --stat --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"
}
alias glog1m="glol --since='1 month ago'"
alias glog1y="glol --since='1 year ago'"
alias glogg-="glol --grep="
# Display a graphical git log for commits on current branch with formatting
alias glolm="git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\" main..HEAD"
# Graphical git log with commit stats
alias glolsm="glolm --stat"
alias gmm="git merge main"
# Switch to main branch and update remote branches
alias gmu="git switch main && git pull --all && git fetch --all"
# Push current branch with setting upstream tracking
alias gpo="git push --set-upstream origin \$(git branch --show-current)"
alias gpf="git push --force-with-lease"
alias gt="git tag"
alias gta="git tag -a"
alias gundo="git reset --soft HEAD^"

# Brew
alias bbd="brew bundle dump --force --describe --file='~/.dotfiles/Brewfile'"
alias bubu="brew update && brew upgrade"

# Pnpm
alias pm="pnpm"
alias pad="pnpm add -d"
alias pb="pnpm build"
alias pd="pnpm dev"
alias pdev="pnpm dev"
alias pf="pnpm format"
alias pi="pnpm install"
alias plf="pnpm lint:fix"
alias pln="pnpm lint"
alias prm="pnpm remove"
alias prun="pnpm run"
alias pst="pnpm start"
alias pt="pnpm test"

# Yarn
alias ylf="yarn lint:fix"
alias yst="BROWSER=none yarn start"
alias yta="yarn test:all"

# Bun
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

# Deno
alias dd="deno doc"
alias df="deno fmt"
alias dl="deno lint"
alias dr="deno run"
alias dta="deno task"
alias dt="deno test"
alias dtw="deno test --watch"
alias dtc="deno task check" # something like "deno lint && deno fmt && deno test --reporter=dot --coverage --parallel"
alias dtd="deno task dev" # something like "deno lint --watch & deno fmt --watch & deno run --allow-net --allow-env --allow-read --watch ./path/to/entry.ts" 
alias dtdoc="deno task docs" # something like "deno doc --html --name='name-of-my-app' ./path/to/entry.ts"
alias dtl="deno task cache" # something like "deno cache --lock=deno.lock --lock-write ./path/to/entry.ts"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
