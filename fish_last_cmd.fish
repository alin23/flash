function fish_last_cmd
    set -l cmd "$argv"
    set -xg _FISH_LAST_CMD "$cmd"

    if test (string length $cmd) -gt 23
        set cmd (string sub -l 20 "$cmd…")
    end

    if test "$PWD" != "$HOME"
        set -l ddir (basename $PWD)
        if not test "$cmd"
            set cmd $ddir
        else
            set cmd (printf "$ddir \u276F $cmd")
        end
    end

    echo "$cmd"
end
