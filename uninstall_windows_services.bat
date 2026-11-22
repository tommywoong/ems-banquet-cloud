@echo off
title Go bo Windows Services - EMS Banquet
cls

echo ===============================================================================
echo          EMS BANQUET SYSTEM - GO BO WINDOWS SERVICES
echo ===============================================================================
echo.

net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [CANH BAO] Vui long click chuot phai va chon "Run as administrator".
    pause
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"
set "NSSM_BIN=nssm.exe"
if exist "%SCRIPT_DIR%tools\nssm.exe" set "NSSM_BIN=%SCRIPT_DIR%tools\nssm.exe"

echo Dang dung va go bo cac dich vu...
%NSSM_BIN% stop EMS_Banquet_Web >nul 2>&1
%NSSM_BIN% remove EMS_Banquet_Web confirm >nul 2>&1

%NSSM_BIN% stop EMS_Banquet_Analytics >nul 2>&1
%NSSM_BIN% remove EMS_Banquet_Analytics confirm >nul 2>&1

%NSSM_BIN% stop EMS_Banquet_AI >nul 2>&1
%NSSM_BIN% remove EMS_Banquet_AI confirm >nul 2>&1

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "EMS_Banquet_System" /f >nul 2>&1

set "PYTHON_EXE=%SCRIPT_DIR%python_runtime\python.exe"
if not exist "%PYTHON_EXE%" set "PYTHON_EXE=python"
if exist "%SCRIPT_DIR%stop_services.py" (
    "%PYTHON_EXE%" "%SCRIPT_DIR%stop_services.py" >nul 2>&1
)

echo.
echo ===============================================================================
echo  DA GO BO TOAN BO DICH VU WINDOWS THANH CONG!
echo ===============================================================================
pause
