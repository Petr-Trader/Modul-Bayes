# TODO – Modul‑Bayes (Milník 1)

> Řídicí seznam úkolů a kontrol pro projekt **Modul‑Bayes**.  
> Cíle Milníku 1: základní skripty, testy, CI, PR/issue šablony, pracovní „workspace“ nastavení.

## 1) Hotovo v Milníku 1
- [x] Skripty **home/work start/end** (`scripts/*.bat`).
- [x] Základní testy (`tests/…`).
- [x] CI workflow (lint + testy).
- [x] PR šablony (default/small).
- [x] Příprava dokumentů **TODO.md** a **workspace.md**.

## 2) Kroky k dokončení Milníku 1 (teď)
- [x] **Přidat** `TODO.md` a `workspace.md` do větve `dev` přes PR.
- [X] Ověřit, že CI proběhne „zeleně“ na PR.
- [ ] **Zamknout** větve `main` a `dev` (branch protection) – povinné PR + úspěšný CI.
- [X] Sloučit PR → `dev`.
- [ ] (Volitelné) **ALIGN**: otevřít PR `dev → main` a sjednotit stav.

## 3) Kontroly po dokončení
- [ ] V GitHub **Settings → Branches**: pravidla pro `main` a `dev`:
  - Require a pull request before merging (ON).
  - Require status checks to pass before merging (ON) – zvol CI workflow.
  - Require conversation resolution before merging (ON).
  - Do not allow bypassing the above settings (ON) – vyjma GitHub Actions, pokud je potřeba.
- [ ] PR šablona **small** je výchozí pro drobné změny.
- [ ] `scripts/*_start.bat` a `*_end.bat` běží lokálně bez chyb.

## Dnešní práce – 2025-09-09
- [x] Přidán `workspace.md` s hlavičkou `# Provozní řád (workflow)`.
- [x] Přidán `TODO_Milnik_1.md`.
- [x] PR #13 (docs) – CI zelené (hlavička opravena).
- [x] PR #13 sloučen do `dev`.  _(zaškrtni po merge, pokud ještě není)_
- [x] Přidán `.gitattributes`.
- [x] Uzavřeny zbytečné PR/větve (#17, #18).
- [ ] ALIGN `dev → main` (#14).  _(zaškrtni po merge)_

## 4) Rychlé příkazy (lokálně)
```bat
:: vytvoř vlastní větev a commit
git checkout -b docs/m1-todo-workspace
git add TODO.md workspace.md
git commit -m "docs: přidat TODO a workspace (Milník 1)"

:: push a PR do dev
git push -u origin docs/m1-todo-workspace
gh pr create --base dev --head docs/m1-todo-workspace --title "docs: TODO + workspace (M1)" --body "Dokončení Milníku 1: přidání TODO.md a workspace.md."
```

## 5) Checklist CI (na PR)
- [ ] `pytest` ✅
- [ ] `ruff` ✅
- [ ] `mypy` (pokud zapnuto) ✅
- [ ] Test skriptů (`tests/test_scripts.py`) ✅

## 6) Poznámky
- Pro větve `main` a `dev` **nepushuji přímo** – vždy přes PR.
- Commit zprávy udržuj česky a stručně (prefixy: `feat|fix|docs|chore|ci|test`).
