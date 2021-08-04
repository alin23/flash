if test "$LC_TERMINAL" = iTerm2
  set_terminal_256_colors
end

if not test -f (dirname (status filename))/kitty.fish
  set KITTY_INTEGRATION_SCRIPT (kitty +runpy "from kitty.constants import *; print(shell_integration_dir)")/kitty.fish
  export KITTY_SHELL_INTEGRATION="enabled"
  if test -f "$KITTY_INTEGRATION_SCRIPT"
    source "$KITTY_INTEGRATION_SCRIPT"
  else
    source (dirname (dirname (status filename)))/functions/__kitty.fish
  end
end
