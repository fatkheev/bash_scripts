#!/bin/bash

# Сканируем самые большие папки так:
# du -sh /Users/mathosha/*

# Исходные папки (указать здесь)
SRC_FOLDERS=(
  "/Users/mathosha/Library"
  "/Users/mathosha/go"
)

# Целевая папка для переноса
TARGET="/Users/mathosha/goinfre"

# Функция для переноса и создания символической ссылки
move_and_link() {
  local src=$1
  local target=$2

  # Имя папки в целевой директории
  local folder_name=$(basename "$src")

  # Целевая директория
  local target_path="$target/$folder_name"

  echo "Перемещаем $src в $target_path..."

  # Проверяем, существует ли целевая директория
  if [ ! -d "$target" ]; then
    echo "Создаем директорию $target..."
    mkdir -p "$target"
  fi

  # Перенос папки
  if [ -d "$src" ]; then
    mv "$src" "$target_path"
    echo "$src перемещен в $target_path."
  else
    echo "Ошибка: $src не существует."
    return 1
  fi

  # Создание символической ссылки
  ln -s "$target_path" "$src"
  echo "Символическая ссылка создана: $src -> $target_path."
}

# Перемещаем и создаем ссылки для каждой папки
for folder in "${SRC_FOLDERS[@]}"; do
  move_and_link "$folder" "$TARGET"
done

echo "Готово!"
