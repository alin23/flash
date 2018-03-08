set -g CMD_DURATION 0

function flash_fst; set_color -o F0476D; end
function flash_snd; set_color -o EEA87A; end
function flash_trd; set_color -o 777; end
function flash_dim; set_color -o 444; end
function flash_env; set_color -o 56C; end

function flash_charging; set_color -o 7A7FB5; end
function flash_charging_dim; set_color -o 5B5979; end
function flash_charged; set_color -o 5eebb8; end
function flash_charged_dim; set_color -o 96C5D7; end
function flash_midcharged; set_color -o EEA87A; end
function flash_midcharged_dim; set_color -o dEA87A; end
function flash_discharged; set_color -o F0476D; end
function flash_discharged_dim; set_color -o B11; end

function flash_off; set_color normal; end
function bc; command bc -l $argv; end

function fish_prompt
  set -l code $status

  set -l prompt (prompt_pwd)
  set -l base (basename "$prompt")

  printf (flash_snd)"( "(begin
    if test "$PWD" = "/"
      test $code -eq 0; and echo (flash_fst)"/"(flash_off); or echo (flash_dim)"/"(flash_off)
    else
      echo ""
    end
  end)(echo "$prompt" \
  | sed "s|~|"(begin
      test $code -eq 0; and echo (flash_fst); or echo (flash_dim)
    end)"⌁"(flash_off)"|g" \
  | sed "s|/|"(flash_snd)" ) "(flash_off)"|g" \
  | sed "s|"$base"|"(flash_fst)$base(flash_off)" |g")(flash_snd)(begin
    test "$PWD" = "$HOME"; and echo " "; echo ""
    end)(begin
      if test "$PWD" = "/"
        echo ""
      else
        echo ") "
      end
    end)(flash_off)
end
