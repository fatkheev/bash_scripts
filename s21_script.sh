#!/bin/bash

# Инструкция

# Установить, но не запускать Docker Desktop
# chmod +x s21_script.sh
# ./s21_script.sh <nick>

# Изменение размера окна терминала
printf '\033[8;80;200t' # Устанавливаем размер окна на 40 строк и 100 столбцов

# Анимация ASCII-арта с переливанием цветов
read -r -d '' ASCII_ART <<"EOF"
`7MMM.     ,MMF'           mm    `7MM                          `7MM                 
  MMMb    dPMM             MM      MM                            MM                 
  M YM   ,M MM   ,6"Yb.  mmMMmm    MMpMMMb.   ,pW"Wq.  ,pP"Ybd   MMpMMMb.   ,6"Yb.  
  M  Mb  M' MM  8)   MM    MM      MM    MM  6W'   `Wb 8I   `"   MM    MM  8)   MM  
  M  YM.P'  MM   ,pm9MM    MM      MM    MM  8M     M8 `YMMMa.   MM    MM   ,pm9MM  
  M  `YM'   MM  8M   MM    MM      MM    MM  YA.   ,A9 L.   I8   MM    MM  8M   MM  
.JML. `'  .JMML.`Moo9^Yo.  `Mbmo .JMML  JMML. `Ybmd9'  M9mmmP' .JMML  JMML.`Moo9^Yo.
EOF

COLORS=(31 32 33 34 35 36)

