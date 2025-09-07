@echo off
setlocal

rem --- vetev (bez FOR) ---
git rev-parse --abbrev-ref HEAD 1>"%TEMP%\branch.txt" 2>nul
if errorlevel 1 echo [ERR] Nelze zjistit git vetev. & exit /b 1
set /p GIT_BRANCH=<"%TEMP%\branch.txt"
del "%TEMP%\branch.txt" 2>nul

rem --- datum (bez PowerShellu) ---
set "TODAY=%date%"

rem --- python verze (bez FOR) ---
python -V 1>"%TEMP%\pyver.txt" 2>&1
set /p PY_VER=<"%TEMP%\pyver.txt"
if not defined PY_VER set "PY_VER=Python N/A"
del "%TEMP%\pyver.txt" 2>nul

rem --- tvoje cesty ---
set "REPO=%cd%"
set "MT5_TERMS=""C:\MT5_Portable\MT5_A\terminal64.exe"";""C:\MT5_Portable\MT5_B\terminal64.exe"";""C:\MT5_Portable\MT5_C\terminal64.exe"""
set "DATA_ROOT=C:\DATA"

rem --- zapis souboru (escapnute < a >) ---
>DAILY_BRIEFING.md  echo # Briefing pro asistenta %TODAY%
>>DAILY_BRIEFING.md echo Branch: %GIT_BRANCH%
>>DAILY_BRIEFING.md echo Cil na dnes: ^<dopln 1-2^>
>>DAILY_BRIEFING.md echo Stroj: ^<doma/prace^>
>>DAILY_BRIEFING.md echo Nove zmeny od vcera:
>>DAILY_BRIEFING.md echo - spust: git log --since="yesterday" --oneline
>>DAILY_BRIEFING.md echo Blokery/omezeni: ^<pokud jsou^>
>>DAILY_BRIEFING.md echo Co overit po dokonceni: DoD/CI/artefakty
>>DAILY_BRIEFING.md echo ----------------------------------------------
>>DAILY_BRIEFING.md echo ## Kontext [auto]
>>DAILY_BRIEFING.md echo - Python: %PY_VER%
>>DAILY_BRIEFING.md echo - Repo: %REPO%
>>DAILY_BRIEFING.md echo - MT5 terminals: %MT5_TERMS%
>>DAILY_BRIEFING.md echo - Data root: %DATA_ROOT%

if not exist DAILY_BRIEFING.md echo [ERR] Zapis selhal.
if not exist DAILY_BRIEFING.md exit /b 1

echo [OK] Vytvoreno: DAILY_BRIEFING.md
endlocal
