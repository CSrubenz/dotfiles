# 💻 My Dotfiles

These dotfiles are cleanly managed using **GNU Stow** for a modular and instant setup across different machines.

## 🛠️ Configured Software

* **Git:**  Global configuration and aliases.
* **Shell:** bash (`.bashrc` and `.profile`).
* **Editor:** Neovim (Fully loaded with Native LSP & Fzf-Lua)
* **Window Manager:** Hyprland (Wayland, dynamically tiled, hardware-accelerated)
* **Bar:** Waybar (Custom JSON/CSS with dual-battery ThinkPad support)
* **Terminal:** Foot (Ultra-lightweight, Wayland-native)
* **Launcher:** Fuzzel (Fast, Wayland-native application launcher)
* **Notifications:** Mako (light pop-up)
* **Color Scheme:** 🎨 Catppuccin Mocha (Consistent across Hyprland, Waybar, Foot, Fuzzel, and Mako)

## 🚀 Installation on a new machine

1. Ensure you have `git` and `stow` installed on your system.
2. Clone this repository to the root of your home directory:
   ```bash
   git clone git@github.com:CSrubenz/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   chmod +x deploy.sh
   ./deploy.sh
   ```

Note: If you used my automated Arch Installer, this repository was already cloned and deployed for you automatically!

## ⌨️ Key Workflow & Bindings

The environment is configured for a French AZERTY layout and heavily relies on the SUPER (Windows) key.

### Window Management

* SUPER + CONTROL + T : Open Terminal
* SUPER + CONTROL + D : Open Launcher
* SUPER + CONTROL + B : Open Browser
* SUPER + CONTROL + F : Open File Manager
* SUPER + CONTROL + L : Lock the screen
* SUPER + CONTROL + K : Kill active windows
* SUPER + CONTROL + E : Exit hyprland
* SUPER + CONTROL + S : Screenshot
* etc

### Workspaces (AZERTY Native)

* SUPER + [&, é, ", ', (, ...] : Navigate to workspaces 1 to 9
* SUPER + Shift + [&, é, ", ', (, ...] : Move active window to workspaces 1 to 9 (DWM mode)
* SUPER + ALT + [&, é, ", ', (, ...] : Move active window and move focus to workspaces 1 to 9
* SUPER + Mouse Scroll : Scroll through workspaces
* etc

## 💻 Hardware-Specific Notes (ThinkPad T480)

These dotfiles include specific configurations to elegantly handle ThinkPad hardware quirks:

* PowerBridge Battery: Waybar uses a custom script module to merge BAT0 (Internal) and BAT1 (External) into a single, mathematically accurate percentage.
* Media Keys: Volume, brightness, and media playback keys (Play/Pause/Next) are mapped natively via wpctl, brightnessctl, and playerctl.
