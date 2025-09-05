# Modul-Bayes
ECHO is off.
Modulární Bayes optimalizace pro MT5 \(EA\): katalog indikátorů (YAML), profily EA, generátor prostoru, builder .set, runner, parser reportů, scorer a leaderboard.
ECHO is off.
## Rychlý start
1. `pip install -r requirements.txt`
2. `pytest -q`
ECHO is off.
## Struktura
- `catalog/` - YAML katalog indikátorů \(jediný zdroj pravdy\)
- `profiles/` - YAML profily EA \(mapování na Inputs\)
- `modules/` - jednotlivé moduly \(space_generator, set_builder, ...\)
- `sets/` - .set baseline / generated / deploy
- `reports/raw/` - MT5 HTML/CSV reporty
- `results/` - parsované a skórované výsledky
- `tests/` - rychlé testy a validace
ECHO is off.
## Licence
MIT \(pokud nezměníš\).
