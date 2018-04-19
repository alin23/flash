function ssh_hostname_simple
  if set -q SSH_CLIENT
    echo (whoami)'@'(hostname)
  else
    whoami
  end
end


function fish_prompt_simple
  set -l sepleft '('
  set -l sepright ')'

  set -l prompt (prompt_pwd)

  printf (begin
    if string match -q '/*' $prompt
      format_path (string replace '/' "$sepleft # $sepright " $prompt)
    else if string match -q '~*' $prompt
      format_path (string replace -r '~/?' "$sepleft ⌁ $sepright " $prompt)
    else
      format_path $prompt
    end
  end)(test (string length $prompt) -ne 1; and echo " $sepright "; or echo '')
end


function fish_title
  echo "$_ ⌁ "(ssh_hostname_simple)" ➜ "(fish_prompt_simple)
end