@echo off
chcp 65001 >nul
title EMS Banquet - Cong Cu Quan Ly & Chon Tat Cong
cd /d "%~dp0"

echo ========================================================
echo       EMS BANQUET - QUAN LY & CHON TAT CONG
echo ========================================================

REM Kiem tra quyen Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [CANH BAO] Ban chua chay voi quyen Administrator!
    echo Neu can tat tien trinh he thong, vui long Right-click chon "Run as Administrator".
    echo.
)

REM Tim Python runtime
set "PY_EXE=%~dp0python_runtime\python.exe"
if not exist "%PY_EXE%" (
    set "PY_EXE=python"
)

"%PY_EXE%" "%~dp0manage_ports.py"
pause
