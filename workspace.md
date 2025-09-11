# Provozní řád (workflow)

# Workspace – Modul‑Bayes (VS Code)

Tento dokument standardizuje pracovní prostředí pro **Modul‑Bayes** (Windows).

## Doporučené rozšíření VS Code
- Python (Microsoft)
- Pylance
- GitHub Pull Requests and Issues
- Git Graph
- Markdown All in One
- EditorConfig for VS Code
- YAML
- PowerShell (pokud používáš PS)
- Batch Runner / Command Runner (pro `.bat`)

## Nastavení (vlož do `.vscode/settings.json`)
```json
{
  "files.encoding": "utf8",
  "files.eol": "\n",
  "python.defaultInterpreterPath": "C:\\Program Files\\Python313\\python.exe",
  "python.testing.pytestEnabled": true,
  "python.analysis.typeCheckingMode": "basic",
  "editor.rulers": [100],
  "editor.formatOnSave": true,
  "[python]": {
    "editor.tabSize": 4,
    "editor.formatOnSave": true
  },
  "[markdown]": {
    "editor.wordWrap": "on"
  }
}
```

## Tasks (volitelné, `.vscode/tasks.json`)
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "CI: pytest",
      "type": "shell",
      "command": ".venv\\Scripts\\python -m pytest",
      "problemMatcher": []
    },
    {
      "label": "CI: ruff",
      "type": "shell",
      "command": ".venv\\Scripts\\python -m ruff check .",
      "problemMatcher": []
    }
  ]
}
```

## Doporučené návyky
- Před prací spustit `scripts/home_start.bat` nebo `scripts/work_start.bat`.
- Pracovat v samostatných větvích (`feat/*`, `docs/*`, `chore/*`).
- PR vždy do `dev`; po schválení **ALIGN** (`dev → main`).

## Git a GH CLI (základ)
```bat
git fetch --all --prune
git switch dev
git pull --rebase

:: nová větev
git switch -c docs/m1-todo-workspace

:: commit
git add -A
git commit -m "docs: přidat TODO a workspace (M1)"

:: push + PR
git push -u origin docs/m1-todo-workspace
gh pr create --base dev --head docs/m1-todo-workspace --title "docs: TODO + workspace (M1)" --body "Přidání TODO.md a workspace.md; dokončení Milníku 1."
```

## Branch protection (doporučení)
- `main`: vyžadovat PR + úspěšné CI; zákaz přímého push.
- `dev`: také PR + CI (udrží kvalitu), případně povolit squash merge.
- Povolit běh GitHub Actions na PR z forků (pokud bude relevantní).

## Poznámka k prostředím
- Domácí PC Python: `C:\Program Files\Python313\python.exe`.
- Preferované CSV kódování: `utf-8-sig` (kompatibilní s Excelem).
- Excel exporty v UTF‑8.
=======
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


