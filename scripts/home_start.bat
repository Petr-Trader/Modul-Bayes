@echo off
cd /d C:\CLON_Git\Modul-Bayes
git switch dev
git pull origin dev
if not exist .venv (
  "C:\Program Files\Python313\python.exe" -m venv .venv
)
call .venv\Scripts\activate
if exist scripts\make_briefing.bat call scripts\make_briefing.bat
start "" "https://github.com/Petr-Trader/Modul-Bayes/pulls"
start "" "https://github.com/Petr-Trader/Modul-Bayes/actions"
start "" code .
