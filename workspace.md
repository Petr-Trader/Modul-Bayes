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
