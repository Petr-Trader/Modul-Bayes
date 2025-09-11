# tests/test_workspace.py
from pathlib import Path

def test_workspace_has_operating_rules():
    p = Path("workspace.md")
    assert p.exists(), "workspace.md chybí"
    head = p.read_text(encoding="utf-8").lstrip()[:80].lower()
    assert head.startswith("# provozní řád"), "workspace.md nezačíná '# Provozní řád (workflow)'"
