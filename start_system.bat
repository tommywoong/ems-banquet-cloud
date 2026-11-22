@echo off
setlocal EnableDelayedExpansion
title EMS Banquet System - Service Launcher
cls

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

set "PYTHON_EXE=%SCRIPT_DIR%python_runtime\python.exe"
if not exist "%PYTHON_EXE%" (
    where python >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        set "PYTHON_EXE=python"
    ) else (
        echo [LOI] Khong tim thay Python! Vui long kiem tra thu muc python_runtime.
        pause
        exit /b 1
    )
)

"%PYTHON_EXE%" run_services.py
pause
