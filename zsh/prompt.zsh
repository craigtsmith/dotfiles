autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  ref=$($git symbolic-ref HEAD 2>/dev/null) || return
  echo "${ref#refs/heads/}"
}

git_state_colour() {
  st=$($git status 2>/dev/null)
  state_colour=""
  if [[ $st == "" ]]; then
    echo ""
  else
    if [[ "$st" =~ "working directory clean" ]]; then
      state_colour="%{$fg_bold[green]%}"
    elif [[ "$st" =~ "Changes to be committed" ]]; then
      state_colour="%{$fg_bold[yellow]%}"
    else
      state_colour="%{$fg_bold[red]%}"
    fi
  fi
  echo "$state_colour"
}

git_push_symbol () {
  st=$($git status 2>/dev/null)
  remote_pattern="# Your branch is (.*) of"

  if [[ "$st" =~ $remote_pattern ]]; then
    if [[ $MATCH =~ "ahead" ]]; then
      remote="↑"
    else
      remote="↓"
    fi
  else
    remote=""
  fi

  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ "$st" =~ $diverge_pattern ]]; then
    remote="↕"
  fi

  echo "$remote"
}

git_info () {
  ref=$($git symbolic-ref HEAD 2>/dev/null) || return
  echo "$(git_state_colour)[$(git_branch)$(git_push_symbol)]%{$reset_color%}"
}

ruby_version() {

  if (( $+commands[rbenv] ))
  then
    echo "$(rbenv version | awk '{print $1}')"
  fi

  if (( $+commands[rvm-prompt] ))
  then
    echo "$(rvm-prompt | awk '{print $1}')"
  fi
}

rb_prompt() {
  if ! [[ -z "$(ruby_version)" ]]
  then
    echo "%{$fg[red]%}[$(ruby_version)]%{$reset_color%}"
  else
    echo ""
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/"
}

login_info () {
  if [[ -z "$SSH_CLIENT" ]]; then
    echo ""
  else
    echo " %{$fg_bold[green]%}%n@$(hostname -s)%{$reset_color%}"
  fi
}

time_info () {
  echo "%{$fg[green]%}%T%{$reset_color%}"
}

prompt_symbol () {
  echo "%(?,%{$reset_color%}› ,%{$fg_bold[red]%}› %{$reset_color%}"
}

set_prompt () {
  export RPROMPT="$(rb_prompt)$(git_info)"
  export PROMPT="$(time_info)$(login_info) $(directory_name) $(prompt_symbol)"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
