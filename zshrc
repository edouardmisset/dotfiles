# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  alias-tips
  aliases
  bun
  colored-man-pages
  colorize
  command-not-found
  fzf
  git
  history
  vscode
  zoxide
  zsh-autocomplete
  zsh-autosuggestions
  zsh-syntax-highlighting
  )

source $ZSH/oh-my-zsh.sh

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
alias update="brew update && brew upgrade && tldr --update && omz update && mas upgrade && sudo softwareupdate -ia --verbose"

# ZSH
alias p10k="code ~/.p10k.zsh"
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
# Show last commit with formatted details
alias glast="git log -1 --pretty=format:\"%C(auto)%h %s %Cgreen(%ar)\""
alias glol1m="glol --since='1 month ago'"
alias glol1w="glol --since='1 week ago'"
alias glol1y="glol --since='1 year ago'"
alias glolg-="glol --grep="
# Display a graphical git log for commits on current branch with formatting
alias glolm="git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\" main..HEAD"
# Graphical git log with commit stats
alias glolsm="glolm --stat"
alias gmm="git merge main"
# Switch to main branch and update remote branches
alias gmu="git switch main && git pull --all && git fetch --all"
# Push current branch with setting upstream tracking
alias gpo="git push --set-upstream origin $(git_current_branch)"
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

# FUNCTIONS

# You fix the bug, stage only the changes related to the bug and execute
# This will create a branch called bugfix based off master with only the bug fix
function gmove() {
  git stash -- $(git diff --staged --name-only) &&
  gwip ;
  git branch $1 $2 &&
  git checkout $1 &&
  git stash pop
}

# You fix the bug, stage only the changes related to the bug and execute
# This will create a branch called bugfix based off master with only the bug fix
function killport() {
  kill -9 $(lsof -t -i:$1)
}

function mkcd() {
  mkdir -p "$@" && cd "$_"
}

# Go to directory (`cd`) then list what's in it (`ls`)
function cl() {
  DIR="$*";
    # if no DIR given, go home
    if [ $# -lt 1 ]; then
      DIR=$HOME;
  fi;
  builtin cd "${DIR}" && \
  # use your preferred ls command
    ls
}

# Function to rename a file from Pascal case or snake case to kebab case
function kebabify() {
  # Check if at least one filename is provided as an argument
  if [ "$#" -eq 0 ]; then
    echo "Usage: pascal_snake_case_to_kebab <filename1> [<filename2> ...]"
    return 1
  fi

  # Iterate over all provided filenames
  for file in "$@"; do
    # Convert Pascal case or snake case to kebab case using sed and tr
    new_name=$(echo $file | sed -E 's/([a-z0-9])([A-Z])/\1-\2/g; s/_/-/g' | tr '[:upper:]' '[:lower:]')

    # Rename the file
    mv "$file" "$new_name"
    
    echo "File renamed from $file to $new_name"
  done
}

function list_deno_tasks() {
  if ! command -v deno &> /dev/null; then
    echo "Error: deno is not installed"
    return 1
  fi

  echo "import tasks from './deno.json' with { type: 'json' };console.log(Object.keys(tasks.tasks).join('\t'))" | deno run --allow-read -
}

function is_script_in_deno_json () {
    if ! command -v deno &> /dev/null; then
    echo "Error: deno is not installed"
    return 1
  fi

  echo "import tasks from './deno.json' with { type: 'json' };console.log(Object.keys(tasks?.tasks).includes('$1') ? 'true' : 'false')" | deno run --allow-read -
}

function is_script_in_package_json() {
  node -e "try {
    const pkg = require('./package.json');
    console.log(pkg.scripts && pkg.scripts['$1'] ? 'true' : 'false');
  } catch (error) {
    throw new Error('Error:', error);
  }"
}

function list_scripts_in_package_json() {
  node -e "try {
    const pkg = require('./package.json');
    console.log(Object.keys(pkg.scripts || {}).join('\n'));
  } catch (error) {
    throw new Error('Error:', error);
  }"
}

