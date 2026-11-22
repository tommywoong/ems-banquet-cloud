@echo off
setlocal
cd /d "%~dp0"
title [PAID 2A] Cai Dat Tu Dong Tren Cloud VPS Windows

set "PY=python"
if exist "..\..\python_runtime\python.exe" set "PY=..\..\python_runtime\python.exe"

"%PY%" install_vps_windows.py
if errorlevel 1 pause
