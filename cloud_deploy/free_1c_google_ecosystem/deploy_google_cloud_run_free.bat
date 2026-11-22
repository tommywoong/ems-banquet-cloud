@echo off
setlocal
cd /d "%~dp0"
title [FREE 1C] Trien Khai EMS Banquet Len Google Cloud Run

set "PY=python"
if exist "..\..\python_runtime\python.exe" set "PY=..\..\python_runtime\python.exe"

"%PY%" deploy_google_cloud_run.py
if errorlevel 1 pause
