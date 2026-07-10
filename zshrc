# ~/.zshrc — interactive shell configuration.
# Environment & PATH live in ~/.zshenv. Aliases live in zsh/aliases.zsh.

# ── Zinit (plugin manager) ────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# ── Autoloaded functions ──────────────────────────────────────────────────
# Lazy-loaded on first use from ~/.dotfiles/zsh/functions/autoload.
fpath=("$HOME/.dotfiles/zsh/functions/autoload" $fpath)
autoload -Uz \
  gmove killport mkcd cl kebabify run install \
  list_deno_tasks is_script_in_deno_json

if command -v brew >/dev/null 2>&1; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" "$(brew --prefix)/share/zsh-completions" $fpath)
  typeset -U fpath
fi

# ── Completion styling ────────────────────────────────────────────────────
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case-insensitive matching
zstyle ':completion:*' menu no                          # let fzf-tab render the menu
zstyle ':completion:*:git-checkout:*' sort false        # keep git checkout order
zstyle ':completion:*:descriptions' format '[%d]'       # NOTE: no color escapes (fzf-tab ignores them)
# fzf-tab directory previews: prefer eza, fall back to ls
if command -v eza >/dev/null 2>&1; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always ${(Q)realpath}'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always ${(Q)realpath}'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -G ${(Q)realpath}'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -G ${(Q)realpath}'
fi

# ── Plugins (deferred via turbo mode for faster startup) ──────────────────
# compinit + cdreplay run via atinit on the first deferred plugin.
# Order matters: fzf-tab before the widget-wrappers; syntax-highlighting last.
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
  Aloxaf/fzf-tab \
    atload"_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
  zsh-users/zsh-completions \
  zsh-users/zsh-syntax-highlighting

# ── Shell integrations ────────────────────────────────────────────────────
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"

# ── Keybindings ───────────────────────────────────────────────────────────
# Alt+Left / Alt+Right move by word (VS Code & common terminals)
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

# ── History ───────────────────────────────────────────────────────────────
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE="$HOME/.zsh_history"
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space
setopt hist_ignore_dups hist_ignore_all_dups hist_save_no_dups hist_find_no_dups

# ── Behaviour ─────────────────────────────────────────────────────────────
export NULLCMD=bat                           # default viewer for `< file`

# ── Prompt ────────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ── Aliases ───────────────────────────────────────────────────────────────
[[ -f "$HOME/.dotfiles/zsh/aliases.zsh" ]] && source "$HOME/.dotfiles/zsh/aliases.zsh"
