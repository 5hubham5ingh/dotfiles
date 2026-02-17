#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f ~/.bash_profile ]; then
  source ~/.bash_profile
fi

if [ -f ~/.api-keys.sh ]; then
  source ~/.api-keys.sh
fi

# vim mode
set -o vi

alias ls='ls --color=auto'
alias yz='yazi'
alias grep='grep --color=auto'
alias clr='clear'
alias icat='kitty +kitten icat'
alias cd='z'
alias wr='WallRizz'
alias btop='btop --utf-force'
alias dict='~/.config/js/dict.js'
alias fzchoose='fzf -m --preview "bat --color=always {} 2>/dev/null || batcat --color=always {}" --preview-window=border-none'

nv() {
  local project_name=$(basename "$PWD")

  kitty @ set-window-title "$project_name"

  nvim "$@"
}

fzd() {
  local selection=$(find -type d 2>/dev/null | fzf)

  if [ -n "$selection" ]; then
    cd "$selection"
  fi
}

fzi() {
  fzf --layout=reverse --height '100%' --color=16,current-bg:-1,current-fg:-1 --prompt= --marker= --pointer= --info inline-right --preview-window='70%,border-none' --preview='kitty icat --clear --transfer-mode=memory --stdin=no --scale-up --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}'
}

fzvim() {
  local selected_files

  selected_files=$(
    fzf \
      --height '100%' \
      --preview-window='right:50%:border-none' \
      --preview 'batcat --color=always --style=numbers,changes {}' \
      --bind 'ctrl-h:change-preview-window(right:75%)' \
      --bind 'ctrl-l:change-preview-window(right:50%)' \
      --bind 'ctrl-j:preview-down' \
      --bind 'ctrl-k:preview-up'
  )

  if [ -n "$selected_files" ]; then
    vim "$selected_files"
  else
    echo "No file selected."
  fi
}

fznav() {
  local current_dir="${1:-$PWD}"

  while true; do
    # ls -1pa:
    # -1: single column
    # -p: add '/' to directories
    # -a: show hidden
    local selected=$(ls -1pa "$current_dir" | grep -v '^\./$' | fzf \
      --prompt="Navigate: $current_dir > " \
      --header="[→/Enter] Open/Select  [←] Back  [Ctrl-C] Quit" \
      --bind "right:accept" \
      --bind "left:become(echo '..')" \
      --preview "[[ -d $current_dir/{} ]] && ls -F --color=always $current_dir/{} || head -n 100 $current_dir/{}" \
      --layout=reverse \
      --height=80%)

    # Handle Exit
    [[ -z "$selected" ]] && return 1

    local target_path=$(realpath "$current_dir/$selected")

    if [[ -d "$target_path" ]]; then
      current_dir="$target_path"
    else
      echo "$target_path"
      break
    fi
  done
}

redo() {
  selection=$(js "redo()")

  if [ -n "$selection" ]; then
    READLINE_LINE="$selection"
    READLINE_POINT=${#READLINE_LINE}
  fi
}

export -f redo
bind -x '"\C-x": redo'

vcat() {
  mpv --vo=kitty $1
}

export COLUMNS

# zoxide
export PATH=$PATH:/home/ss/.local/bin
eval "$(zoxide init bash)"

# deno
export DENO_INSTALL="/home/ss/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export WALLPAPER_DIR="/home/ss/pics/walls/1920x1080.anime/"
export WALLPAPER_REPO_URLS="https://github.com/D3Ext/aesthetic-wallpapers/tree/main/images ; https://github.com/5hubham5ingh/WallWiz/tree/wallpapers/"

# Jiffy
export TERMINAL="kitty -1 --hold"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# starship prompt
eval "$(starship init bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "/home/ss/.deno/env"

export PATH="$PATH:~/.scripts/"
export EDITOR="vim"
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export PATH=$PATH:/usr/local/go/bin
. "$HOME/.cargo/env"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH="$HOME/bin:$PATH"
