@echo off
REM Skript pro vytvoření základní struktury projektu Modul-Bayes

REM Složky
mkdir catalog
mkdir profiles
mkdir config
mkdir config\broker
mkdir bayes
mkdir sets
mkdir sets\baseline
mkdir sets\generated
mkdir sets\deploy
mkdir reports
mkdir reports\raw
mkdir results
mkdir logs
mkdir modules
mkdir modules\env_check
mkdir modules\universe_builder
mkdir modules\indicator_catalog
mkdir modules\space_generator
mkdir modules\set_builder
mkdir modules\runner_mt5
mkdir modules\report_parser
mkdir modules\objective_scorer
mkdir modules\leaderboard_maker
mkdir modules\deployer
mkdir tests

REM Soubory
type nul > catalog\indicators.yaml
type nul > profiles\EA_FX_CarryMomentum.yaml
type nul > profiles\EA_FollowTrend.yaml
type nul > config\env.yaml
type nul > config\universe.yaml
type nul > config\broker\darwinex.yaml
type nul > config\magic_registry.yaml
type nul > bayes\space.json
type nul > results\parsed.parquet
type nul > results\scored.parquet
type nul > results\leaderboard.html
type nul > pyproject.toml
type nul > README.md

echo Struktura projektu Modul-Bayes byla vytvořena.
pause