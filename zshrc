### Prompt stack: Starship + Zinit (clean, fast)

# Plugins: Zinit replaces OMZ plugin loading (fast lazy/turbo load)
# Bootstrap Zinit if missing, then source it
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" && ! -f "$HOME/.zinit/bin/zinit.zsh" && ! -f "$ZINIT_HOME/zinit.git/zinit.zsh" ]]; then
  curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/refs/heads/main/scripts/install.sh | bash
fi
# Source zinit from common install locations
if [[ -f "$ZINIT_HOME/zinit.zsh" ]]; then
  source "$ZINIT_HOME/zinit.zsh"
elif [[ -f "$ZINIT_HOME/zinit.git/zinit.zsh" ]]; then
  source "$ZINIT_HOME/zinit.git/zinit.zsh"
elif [[ -f "$HOME/.zinit/bin/zinit.zsh" ]]; then
  source "$HOME/.zinit/bin/zinit.zsh"
fi

# Core plugins
zinit light zsh-users/zsh-autosuggestions
# Faster than zsh-syntax-highlighting; if you prefer the original, replace with zsh-users/zsh-syntax-highlighting and keep it last.
zinit light zdharma-continuum/fast-syntax-highlighting

# OMZ plugin equivalents via snippets (preserve DX)
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/bun/bun.plugin.zsh

# Keep fzf init from local install (already sourced below)
# Keep zoxide init (already present below)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='nano'
# else
#   export EDITOR='nano'
# fi

# VARIABLES

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# Disable gatekeeper for Homebrew
export HOMEBREW_CASK_OPTS="--no-quarantine"
# Set default "viewer" (from cat => bat)
export NULLCMD=bat
export N_PREFIX="$HOME/.n"
export PREFIX="$N_PREFIX"

# HISTORY

# These options prevent duplicates.
setopt HIST_IGNORE_DUPS      # Ignore command if it is the same as the previous one
setopt HIST_IGNORE_ALL_DUPS  # Remove older duplicate entries when adding a new one
setopt HIST_SAVE_NO_DUPS     # Do not write duplicate entries to the history file
setopt HIST_FIND_NO_DUPS     # Do not show duplicates during history search

# ALIASES

# Shell
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
alias gclean="git remote prune origin && git switch main | git branch --merged | egrep -v '(^\*|master|main|dev)' | xargs git branch -d"
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

# PNPM
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

# YARN
alias ylf="yarn lint:fix"
alias yst="BROWSER=none yarn start"
alias yta="yarn test:all"

# BUN
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
alias dtd="deno task docs" # something like "deno doc --html --name='name-of-my-app' ./path/to/entry.ts"
alias dtl="deno task cache" # something like "deno cache --lock=deno.lock --lock-write ./path/to/entry.ts"

# FUNCTIONS (autoloaded from ~/.dotfiles/zsh/functions/autoload/)
# Functions are lazy-loaded on first use for faster startup
FPATH_FUNCS="$HOME/.dotfiles/zsh/functions/autoload"
fpath+=("$FPATH_FUNCS")

# Declare functions to autoload
typeset -a my_funcs=(
  gmove killport mkcd cl kebabify
  list_deno_tasks is_script_in_deno_json
  is_script_in_package_json list_scripts_in_package_json get_package_manager
)

autoload -Uz $my_funcs

# Prompt: Starship configured in ~/.config/starship.toml

# fzf (fuzzy finder)
export FZF_BASE="/usr/bin/fzf/"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Add Locations to $PATH Variables

export PATH="$N_PREFIX/bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Python
export PATH="$HOME/.local/bin:$PATH"

# Jupyter
export PATH="$HOME/.local/share/jupyter/runtime:$PATH"

# Add my scripts to $PATH
export PATH="$HOME/Projects/code/scripts/bin:$PATH"

# Initialize zoxide
eval "$(zoxide init zsh)"

# Command not found
HOMEBREW_COMMAND_NOT_FOUND_HANDLER="$(brew --repository)/Library/Homebrew/command-not-found/handler.sh"
if [ -f "$HOMEBREW_COMMAND_NOT_FOUND_HANDLER" ]; then
  source "$HOMEBREW_COMMAND_NOT_FOUND_HANDLER";
fi

# Common escape sequences emitted by VS Code / different renderers / meta settings
# Bind all to be safe (duplicate binds are harmless)
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

# Initialize Starship prompt (fast, cross-shell). See ~/.config/starship.toml for config.
eval "$(starship init zsh)"
### End of shell init
