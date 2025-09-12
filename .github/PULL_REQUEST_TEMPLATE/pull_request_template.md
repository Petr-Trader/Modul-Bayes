# Název PR (krátce a s prefixem)
# např.: feat: space_generator v1.00 – policy=safe (H4) | ci: bootstrap pytest+ruff+mypy

## Kontext / Milník
- Milník: Mx – <název> (viz TODO.md)
- Úkol(y): <odrážky nebo odkazy na řádky v TODO.md>
- Důvod změny (Proč): 1–2 věty, jakou hodnotu přináší / jaký problém řeší.

## Co se mění (ELI5)
- [ ] bod 1
- [ ] bod 2
- [ ] bod 3
> Pokud měníš názvy parametrů/kontrakty, zvýrazni to tady.

## Vstupy (Inputs)
- Konfigy / data / soubory: `...`
- Předpoklady: verze Pythonu / MT5 terminály / cesty (pokud relevantní)

## Příkazy k ověření (How to test)
```bash
# minimální smoke-test
pytest -q

# příklad běhu modulu/CLI k této změně
python -m modules.<modul> <argumenty>


---

## Titulek PR a štítky
- Titulek: **`<prefix>: <oblast> – <stručný cíl>`** (např. `feat: set_builder v1.00 – validace typů`)
- Prefixy: `feat`, `fix`, `docs`, `chore`, `test`, `ci` (stejné jako v TODO) – pomáhá to čitelnosti historie a CI filtrům. :contentReference[oaicite:2]{index=2}
- Labels (pokud používáš): `milestone:Mx`, `area:ci`, `type:feature`, apod.

## Kdy PR dělat (→ `dev`)
- Každé **smysluplné sousto** (~1–3 hod. práce nebo ~100–300 LOC).
- **Vždy na konci dne**: Draft PR je v pohodě; aspoň běží CI a vidíš diff.
- Velké PR rozsekej; menší PR = rychlejší kontrola a menší riziko.

Chceš i **mini šablonu** pro drobné PR (jen dokumentace či malý fix)? Stačí vytvořit druhý soubor `.github/PULL_REQUEST_TEMPLATE/small.md` a GitHub ti při zakládání PR nabídne výběr šablony.
::contentReference[oaicite:3]{index=3}
