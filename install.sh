#!/bin/bash

# --- COLORS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}--- DARK GLOWY DOTS INSTALLER (White Animated Gray Blur Edition) ---${NC}"
echo -e "${BLUE}--- Designed by Frqmelikescheese ---${NC}"

# 1. DEPENDENCIES (Arch Linux focus)
# Added: sddm, hyprlock, and Qt modules for the theme
DEPS="hyprland hyprlock sddm qt5-quickcontrols2 qt5-graphicaleffects qt6-5compat qt6-declarative waybar kitty rofi dunst swaybg ttf-jetbrains-mono-nerd brightnessctl wireplumber grim slurp wl-clipboard network-manager-applet thunar cava fastfetch"

if command -v yay >/dev/null 2>&1; then
    echo -e "${GREEN}Installing dependencies with yay...${NC}"
    yay -S --needed $DEPS --noconfirm
elif command -v pacman >/dev/null 2>&1; then
    echo -e "${GREEN}Installing dependencies with pacman...${NC}"
    sudo pacman -S --needed $DEPS --noconfirm
else
    echo -e "${RED}Error: Neither yay nor pacman found. Please install manually:${NC}"
    echo "$DEPS"
    exit 1
fi

# 2. CONFIGURATION BACKUP
echo -e "${BLUE}Backing up existing configs...${NC}"
BACKUP_DIR=~/.config/backup-dots-$(date +%s)
mkdir -p "$BACKUP_DIR"

# Backup .config directories
for dir in hypr waybar kitty rofi dunst cava sddm-theme; do
    if [ -d ~/.config/$dir ]; then
        cp -r ~/.config/$dir "$BACKUP_DIR"/ 2>/dev/null
    fi
done

# Backup shell configs
for file in .bashrc .zshrc; do
    if [ -f ~/$file ]; then
        cp ~/$file "$BACKUP_DIR"/ 2>/dev/null
    fi
done

# 3. APPLY NEW CONFIGS
echo -e "${GREEN}Applying new configurations...${NC}"
mkdir -p ~/.config

# Copy .config files
cp -r .config/* ~/.config/

# Copy shell files
cp .bashrc ~/ 2>/dev/null
cp .zshrc ~/ 2>/dev/null

# 4. INSTALL SDDM THEME
THEME_NAME="WhiteAnimatedGrayBlur"
INSTALL_DIR="/usr/share/sddm/themes/$THEME_NAME"

echo -e "${GREEN}Installing SDDM theme: $THEME_NAME...${NC}"
if [ -d ".config/sddm-theme" ]; then
    sudo mkdir -p "$INSTALL_DIR"
    sudo cp -r .config/sddm-theme/* "$INSTALL_DIR"
    
    echo -e "${BLUE}Setting SDDM theme in config...${NC}"
    if [ -f /etc/sddm.conf ]; then
        sudo sed -i "s/^Current=.*/Current=$THEME_NAME/" /etc/sddm.conf
    else
        echo -e "[Theme]\nCurrent=$THEME_NAME" | sudo tee /etc/sddm.conf > /dev/null
    fi
fi

# 5. FINALIZING
echo -e "${BLUE}Finalizing...${NC}"
chmod +x ~/.config/waybar/launch.sh 2>/dev/null
chmod +x ~/.config/hypr/scripts/*.sh 2>/dev/null

echo -e "${GREEN}--- INSTALLATION COMPLETE ---${NC}"
echo "Designed by Frqmelikescheese"
echo "Log out or use 'SUPER + L' to see your new lock screen!"
