# to show colors at terminal: 'spectrum_ls'

ZSH_THEME_GIT_PROMPT_PREFIX="$FG[008]"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="$FG[047]●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="$FG[221]●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$FG[203]●%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_BRANCHCOLOR="$FG[008]"
ZSH_THEME_GIT_PROMPT_DIRTY=" $FG[221]"


bureau_git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

bureau_git_status () {
  _INDEX=$(command git status --porcelain -b 2> /dev/null)
  _STATUS=""
  if $(echo "$_INDEX" | grep '^[AMRD]. ' &> /dev/null); then
    _STATUS="$_STATUS $ZSH_THEME_GIT_PROMPT_STAGED"
  fi
  if $(echo "$_INDEX" | grep '^.[MTD] ' &> /dev/null); then
    _STATUS="$_STATUS $ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi
  if $(echo "$_INDEX" | grep -E '^\?\? ' &> /dev/null); then
    _STATUS="$_STATUS $ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi
  if $(echo "$_INDEX" | grep '^UU ' &> /dev/null); then
    _STATUS="$_STATUS $ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    _STATUS="$_STATUS $ZSH_THEME_GIT_PROMPT_STASHED"
  fi
  if $(echo "$_INDEX" | grep '^## .*ahead' &> /dev/null); then
    _STATUS="$_STATUS $ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if $(echo "$_INDEX" | grep '^## .*behind' &> /dev/null); then
    _STATUS="$_STATUS $ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if $(echo "$_INDEX" | grep '^## .*diverged' &> /dev/null); then
    _STATUS="$_STATUS $ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  echo $_STATUS
}


bureau_git_prompt () {
  _branch=$(bureau_git_branch)
  _pStatus=$(bureau_git_status)
  _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$(parse_git_dirty)$_branch"
    if [[ "${_pStatus}x" != "x" ]]; then
      _result="$_pStatus $_result"
    fi
    _result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
  echo $_result
}


# get_space () {
#   local STR=$1$2
#   local zero='%([BSUbfksu]|([FB]|){*})'
#   local LENGTH=${#${(S%%)STR//$~zero/}} 
#   local SPACES=""
#   (( LENGTH = ${COLUMNS} - $LENGTH - 1))
  
#   for i in {0..$LENGTH}
#     do
#       SPACES="$SPACES "
#     done

#   echo $SPACES
# }

# _1LEFT="$_USERNAME $_PATH"
# _1RIGHT="$(bureau_git_branch) "

addSpaceLine () {
  # _1SPACES=`get_space $_1LEFT $_1RIGHT`
  print 
  # print -rP "$_1LEFT$_1SPACES$_1RIGHT"
}

# default LSCOLORS=Gxfxcxdxbxegedabagacad


# PROMPT='🌀  $FG[023]%~%u%{$reset_color%} $(bureau_git_prompt) '
PROMPT='🌀  $FG[047]%~%u%{$reset_color%}  '
RPROMPT='$(bureau_git_prompt)  $FG[240]%m'

autoload -U add-zsh-hook
add-zsh-hook precmd addSpaceLine
