@echo off
chcp 65001 >nul
title Cai Dat Windows Services Tu Dong Chay Ngam - EMS Banquet
cls

echo ===============================================================================
echo          EMS BANQUET SYSTEM - DANG KY WINDOWS SERVICES CHAY NGAM TU DONG
echo ===============================================================================
echo.

net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [CANH BAO] Ban CAN chay file nay voi quyen Administrator!
    echo Vui long click chuot phai vao file va chon "Run as administrator".
    echo.
    pause
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"
set "NSSM_BIN=nssm.exe"

set "PYTHON_EXE=%SCRIPT_DIR%python_runtime\python.exe"
if not exist "%PYTHON_EXE%" set "PYTHON_EXE=python"

if exist "%SCRIPT_DIR%tools\nssm.exe" (
    set "NSSM_BIN=%SCRIPT_DIR%tools\nssm.exe"
) else (
    where nssm >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [THONG BAO] Khong tim thay nssm.exe. Su dung che do khoi dong ngam Registry Run...
        reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "EMS_Banquet_System" /t REG_SZ /d ""%SCRIPT_DIR%start_silent.vbs"" /f
        echo Da dang ky khoi dong ngam cung Windows thanh cong!
        pause
        exit /b 0
    )
)

if not exist "%SCRIPT_DIR%logs" mkdir "%SCRIPT_DIR%logs"

echo [1/3] Dang dang ky Windows Service: EMS_Banquet_Web...
"%NSSM_BIN%" stop EMS_Banquet_Web >nul 2>&1
"%NSSM_BIN%" remove EMS_Banquet_Web confirm >nul 2>&1
"%NSSM_BIN%" install EMS_Banquet_Web "%PYTHON_EXE%" """%SCRIPT_DIR%ems-web\app.py"""
"%NSSM_BIN%" set EMS_Banquet_Web AppDirectory "%SCRIPT_DIR%ems-web"
"%NSSM_BIN%" set EMS_Banquet_Web DisplayName "EMS Banquet - Web Application"
"%NSSM_BIN%" set EMS_Banquet_Web Description "EMS Banquet Web Service (Port 5090) - Core Banquet Management"
"%NSSM_BIN%" set EMS_Banquet_Web Start SERVICE_AUTO_START
"%NSSM_BIN%" set EMS_Banquet_Web AppStdout "%SCRIPT_DIR%logs\web_service.log"
"%NSSM_BIN%" set EMS_Banquet_Web AppStderr "%SCRIPT_DIR%logs\web_service_err.log"
"%NSSM_BIN%" start EMS_Banquet_Web
echo  -> EMS_Banquet_Web da duoc cai dat va kich hoat che do tu dong chay ngam khi khoi dong may!

echo.
echo [2/3] Dang dang ky Windows Service: EMS_Banquet_Analytics...
"%NSSM_BIN%" stop EMS_Banquet_Analytics >nul 2>&1
"%NSSM_BIN%" remove EMS_Banquet_Analytics confirm >nul 2>&1
"%NSSM_BIN%" install EMS_Banquet_Analytics "%PYTHON_EXE%" """%SCRIPT_DIR%ems-analytics\app.py"""
"%NSSM_BIN%" set EMS_Banquet_Analytics AppDirectory "%SCRIPT_DIR%ems-analytics"
"%NSSM_BIN%" set EMS_Banquet_Analytics DisplayName "EMS Banquet - Analytics & BI"
"%NSSM_BIN%" set EMS_Banquet_Analytics Description "EMS Banquet Analytics & BI Dashboard (Port 5088)"
"%NSSM_BIN%" set EMS_Banquet_Analytics Start SERVICE_AUTO_START
"%NSSM_BIN%" set EMS_Banquet_Analytics AppStdout "%SCRIPT_DIR%logs\analytics_service.log"
"%NSSM_BIN%" set EMS_Banquet_Analytics AppStderr "%SCRIPT_DIR%logs\analytics_service_err.log"
"%NSSM_BIN%" start EMS_Banquet_Analytics
echo  -> EMS_Banquet_Analytics da duoc cai dat va kich hoat che do tu dong chay ngam!

echo.
echo [3/3] Dang dang ky Windows Service: EMS_Banquet_AI...
"%NSSM_BIN%" stop EMS_Banquet_AI >nul 2>&1
"%NSSM_BIN%" remove EMS_Banquet_AI confirm >nul 2>&1
"%NSSM_BIN%" install EMS_Banquet_AI "%PYTHON_EXE%" """%SCRIPT_DIR%ems-ai\app.py"""
"%NSSM_BIN%" set EMS_Banquet_AI AppDirectory "%SCRIPT_DIR%ems-ai"
"%NSSM_BIN%" set EMS_Banquet_AI DisplayName "EMS Banquet - AI Assistant"
"%NSSM_BIN%" set EMS_Banquet_AI Description "EMS Banquet AI Assistant Engine (Port 5092)"
"%NSSM_BIN%" set EMS_Banquet_AI Start SERVICE_AUTO_START
"%NSSM_BIN%" set EMS_Banquet_AI AppStdout "%SCRIPT_DIR%logs\ai_service.log"
"%NSSM_BIN%" set EMS_Banquet_AI AppStderr "%SCRIPT_DIR%logs\ai_service_err.log"
"%NSSM_BIN%" start EMS_Banquet_AI
echo  -> EMS_Banquet_AI da duoc cai dat va kich hoat che do tu dong chay ngam!

echo.
echo ===============================================================================
echo  DA CAI DAT THANH CONG TOAN BO DICH VU WINDOWS!
echo  - Cac service chay hoan toan NGAM 100%% khong hien cua so CMD.
echo  - He thong se TU DONG KHOI DONG lai moi khi may tinh duoc bat / restart.
echo ===============================================================================
pause
