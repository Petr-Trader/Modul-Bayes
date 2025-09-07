@echo off
setlocal
for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD 2^>NUL') do set "BR=%%b"
if not defined BR (
  echo [ERR] Not a git repository here.
  exit /b 1
)
if "%BR%"=="dev" (
  echo [WARN] You are currently on 'dev'. Create a feature/fix branch first.
  exit /b 1
)
set "BASE_BRANCH=dev"
if not "%1"=="" set "BASE_BRANCH=%1"
start "" "https://github.com/Petr-Trader/Modul-Bayes/compare/%BASE_BRANCH%...%BR%?quick_pull=1"
endlocal
