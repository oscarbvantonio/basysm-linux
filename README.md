# BaSysM (Basic System Maintenance): Script de Mantenimiento y Diagnóstico del Sistema

## Descripción
Script en bash diseñado para automatizar tareas rutinarias de mantenimiento en sistemas Linux (Debian, Ubuntu y derivados) y realizar un diagnóstico rápido de la salud del sistema.

## Características
- **Mantenimiento Automatizado**: Actualiza la lista de paquetes, instala actualizaciones, limpia la caché de `apt` y elimina dependencias huérfanas (incluyendo Flatpaks en caso de que se tenga instalado).
- **Diagnóstico de Disco**: Verifica el porcentaje de uso de la partición raíz y alerta visualmente si el espacio es crítico.
- **Monitoreo Térmico**: Lee los sensores de temperatura de la CPU y alerta sobre sobrecalentamient.
- **Análisis de Logs**: Revisa y cuenta los errores de prioridad `err` o superior en el último arranque del sistema.
- **Estado de Servicios**: Detecta si algún servicio del sistema falló al iniciar.

## Cómo usarlo
1. Clonar el repositorio o descargar el script `basysm.sh`
2. Otorga permisos de ejecución con `chmod +x basysm.sh`
3. Ejecutar con `./basysm.sh`

## Recomendaciones antes de usar xd
1. Tener instalado `lm-sensors`
2. (Opcional) Flatpak
3. (Opcional) Ejecutar después del inicio de sesión
