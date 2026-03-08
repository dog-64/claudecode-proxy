#!/bin/bash

# install.sh - Installation script for claudecode-proxy
# Usage: ./install.sh [target_dir]

set -euo pipefail

SCRIPT_NAME="clc"
SCRIPT_FILE="clc"
TARGET_DIR="${1:-}"

# Available installation directories
DIRS=(
    "$HOME/.local/bin"
    "/usr/local/bin"
    "$HOME/bin"
)

# Check if directory is in PATH
in_path() {
    local dir="$1"
    local IFS=':'
    for p in $PATH; do
        [ "$p" = "$dir" ] && return 0
    done
    return 1
}

main() {
    local target_dir="$TARGET_DIR"
    local -a available_dirs=()
    local current_install=""
    local default_choice=""

    # Check where script is already installed
    if current_location=$(command -v "$SCRIPT_NAME" 2>/dev/null); then
        current_install="$(dirname "$current_location")"
    fi

    # If directory not specified - offer selection
    if [ -z "$target_dir" ]; then
        echo "Выберите директорию для установки:"
        echo ""

        # Collect available directories
        for dir in "${DIRS[@]}"; do
            if [ -d "$dir" ] && [ -w "$dir" ]; then
                available_dirs+=("$dir")
            fi
        done

        local i=1

        # Show current installation first if exists
        if [ -n "$current_install" ]; then
            echo "Текущая установка:"
            echo "  [$i] $current_install [уже установлен]"
            default_choice="$i"
            ((i++))
            echo ""
        fi

        # Show directories in PATH
        echo "В PATH:"
        for dir in "${available_dirs[@]}"; do
            if in_path "$dir" && [ "$dir" != "$current_install" ]; then
                echo "  [$i] $dir"
                [ -z "$default_choice" ] && default_choice="$i"
                ((i++))
            fi
        done

        echo ""
        echo "Другие директории:"
        for dir in "${available_dirs[@]}"; do
            if ! in_path "$dir" && [ "$dir" != "$current_install" ]; then
                echo "  [$i] $dir"
                [ -z "$default_choice" ] && default_choice="$i"
                ((i++))
            fi
        done
        echo "  [0] Другая (ввести путь)"

        echo ""
        if [ -n "$default_choice" ]; then
            read -rp "Ваш выбор (номер) [по умолчанию $default_choice]: " choice
            [ -z "$choice" ] && choice="$default_choice"
        else
            read -rp "Ваш выбор (номер): " choice
        fi

        if [ "$choice" = "0" ]; then
            read -rp "Введите полный путь: " target_dir
        elif [[ "$choice" =~ ^[1-9][0-9]*$ ]] && [ "$choice" -lt "$i" ]; then
            idx=$((choice - 1))
            target_dir="${available_dirs[$idx]}"
        else
            echo "Ошибка: неверный выбор"
            exit 1
        fi
    fi

    # Directory check
    if [ ! -d "$target_dir" ]; then
        echo "Создание директории: $target_dir"
        mkdir -p "$target_dir"
    fi

    if [ ! -w "$target_dir" ]; then
        echo "Ошибка: нет прав записи в $target_dir"
        echo "Попробуйте с sudo:"
        echo "  sudo ./install.sh $target_dir"
        exit 1
    fi

    # Copy script
    local src
    local dst
    src="$(dirname "$0")/$SCRIPT_FILE"
    dst="$target_dir/$SCRIPT_NAME"

    echo "Установка: $src -> $dst"
    cp "$src" "$dst"
    chmod +x "$dst"

    echo ""
    echo "Установлено!"
    echo ""

    # Check if directory is in PATH
    if in_path "$target_dir"; then
        echo "[OK] Директория уже в PATH"
        echo ""
        echo "Обновление кэша команд zsh..."
        hash -r 2>/dev/null || rehash 2>/dev/null || true
        echo ""
        echo "Готово! Теперь можно использовать: clc [--model glm|sonnet|opus|haiku]"
    else
        echo "[!] Директория не найдена в PATH"
        echo ""
        echo "Добавьте в ~/.zshrc:"
        echo "  export PATH=\"$target_dir:\$PATH\""
        echo ""
        echo "Затем выполните:"
        echo "  source ~/.zshrc && rehash"
        echo ""
        echo "Или для текущей сессии:"
        echo "  export PATH=\"$target_dir:\$PATH\" && rehash"
    fi
}

main
