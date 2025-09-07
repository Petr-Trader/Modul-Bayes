# Modul-Bayes

Modulární Bayes optimalizace pro MT5 \(EA\): katalog indikátorů (YAML), profily EA, generátor prostoru, builder .set, runner, parser reportů, scorer a leaderboard.

## Rychlý start
1. `pip install -r requirements.txt`
2. `pytest -q`

## Struktura
- `catalog/` - YAML katalog indikátorů \(jediný zdroj pravdy\)
- `profiles/` - YAML profily EA \(mapování na Inputs\)
- `modules/` - jednotlivé moduly \(space_generator, set_builder, ...\)
- `sets/` - .set baseline / generated / deploy
- `reports/raw/` - MT5 HTML/CSV reporty
- `results/` - parsované a skórované výsledky
- `tests/` - rychlé testy a validace

## Licence
MIT \(pokud nezměníš\).
