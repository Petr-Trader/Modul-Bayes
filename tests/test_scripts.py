# tests/test_scripts.py
from pathlib import Path

def test_required_scripts_exist():
    required = [
        Path("scripts/env_vars_home.cmd"),
        Path("scripts/env_vars_work.cmd"),
        Path("scripts/make_briefing.bat"),
        Path("scripts/open_pr_default.cmd"),
        Path("scripts/open_pr_small.cmd"),
    ]
    missing = [str(p) for p in required if not p.exists()]
    assert not missing, f"Chybí soubory: {missing}"
