#!/bin/bash

# PEQUEÑO SCRIPT DE MANTENIMIENTO Y DIAGNOSTICO DEL SISTEMA
# Descripción: Actualiza paquetes, limpia caché y elimina dependencias huerfanas
# Por -> oscar@optiplex3050

ROJO='\033[0;31m'
AMARILLO='\033[0;33m'
VERDE='\033[0;32m'
NC='\033[0m'

echo "================================"
echo "=== SECCIÓN 1: MANTENIMIENTO ==="
echo "================================"
echo ""
echo "Iniciando mantenimiento del sistema..."
echo ""

#1. Actualizar la lista de paquetes
echo "[1/6] Actualizando la lista de paquetes..."
sudo apt update -y
echo ""

#2. Actualizar paquetes instalados
echo "[2/6] Actualizando paquetes..."
sudo apt upgrade -y
echo ""

#3. Limpiar caché de paquetes antiguos
echo "[3/6] Limpiando caché de paquetes..."
sudo apt autoclean -y
echo ""

#4. Eliminar dependencias huerfanas
echo "[4/6] Eliminando dependencias no utilizadas..."
sudo apt autoremove -y
echo ""

#5. Actualizar paquetes Flatpak instalados
echo "[5/6] Actualizando paquetes Flatpak... "
flatpak update -y
echo ""

#6. Limpiar paquetes Flatpak no utilizados
echo "[6/6] Limpiando paquetes Flatpak no utilizados..."
flatpak uninstall --unused -y
echo ""
echo ""

echo "=============================="
echo "=== SECCIÓN 2: DIAGNÓSTICO ==="
echo "=============================="
echo ""

#1. Espacio en disco
echo "(DISCO) Verificando espacio disponible..."
USO_DISCO=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$USO_DISCO" -gt 90 ]; then
    echo -e  "[${ROJO}X${NC}] ALERTA CRÍTICA: Disco al $USO_DISCO% - ¡Necesitas liberar espacio en disco!"
elif [ "$USO_DISCO" -gt 80 ]; then
    echo -e "[${AMARILLO}!${NC}] ALERTA: Disco al $USO_DISCO% - Considera limpiar archivos grandes :/"
else
    echo -e "[${VERDE}OK${NC}] Disco al $USO_DISCO% - Espacio saludable :D"
fi
echo ""

#2. Temperatura
echo "(TEMPERATURA) Verificando sensores térmicos..."
if command -v sensors &> /dev/null; then
    TEMP_MAX=$(sensors 2>/dev/null | grep -E "Core|Tctl|Package" | awk '{print $3}' | sed 's/+//;s/°C//' | sort -n | tail -1)
    if [ -n "$TEMP_MAX" ]; then
        TEMP_INT=${TEMP_MAX%.*}
        if [ "$TEMP_INT" -gt 85 ]; then
        echo -e "[${ROJO}X${NC}] CRÍTICO: ${TEMP_MAX}°C - ¡Limpia el polvo o cambia la pasta térmica!"
        elif [ "$TEMP_INT" -gt 70 ]; then
        echo -e "[${AMARILLO}!${NC}] ALERTA: ${TEMP_MAX}°C - Mejora la ventilación :/"
            else
            echo -e "[${VERDE}OK${NC}] ${TEMP_MAX}°C - Rango seguro :D"
            fi
                else
                echo -e "[${AMARILLO}!${NC}] No se pudieron leer sensores :("
                fi
                    else
                    echo -e "[${AMARILLO}!${NC}] Instala: <sudo apt install lm-sensors>, luego ejecuta: <sensors-detect>"
                    fi
echo ""

#3. Errores en el último arranque
echo "(LOGS) Verificando errores en la sesión actual..."
ERRORES_BOOT=$(sudo journalctl -b -p err --no-pager 2>/dev/null | wc -l)
if [ "$ERRORES_BOOT" -gt 20 ]; then
echo -e "[${ROJO}X${NC}] ALERTA: $ERRORES_BOOT errores en este arranque"
echo "Revisa con: sudo journalctl -b -p err"
    elif [ "$ERRORES_BOOT" -gt 0 ]; then
    echo -e "[${VERDE}OK${NC}] Solo $ERRORES_BOOT errores (probablemente menores)"
    echo "Revisar con: sudo journalctl -b -p err"
        else
        echo -e "[${VERDE}OK${NC}] Sin errores en este arranque :D"
        fi
echo ""

#4. Servicios fallidos
echo "(SERVICIOS) Verificando estado de servicios"
SERVICIOS_FALLIDOS=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
if [ "$SERVICIOS_FALLIDOS" -gt 0 ]; then
echo -e "[${AMARILLO}!${NC}] ALERTA: $SERVICIOS_FALLIDOS servicios fallidos:"
systemctl --failed --no-pager
    else
    echo -e "[${VERDE}OK${NC}] Todos los servicios arrancaron correctamente"
    fi
echo ""
