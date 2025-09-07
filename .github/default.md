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

Očekávané výstupy (Artefakty)

Vzniká: path/to/output (typ: html/csv/parquet/json)

Vedlejší efekty: např. kopie .set do sets/deploy

DoD (Definition of Done)

 Testy (pytest) pro klíčové happy-path i edge-cases

 CLI (--help) + ukázkový příkaz v README

 Determinismus: stejné vstupy → stejné výstupy + uložena metadata (verze katalogu/profilu/EA)

 Hygiena commitů / .gitignore (žádné velké HTML v gitu)

 CI zelené (GitHub Actions)

Rizika / Dopady / Rollback

Rizika: …

Breaking changes: …

Rollback: revert commit X / vypnutí modulu Y

Screens / Logy (volitelné)

Screenshoty CI, ukázka výsledného HTML/CSV, výřez logu…

Související

Issues: #…

TODO.md: odkaz na milník/úkol

Poznámka: po merge odškrtnu položky v TODO.md
