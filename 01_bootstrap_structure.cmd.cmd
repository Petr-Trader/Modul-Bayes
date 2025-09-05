@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul

REM === Spouštěj v kořeni repa nebo nastav REPO_DIR na úplnou cestu ===
set "REPO_DIR=."

pushd "%REPO_DIR%" || goto :path_error

REM --- Git sanity ---
git rev-parse --is-inside-work-tree >nul 2>&1 || goto :git_error

REM --- Přepnutí / vytvoření větve ci/bootstrap ---
git rev-parse --verify ci/bootstrap >nul 2>&1
if errorlevel 1 (
  echo [INFO] Větev ci/bootstrap neexistuje, vytvářím...
  git checkout -b ci/bootstrap || goto :git_error
) else (
  echo [INFO] Větev ci/bootstrap už existuje, přepínám...
  git checkout ci/bootstrap || goto :git_error
)

REM --- Struktura adresářů ---
for %%D in (
  catalog
  profiles
  config
  modules
  tests
  sets
  sets\baseline
  sets\generated
  sets\deploy
  reports
  reports\raw
  results
  logs
  .github
  .github\workflows
  examples
  examples\catalog
  examples\profiles
) do (
  if not exist "%%D" mkdir "%%D"
)

REM --- .gitkeep do prázdných složek ---
for %%D in (catalog profiles config modules tests sets\baseline sets\generated sets\deploy reports\raw results logs) do (
  if not exist "%%D\.gitkeep" echo.>"%%D\.gitkeep"
)

REM --- .gitignore ---
(
echo __pycache__/
echo .venv/
echo .vscode/
echo .idea/
echo *.pyc
echo *.pyo
echo *.pyd
echo *.log
echo results/
echo reports/raw/
echo sets/generated/
echo logs/
echo .DS_Store
) > ".gitignore"

REM --- requirements.txt ---
(
echo pyyaml
echo pydantic
echo pandas
echo pytest
echo ruff
echo mypy
echo yamllint
) > "requirements.txt"

REM --- README.md (minimal) ---
(
echo # Modul-Bayes
echo
echo Modulární Bayes optimalizace pro MT5 (EA): katalog indikátorů (YAML), profily EA, generátor prostoru, builder .set, runner, parser reportů, scorer a leaderboard.
echo
echo ## Rychlý start
echo 1. pip install -r requirements.txt
echo 2. pytest -q
echo
echo ## Struktura
echo - catalog/ - YAML katalog indikátorů (jediný zdroj pravdy)
echo - profiles/ - YAML profily EA (mapování na Inputs)
echo - modules/ - jednotlivé moduly (space_generator, set_builder, ...)
echo - sets/ - .set baseline / generated / deploy
echo - reports/raw/ - MT5 HTML/CSV reporty
echo - results/ - parsované a skórované výsledky
echo - tests/ - rychlé testy a validace
echo
echo ## Licence
echo MIT (pokud nezměníš).
) > "README.md"

REM --- LICENSE (MIT krátce, rok doplň dle potřeby) ---
(
echo MIT License
echo
echo Copyright (c) 2025
echo
echo Permission is hereby granted, free of charge, to any person obtaining a copy
echo of this software and associated documentation files (the "Software"), to deal
echo in the Software without restriction, including without limitation the rights
echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
echo copies of the Software, and to permit persons to whom the Software is
echo furnished to do so, subject to the following conditions:
echo
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
) > "LICENSE"

REM --- Examples: indicators.yaml ---
(
echo version: "1.00"
echo indicators:
echo ^  RSI:
echo ^    mt5_name: "RSI"
echo ^    aliases: ["RelativeStrengthIndex","iRSI"]
echo ^    inputs:
echo ^      Period:
echo ^        type: int
echo ^        default: 14
echo ^        range:
echo ^          H1: {min: 5, max: 40, step: 1}
echo ^          H4: {min: 5, max: 50, step: 1}
echo ^          D1: {min: 5, max: 60, step: 1}
echo ^      AppliedPrice:
echo ^        type: enum
echo ^        allowed: ["CLOSE","OPEN","HIGH","LOW","MEDIAN","TYPICAL","WEIGHTED"]
echo ^        default: "CLOSE"
echo ^  ADX:
echo ^    mt5_name: "ADX"
echo ^    aliases: ["AverageDirectionalMovementIndex","iADX"]
echo ^    inputs:
echo ^      Period:
echo ^        type: int
echo ^        default: 14
echo ^        range:
echo ^          H1: {min: 7, max: 40, step: 1}
echo ^          H4: {min: 7, max: 50, step: 1}
) > "examples\catalog\indicators.yaml"

REM --- Examples: EA profile ---
(
echo ea:
echo ^  name: "EA_Example"
echo ^  version: "0.1"
echo ^  inputs:
echo ^    InpRsiPeriod:
echo ^      from_indicator: "RSI"
echo ^      field: "Period"
echo ^    InpAdxPeriod:
echo ^      from_indicator: "ADX"
echo ^      field: "Period"
echo ^    InpLotSize:
echo ^      type: float
echo ^      default: 0.10
echo ^      range: {min: 0.01, max: 1.00, step: 0.01}
echo ^  constraints:
echo ^    min_trades: 50
echo ^    max_dd_pct: 35
echo ^  objective:
echo ^    primary: "MAR"
echo ^    secondary: "PF"
echo universe_ref: "../config/universe.yaml"
) > "examples\profiles\EA_Example.yaml"

REM --- GitHub Actions CI ---
(
echo name: CI
echo on: [push, pull_request]
echo jobs:
echo ^  build:
echo ^    runs-on: ubuntu-latest
echo ^    strategy:
echo ^      matrix:
echo ^        pyt
