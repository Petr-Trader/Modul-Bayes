@echo off
cd /d C:\CLON_Git\Modul-Bayes
call .venv\Scripts\activate
pytest -q
git status -sb
echo -----------------------------------------
echo Pokud jsou zmeny, udelej: git add ... ^& git commit -m "..." ^& git push origin dev
echo Hotovo. Okno muzes zavrit.
pause
