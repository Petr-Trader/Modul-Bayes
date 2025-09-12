@echo off
cd /d C:\CLON_Git\Modul-Bayes
git switch dev
git pull origin dev
if not exist .venv (
  python -m venv .venv
)
call .venv\Scripts\activate
if exist scripts\make_briefing.bat call scripts\make_briefing.bat
start "" "https://github.com/Petr-Trader/Modul-Bayes/pulls"
start "" "https://github.com/Petr-Trader/Modul-Bayes/actions"
start "" code .
REM === Auto: plný výpis repa do vypis.txt (v1.00) ===
REM %~dp0 = cesta k tomuto .bat; .. = kořen repa (protože .bat je ve složce scripts)
set "_REPO_ROOT=%~dp0.."
pushd "%_REPO_ROOT%" >nul
dir /a /s /b > "vypis.txt"
popd >nul
