#!/bin/bash

# --- COLORS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}--- DARK GLOWY DOTS INSTALLER ---${NC}"

# 1. DEPENDENCIES (Arch Linux focus given 'yay')
DEPS="hyprland waybar kitty rofi dunst swaybg ttf-jetbrains-mono-nerd brightnessctl wireplumber grim slurp wl-clipboard network-manager-applet thunar cava fastfetch"

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
for dir in hypr waybar kitty rofi dunst cava; do
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

# 4. FINALIZING
echo -e "${BLUE}Finalizing...${NC}"
chmod +x ~/.config/waybar/launch.sh 2>/dev/null
chmod +x ~/.config/hypr/scripts/*.sh 2>/dev/null

echo -e "${GREEN}--- INSTALLATION COMPLETE ---${NC}"
echo "Log out and log back into Hyprland to see changes!"
