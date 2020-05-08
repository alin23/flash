
function flash_git_is_stashed
  command git rev-parse --verify --quiet refs/stash >/dev/null
end

function flash_git_branch_name
  command git symbolic-ref --short HEAD
end

function flash_git_is_touched
  test -n (echo (command git status --porcelain))
end

function flash_battery_charge
  if [ (uname) != Darwin ]
    return 0
  end
  set battery_info (pmset -g batt)

  set charging false
  if string match "*AC Power*" $battery_info >/dev/null
    set charging true
  end

  set battcolor "flash_discharged"

  set percentage (echo $battery_info | awk 'match($0, "[0-9]+%;") { print substr($0,RSTART,RLENGTH-2) }')
  set remaining (echo $battery_info | awk 'match($0, "[0-9]+:[0-9]+ remaining") { print substr($0,RSTART,RLENGTH-10) }')

  if string match -r "[0-9]{1,2}:[0-9]{1,2}" $remaining >/dev/null 2>/dev/null
    set remaining "($remaining)"
  end

  if [ $charging = true ]
    set battcolor "flash_charging"
  else if [ $percentage -gt 70 ]
    set battcolor "flash_charged"
  else if [ $percentage -gt 30 ]
    set battcolor "flash_midcharged"
  end

  set timecolor $battcolor'_dim'

  printf " "(eval $battcolor)"$percentage%%"(eval $timecolor)"$remaining"(flash_off)
end

set -xg GIT_PROMPT_EXISTS (which git-prompt 2>/dev/null)
set -xg PYENV_EXISTS (which pyenv 2>/dev/null)
if test -n "$PYENV_EXISTS"
  set -xg PYENV_VERSION_PROMPT (flash_env)(command pyenv version-name 2>/dev/null)(flash_off)
else
  set -xg PYENV_VERSION_PROMPT ""
end

function update_pyenv_version_prompt --on-variable PYENV_VERSION --on-variable PYENV_VIRTUAL_ENV
  if test -n "$PYENV_EXISTS"
    set -xg PYENV_VERSION_PROMPT (flash_env)(command pyenv version-name 2>/dev/null)(flash_off)
  end
end

function fish_right_prompt
  set -l code $status

  function status::color -S
    test $code -ne 0
    and echo (flash_fst)
    or echo (flash_snd)
  end


  if test $CMD_DURATION -gt 1000
    printf (flash_dim)" ~"(printf "%.1fs " (math "$CMD_DURATION / 1000"))(flash_off)
  end

  # flash_battery_charge

  if test -n "$PYENV_EXISTS"
    printf "$PYENV_VERSION_PROMPT"
  end

  if test -d .git
    and not test -f .git-prompt-disable
    if test -n "$GIT_PROMPT_EXISTS"
      git-prompt
    else
      if flash_git_is_stashed
        echo (flash_dim)"<"(flash_off)
      end
      printf " "(begin
        flash_git_is_touched
          and echo (flash_fst)"(*"(flash_snd)(flash_git_branch_name)(flash_fst)")"(flash_off)
          or echo (flash_snd)"("(flash_fst)(flash_git_branch_name)(flash_snd)")"(flash_off)
      end)(flash_off)
    end
  end

  # printf " "(flash_trd)(date +%H(status::color):(flash_trd)%M)(flash_snd)" "(flash_off)

  if test $code -ne 0
    echo (flash_fst)" ≡ "(flash_snd)"$code"(flash_off)
  end
end
