# Workspace – rychlý start dne

Tento soubor drží návyky, skripty a šablony, aby byl start práce co nejrychlejší a konzistentní.

## 1) Ranní rutina (≤ 2 min)
1. `git pull --rebase` (srovnat větev)
2. Otevři `TODO.md` a vyber **nejbližší neodškrtnutý úkol** v aktuálním milníku
3. Spusť **briefing** (viz níže) → vznikne `DAILY_BRIEFING.md` s předvyplněnými údaji
4. `pytest -q` (rychlý smoke test) / případně `python -m modules.<modul> --help`
5. Začni pracovat na 1–2 konkrétních krocích (90–120 min), dělej malé commity s prefixy

## 2) Šablona „Briefing pro asistenta (dnes)“
```
# Briefing pro asistenta (dnes)
Branch: <aktuální větev>
Cíl na dnes: <1–2 konkrétní kroky>
Stroj: <doma/práce; omezení PowerShell apod.>
Nové změny od včera: <1–3 odrážky>
Blokery/omezení: <pokud něco je>
Co ověřit po dokončení: <DoD/CI/artefakty>
```


## 3) Automatizace – vytvoření briefing souboru
> Skripty níže vytvoří `DAILY_BRIEFING.md` s předvyplněnými informacemi (větev, datum, Python, cesty).

## 3.1) CMD (Windows .bat)
Ulož do `scripts\make_briefing.bat` a spusť z kořene repa.
## 3.2) PS1 (windows, .ps1)
Ulož do `scripts\make_briefing.ps1` a spusť z kořene repa.

## 4) Krátký start dne
call scripts\make_briefing.bat
pytest -q



## Co tím „líný člověk“ automatizuje
- **Předvyplní data** (větev, datum, Python verzi, cesty), aby ses k psaní briefingu jen „dopsal cíl“.
- **Oddělené env skripty** (`env_vars_work.cmd` vs. `env_vars_home.cmd`) – stačí spustit správný a vše je aktuální.
- **Jedno tlačítko**: můžeš si ve VS Code udělat **Task** („Start day“) volající `env_vars_*` → `make_briefing` → `pytest -q`.

Chceš, abych ti k tomu ještě přidal hotové `env_vars_work.cmd` / `env_vars_home.cmd` šablony a VS Code `tasks.json`, abys to spouštěl jedním příkazem z Command Palette?
::contentReference[oaicite:0]{index=0}
