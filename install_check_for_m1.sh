#!/bin/bash

# Проверка наличия Homebrew
if ! command -v brew &> /dev/null; then
    echo "Установка Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew уже установлен!"
fi

# Проверка наличия библиотеки check
if ! brew list check &> /dev/null; then
    echo "Установка библиотеки check..."
    brew update
    brew install check
else
    echo "Библиотека check уже установлена!"
fi

# Находим путь установки check.h
CHECK_PATH=$(find /opt/homebrew -path "*/check/0.15.2/include/check.h" 2>/dev/null | head -n 1)

# Если не найдено, завершаем скрипт с ошибкой
if [[ -z "$CHECK_PATH" ]]; then
    echo "Ошибка: не удалось найти путь установки check.h"
    exit 1
fi

CHECK_DIR=$(dirname "$CHECK_PATH")
LIB_DIR=$(dirname "$CHECK_DIR")/lib

# Добавляем пути к заголовочным файлам и библиотекам в ~/.bashrc и ~/.zshrc
echo "Добавление путей к переменным окружения..."

echo "export CPATH=\"$CHECK_DIR:\$CPATH\"" >> ~/.bashrc
echo "export LIBRARY_PATH=\"$LIB_DIR:\$LIBRARY_PATH\"" >> ~/.bashrc

echo "export CPATH=\"$CHECK_DIR:\$CPATH\"" >> ~/.zshrc
echo "export LIBRARY_PATH=\"$LIB_DIR:\$LIBRARY_PATH\"" >> ~/.zshrc

# Применяем изменения
source ~/.bashrc
source ~/.zshrc

echo "Готово!"
