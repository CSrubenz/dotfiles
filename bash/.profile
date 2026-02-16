# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# =========================================
# XDG Base Directory
# =========================================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"


# Language directory
export GOPATH="$XDG_DATA_HOME/go"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GHCUP_USE_XDG_DIRS=1
export NVM_DIR="$XDG_DATA_HOME/nvm"
export CABAL_DIR="$XDG_DATA_HOME/cabal"
export STACK_ROOT="$XDG_DATA_HOME/stack"
export OPAMROOT="$XDG_DATA_HOME/opam"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# Utils
export LESSHISTFILE="$XDG_STATE_HOME/lesshst"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export SCIKIT_LEARN_DATA="$XDG_DATA_HOME/scikit_learn_data"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# Python & Data Science (XDG)
export PYTHONHISTORY="$XDG_STATE_HOME/python_history"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export NLTK_DATA="$XDG_DATA_HOME/nltk_data"
export GENSIM_DATA_DIR="$XDG_DATA_HOME/gensim-data"

# =========================================
# Default applications
# =========================================
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"

# =========================================
# Keyboard input
# =========================================
export XMODIFIERS=@im=fcitx5

# =========================================
# PATH
# =========================================
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Go
PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# JetBrains IDEs
PATH="$PATH:$XDG_DATA_HOME/clion/bin"
PATH="$PATH:$XDG_DATA_HOME/pycharm/bin"
PATH="$PATH:$XDG_DATA_HOME/idea/bin"

# ROCM
PATH="/opt/rocm/bin:$PATH"

export PATH

# =========================================
# Environnements
# =========================================
[ -f "$XDG_CONFIG_HOME/ghcup/env" ] && . "$XDG_CONFIG_HOME/ghcup/env"
[ -f "$CARGO_HOME/env" ] && . "$CARGO_HOME/env"

# =========================================
# Bashrc
# =========================================
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
