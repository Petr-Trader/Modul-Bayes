# Modul-Bayes – TODO (roadmapa a kontrolní body)
ECHO is off.
Tento dokument je živý plán. Každý krok má **vstupy**, **příkazy**, **očekávané výstupy** a **DoD** (Definition of Done).
Doporučený commit prefix: `feat:`, `fix:`, `docs:`, `chore:`, `test:`, `ci:`.
ECHO is off.
---
ECHO is off.
## Milník 0 – Repo/CI sanity
- [X] **Kontrola Gitu a CI**
  - Vstup: čistý working tree, GitHub Actions zapnuté.
  - Příkazy:
    - `git status -sb`
    - Ověřit workflow: *Actions* > run `CI`.
  - Očekávané výstupy: CI green pro matrix 3.10–3.13; žádné untracked soubory mimo `.gitignore`.
  - DoD: README, .gitignore, requirements, workflow existují; bootstrap skript má správný název.
ECHO is off.
---
ECHO is off.
## Milník 1 – Katalog indikátorů v1.00
- [ ] **Schéma katalogu**
  - Vstup: `examples/catalog/indicators.yaml`
  - Příkazy:
    - `pytest -q` (projde test, že YAML jde načíst)
    - `yamllint catalog examples`
  - Očekávané výstupy: `catalog/indicators.yaml` s RSI, ADX, EMA, ATR, Stochastic; per-TF rozsahy; aliasy.
  - DoD: lint OK, test OK, verzováno `version: "1.00"`, changelog v PR.
ECHO is off.
- [ ] **Rozšíření katalogu**
  - Přidej: `EMA`, `ATR`, `Stochastic`, `DMI/ADX detaily` (±DI), `AppliedPrice` enum sjednoceně.
  - Kontrola: typy (int/float/enum), `step`, hranice dle TF (H1/H4/D1).
ECHO is off.
---
ECHO is off.
## Milník 2 – Profily EA
- [ ] **EA_FollowTrend.yaml** a **EA_FX_CarryMomentum.yaml**
  - Vstup: `profiles/EA_*.yaml`
  - Příkazy:
    - Mapuj `from_indicator` + `field`, doplň `constraints` (min_trades, max_dd_pct) a `objective`.
    - `pytest -q` (doplnit test profilu)
  - Očekávané výstupy: dva profily s úplným mapováním inputs → přesné názvy EA.
  - DoD: test profilu projde, názvy odpovídají EA inputs (ruční křížová kontrola/šablona .set).
ECHO is off.
---
ECHO is off.
## Milník 3 – **space_generator v1.00**
- [ ] CLI (policy: safe / wide / informed)
  - Vstup: profil EA + katalog
  - Příkazy:
    - `python -m modules.space_generator --ea profiles/EA_FX_CarryMomentum.yaml --tf H4 --policy safe --out bayes/space.json`
    - `pytest -q` (unit pro typy/rozsahy)
  - Očekávané výstupy: `bayes/space.json` s typy (int/float/categorical), per-TF rozsahy, volitelně log-scale.
  - DoD: opakované spuštění vytváří deterministický obsah (při stejné verzi profilů/katalogu).
ECHO is off.
---
ECHO is off.
## Milník 4 – **set_builder v1.00**
- [ ] Generátor `.set` souborů s validací
  - Vstup: `params.json` (vzorek) + profil EA
  - Příkazy:
    - `python -m modules.set_builder --ea profiles/EA_*.yaml --symbol EURUSD --tf H4 --params examples/params.sample.json --out sets/generated/...set`
    - Volitelně: porovnání klíčů proti šabloně `sets/baseline/*.set`
  - Očekávané výstupy: `.set` se 100% shodou názvů inputs; kontrola typů (int/float/enum).
  - DoD: mismatch (neznámý klíč/typ) → **fail fast** s jasnou chybou; na validních datech generuje korektní `.set`.
ECHO is off.
---
ECHO is off.
## Milník 5 – **env_check v1.00**
- [ ] Kontrola prostředí/terminálů
  - Vstup: `config/env.yaml` (cesty k MT5_A/B/C, disky, práva)
  - Příkazy:
    - `python -m modules.env_check --config config/env.yaml --out results/env_check.json`
  - Očekávané výstupy: JSON s verzí Pythonu, dostupností terminálů, volným místem, právy na zápis.
  - DoD: když chybí cokoliv kritického, modul skončí s návrhem nápravy.
