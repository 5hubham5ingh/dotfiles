# List your config folders/files here
APPS=("kitty" "bash")

for APP in "${APPS[@]}"; do
  mkdir -p "$HOME/.dotfiles/$APP"
  # If it's a standard .config folder
  if [ -d "$HOME/.config/$APP" ]; then
    mkdir -p "$HOME/.dotfiles/$APP/.config"
    mv "$HOME/.config/$APP" "$HOME/.dotfiles/$APP/.config/"
  # If it's a home-level dotfile (like .bashrc)
  elif [ -f "$HOME/.$APP" ] || [ -f "$HOME/.${APP}rc" ]; then
    mv "$HOME/.$APP"* "$HOME/.dotfiles/$APP/" 2>/dev/null
  fi
done
