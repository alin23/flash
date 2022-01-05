if test "$LC_TERMINAL" = iTerm2
  set_terminal_256_colors
end

if status --is-interactive; and not test -f (dirname (status filename))/kitty.fish
  set KITTY_INTEGRATION_SCRIPT ""
  set KITTY (which kitty 2>/dev/null)
  if test -n "$KITTY"
    set KITTY_INTEGRATION_SCRIPT ($KITTY +runpy "from kitty.constants import *; print(shell_integration_dir)")/fish/vendor_conf.d/kitty-shell-integration.fish
  end
  export KITTY_SHELL_INTEGRATION="no-title"

  if test -f "$KITTY_INTEGRATION_SCRIPT"
    source "$KITTY_INTEGRATION_SCRIPT"
  else
    source (dirname (dirname (status filename)))/functions/__kitty.fish
  end
end
