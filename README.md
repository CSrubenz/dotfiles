# 💻 My Dotfiles

Welcome to my system configuration repository!
These dotfiles are cleanly managed using **GNU Stow** for a modular and instant setup across different machines.

## 🛠️ Configured Software

* **Neovim** (`nvim/`): Full IDE setup (LSP for C++, Go, Bash, autocompletion, Treesitter, auto-formatting).
* **Bash** (`bash/`): Shell configuration (`.bashrc` and `.profile`).
* **Git** (`git/`): Global configuration and aliases.

## 🚀 Installation on a new machine

1. Ensure you have `git` and `stow` installed on your system.
2. Clone this repository to the root of your home directory:
   ```bash
   git clone git@github.com:CSrubenz/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   stow bash nvim git
