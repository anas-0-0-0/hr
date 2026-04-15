@echo off
cd /d "%~dp0"
title HR Dashboard Runner
echo Launching PowerShell runner...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0run-site.ps1"
if errorlevel 1 (
  echo.
  echo Startup failed. Check run-site.log
  pause
)
