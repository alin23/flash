function command_exists
    argparse --name command_exists 'v/verbose' -- $argv

    set varname (string escape --style=var -- $argv[1])
    if set -q "$varname"_EXISTS
        set out (eval echo '$'(echo -n "$varname"_EXISTS))
        if set -q _flag_verbose
            echo $out
        end
        if test -z "$out"
            return 1
        end
        return 0
    end

    set cmdout (command -s $argv[1]; or which $argv[1] 2>/dev/null | tr -d '[:space:]')
    if test -n "$cmdout"
        set -xU "$varname"_EXISTS $cmdout
        return 0
    end

    set -xU "$varname"_EXISTS ""
    return 1
end

function flash_git_is_stashed
	command git rev-parse --verify --quiet refs/stash >/dev/null
end

function flash_git_branch_name
	command git symbolic-ref --short HEAD 2>/dev/null
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

function update_virtualenv_prompt --on-variable VIRTUAL_ENV
	if set -q VIRTUAL_ENV
		set -xg VENV_PROMPT (flash_env) (basename "$VIRTUAL_ENV") (flash_off)" "
	else
		set -xg VENV_PROMPT ""
	end
end

function update_pyenv_version_prompt --on-variable PYENV_VERSION --on-variable PYENV_VIRTUAL_ENV --on-variable FLASH_PYTHON_VERSION
	if command_exists pyenv
		set -xg PYENV_VERSION_PROMPT (flash_env)(command pyenv version-name 2>/dev/null)(flash_off)' '
	else
		set -xg PYENV_VERSION_PROMPT ""
	end
end

update_virtualenv_prompt
update_pyenv_version_prompt

function fish_prompt_ranger
	if not set -q RANGER_LEVEL
		echo ""
		return 0
	end
	echo (set_color -o $_COLOR_1)  (flash_off)
end

function isgit
	not test -f .git-prompt-disable
		and test -d .git
		or test -d ../.git
		or test -d ../../.git
		or test -d ../../../.git
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

	if command_exists pyenv
		printf "$PYENV_VERSION_PROMPT"
	end

	if test -n "$VENV_PROMPT"
		printf "$VENV_PROMPT"
	end

	if isgit
		if command_exists pretty-git-prompt
			pretty-git-prompt
		else if command_exists git-prompt
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
	fish_prompt_ranger
	if test $code -ne 0
		echo (flash_fst)" ≡ "(flash_snd)"$code"(flash_off)
	end
end
