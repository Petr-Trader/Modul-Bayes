@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul

REM === Vytvoří/aktualizuje TODO.md a workspace.md v kořeni repa ===

REM --- TODO.md ---
(
echo # Modul-Bayes – TODO ^(roadmapa a kontrolní body^)
echo
echo Tento dokument je živý plán. Každý krok má **vstupy**, **příkazy**, **očekávané výstupy** a **DoD** ^(Definition of Done^).
echo Doporučený commit prefix: `feat:`, `fix:`, `docs:`, `chore:`, `test:`, `ci:`.
echo
echo ---
echo
echo ## Milník 0 – Repo/CI sanity
echo - [ ] **Kontrola Gitu a CI**
echo   - Vstup: čistý working tree, GitHub Actions zapnuté.
echo   - Příkazy:
echo     - `git status -sb`
echo     - Ověřit workflow: *Actions* ^> run `CI`.
echo   - Očekávané výstupy: CI green pro matrix 3.10–3.13; žádné untracked soubory mimo ^`.gitignore^`.
echo   - DoD: README, .gitignore, requirements, workflow existují; bootstrap skript má správný název.
echo
echo ---
echo
echo ## Milník 1 – Katalog indikátorů v1.00
echo - [ ] **Schéma katalogu**
echo   - Vstup: `examples/catalog/indicators.yaml`
echo   - Příkazy:
echo     - `pytest -q` ^(projde test, že YAML jde načíst^)
echo     - `yamllint catalog examples`
echo   - Očekávané výstupy: `catalog/indicators.yaml` s RSI, ADX, EMA, ATR, Stochastic; per-TF rozsahy; aliasy.
echo   - DoD: lint OK, test OK, verzováno `version: "1.00"`, changelog v PR.
echo
echo - [ ] **Rozšíření katalogu**
echo   - Přidej: `EMA`, `ATR`, `Stochastic`, `DMI/ADX detaily` ^(±DI^), `AppliedPrice` enum sjednoceně.
echo   - Kontrola: typy ^(int/float/enum^), `step`, hranice dle TF ^(H1/H4/D1^).
echo
echo ---
echo
echo ## Milník 2 – Profily EA
echo - [ ] **EA_FollowTrend.yaml** a **EA_FX_CarryMomentum.yaml**
echo   - Vstup: `profiles/EA_*.yaml`
echo   - Příkazy:
echo     - Mapuj `from_indicator` ^+ `field`, doplň `constraints` ^(min_trades, max_dd_pct^) a `objective`.
echo     - `pytest -q` ^(doplnit test profilu^)
echo   - Očekávané výstupy: dva profily s úplným mapováním inputs → přesné názvy EA.
echo   - DoD: test profilu projde, názvy odpovídají EA inputs ^(ruční křížová kontrola/šablona .set^).
echo
echo ---
echo
echo ## Milník 3 – **space_generator v1.00**
echo - [ ] CLI ^(policy: safe / wide / informed^)
echo   - Vstup: profil EA + katalog
echo   - Příkazy:
echo     - `python -m modules.space_generator --ea profiles/EA_FX_CarryMomentum.yaml --tf H4 --policy safe --out bayes/space.json`
echo     - `pytest -q` ^(unit pro typy/rozsahy^)
echo   - Očekávané výstupy: `bayes/space.json` s typy ^(int/float/categorical^), per-TF rozsahy, volitelně log-scale.
echo   - DoD: opakované spuštění vytváří deterministický obsah ^(při stejné verzi profilů/katalogu^).
echo
echo ---
echo
echo ## Milník 4 – **set_builder v1.00**
echo - [ ] Generátor `.set` souborů s validací
echo   - Vstup: `params.json` ^(vzorek^) ^+ profil EA
echo   - Příkazy:
echo     - `python -m modules.set_builder --ea profiles/EA_*.yaml --symbol EURUSD --tf H4 --params examples/params.sample.json --out sets/generated/...set`
echo     - Volitelně: porovnání klíčů proti šabloně `sets/baseline/*.set`
echo   - Očekávané výstupy: `.set` se 100%% shodou názvů inputs; kontrola typů ^(int/float/enum^).
echo   - DoD: mismatch ^(neznámý klíč/typ^) → **fail fast** s jasnou chybou; na validních datech generuje korektní `.set`.
echo
echo ---
echo
echo ## Milník 5 – **env_check v1.00**
echo - [ ] Kontrola prostředí/terminálů
echo   - Vstup: `config/env.yaml` ^(cesty k MT5_A/B/C, disky, práva^)
echo   - Příkazy:
echo     - `python -m modules.env_check --config config/env.yaml --out results/env_check.json`
echo   - Očekávané výstupy: JSON s verzí Pythonu, dostupností terminálů, volným místem, právy na zápis.
echo   - DoD: když chybí cokoliv kritického, modul skončí s návrhem nápravy.
echo
echo ---
echo
echo ## Milník 6 – **runner_mt5 v1.00**
echo - [ ] Paralelní běh testeru
echo   - Vstup: složka `sets/generated/*.set`, `config/env.yaml`
echo   - Příkazy:
echo     - `python -m modules.runner_mt5 --sets sets/generated --terms "C:\MT5_Portable\MT5_A\terminal64.exe;...MT5_B\terminal64.exe" --max-parallel 2 --timeout 1800`
echo   - Očekávané výstupy: `reports/raw/*.html`, `logs/mt5/*.log`, návratové kódy; retry/backoff na chybách.
echo   - DoD: běhy jsou stabilní, nezahlcují disk/CPU; jasné logy per run_id.
echo
echo ---
echo
echo ## Milník 7 – **report_parser v1.00**
echo - [ ] Parsování HTML/CSV na jednotné metriky
echo   - Vstup: `reports/raw/*.html`
echo   - Příkazy:
echo     - `python -m modules.report_parser --in reports/raw --out results/parsed.parquet`
echo     - `pytest -q` na vzorových reportech
echo   - Očekávané výstupy: `results/parsed.parquet` ^(+ `utf-8-sig` CSV pokud chceš^), klíče: run_id, symbol, tf, PF, Net, DD%%, trades…
echo   - DoD: chybné/nekonzistentní reporty → označeny a vyřazeny s důvodem.
echo
echo ---
echo
echo ## Milník 8 – **objective_scorer v1.00**
echo - [ ] MAR, PF, penalizace, multi-objective
echo   - Vstup: `results/parsed.parquet`
echo   - Příkazy:
echo     - `python -m modules.objective_scorer --in results/parsed.parquet --out results/scored.parquet --min-trades 50 --max-dd 35 --objective MAR`
echo   - Očekávané výstupy: `results/scored.parquet` s finálními skóre; log penalizací.
echo   - DoD: deterministické; parametry ^(min_trades, max_dd^) čitelné v logu i metadatech.
echo
echo ---
echo
echo ## Milník 9 – **leaderboard_maker v1.00**
echo - [ ] HTML/CSV přehled, kopie TOP `.set`
echo   - Vstup: `results/scored.parquet`
echo   - Příkazy:
echo     - `python -m modules.leaderboard_maker --in results/scored.parquet --top 50 --copy-sets sets/deploy --out results/leaderboard.html`
echo   - Očekávané výstupy: `results/leaderboard.html`, kopie vítězných `.set` do `sets/deploy`.
echo   - DoD: barvy/filtry, stabilní řazení, jasné metriky v tabulce.
echo
echo ---
echo
echo ## Milník 10 – **deployer v1.00**
echo - [ ] Manifest nasazení a registr Magic
echo   - Vstup: `sets/deploy/*.set`, `config/magic_registry.yaml`
echo   - Příkazy:
echo     - `python -m modules.deployer --in sets/deploy --magic-reg config/magic_registry.yaml --out deploy/`
echo   - Očekávané výstupy: `deploy/<EA>/<SYMBOL>/<TF>/{.set, manifest.json}`, kontrola kolize Magic.
echo   - DoD: žádné kolize, manifest obsahuje EA verzi, katalog/profil verzi, metriky a datum.
echo
echo ---
echo
echo ## Milník 11 – **monitor_live** ^(volitelné^)
echo - [ ] Sledování driftu mezi live a backtestem
echo   - Vstup: živé logy/journal, metriky účtu
echo   - Příkazy: návrh konektorů ^(CSV/REST/ručně^)
echo   - Očekávané výstupy: základní report ^(měsíčně/ týdně^).
echo   - DoD: první jednoduchý alarm ^(drop MAR, růst DD%%^).
echo
echo ---
echo
echo ## Milník 12 – CI v2
echo - [ ] Před-commit hooky, cache, artefakty
echo   - Přidat `pre-commit` ^(ruff, yamllint^), kešování pip v Actions, upload artefaktů `leaderboard.html`.
echo   - DoD: CI běží ^< 3 min, stabilní.
echo
echo ---
echo
echo ## Milník 13 – Dokumentace
echo - [ ] Doplnit README: architektura, sekvence kroků, diagramy ^(plantuml/mermaid^), příklady CLI.
echo - [ ] Modul-specifické README v `modules/*`.
echo
echo ---
echo
echo ## Kontrolní checklist po každém modulu
echo - [ ] ^(a^) Mám testy ^(pytest^) pro klíčové happy-path i edge-cases?
echo - [ ] ^(b^) Mám jasné CLI ^(--help^) a ukázkový příkaz v README?
echo - [ ] ^(c^) Výstupy jsou deterministické ^(se stejnými vstupy^) a uložím i metadata ^(verze katalogu, profilu, EA^)?
echo - [ ] ^(d^) Vše je ignorováno/commitnuto správně ^(.gitignore^, žádné velké HTML v Gitu^)?
echo - [ ] ^(e^) CI zelené?
) > "TODO.md"

