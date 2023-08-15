#!/bin/zsh

read -r -d '' ASCII_ART <<"EOF"
.___  ___.      ___      .___________. __    __    ______        _______. __    __       ___      
|   \/   |     /   \     |           ||  |  |  |  /  __  \      /       ||  |  |  |     /   \     
|  \  /  |    /  ^  \    `---|  |----`|  |__|  | |  |  |  |    |   (----`|  |__|  |    /  ^  \    
|  |\/|  |   /  /_\  \       |  |     |   __   | |  |  |  |     \   \    |   __   |   /  /_\  \   
|  |  |  |  /  _____  \      |  |     |  |  |  | |  `--'  | .----)   |   |  |  |  |  /  _____  \  
|__|  |__| /__/     \__\     |__|     |__|  |__|  \______/  |_______/    |__|  |__| /__/     \__\ 
EOF

for i in {1..3}; do
    for j in {5..8} {8..5}; do
        clear
        tput cup $j 0
        echo "$ASCII_ART"
        sleep 0.1
    done
done

if ! command -v brew &> /dev/null; then
    echo "Установка Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew уже установлен!"
fi

if ! brew list check &> /dev/null; then
    echo "Установка библиотеки check..."
    brew update
    brew install check
else
    echo "Библиотека check уже установлена!"
fi

CHECK_PATH=$(find /opt/homebrew -path "*/check/0.15.2/include/check.h" 2>/dev/null | head -n 1)

if [[ -z "$CHECK_PATH" ]]; then
    echo "Ошибка: не удалось найти путь установки check.h"
    exit 1
fi

CHECK_DIR=$(dirname "$CHECK_PATH")
LIB_DIR=$(dirname "$CHECK_DIR")/lib

echo "Добавление путей к переменным окруженим..."

echo "export CPATH=\"$CHECK_DIR:\$CPATH\"" >> ~/.bashrc
echo "export LIBRARY_PATH=\"$LIB_DIR:\$LIBRARY_PATH\"" >> ~/.bashrc

echo "export CPATH=\"$CHECK_DIR:\$CPATH\"" >> ~/.zshrc
echo "export LIBRARY_PATH=\"$LIB_DIR:\$LIBRARY_PATH\"" >> ~/.zshrc

source ~/.bashrc
source ~/.zshrc

echo "Готово!"
