#!/bin/bash
#Ensamblador/ligador 

if [ -z $1 ]; then
    echo "Usage ./asm64 <asmMainFile> (no extension)"
    exit
fi

# Verificar que no puso el usuario la extension
if [ ! -e "$1.asm" ]; then
    echo "Erro $1.asm not found"
    echo "Note, do not enter file extentions."
    exit
fi
echo "Ensamblando el archivo..."
yasm -Worphan-labels -g dwarf2 -f elf64 $1.asm -l $1.lst
echo "Ligando..."
ld -g -o $1 $1.o
echo "Programa listo."