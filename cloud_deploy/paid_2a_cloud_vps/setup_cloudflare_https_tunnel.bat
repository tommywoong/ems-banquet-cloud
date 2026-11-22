@echo off
setlocal
cd /d "%~dp0"
title [PAID 2A] Ket Noi Ten Mien Rieng HTTPS Qua Cloudflare Tunnel

set "PY=python"
if exist "..\..\python_runtime\python.exe" set "PY=..\..\python_runtime\python.exe"

"%PY%" setup_cloudflare_tunnel.py
if errorlevel 1 pause
