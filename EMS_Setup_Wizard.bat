@echo off
setlocal EnableDelayedExpansion
title EMS Banquet Setup Wizard
cls

echo ===============================================================================
echo          EMS BANQUET SYSTEM - BO CAI DAT VA KICH HOAT HE THONG
echo          Khach san MerPerle / Khai Vy Hotel - Phien ban 2.1.0 Portable
echo ===============================================================================
echo.

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo [1/3] Kiem tra moi truong thuc thi: Portable Python Runtime...
set "PYTHON_EXE=%SCRIPT_DIR%python_runtime\python.exe"

if not exist "%PYTHON_EXE%" (
    echo [CANH BAO] Khong tim thay python_runtime tai: %PYTHON_EXE%
    echo Dang thu tim Python he thong...
    where python >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        set "PYTHON_EXE=python"
        echo   -> Su dung Python he thong.
    ) else (
        echo.
        echo [LOI NGHIEP TRONG] Khong tim thay Python!
        echo Thu muc python_runtime bi thieu hoac loi giai nen.
        echo Vui long kiem tra lai bo cai dat.
        echo.
        pause
        exit /b 1
    )
) else (
    echo   -> Moi truong Python nhung da san sang.
)

if exist "%SCRIPT_DIR%.wizard_port" del /f /q "%SCRIPT_DIR%.wizard_port" >nul 2>&1

echo [2/3] Dang kiem tra cong mang va khoi dong Web Setup Wizard...
start "" /b "%PYTHON_EXE%" setup_wizard\wizard_app.py --port 5888

ping 127.0.0.1 -n 3 >nul

set WIZARD_PORT=5888
if exist "%SCRIPT_DIR%.wizard_port" (
    set /p WIZARD_PORT=<"%SCRIPT_DIR%.wizard_port"
)

echo [3/3] Dang mo trinh duyet cau hinh tren cong %WIZARD_PORT%...
start http://127.0.0.1:%WIZARD_PORT%

echo.
echo ===============================================================================
echo  Trinh cai dat dang chay tai: http://127.0.0.1:%WIZARD_PORT%
echo  He thong tu dong phat hien va canh bao cong trung tren server.
echo  Vui long giu nguyen cua so nay trong qua trinh cai dat.
echo ===============================================================================
echo.
pause
