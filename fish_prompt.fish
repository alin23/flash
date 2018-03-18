set -g CMD_DURATION 0

function flash_alert; set_color -r F0476D; end
function flash_fst; set_color -o F0476D; end
function flash_snd; set_color -o EEA87A; end
function flash_trd; set_color -o 777; end
function flash_dim; set_color -o 444; end
function flash_env; set_color -o 56C; end

function flash_charging; set_color -o 4F58B5; end
function flash_charging_dim; set_color -o 5B5979; end
function flash_charged; set_color -o 3BF1AF; end
function flash_charged_dim; set_color -o 5ECDA4; end
function flash_midcharged; set_color -o EEA87A; end
function flash_midcharged_dim; set_color -o dEA87A; end
function flash_discharged; set_color -o F0476D; end
function flash_discharged_dim; set_color -o B11; end

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
