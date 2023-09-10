# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
HISTIGNORE='fg:ls:l:la:gl:o.:v'

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# HISTSIZE=100000
# HISTFILESIZE=100000
HISTSIZE=-1
HISTFILESIZE=-1

# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command
shopt -s checkwinsize
# automatically cd into directories
# shopt -s autocd

# don't tab complete hidden
bind 'set match-hidden-files off'

: "${HOST_COLOR=\[\033[2;32m\]}"
SLASH_COLOR='\[\033[1;90m\]'

# COMPLETION_PATH='C:/Program Files/Git/mingw64/share/git/completion'
# . "$COMPLETION_PATH/git-completion.bash"
# . "$COMPLETION_PATH/git-prompt.sh"

# if command -v __git_ps1 >&-; then
if false; then
  PROMPT_COMMAND_GIT=' \[\e[2;33m\]$(__git_ps1 " %s")\[\e[0m\]'
else
  PROMPT_COMMAND_GIT=''
fi
export GIT_PS1_SHOWDIRTYSTATE=true      # staged '+', unstaged '*'
# export GIT_PS1_SHOWUNTRACKEDFILES=true  # '%' untracked files
# export GIT_PS1_SHOWUPSTREAM="auto"      # '<' behind, '>' ahead, '<>' diverged, '=' no difference
export GIT_PS1_SHOWSTASHSTATE=true      # '$' something is stashed

PROMPT_COMMAND='PS1="$(dirs +0)";PS1="\[\e[90m\]\D{%I:%M%P}\[\e[0m\] $HOST_COLOR$(whoami)\[\e[0m\] ${PS1//\//$SLASH_COLOR/\\[\\e[0m\\]}$PROMPT_COMMAND_GIT\n\[\e[90m\]\$\[\e[0m\] "'

##########################################################################

for x in ls grep fgrep egrep diff
do
  alias "$x=$x --color=auto"
done
alias tree='tree -C'

alias la='ls -A'
alias ll='ls -lhAF'
alias l='ls -lh'
alias l.='ls -d .*'

alias v='vim'

alias vimp='xargs -od"\n" vim -p'

up() { # no more cd ../../../
  local d=""
  local n=$1
  for ((i=1; i<=n; i++)); do d=$d/..; done
  d=$(sed 's/^\///' <<< "$d")
  [ -z "$d" ] && d=..
  cd $d
}

ups() { ps -u "${1:-$USER}" -o pid,uname,nice,pcpu,pmem,etime,args --sort=-pcpu,-pmem; }

here() { cd "$(pwd -P)"; }
loc() { echo "$(whoami)@$(hostname):$(pwd -P)"; }

GL_FORMAT='%C(auto)%h%Creset %s %Cblue(%aN, %cr)%Creset'
gl() {
  local OPTIND opt c b
  while getopts 'cb' opt; do
    case "$opt" in
      c)
        echo "$(git rev-list --count HEAD) commits"
        ;;
      b)
        echo -e "\033[1;32m$(git branch --show-current)\033[0m"
        ;;
      *)
        echo "usage: ${FUNCNAME[0]} [-c] [-b]" >&2
        exit 1
        ;;
    esac
  done
  shift "$(($OPTIND -1))"

  git log --format="$GL_FORMAT" -n"${1:-8}"
}
g-hash() {
  git log --format='%H %ae' -n"${1:-16}" \
  | awk '{ if (!x) { x = $2 } else if ($2!=x) { print $1; exit } }'
}
g-modified() {
  git diff --name-only `g-hash`
}
g-stash() {
  local OPTIND opt c b ref
  while getopts 'cb' opt; do
    case "$opt" in
      c)
        ref="/$(git rev-parse HEAD)"
        ;;
      b)
        ref="$(git branch --show-current | sed 's,/,%2F,g')"
        ref="?until=refs%2Fheads%2F${ref}&merges=include"
        ;;
      *)
        echo "usage: ${FUNCNAME[0]} [-c] [-b]" >&2
        exit 1
        ;;
    esac
  done
  shift "$(($OPTIND -1))"

  base=$(\
    git config --get remote.origin.url \
    | sed -n "s;ssh://git@\([^/:]\+\)\(:[0-9]\+\)\?/\([^./]\+\)/\([^./]\+\).git;https://\1/projects/\3/repos/\4/commits;p" \
  )
  echo "$base$ref"
}

if [ -v MINGW_PREFIX ]; then
  export VISUAL=vim;
  export EDITOR=vim;

  alias python='winpty python.exe'
fi
