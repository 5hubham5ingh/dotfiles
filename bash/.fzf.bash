# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ss/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/ss/.fzf/bin"
fi
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border --cycle"
eval "$(fzf --bash)"