function get_package_manager() {
  if [ -f pnpm-lock.yaml ]; then
    echo "pnpm"
  elif [ -f bun.lockb ]; then
    echo "bun"
  elif [ -f bun.lock ]; then
    echo "bun"
  elif [ -f yarn.lock ]; then
    echo "yarn"
  elif [ -f package-lock.json ]; then
    echo "npm"
  else
    echo "unknown"
  fi
}

# Define some colors and styles
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

function run() {
  SCRIPT=$1
  if [ -f package.json ]; then
    IS_SCRIPT_IN_PACKAGE_JSON=$(is_script_in_package_json $SCRIPT)
    if [ "$IS_SCRIPT_IN_PACKAGE_JSON" = "false" ]; then
      echo -e "${RED}${BOLD}Error:${RESET} Script '${SCRIPT}' not found in package.json 🚫"
      echo -e "${GREEN}Available scripts:${RESET}"
      list_scripts_in_package_json
      PACKAGE_MANAGER=$(get_package_manager)
      echo -e "${GREEN}${BOLD}Package manager in use: ${PACKAGE_MANAGER}${RESET} 🚀"
      return 1
    fi

    PACKAGE_MANAGER=$(get_package_manager)
    if [ "$PACKAGE_MANAGER" = "unknown" ]; then
      echo -e "${RED}No package manager lock file found. Trying to install packages...${RESET} 🔄"
      if command -v bun &> /dev/null; then
        echo -e "${GREEN}${BOLD}Installing packages with bun...${RESET} 📦"
        bun install && bun run $SCRIPT
      elif command -v pnpm &> /dev/null; then
        echo -e "${GREEN}${BOLD}Installing packages with pnpm...${RESET} 📦"
        pnpm install && pnpm run $SCRIPT
      elif command -v npm &> /dev/null; then
        echo -e "${GREEN}${BOLD}Installing packages with npm...${RESET} 📦"
        npm install && npm run $SCRIPT
      elif command -v yarn &> /dev/null; then
        echo -e "${GREEN}${BOLD}Installing packages with yarn...${RESET} 📦"
        yarn install && yarn run $SCRIPT
      else
        echo -e "${RED}${BOLD}Error:${RESET} No package manager found 🚫"
        return 1
      fi
    else
      echo -e "${GREEN}${BOLD}Running script with ${PACKAGE_MANAGER}...${RESET} 🚀"
      $PACKAGE_MANAGER run $SCRIPT
    fi
  elif [ -f deno.json ]; then
    IS_SCRIPT_IN_DENO_JSON=$(is_script_in_deno_json $SCRIPT)
    if [ "$IS_SCRIPT_IN_DENO_JSON" = "false" ]; then
      echo -e "${RED}${BOLD}Error:${RESET} Task '${BOLD}${SCRIPT}${RESET}' not found in deno.json 🚫"
      echo -e "${GREEN}Available tasks:${RESET}"
      list_deno_tasks
      return 1
    fi

    echo -e "${GREEN}${BOLD}Running task with deno...${RESET} 🚀"
    deno task $SCRIPT
  else
    echo -e "${RED}${BOLD}Error:${RESET} No package.json or deno.json found. Cannot determine project type. 🚫"
    return 1
  fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf (fuzzy finder)
export FZF_BASE="/usr/bin/fzf/"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bun completions
[ -s "/home/edouard/.bun/_bun" ] && source "/home/edouard/.bun/_bun"

# Add Locations to $PATH Variables

export PATH="$N_PREFIX/bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Deno
export DENO_INSTALL="/home/edouard/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/home/edouard/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Python
export PATH="$HOME/.local/bin:$PATH"

# Jupyter
export PATH="$HOME/.local/share/jupyter/runtime:$PATH"

# Add console-ninja to $PATH
export PATH=~/.console-ninja/.bin:$PATH

# Add my scripts to $PATH
export PATH="$HOME/Projects/code/scripts/bin:$PATH"

# Initialize zoxide
eval "$(zoxide init zsh)"