REM --- workspace.md ---
(
echo # VS Code workspace pro Modul-Bayes
echo
echo Doporučené rozšíření, nastavení a úlohy pro pohodlnou práci.
echo
echo ## Doporučená rozšíření (IDs)
echo - ms-python.python
echo - ms-python.vscode-pylance
echo - ms-toolsai.jupyter
echo - ms-azuretools.vscode-docker ^(volitelné^)
echo - ms-vscode.makefile-tools ^(volitelné^)
echo - charliermarsh.ruff
echo - ms-python.mypy-type-checker
echo - redhat.vscode-yaml
echo - tamasfe.even-better-toml
echo - streetsidesoftware.code-spell-checker ^(EN^)
echo - DavidAnson.vscode-markdownlint
echo - Gruntfuggly.todo-tree
echo - GitHub.vscode-pull-request-github
echo - eamodio.gitlens
echo - github.vscode-github-actions
echo - usernamehw.errorlens
echo
echo **Instalace přes CLI:** `code --install-extension <id>`
echo
echo ## Doporučené workflow
echo 1. Vytvoř ^`.venv^` v kořeni a aktivuj:
echo    - `python -m venv .venv` ; `.venv\Scripts\activate`
echo    - `pip install -r requirements.txt`
echo 2. V levém spodním rohu ve VS Code vyber Python interpreter: ^`${workspaceFolder}\\.venv\\Scripts\\python.exe^`.
echo 3. Spouštěj testy ^(Ctrl+Shift+P → Python: Run All Tests^) nebo přes tasks.
echo
echo ## Doporučené nastavení ^(.vscode/settings.json^)
echo ```json
echo {
echo   "python.defaultInterpreterPath": "^${workspaceFolder}\\.venv\\Scripts\\python.exe",
echo   "python.testing.pytestEnabled": true,
echo   "python.testing.unittestEnabled": false,
echo   "python.analysis.typeCheckingMode": "basic",
echo   "ruff.lint.args": ["--select", "E,F,I", "--line-length", "100"],
echo   "editor.codeActionsOnSave": {
echo     "source.organizeImports": "explicit"
echo   },
echo   "files.eol": "\\n",
echo   "files.insertFinalNewline": true,
echo   "yaml.validate": true,
echo   "yaml.schemas": {
echo     "https://json.schemastore.org/github-workflow.json": ".github/workflows/ci.yml"
echo   }
echo }
echo ```
echo
echo ## Tasks ^(.vscode/tasks.json^) – běžné příkazy na klik
echo ```json
echo {
echo   "version": "2.0.0",
echo   "tasks": [
echo     { "label": "Install deps", "type": "shell", "command": "pip install -r requirements.txt", "group": "build" },
echo     { "label": "Pytest", "type": "shell", "command": "pytest -q", "group": "test" },
echo     { "label": "Ruff", "type": "shell", "command": "ruff check ."},
echo     { "label": "Mypy", "type": "shell", "command": "mypy --ignore-missing-imports ."},
echo     { "label": "YAML lint", "type": "shell", "command": "yamllint ." },
echo     {
echo       "label": "Space: generate (safe H4)",
echo       "type": "shell",
echo       "command": "python -m modules.space_generator --ea profiles/EA_FX_CarryMomentum.yaml --tf H4 --policy safe --out bayes/space.json"
echo     },
echo     {
echo       "label": "Set: build sample",
echo       "type": "shell",
echo       "command": "python -m modules.set_builder --ea profiles/EA_FX_CarryMomentum.yaml --symbol EURUSD --tf H4 --params examples/params.sample.json --out sets/generated/EA_sample.set"
echo     },
echo     {
echo       "label": "Leaderboard",
echo       "type": "shell",
echo       "command": "python -m modules.leaderboard_maker --in results/scored.parquet --top 50 --copy-sets sets/deploy --out results/leaderboard.html"
echo     }
echo   ]
echo }
echo ```
echo
echo ## Debug konfigurace ^(.vscode/launch.json^) – volitelné
echo ```json
echo {
echo   "version": "0.2.0",
echo   "configurations": [
echo     {
echo       "name": "space_generator",
echo       "type": "python",
echo       "request": "launch",
echo       "module": "modules.space_generator",
echo       "args": ["--ea", "profiles/EA_FX_CarryMomentum.yaml", "--tf", "H4", "--policy", "safe", "--out", "bayes/space.json"]
echo     },
echo     {
echo       "name": "set_builder",
echo       "type": "python",
echo       "request": "launch",
echo       "module": "modules.set_builder",
echo       "args": ["--ea", "profiles/EA_FX_CarryMomentum.yaml", "--symbol", "EURUSD", "--tf", "H4", "--params", "examples/params.sample.json", "--out", "sets/generated/EA_sample.set"]
echo     }
echo   ]
echo }
echo ```
echo
echo ## Poznámky
echo - Nastavení interpreteru ulož do repo ^(.vscode/^), aby se neodchylovaly běhy mezi PC.
echo - Pro CSV export používej `utf-8-sig` kvůli Excelu.
echo - Cesty k MT5 terminálům drž v `config/env.yaml` a nehardcoduj do kódu.
) > "workspace.md"

echo [OK] Zapsáno: TODO.md a workspace.md
exit /b 0
