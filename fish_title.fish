function ssh_hostname_simple
  if set -q SSH_CLIENT
    printf (hostname)" SSH \u276F "
  end
end

function format_path_simple
  set -l sepright ' ) '
  set -l base (basename "$argv[1]")
  string replace -a '/' $sepright $argv[1] | string replace -r (string escape $base)'$' $base
end

function fish_prompt_simple
  set -l sepleft '('
  set -l sepright ')'

  set -l prompt (prompt_pwd)

  printf (begin
    if string match -q '/*' $prompt
      format_path_simple (string replace '/' "$sepleft # $sepright " $prompt)
    else if string match -q '~*' $prompt
      format_path_simple (string replace -r '~/?' "$sepleft ⌁ $sepright " $prompt)
    else
      format_path_simple $prompt
    end
  end)(test (string length $prompt) -ne 1; and echo " $sepright "; or echo '')
end

function fish_title
  echo (ssh_hostname_simple)(fish_last_cmd $argv)
end