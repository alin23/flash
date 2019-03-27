function fish_title
	set -q SSH_CLIENT
	and printf (hostname)" SSH \u276F "

	set -l cmd (printf "%.20s" "$argv")

	if test "$PWD" != "$HOME"
		if test -n "$cmd"
			printf (basename $PWD)" \u276F $cmd"
		else
			basename $PWD
		end
	else
		echo -n '~'
	end
end