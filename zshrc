# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# # If you come from bash you might have to change your $PATH.
# # export PATH=$HOME/bin:/usr/local/bin:$PATH

# # Path to your oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

# # Set name of the theme to load --- if set to "random", it will
# # load a random theme each time oh-my-zsh is loaded, in which case,
# # to know which specific one was loaded, run: echo $RANDOM_THEME
# # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"

# # Set list of themes to pick from when loading at random
# # Setting this variable when ZSH_THEME=random will cause zsh to load
# # a theme from this variable instead of looking in $ZSH/themes/
# # If set to an empty array, this variable will have no effect.
# # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# # Uncomment the following line to use case-sensitive completion.
# # CASE_SENSITIVE="true"

# # Uncomment the following line to use hyphen-insensitive completion.
# # Case-sensitive completion must be off. _ and - will be interchangeable.
# # HYPHEN_INSENSITIVE="true"

# # Uncomment one of the following lines to change the auto-update behavior
# # zstyle ':omz:update' mode disabled  # disable automatic updates
# # zstyle ':omz:update' mode auto      # update automatically without asking
# # zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# # Uncomment the following line to change how often to auto-update (in days).
# # zstyle ':omz:update' frequency 13

# # Uncomment the following line if pasting URLs and other text is messed up.
# # DISABLE_MAGIC_FUNCTIONS="true"

# # Uncomment the following line to disable colors in ls.
# # DISABLE_LS_COLORS="true"

# # Uncomment the following line to disable auto-setting terminal title.
# # DISABLE_AUTO_TITLE="true"

# # Uncomment the following line to enable command auto-correction.
# # ENABLE_CORRECTION="true"

# # Uncomment the following line to display red dots whilst waiting for completion.
# # You can also set it to another string to have that shown instead of the default red dots.
# # e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# # Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# # COMPLETION_WAITING_DOTS="true"

# # Uncomment the following line if you want to disable marking untracked files
# # under VCS as dirty. This makes repository status check for large repositories
# # much, much faster.
# # DISABLE_UNTRACKED_FILES_DIRTY="true"

# # Uncomment the following line if you want to change the command execution time
# # stamp shown in the history command output.
# # You can set one of the optional three formats:
# # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# # or set a custom format using the strftime function format specifications,
# # see 'man strftime' for details.
# # HIST_STAMPS="mm/dd/yyyy"

# # Would you like to use another custom folder than $ZSH/custom?
# # ZSH_CUSTOM=/path/to/new-custom-folder

# # Which plugins would you like to load?
# # Standard plugins can be found in $ZSH/plugins/
# # Custom plugins may be added to $ZSH_CUSTOM/plugins/
# # Example format: plugins=(rails git textmate ruby lighthouse)
# # Add wisely, as too many plugins slow down shell startup.
# plugins=(
#   alias-tips
#   bun
#   colored-man-pages
#   colorize
#   command-not-found
#   fzf
#   git
#   history
#   ubuntu
#   vscode
#   yarn
#   zsh-autosuggestions
#   zsh-syntax-highlighting
#   )

# source $ZSH/oh-my-zsh.sh

# # User configuration

# # export MANPATH="/usr/local/man:$MANPATH"

# # You may need to manually set your language environment
# # export LANG=en_US.UTF-8

# # Preferred editor for local and remote sessions
# # if [[ -n $SSH_CONNECTION ]]; then
# #   export EDITOR='vim'
# # else
# #   export EDITOR='mvim'
# # fi

# # Compilation flags
# # export ARCHFLAGS="-arch x86_64"

# # Set personal aliases, overriding those provided by oh-my-zsh libs,
# # plugins, and themes. Aliases can be placed here, though oh-my-zsh
# # users are encouraged to define aliases within the ZSH_CUSTOM folder.
# # For a full list of active aliases, run `alias`.
# #
# # Example aliases
# # alias zshconfig="mate ~/.zshrc"
# # alias ohmyzsh="mate ~/.oh-my-zsh"


# # alias aliassearch ="alias | grep "

# # Shell
# alias c='clear'
# alias copy='rsync -ah --info=progress2'
# # alias ls='colorls'
# # alias lc='colorls -lA --sd'
# # alias la='colorls -a'

# # Go to directory (`cd`) then list what's in it (`ls`)
# function cl() {
#   DIR="$*";
#     # if no DIR given, go home
#     if [ $# -lt 1 ]; then
#       DIR=$HOME;
#   fi;
#   builtin cd "${DIR}" && \
#   # use your preferred ls command
#     ls
# }

# # ZSH
# alias p10k="code ~/.p10k.zsh"
# alias zshrc="code ~/.zshrc"

# # GIT
# alias gac="git add -A && git commit -m"
# alias gbr+="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
# alias gca="git commit --amend --no-edit"
# alias gclean="git remote prune origin && git switch main | git branch --merged | egrep -v '(^\*|master|main|dev)' | xargs git branch -d"
# alias gco--="git checkout @{-2}"
# alias gco-="git checkout -"
# alias gco-2="gco--"
# alias gcod="git checkout dev"
# alias gcom="git checkout main"
# alias gdel="git branch -D"
# alias githome='cd `git rev-parse --show-toplevel`'
# alias gla="git pull --all && git fetch --all"
# alias gmm="git merge main"
# alias gmu="git switch main && git fetch --all && git pull --all"
# alias gpo='git push --set-upstream origin $(git_current_branch)'
# alias gt="git tag"
# alias gta="git tag -a"
# alias gundo="git reset --soft HEAD^"

# # You fix the bug, stage only the changes related to the bug and execute
# # This will create a branch called bugfix based off master with only the bug fix
# gmove() {
#   git stash -- $(git diff --staged --name-only) &&
#   gwip ;
#   git branch $1 $2 &&
#   git checkout $1 &&
#   git stash pop
# }

# # You fix the bug, stage only the changes related to the bug and execute
# # This will create a branch called bugfix based off master with only the bug fix
# killport() {
#   kill -9 $(lsof -t -i:$1)
# }

# # YARN
# alias ylf="yarn lint:fix"
# alias yst="BROWSER=none yarn start"

# # BUN
# alias b="bun"
# alias ba="bun add"
# alias bad="bun add -d"
# alias bb="bun run build"
# alias bdev="bun run dev"
# alias bf="bun run format"
# alias bi="bun install"
# alias blf="bun run lint:fix"
# alias bln="bun run lint"
# alias brm="bun remove"
# alias brun="bun run"
# alias bst="bun run start"
# alias bt="bun test"


# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# # ZSH Syntax Highlighting
# source /home/edouard/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# # fzf (fuzzy finder)
# export FZF_BASE=/usr/bin/fzf/

# # NVM
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# # bun completions
# [ -s "/home/edouard/.bun/_bun" ] && source "/home/edouard/.bun/_bun"

# # bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

# Set variables

# Change ZSH Options

# Create Aliases

alias ls='ls -lAFh'

# Customize Prompt(s)

PROMPT='
%1~ %L %# '

RPROMPT='%*'


# Add Locations ot $PATH Variables

# Write Handy Functions

function mkcd() {
  mkdir -p "$@" && cd "$_"
}

# Use ZSH Plugins

# ...and other Surprises