# Функция для отображения ASCII-арта с анимацией
animate_ascii_art() {
  local art="$1"
  local colors=("${!2}")
  local color_index=0
  local lines=()

  # Разбиваем арт на строки
  while IFS= read -r line; do
    lines+=("$line")
  done <<< "$art"

  # Делаем несколько проходов для создания эффекта переливания
  for pass in {1..10}; do
    clear
    for line in "${lines[@]}"; do
      for ((i = 0; i < ${#line}; i++)); do
        printf "\033[%sm%c\033[0m" "${colors[color_index]}" "${line:i:1}"
        ((color_index = (color_index + 1) % ${#colors[@]}))
      done
      echo
    done
    color_index=$(( (color_index + 1) % ${#colors[@]} ))
    sleep 0.1
  done
}

# Отображение ASCII-арта с анимацией
animate_ascii_art "$ASCII_ART" COLORS[@]

# ==============================================================================================

# Проверка, что передан аргумент (никнейм)
if [ -z "$1" ]; then
    echo -e "\033[31mОшибка: Никнейм не указан.\033[0m"
    echo "Использование: ./s21_script <nick>"
    exit 1
fi

NICKNAME=$1

# Спрашиваем пользователя, правильно ли указан никнейм
echo -e "Никнейм указан: \033[32m$NICKNAME\033[0m"
echo -e "\033[31mПЕРЕД ТЕМ КАК ПРОДОЛЖИТЬ, СКАЧАЙ \033[32mDOCKER DESKTOP и VScode\033[0m, \033[31mНО НЕ ЗАПУСКАЙ ИХ!!!\033[0m"
read -p "Все сделано/никнейм верный? (Y/N): " CONFIRMATION

# Проверяем подтверждение
if [ "$CONFIRMATION" != "Y" ]; then
    echo -e "\033[31mЗапустите скрипт снова, когда все будет готово.\033[0m"
    exit 1
fi

# ==============================================================================================

# Линковка докера в другое пространство
if [ -L ~/Library/Containers/com.docker.docker ]; then
    echo -e "\033[31mЛинковка Docker уже существует.\033[0m"
else
    echo "Линковка Docker в другое пространство..."
    rm -rf ~/Library/Containers/com.docker.docker
    mkdir -p ~/goinfre/Docker/Data
    ln -s ~/goinfre/Docker ~/Library/Containers/com.docker.docker
    echo "Линковка Docker выполнена."
fi

# Создание папки с ником и установка Homebrew в goinfre
GOINFRE_DIR=/opt/goinfre/$NICKNAME
if [ -d $GOINFRE_DIR/homebrew ]; then
    echo -e "\033[31mHomebrew уже установлен в $GOINFRE_DIR.\033[0m"
else
    echo "Создание папки с ником и установка Homebrew в $GOINFRE_DIR..."
    mkdir -p $GOINFRE_DIR
    cd $GOINFRE_DIR
    git clone https://github.com/Homebrew/brew homebrew
    if [ $? -ne 0 ]; then
        echo -e "\033[31mОшибка при клонировании репозитория Homebrew.\033[0m"
        exit 1
    fi
    mkdir /opt/goinfre/$NICKNAME/homebrew/zsh
    eval "$(/opt/goinfre/$NICKNAME/homebrew/bin/brew shellenv)" 
    brew update --force --quiet 
    chmod -R go-w "$(brew --prefix)/zsh"
    echo "Homebrew установлен."
fi

# ==============================================================================================

# Настройка .zprofile
echo "Настройка .zprofile..."
ZPROFILE=~/.zprofile

# Проверяем, существует ли файл .zprofile и создаем его, если не существует
if [ ! -f "$ZPROFILE" ]; then
    touch "$ZPROFILE"
    echo "Файл $ZPROFILE создан."
fi

# Добавление функции brsw
BRWS_CMD="function brsw {
    eval \"\$($GOINFRE_DIR/homebrew/bin/brew shellenv)\"
    chmod -R go-w \"\$($GOINFRE_DIR/homebrew/bin/brew --prefix)/share/zsh\"
}"

if grep -q "function brsw" "$ZPROFILE"; then
    echo -e "\033[31mФункция brsw уже существует в $ZPROFILE.\033[0m"
else
    echo "$BRWS_CMD" >> "$ZPROFILE"
    echo "Функция brsw добавлена в $ZPROFILE."
fi

# Создание папки scripts в ~/Documents/ и скачивание файла
SCRIPTS_DIR=~/Documents/scripts
FILE_URL="https://raw.githubusercontent.com/fatkheev/bash_scripts/main/clean_memory_on_macos_zapusk_bash_name.sh"
FILE_PATH="$SCRIPTS_DIR/clean_memory_on_macos_zapusk_bash_name.sh"

if [ -d "$SCRIPTS_DIR" ]; then
    if [ -f "$FILE_PATH" ]; then
        echo -e "\033[31mФайл $FILE_PATH уже существует.\033[0m"
    else
        echo "Скачивание файла clean_memory_on_macos_zapusk_bash_name.sh..."
        curl -o "$FILE_PATH" "$FILE_URL"
        if [ $? -ne 0 ]; then
            echo -е "\033[31mОшибка при скачивании файла clean_memory_on_macos_zapusk_bash_name.sh\033[0m"
            exit 1
        fi
        chmod +x "$FILE_PATH"
        if [ $? -ne 0 ]; then
            echo -е "\033[31mОшибка при установке прав на файл clean_memory_on_macos_zapusk_bash_name.sh\033[0m"
            exit 1
        fi
        echo "Файл скачан и сделан исполняемым."
    fi
else
    echo "Создание папки scripts в ~/Documents/..."
    mkdir -p "$SCRIPTS_DIR"
    if [ $? -ne 0 ]; then
        echo -е "\033[31mОшибка при создании папки $SCRIPTS_DIR\033[0m"
        exit 1
    fi
    echo "Скачивание файла clean_memory_on_macos_zapusk_bash_name.sh..."
    curl -o "$FILE_PATH" "$FILE_URL"
    if [ $? -ne 0 ]; then
        echo -е "\033[31mОшибка при скачивании файла clean_memory_on_macos_zapusk_bash_name.sh\033[0m"
        exit 1
    fi
    chmod +x "$FILE_PATH"
    if [ $? -не 0 ]; then
        echo -е "\033[31mОшибка при установке прав на файл clean_memory_on_macos_zapusk_bash_name.sh\033[0m"
        exit 1
    fi
    echo "Файл скачан и сделан исполняемым."
fi

# ==============================================================================================

# Настройка .zshrc
echo "Настройка .zshrc..."
ZSHRC=~/.zshrc

# Проверяем, существует ли файл .zshrc и создаем его, если не существует
if [ ! -f "$ZSHRC" ]; then
    touch "$ZSHRC"
    echo "Файл $ZSHRC создан."
fi

# Функция для добавления строки в .zshrc, если ее нет
add_to_zshrc() {
    local STRING="$1"
    if ! grep -qF "$STRING" "$ZSHRC"; then
        echo "$STRING" >> "$ZSHRC"
        echo "Добавлено в .zshrc: $STRING"
    else
        echo -e "\033[31mУже существует в .zshrc: $STRING\033[0m"
    fi
}

# Добавление необходимых строк в .zshrc
add_to_zshrc 'export PATH="/usr/local/bin/docker:$PATH"'
add_to_zshrc 'export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"'
add_to_zshrc 'export GOPATH=/opt/goinfre/'$NICKNAME'/go'
add_to_zshrc 'export PATH="$PATH:$(go env GOPATH)/bin/protoc/bin"'
add_to_zshrc 'export PATH="$PATH:$(go env GOPATH)/bin"'
add_to_zshrc '# Load Homebrew config script'
add_to_zshrc 'source $HOME/.brewconfig.zsh'
add_to_zshrc '# Использование команды code чтобы открывать папки в VScode'
add_to_zshrc 'export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"'

# Выполнение source ~/.zshrc
source ~/.zshrc

# ==============================================================================================

echo -e "Скрипт завершен. Напиши в консоли \033[32mclean\033[0m, чтобы очистить все временные файлы."
