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
* **Color Scheme:** 🎨 Catppuccin Macchiato (Consistent across Hyprland, Waybar, Foot, Fuzzel, and Mako)

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

* SUPER + Return : Open Terminal (Foot)
* SUPER + D : Open Launcher (Fuzzel)
* SUPER + Shift + B : Open Browser (Firefox)
* SUPER + Shift + F : Open File Manager (PCManFM)
* SUPER + C : Kill active window
* SUPER + V : Toggle floating window
* SUPER + F : Toggle fullscreen
* SUPER + Arrow Keys : Move focus (Left, Right, Up, Down)

### Workspaces (AZERTY Native)

* SUPER + [&, é, ", ', (] : Navigate to workspaces 1 to 5
* SUPER + Shift + [&, é, ", ', (] : Move active window to workspaces 1 to 5
* SUPER + Mouse Scroll : Scroll through workspaces

### Utilities

* SUPER + Shift + S : Screenshot a selected area directly to the clipboard (grim + slurp)

## 💻 Hardware-Specific Notes (ThinkPad T480)

These dotfiles include specific configurations to elegantly handle ThinkPad hardware quirks:

1. PowerBridge Battery: Waybar uses a custom upower module to merge BAT0 (Internal) and BAT1 (External) into a single, mathematically accurate percentage.
2. French Typography: If paired with my keyd kernel patch for ANSI keyboards, pressing Alt + < in Hyprland outputs « (Left French Quote), and Alt + > outputs ».
3. Media Keys: Volume, brightness, and media playback keys (Play/Pause/Next) are mapped natively via wpctl, brightnessctl, and playerctl.
