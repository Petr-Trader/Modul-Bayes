# tests/test_gitignore.py
from pathlib import Path

def test_gitignore_contains_daily_briefing():
    p = Path(".gitignore")
    assert p.exists(), ".gitignore chybí"
    content = p.read_text(encoding="utf-8")
    assert "DAILY_BRIEFING.md" in content, "DAILY_BRIEFING.md není v .gitignore"
