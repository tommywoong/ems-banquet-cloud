@echo off
setlocal
cd /d "%~dp0"
title [FREE 1C] Day Ma Nguon Len GitHub De Deploy Render.com

set "PY=python"
if exist "..\..\python_runtime\python.exe" set "PY=..\..\python_runtime\python.exe"

"%PY%" push_to_github.py
if errorlevel 1 pause
