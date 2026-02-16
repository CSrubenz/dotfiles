# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
export HISTFILE="$HOME/.local/state/bash_history"
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi



# VIM mode
set -o vi

# Function to fuzzy find and cd into directories (including symlinks)
fcd() {
  local dir
  dir=$(find -L ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
  ls
}
bind -x '"\C-f": fcd'

# Function to quickly jump to parent directories
fcdb() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf +m)
  cd "$DIR"
  ls
}

# Function to cd into directories from your command history
fcdh() {
  local dir
  dir=$(history | grep '^cd' | awk '{print $2}' | sort -u | fzf +m) &&
  cd "$dir"
  ls
}

# Function to open files with their default application using fzf
fopen() {
    # Set common file extensions to search for
    local exts="pdf|jpg|jpeg|png|gif|mp4|mkv|avi|mp3|ogg|xlsx|docx|doc|odt|txt|md|csv"

    # Add basic error handling
    if [ ! -x "$(command -v fzf)" ]; then
        echo "Error: fzf is not installed" >&2
        return 1
    fi

    if [ ! -x "$(command -v xdg-open)" ]; then
        echo "Error: xdg-open is not installed" >&2
        return 1
    fi

    # Use find to list files with specific extensions
    local file
    file=$(find "${1:-.}" -type f -regextype posix-extended \
           -not -path '*/\.*/*' \
           -regex ".*\.($exts)" 2>/dev/null | \
           fzf --preview '
             mime=$(file -b --mime-type {});
             if [[ $mime == image/* ]]; then
               if command -v identify >/dev/null 2>&1; then
                 identify {} 2>/dev/null || echo "Image info not available";
               else
                 echo "Install ImageMagick for image information";
               fi
             elif [[ $mime == text/* ]]; then
               head -100 {};
             else
               echo "Binary file: $mime";
               file -b {};
             fi' \
           --preview-window='right:60%')

    # If a file was selected, open it with xdg-open
    if [ -n "$file" ]; then
        nohup xdg-open "$file" >/dev/null 2>&1 &
        # Suppress the "done" message
        disown
    fi
}
bind -x '"\C-o": fopen'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
