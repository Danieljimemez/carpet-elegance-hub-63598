@echo off
echo Ejecutando comandos Git...

cd /d %~dp0

echo.
echo 1. Agregando cambios...
git add .

echo.
echo 2. Haciendo commit...
git commit -m "Ajustes en el banner promocional: tamaño de letra, espaciado y altura"

echo.
echo 3. Subiendo cambios a GitHub...
git push origin main

echo.
echo ¡Listo! Los cambios han sido subidos a GitHub.
pause
