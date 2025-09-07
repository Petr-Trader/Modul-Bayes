# Provozní řád (workflow)

Tento dokument definuje každodenní rytmus práce v projektu Modul-Bayes.

---

## Denní rytmus

### Ráno – 2 min
1. Aktualizuj repozitář:
   ```bat
   git pull --rebase
   ```
2. Nastav prostředí (volitelné cesty):
   ```bat
   call scripts\env_vars_<work|home>.cmd
   ```
3. Vygeneruj briefing:
   ```bat
   call scripts\make_briefing.bat
   ```
   → otevři `DAILY_BRIEFING.md` a zkopíruj blok **„Briefing pro asistenta (dnes)“** do chatu.
4. Otevři `TODO.md` a vyber nejbližší neodškrtnutý úkol.

### Během práce
- Commity dělej malými kroky s prefixy:
  - `feat|fix|docs|chore|test|ci:`
- Větve: `feature/...` → PR do `dev` (default šablona, pro malé změny `small.md`).
- Po splnění DoD odškrtni úkol v `TODO.md`.

### Konec dne – 2 min
1. Spusť smoke testy:
   ```bat
   pytest -q
   ```
   nebo
   ```bat
   call scripts\smoke_test.bat
   ```
2. Ověř, že `git status` je čistý.
3. V `TODO.md` odškrtni hotové + přidej sekci **Zítra:** s 1–2 body.
4. Do chatu pošli krátké EOD: *co hotovo / co blokuje / co zítra*.

---

## Šablona briefingu
Každé ráno mi pošli:

```md
# Briefing pro asistenta (dnes)
Branch: <větev>
Cíl na dnes: <1–2 kroky>
Stroj: <home/work>
Nové změny od včera: <max 3>
Blokery/omezení: <pokud jsou>
Co ověřit po dokončení: <DoD/artefakty>
```

---

## ALIGN
Pokud napíšeš jen `ALIGN`, shrnu poslední stav (TODO, PR, artefakty) a navrhnu nejkratší cestu k dalšímu validnímu kroku.

---

## Kde co najdeš
- `workspace.md` – denní rituál + briefing + příkazy
- `scripts\make_briefing.bat` – generuje `DAILY_BRIEFING.md`
- `TODO.md` – jediný zdroj pravdy o práci
- `.github/pull_request_template.md` + `.github/PULL_REQUEST_TEMPLATE/small.md` – konzistentní PR popisy
