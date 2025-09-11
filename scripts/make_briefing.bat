@echo off
setlocal enabledelayedexpansion

:: Optional arg: number of recent commits to show (default 3)
set "COUNT=%~1"
if "%COUNT%"=="" set "COUNT=3"

:: --- detect branch ---
for /f "delims=" %%B in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set "GIT_BRANCH=%%B"
if not defined GIT_BRANCH (
  echo [ERR] Cannot detect git branch.
  exit /b 1
)

:: --- date ---
set "TODAY=%date%"

:: --- python version ---
for /f "delims=" %%P in ('python -V 2^>^&1') do set "PY_VER=%%P"
if not defined PY_VER set "PY_VER=Python N/A"

:: --- context paths ---
set "REPO=%cd%"
set "MT5_TERMS=""C:\MT5_Portable\MT5_A\terminal64.exe"";""C:\MT5_Portable\MT5_B\terminal64.exe"";""C:\MT5_Portable\MT5_C\terminal64.exe"""
set "DATA_ROOT=C:\DATA"

:: --- machine name ---
set "STROJ=%COMPUTERNAME%"
if /I "%STROJ%"=="PRGDT024" set "STROJ=work"
if /I "%STROJ%"=="HOMEPC" set "STROJ=home"

>DAILY_BRIEFING.md  echo # Briefing pro asistenta %TODAY%
>>DAILY_BRIEFING.md echo Branch: %GIT_BRANCH%
>>DAILY_BRIEFING.md echo Cil na dnes: ^<dopln 1-2^>
>>DAILY_BRIEFING.md echo Stroj: %STROJ%
>>DAILY_BRIEFING.md echo.
>>DAILY_BRIEFING.md echo Nove zmeny od vcera:

:: --- commits since yesterday ---
set "GITLOG_TMP=%TEMP%\gitlog_%RANDOM%.txt"
git log --since="yesterday" --date=short --pretty=format:"%%h %%ad %%s by %%an" > "%GITLOG_TMP%" 2>nul

for %%A in ("%GITLOG_TMP%") do set "GITLOG_SIZE=%%~zA"
if not defined GITLOG_SIZE set "GITLOG_SIZE=0"

if "%GITLOG_SIZE%"=="0" (
  >>DAILY_BRIEFING.md echo - (zadne nove commity od vcerejska)
) else (
  for /f "usebackq delims=" %%L in ("%GITLOG_TMP%") do (
    >>DAILY_BRIEFING.md echo - %%L
  )
)

del "%GITLOG_TMP%" 2>nul

>>DAILY_BRIEFING.md echo.
>>DAILY_BRIEFING.md echo Posledni %COUNT% commit(y):

:: --- show last N commits regardless of date ---
set "GITLOG_TMP=%TEMP%\gitlast_%RANDOM%.txt"
git log -n %COUNT% --date=short --pretty=format:"%%h %%ad %%s by %%an" > "%GITLOG_TMP%" 2>nul

for %%A in ("%GITLOG_TMP%") do set "GITLOG2_SIZE=%%~zA"
if not defined GITLOG2_SIZE set "GITLOG2_SIZE=0"

if "%GITLOG2_SIZE%"=="0" (
  >>DAILY_BRIEFING.md echo - (zadne commity v historii nenalezeny)
) else (
  for /f "usebackq delims=" %%L in ("%GITLOG_TMP%") do (
    >>DAILY_BRIEFING.md echo - %%L
  )
)

del "%GITLOG_TMP%" 2>nul

>>DAILY_BRIEFING.md echo.
>>DAILY_BRIEFING.md echo Blokery/omezeni: ^<pokud jsou^>
>>DAILY_BRIEFING.md echo Co overit po dokonceni: DoD/CI/artefakty
>>DAILY_BRIEFING.md echo ----------------------------------------------
>>DAILY_BRIEFING.md echo ## Kontext [auto]
>>DAILY_BRIEFING.md echo - Python: %PY_VER%
>>DAILY_BRIEFING.md echo - Repo: %REPO%
>>DAILY_BRIEFING.md echo - MT5 terminals: %MT5_TERMS%
>>DAILY_BRIEFING.md echo - Data root: %DATA_ROOT%

endlocal