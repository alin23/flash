set -g CMD_DURATION 0
set -xg HOSTNAME (hostname)

function dark_mode
  set -e FISH_LIGHT_MODE
  set -xg _COLOR_15 FFFFFF #FFFFFF

  set -xg _COLOR_1 77C8BB #77C8BB
  set -xg _COLOR_9 FFDD49 #FFDD49
  set -xg _COLOR_2 FFA36F #FFA36F
  set -xg _COLOR_10 93C4B5 #93C4B5
  set -xg _COLOR_3 AA79C0 #AA79C0
  set -xg _COLOR_11 708966 #708966
  set -xg _COLOR_4 FF6448 #FF6448
  set -xg _COLOR_12 4DAFAD #4DAFAD
  set -xg _COLOR_5 D43459 #D43459
  set -xg _COLOR_13 71C964 #71C964
  set -xg _COLOR_6 5A7187 #5A7187
  set -xg _COLOR_14 BD2A06 #BD2A06
  set -xg _COLOR_7 54516C #54516C
  set -xg _COLOR_8 80B3FF #80B3FF
  set -xg _COLOR_16 888976 #888976
  set -xg _COLOR_17 5FF0AE #5FF0AE
  set -xg _COLOR_18 4F58B5 #4F58B5
end

function light_mode
  set -xU FISH_LIGHT_MODE true
  set -xg _COLOR_15 000000 #000000

  set -xg _COLOR_1 63A69B #63A69B
  set -xg _COLOR_9 C72E75 #C72E75
  set -xg _COLOR_2 DD5000 #DD5000
  set -xg _COLOR_10 0B855E #0B855E
  set -xg _COLOR_3 AA79C0 #AA79C0
  set -xg _COLOR_11 223422 #223422
  set -xg _COLOR_4 FF6448 #FF6448
  set -xg _COLOR_12 4DAFAD #4DAFAD
  set -xg _COLOR_5 D43459 #D43459
  set -xg _COLOR_13 71C964 #71C964
  set -xg _COLOR_6 253545 #253545
  set -xg _COLOR_14 BD2A06 #BD2A06
  set -xg _COLOR_7 54516C #54516C
  set -xg _COLOR_8 80B3FF #80B3FF
  set -xg _COLOR_16 4A4B41 #4A4B41
  set -xg _COLOR_17 5280D0 #5280D0
  set -xg _COLOR_18 4F58B5 #4F58B5
end

function set_all_fish_colors
  set -xg fish_color_normal $_COLOR_15 #   the default color
  set -xg fish_color_command $_COLOR_2 #  the color for commands
  set -xg fish_color_quote $_COLOR_1 #  the color for quoted blocks of text
  set -xg fish_color_redirection $_COLOR_3 #  the color for IO redirections
  set -xg fish_color_end $_COLOR_4 #  the color for process separators like ';' and '&'
  set -xg fish_color_error $_COLOR_5 #  the color used to highlight potential errors
  set -xg fish_color_param $_COLOR_6 #  the color for regular command parameters
  set -xg fish_color_comment $_COLOR_7 #  the color used for code comments
  set -xg fish_color_match $_COLOR_8 #  the color used to highlight matching parenthesis
  set -xg fish_color_search_match $_COLOR_9 #   the color used to highlight history search matches
  set -xg fish_color_operator $_COLOR_10 #   the color for parameter expansion operators like '*' and '~'
  set -xg fish_color_escape $_COLOR_11 #   the color used to highlight character escapes like '\n' and '\x70'
  set -xg fish_color_cwd $_COLOR_15 #  the color used for the current working directory in the default prompt
  set -xg fish_color_autosuggestion $_COLOR_7 #   the color used for autosuggestions
  set -xg fish_color_user $_COLOR_12 #   the color used to print the current username in some of fish default prompts
  set -xg fish_color_host $_COLOR_13 #   the color used to print the current host system in some of fish default prompts
  set -xg fish_color_cancel $_COLOR_9 #   the color for the '^C' indicator on a canceled command
  set -xg fish_pager_color_prefix $_COLOR_15 #   the color of the prefix string, i.e. the string that is to be completed
  set -xg fish_pager_color_completion $_COLOR_7 #   the color of the completion itself
  set -xg fish_pager_color_description $_COLOR_10 #  the color of the completion description
  set -xg fish_pager_color_progress $_COLOR_4 #   the color of the progress bar at the bottom left corner
  set -xg fish_pager_color_secondary $_COLOR_16
end

function reset_fish_colors
  argparse --name reset_fish_colors -x dark,light 'd/dark' 'l/light' -- $argv
  or return 1

  if set -q _flag_light
    light_mode
  else
    dark_mode
  end
  set_all_fish_colors
  set -xg PYENV_VERSION_PROMPT (set_color -o $_COLOR_17)(command pyenv version-name 2>/dev/null)(set_color normal)
end

if set -q FISH_LIGHT_MODE
  reset_fish_colors --light
else
  reset_fish_colors --dark
end

function flash_alert
  set_color -b F0503C black
end #F0503C
function flash_fst
  set_color -o $_COLOR_2
end #FFA36F
function flash_snd
  set_color -o $_COLOR_17
end #5FF0AE
function flash_trd
  set_color -o 777
end #777
function flash_dim
  set_color -o 444
end #444
function flash_env
  set_color -o $_COLOR_17
end #5FF0AE

function flash_charging
  set_color -o $_COLOR_18
end #4F58B5
function flash_charging_dim
  set_color -o 5B5979
end #5B5979
function flash_charged
  set_color -o 3BF1AF
end #3BF1AF
function flash_charged_dim
  set_color -o 5ECDA4
end #5ECDA4
function flash_midcharged
  set_color -o EEA87A
end #EEA87A
function flash_midcharged_dim
  set_color -o DEA87A
end #DEA87A
function flash_discharged
  set_color -o F0476D
end #F0476D
function flash_discharged_dim
  set_color -o B11
end #B11

function flash_off
  set_color normal
end
function bc
  command bc -l $argv
end

function format_path
  set -l sepright ' \u276F '
  set -l base (basename "$argv[1]")
  string replace -a '/' (flash_snd)$sepright(flash_off) $argv[1] | string replace -r (string escape $base)'$' (flash_fst)$base(flash_off)
end

function ssh_hostname
  if set -q SSH_CLIENT
    echo (flash_alert)' '$HOSTNAME' '(flash_off)' '
  else
    echo ''
  end
end

function fish_prompt
  set -l code $status
  set -l sepleft ''
  set -l sepright \u276F
  # set -l user (whoami)

  set -l prompt (prompt_pwd)
  function status::color -S
    test $code -ne 0
    and echo (flash_fst)
    or echo (flash_dim)
  end

  printf '\u200a'(ssh_hostname)(begin
    if string match -q '/*' $prompt
      format_path (string replace '/' (flash_snd)"$sepleft"(status::color)'#'(flash_snd)" $sepright "(flash_off) $prompt)
    else if string match -q '~*' $prompt
      format_path (string replace -r '~/?' (flash_snd)"$sepleft"(status::color)'⌁'(flash_snd)" $sepright "(flash_off) $prompt)
    else
      format_path $prompt
    end
  end)(test (string length $prompt) -ne 1; and echo (flash_snd)" $sepright "(flash_off); or echo '')
end
