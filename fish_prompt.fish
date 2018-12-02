set -g CMD_DURATION 0

set -xg fish_color_normal FAFAFA #FAFAFA    the default color
set -xg fish_color_command 5566CC #5566CC   the color for commands
set -xg fish_color_quote F1AC69 #F1AC69   the color for quoted blocks of text
set -xg fish_color_redirection 7E41BA #7E41BA   the color for IO redirections
set -xg fish_color_end FFAD48 #FFAD48   the color for process separators like ';' and '&'
set -xg fish_color_error FF0067 #FF0067   the color used to highlight potential errors
set -xg fish_color_param 5A5A87 #5A5A87   the color for regular command parameters
set -xg fish_color_comment 67516C #67516C   the color used for code comments
set -xg fish_color_match 74C4FF #74C4FF   the color used to highlight matching parenthesis
set -xg fish_color_search_match FFD51D #FFD51D    the color used to highlight history search matches
set -xg fish_color_operator 93A0C4 #93A0C4    the color for parameter expansion operators like '*' and '~'
set -xg fish_color_escape 896667 #896667    the color used to highlight character escapes like '\n' and '\x70'
set -xg fish_color_cwd FFFFFF #FFFFFF   the color used for the current working directory in the default prompt
set -xg fish_color_autosuggestion 67516C #67516C    the color used for autosuggestions
set -xg fish_color_user AF5D4D #AF5D4D    the color used to print the current username in some of fish default prompts
set -xg fish_color_host 7DC953 #7DC953    the color used to print the current host system in some of fish default prompts
set -xg fish_color_cancel F53608 #F53608    the color for the '^C' indicator on a canceled command
set -xg fish_pager_color_prefix FAFAFA #FAFAFA    the color of the prefix string, i.e. the string that is to be completed
set -xg fish_pager_color_completion 67516C #67516C    the color of the completion itself
set -xg fish_pager_color_description 93A0C4 #93A0C4   the color of the completion description
set -xg fish_pager_color_progress FFAD48 #FFAD48    the color of the progress bar at the bottom left corner
set -xg fish_pager_color_secondary 898080 #898080   the background color of the every second completion

function flash_alert; set_color -b F02F66 black; end  #F02F66
function flash_fst; set_color -o F02F66; end  #F02F66
function flash_snd; set_color -o FFC082; end  #FFC082
function flash_trd; set_color -o 777; end  #777
function flash_dim; set_color -o 444; end  #444
function flash_env; set_color -o 56C; end  #56C

function flash_charging; set_color -o 4F58B5; end  #4F58B5
function flash_charging_dim; set_color -o 5B5979; end  #5B5979
function flash_charged; set_color -o 3BF1AF; end  #3BF1AF
function flash_charged_dim; set_color -o 5ECDA4; end  #5ECDA4
function flash_midcharged; set_color -o EEA87A; end  #EEA87A
function flash_midcharged_dim; set_color -o DEA87A; end  #DEA87A
function flash_discharged; set_color -o F0476D; end  #F0476D
function flash_discharged_dim; set_color -o B11; end  #B11

function flash_off; set_color normal; end
function bc; command bc -l $argv; end

function format_path
  set -l sepright ' ) '
  set -l base (basename "$argv[1]")
  string replace -a '/' (flash_snd)$sepright(flash_off) $argv[1] | string replace -r (string escape $base)'$' (flash_fst)$base(flash_off)
end

function ssh_hostname
  if set -q SSH_CLIENT
    echo (flash_alert)' '(hostname)' '(flash_off)' '
  else
    echo ''
  end
end

function fish_prompt
  set -l code $status
  set -l sepleft '('
  set -l sepright ')'
  set -l user (whoami)

  set -l prompt (prompt_pwd)
  function status::color -S
    test $code -ne 0; and echo (flash_fst); or echo (flash_dim)
  end

  printf (ssh_hostname)(begin
    if string match -q '/*' $prompt
      format_path (string replace '/' (flash_snd)"$sepleft "(status::color)'#'(flash_snd)" $sepright "(flash_off) $prompt)
    else if string match -q '~*' $prompt
      format_path (string replace -r '~/?' (flash_snd)"$sepleft "(status::color)'⌁'(flash_snd)" $sepright "(flash_off) $prompt)
    else
      format_path $prompt
    end
  end)(test (string length $prompt) -ne 1; and echo (flash_snd)" $sepright "(flash_off); or echo '')(test $user = 'root'; and echo (flash_env)"# "(flash_off); or echo '')
end
