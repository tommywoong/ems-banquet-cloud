@echo off
setlocal
title Dung EMS Banquet System
cls

echo ===============================================================================
echo          EMS BANQUET SYSTEM - DUNG TAT CA DICH VU HE THONG
echo ===============================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "PYTHON_EXE=%SCRIPT_DIR%python_runtime\python.exe"

if not exist "%PYTHON_EXE%" (
    set "PYTHON_EXE=python"
)

if exist "%SCRIPT_DIR%stop_services.py" (
    "%PYTHON_EXE%" "%SCRIPT_DIR%stop_services.py"
)

echo Dang giai phong cac cong mang 5xxx va 8xxx...
for %%p in (5090 5088 5092 5888 5123 5255 8090 8088 8092 8888 8999) do (
    for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":%%p " ^| findstr "LISTENING"') do (
        taskkill /F /PID %%a >nul 2>&1
    )
)

echo.
echo ===============================================================================
echo  Tat ca cac dich vu da duoc dung va giai phong cong an toan.
echo ===============================================================================
echo.
ping 127.0.0.1 -n 2 >nul