ECHO is off.
---
ECHO is off.
## Milník 6 – **runner_mt5 v1.00**
- [ ] Paralelní běh testeru
  - Vstup: složka `sets/generated/*.set`, `config/env.yaml`
  - Příkazy:
    - `python -m modules.runner_mt5 --sets sets/generated --terms "C:\MT5_Portable\MT5_A\terminal64.exe;...MT5_B\terminal64.exe" --max-parallel 2 --timeout 1800`
  - Očekávané výstupy: `reports/raw/*.html`, `logs/mt5/*.log`, návratové kódy; retry/backoff na chybách.
  - DoD: běhy jsou stabilní, nezahlcují disk/CPU; jasné logy per run_id.
ECHO is off.
---
ECHO is off.
## Milník 7 – **report_parser v1.00**
- [ ] Parsování HTML/CSV na jednotné metriky
  - Vstup: `reports/raw/*.html`
  - Příkazy:
    - `python -m modules.report_parser --in reports/raw --out results/parsed.parquet`
    - `pytest -q` na vzorových reportech
  - Očekávané výstupy: `results/parsed.parquet` (+ `utf-8-sig` CSV pokud chceš), klíče: run_id, symbol, tf, PF, Net, DD%, trades…
  - DoD: chybné/nekonzistentní reporty → označeny a vyřazeny s důvodem.
ECHO is off.
---
ECHO is off.
## Milník 8 – **objective_scorer v1.00**
- [ ] MAR, PF, penalizace, multi-objective
  - Vstup: `results/parsed.parquet`
  - Příkazy:
    - `python -m modules.objective_scorer --in results/parsed.parquet --out results/scored.parquet --min-trades 50 --max-dd 35 --objective MAR`
  - Očekávané výstupy: `results/scored.parquet` s finálními skóre; log penalizací.
  - DoD: deterministické; parametry (min_trades, max_dd) čitelné v logu i metadatech.
ECHO is off.
---
ECHO is off.
## Milník 9 – **leaderboard_maker v1.00**
- [ ] HTML/CSV přehled, kopie TOP `.set`
  - Vstup: `results/scored.parquet`
  - Příkazy:
    - `python -m modules.leaderboard_maker --in results/scored.parquet --top 50 --copy-sets sets/deploy --out results/leaderboard.html`
  - Očekávané výstupy: `results/leaderboard.html`, kopie vítězných `.set` do `sets/deploy`.
  - DoD: barvy/filtry, stabilní řazení, jasné metriky v tabulce.
ECHO is off.
---
ECHO is off.
## Milník 10 – **deployer v1.00**
- [ ] Manifest nasazení a registr Magic
  - Vstup: `sets/deploy/*.set`, `config/magic_registry.yaml`
  - Příkazy:
    - `python -m modules.deployer --in sets/deploy --magic-reg config/magic_registry.yaml --out deploy/`
  - DoD: žádné kolize, manifest obsahuje EA verzi, katalog/profil verzi, metriky a datum.
ECHO is off.
---
ECHO is off.
## Milník 11 – **monitor_live** (volitelné)
- [ ] Sledování driftu mezi live a backtestem
  - Vstup: živé logy/journal, metriky účtu
  - Příkazy: návrh konektorů (CSV/REST/ručně)
  - Očekávané výstupy: základní report (měsíčně/ týdně).
  - DoD: první jednoduchý alarm (drop MAR, růst DD%).
ECHO is off.
---
ECHO is off.
## Milník 12 – CI v2
- [ ] Před-commit hooky, cache, artefakty
  - Přidat `pre-commit` (ruff, yamllint), kešování pip v Actions, upload artefaktů `leaderboard.html`.
  - DoD: CI běží < 3 min, stabilní.
ECHO is off.
---
ECHO is off.
## Milník 13 – Dokumentace
- [ ] Doplnit README: architektura, sekvence kroků, diagramy (plantuml/mermaid), příklady CLI.
- [ ] Modul-specifické README v `modules/*`.
ECHO is off.
---
ECHO is off.
## Kontrolní checklist po každém modulu
- [ ] (a) Mám testy (pytest) pro klíčové happy-path i edge-cases?
- [ ] (b) Mám jasné CLI (--help) a ukázkový příkaz v README?
- [ ] (c) Výstupy jsou deterministické (se stejnými vstupy) a uložím i metadata (verze katalogu, profilu, EA)?
- [ ] (d) Vše je ignorováno/commitnuto správně (.gitignore, žádné velké HTML v Gitu)?
- [ ] (e) CI zelené?
