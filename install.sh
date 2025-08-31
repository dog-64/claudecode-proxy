#!/bin/bash

set -e

CURRENT_DIR="$(pwd)"

echo "🔍 Searching for bin directories in home folder..."
BIN_DIRS=$(find ~ -maxdepth 2 -type d -name "*bin*" 2>/dev/null | grep -E "(bin|\.local/bin)$" | head -5)

if [[ -z "$BIN_DIRS" ]]; then
    echo "📁 No existing bin directories found"
    echo -n "🎯 Create ~/.local/bin? (Y/n): "
    read -r create_choice
    if [[ "$create_choice" =~ ^[Nn]$ ]]; then
        echo "❌ Installation cancelled"
        exit 1
    fi
    TARGET_DIR="$HOME/.local/bin"
    echo "📁 Creating $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
else
    echo "📂 Found bin directories:"
    echo "$BIN_DIRS" | nl -w2 -s'. '
    echo "$(($(echo "$BIN_DIRS" | wc -l) + 1)). Create new: ~/.local/bin"
    
    echo -n "🎯 Select directory (1-$(($(echo "$BIN_DIRS" | wc -l) + 1))) or press Enter for ~/.local/bin: "
    read -r choice
    
    if [[ -z "$choice" ]] || [[ "$choice" -eq $(($(echo "$BIN_DIRS" | wc -l) + 1)) ]]; then
        TARGET_DIR="$HOME/.local/bin"
        if [[ ! -d "$TARGET_DIR" ]]; then
            echo "📁 Creating $TARGET_DIR"
        fi
        mkdir -p "$TARGET_DIR"
    else
        TARGET_DIR=$(echo "$BIN_DIRS" | sed -n "${choice}p")
        if [[ -z "$TARGET_DIR" ]]; then
            echo "❌ Invalid choice, using ~/.local/bin"
            TARGET_DIR="$HOME/.local/bin"
            mkdir -p "$TARGET_DIR"
        fi
    fi
fi

echo "📦 Installing files from $CURRENT_DIR to $TARGET_DIR..."

for file in *; do
    if [[ -f "$file" && "$file" != "install.sh" && "$file" != "README.md" ]]; then
        echo "📋 Copying $file to $TARGET_DIR/"
        cp "$file" "$TARGET_DIR/"
        chmod +x "$TARGET_DIR/$file"
    fi
done

echo "🔍 Checking if $TARGET_DIR is in PATH..."
if [[ ":$PATH:" == *":$TARGET_DIR:"* ]]; then
    echo "✅ $TARGET_DIR is already in PATH"
else
    echo "⚠️ $TARGET_DIR is not in PATH"
    
    SHELL_NAME=$(basename "$SHELL")
    case "$SHELL_NAME" in
        zsh)
            PROFILE_FILE="$HOME/.zshrc"
            ;;
        bash)
            if [[ -f "$HOME/.bash_profile" ]]; then
                PROFILE_FILE="$HOME/.bash_profile"
            else
                PROFILE_FILE="$HOME/.bashrc"
            fi
            ;;
        fish)
            PROFILE_FILE="$HOME/.config/fish/config.fish"
            ;;
        *)
            PROFILE_FILE="$HOME/.profile"
            ;;
    esac
    
    echo "📝 To add $TARGET_DIR to PATH, add this line to $PROFILE_FILE:"
    echo ""
    if [[ "$SHELL_NAME" == "fish" ]]; then
        echo "    set -gx PATH $TARGET_DIR \$PATH"
    else
        echo "    export PATH=\"$TARGET_DIR:\$PATH\""
    fi
    echo ""
    echo "💡 Then run: source $PROFILE_FILE"
fi

echo "✅ Installation complete!"
