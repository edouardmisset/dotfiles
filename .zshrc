# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  alias-tips
  colored-man-pages
  command-not-found
  fzf
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  )

# fzf (fuzzy finder)
export FZF_BASE="/usr/bin/fzf/"
export FZF_DEFAULT_COMMAND='fzf'

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# alias aliassearch ="alias | grep "

# Shell
alias as="alias | grep "
alias c='clear'
alias cdi="cd ~/code/innova-web-ui"
alias copy='rsync --archive --human-readable --recursive --update --copy-links --info=progress2'
alias cwd="pwd"

# Ubuntu
alias agi="sudo apt-get install"
alias agr="sudo apt-get remove"
alias agp="sudo apt-get purge"
alias agli="apt list --installed"
alias aguu="sudo apt-get update && sudo apt-get upgrade"

# History
alias h='history'
alias hs='history | grep'
alias hsi='history | grep -i'

# OMZ & p10k
alias p10k="code ~/.p10k.zsh"
alias zshrc="code ~/.zshrc"

# GIT
alias gaa="git add --all"
alias gac="git add --all && git commit -m"
alias gbr+="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias gca="git commit --amend --no-edit"
alias gclean="git remote prune origin && git switch main | git branch --merged | egrep -v '(^\*|master|main|dev)' | xargs git branch -d"
alias gco--="git checkout @{-2}"
alias gco-="git checkout -"
alias gco-2="gco--"
alias gcod="git checkout dev"
alias gcom="git checkout main"
alias gdel="git branch -D"
alias githome='cd `git rev-parse --show-toplevel`'
alias gla="git pull --all && git fetch --all"
alias glm="glol main..HEAD"
alias glol1m="glol --since='1 month ago'"
alias glol1w="glol --since='1 week ago'"
alias glol1y="glol --since='1 year ago'"
alias glolg-="glol --grep="
alias gmm="git merge main"
alias gmu="git switch main && git pull --all && git fetch --all"
alias gpo='git push --set-upstream origin $(git_current_branch)'
alias gt="git tag"
alias gta="git tag -a"
alias gundo="git reset --soft HEAD^"

# VS Code
alias vsc="code"

# YARN
alias y="yarn"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yb="yarn build"
alias yd="yarn dev"
alias ydev="yarn dev"
alias ydev="yarn dev"
alias ylf="yarn lint:fix"
alias yln="yarn lint"
alias yrm="yarn remove"
alias yrun="yarn run"
alias ys="yarn serve"
alias yst="BROWSER=none yarn start"
alias yup="yarn upgrade"

# DENO
alias dfmt="deno fmt"
alias dln="deno lint"
alias drun="deno run"
alias drunA="deno run -A"
alias drunw="deno run --watch"
alias drw="deno run --watch"
alias dt="deno test"
alias dta="deno task"
alias dtc="deno task check"
alias dtca="deno task cache"
alias dtd="deno task dev"
alias dtf="deno task format"
alias dtl="deno task lint"
alias dtt="deno task test"
alias dup="deno upgrade"


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

# PNPM
alias pad="pnpm add -d"
alias pb="pnpm build"
alias pd="pnpm dev"
alias pdev="pnpm dev"
alias pf="pnpm format"
alias pi="pnpm install"
alias plf="pnpm lint:fix"
alias pln="pnpm lint"
alias pm="pnpm"
alias prm="pnpm remove"
alias prun="pnpm run"
alias pst="pnpm start"
alias pt="pnpm test"

# Script runner
alias rb="run build"
alias rc="run check"
alias rd="run dev"
alias rdev="run dev"
alias rf="run format"
alias ri="run install"
alias rlf="run lint:fix"
alias rln="run lint"
alias rst="run start"
alias rt="run test"

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

# Connect to `Nano Boombox * *` Bluetooth headphones using bluetoothctl on **Linux**
function connectToNano() {
  # Set the name of the Bluetooth device
  DEVICE_NAME="Nano Boom Box * *"  # Replace with your device's name

  # Find the MAC address of the device by its name
  DEVICE_MAC=$(bluetoothctl devices | grep "$DEVICE_NAME" | awk '{print $2}')

  # Check if the device was found
  if [ -z "$DEVICE_MAC" ]; then
      echo "Device $DEVICE_NAME not found"
      exit 1
  fi

  # Connect to the device using bluetoothctl
  echo -e "connect $DEVICE_MAC\nquit" | bluetoothctl

  sleep 2

  # Check if the connection was successful
  connected=$(echo -e "info $DEVICE_MAC\nquit" | bluetoothctl | grep "Connected: yes")

  if [ -n "$connected" ]; then
      echo "Successfully connected to device $DEVICE_MAC"
  else
      echo "Failed to connect to device $DEVICE_MAC"
  fi
}

function list_deno_tasks() {
  if ! command -v deno &> /dev/null; then
    echo "Error: deno is not installed"
    return 1
  fi

  echo "import tasks from './deno.json' with { type: 'json' };console.log(Object.keys(tasks.tasks).join('\t'))" | deno run --allow-read -
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
      return 1
    fi

    if [ -f pnpm-lock.yaml ]; then
      echo -e "${GREEN}${BOLD}Running script with pnpm...${RESET} 🚀"
      pnpm run $SCRIPT
    elif [ -f bun.lockb ]; then
      echo -e "${GREEN}${BOLD}Running script with bun...${RESET} 🚀"
      bun run $SCRIPT
    elif [ -f yarn.lock ]; then
      echo -e "${GREEN}${BOLD}Running script with yarn...${RESET} 🚀"
      yarn run $SCRIPT
    elif [ -f package-lock.json ]; then
      echo -e "${GREEN}${BOLD}Running script with npm...${RESET} 🚀"
      npm run $SCRIPT
    else
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
    fi
  elif [ -f deno.json ]; then
    if ! list_deno_tasks | grep -qw "$SCRIPT"; then
      echo -e "${RED}${BOLD}Error:${RESET} Task '${SCRIPT}' not found in deno.json 🚫"
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

# ZSH Syntax Highlighting
source /home/edouard/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/home/edouard/.bun/_bun" ] && source "/home/edouard/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Deno
  export DENO_INSTALL="/home/edouard/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"

# Console Ninja
PATH="/home/edouard/.console-ninja/.bin:$PATH"

# Python
export PATH="/home/edouard/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/home/edouard/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
