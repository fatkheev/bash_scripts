#!/bin/bash

# Задаем имя проекта
project_name=$1

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

all: s21_math

s21_math: s21_math.o
	$(GCC) s21_math.o -o s21_math

s21_math.o: s21_math.c
	$(GCC) -c s21_math.c -o s21_math.o

s21_math.a : s21_math.c
	$(GCC) -c s21_math.c 
	ar rc  s21_math.a s21_math.o 
	ranlib s21_math.a

rebuild: clean all

clean:
	rm -rf *.o
	rm -rf *.a
	rm -rf *.out' > Makefile

# Создаем основные файлы проекта (если нужно)
touch main.c
