@echo off
setlocal
title Giai Phong Va Dong Sach Tat Ca Cac Cong 5xxx va 8xxx
cls

echo ===============================================================================
echo   EMS BANQUET - 1-CLICK DUNG TRIET DE TIEN TRINH VA GIAI PHONG TAT CA CAC CONG
echo ===============================================================================
echo.

echo [1/3] Dong toan bo tien trinh Python chay ngam...
taskkill /F /IM python.exe >nul 2>&1

echo [2/3] Quet va giai phong cac cong mang (5090, 5088, 5092, 5888, 5123, 5255)...
for %%p in (5090 5088 5092 5888 5123 5255 8090 8088 8092 8888 8999) do (
    for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":%%p " ^| findstr "LISTENING"') do (
        echo   -> Giai phong cong %%p (Tien trinh PID %%a)...
        taskkill /F /PID %%a >nul 2>&1
    )
)

echo [3/3] Chay Engine quet don sach se stop_services.py...
set "SCRIPT_DIR=%~dp0"
set "PYTHON_EXE=%SCRIPT_DIR%python_runtime\python.exe"
if not exist "%PYTHON_EXE%" set "PYTHON_EXE=python"
if exist "%SCRIPT_DIR%stop_services.py" (
    "%PYTHON_EXE%" "%SCRIPT_DIR%stop_services.py"
)

echo.
echo ===============================================================================
echo  DA DUNG SACH SE 100%% CAC CONG VA GIAI PHONG PORT 5123, 5090, 5088, 5092...
echo ===============================================================================
echo.
ping 127.0.0.1 -n 2 >nul
