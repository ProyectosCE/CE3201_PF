#!/bin/bash

# Archivo fuente de ensamblador ARMv4
SRC="pruebaboton.asm"
OBJ="pruebaboton.o"
BIN="pruebaboton.bin"
HEX="pruebaboton.hex"

# Colores para mensajes
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Ensamblando con arm-none-eabi-as...${NC}"
arm-none-eabi-as -mcpu=arm7tdmi -o $OBJ $SRC || exit 1

echo -e "${GREEN}==> Exportando binario plano...${NC}"
arm-none-eabi-objcopy -O binary $OBJ $BIN || exit 1

echo -e "${GREEN}==> Corrigiendo endian y generando Gambling_Tec.hex...${NC}"
xxd -p -c 4 $BIN | sed 's/^\(..\)\(..\)\(..\)\(..\)$/\4\3\2\1/' > $HEX

echo -e "${GREEN} Archivo $HEX generado exitosamente.${NC}"
