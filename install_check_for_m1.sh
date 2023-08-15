#!/bin/zsh

read -r -d '' ASCII_ART <<"EOF"
`7MMM.     ,MMF'           mm    `7MM                          `7MM                 
  MMMb    dPMM             MM      MM                            MM                 
  M YM   ,M MM   ,6"Yb.  mmMMmm    MMpMMMb.   ,pW"Wq.  ,pP"Ybd   MMpMMMb.   ,6"Yb.  
  M  Mb  M' MM  8)   MM    MM      MM    MM  6W'   `Wb 8I   `"   MM    MM  8)   MM  
  M  YM.P'  MM   ,pm9MM    MM      MM    MM  8M     M8 `YMMMa.   MM    MM   ,pm9MM  
  M  `YM'   MM  8M   MM    MM      MM    MM  YA.   ,A9 L.   I8   MM    MM  8M   MM  
.JML. `'  .JMML.`Moo9^Yo.  `Mbmo .JMML  JMML. `Ybmd9'  M9mmmP' .JMML  JMML.`Moo9^Yo.
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

echo 'export PATH="$PATH:/opt/homebrew/bin:/path/to/pip"' >> ~/.bashrc
echo 'export PATH="/opt/homebrew/include:$PATH"' >> ~/.bashrc

echo 'export PATH="$PATH:/opt/homebrew/bin:/path/to/pip"' >> ~/.zshrc
echo 'export PATH="/opt/homebrew/include:$PATH"' >> ~/.zshrc


echo "export CPATH=\"$CHECK_DIR:\$CPATH\"" >> ~/.bashrc
echo "export LIBRARY_PATH=\"$LIB_DIR:\$LIBRARY_PATH\"" >> ~/.bashrc

echo "export CPATH=\"$CHECK_DIR:\$CPATH\"" >> ~/.zshrc
echo "export LIBRARY_PATH=\"$LIB_DIR:\$LIBRARY_PATH\"" >> ~/.zshrc

source ~/.bashrc
source ~/.zshrc

echo "Готово! Дождись перезагрузки консоли..."

sleep 3
exec zsh

echo "Теперь точно готово!"