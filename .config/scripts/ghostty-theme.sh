switch_theme() {
  local ghostty_config="$HOME/.config/ghostty/config"
  local tmux_config="$HOME/.config/tmux/tmux.conf"

  if [[ "$COLORSCHEME" == "dark" ]]; then
    export COLORSCHEME="light"
    sed -i '' "s/^theme = .*/theme = \"flow-sun-ecliplse\"/" "$ghostty_config"
    sed -i '' 's|^source ".*"$|source "$HOME/.config/tmux/flow-sun-eclipse.conf"|' "$tmux_config"
  else
    export COLORSCHEME="dark"
    sed -i '' "s/^theme = .*/theme = \"flow-moon-eclipse\"/" "$ghostty_config"
    sed -i '' 's|source ".*\.conf"|source "$HOME/.config/tmux/flow-eclipse.conf"|' "$tmux_config"
  fi

  pkill -SIGUSR2 ghostty
  tmux source-file "$tmux_config"
}
