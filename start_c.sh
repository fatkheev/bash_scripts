#!/bin/bash

# Задаем имя проекта
name=$1

# Создаем .vscode директорию и файл c_cpp_properties.json внутри неё
rm -rf .vscode
mkdir .vscode
echo '{
    "configurations": [
        {
            "name": "Mac",
            "includePath": [
                "/opt/homebrew/Cellar/check/0.15.2/include",
                "${workspaceFolder}/**"
            ],
            "defines": [],
            "macFrameworkPath": [
                "/System/Library/Frameworks",
                "/Library/Frameworks"
            ],
            "compilerPath": "/usr/bin/clang",
            "cStandard": "c11",
            "cppStandard": "c++98",
            "intelliSenseMode": "macos-clang-x64"
        }
    ],
    "version": 4
}' > .vscode/c_cpp_properties.json

# Создаем Makefile
echo 'GCC=gcc -Wall -Werror -Wextra

all: '$name'

'$name': '$name'.o
	$(GCC) '$name'.o -o '$name'

'$name'.o: '$name'.c
	$(GCC) -c '$name'.c -o '$name'.o

'$name'.a : '$name'.c
	$(GCC) -c '$name'.c 
	ar rc '$name'.a '$name'.o 
	ranlib '$name'.a

rebuild: clean all

clean:
	rm -rf *.o
	rm -rf *.a
	rm -rf *.out' > Makefile

# Создаем файлы $name.c и $name.h
echo '#ifndef '$name'_H
#define '$name'_H

#include <stdio.h>

// Другие инициализации

#endif' > $name.h

echo '#include "'$name'.h"

int main() {
    int number;
    printf("Enter a number: ");
    scanf("%d", &number);
    printf("The number is: %d", number);
    return 0;
}' > $name.c
