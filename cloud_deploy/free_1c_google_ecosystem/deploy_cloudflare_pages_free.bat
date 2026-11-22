@echo off
setlocal
cd /d "%~dp0"
title [FREE 1C] Trien Khai Giao Dien Len Cloudflare Pages CDN

where npx >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [!] Vui long cai dat Node.js de chay cong cu Wrangler CLI
    echo     Hoac truy cap https://dash.cloudflare.com va keo tha thu muc ems-web/static len trinh duyet!
    pause
    exit /b 1
)

set /p CF_PROJECT="Nhap ten du an tren Cloudflare Pages (VD: ems-banquet-hotel): "
echo.
echo [*] Dang deploy giao dien len Cloudflare Pages CDN...
pushd "..\..\ems-web"
call npx wrangler pages deploy static --project-name=%CF_PROJECT%
popd

echo.
echo [HOAN TAT] Giao dien da duoc xuat ban len https://%CF_PROJECT%.pages.dev
pause
