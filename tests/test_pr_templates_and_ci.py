# tests/test_pr_templates_and_ci.py
from pathlib import Path

def test_small_pr_template_exists_and_has_headings():
    p = Path(".github/PULL_REQUEST_TEMPLATE/small.md")
    assert p.exists(), "PR template small.md chybí"
    txt = p.read_text(encoding="utf-8").lower()

    # Tolerantní kontroly nadpisů (CZ/EN varianty)
    assert any(h in txt for h in ["co se mění", "changes", "what"]),         "small.md neobsahuje sekci 'Co se mění / What'"
    assert any(h in txt for h in ["proč", "why", "důvod"]),         "small.md neobsahuje sekci 'Proč / Why'"

    # DoD / požadavky / checklist – povolíme více synonym
    dod_synonyms = ["dod", "požadavky", "checklist", "kontrola", "co projde"]
    assert any(h in txt for h in dod_synonyms),         "small.md neobsahuje sekci DoD/Požadavky/Checklist/Kontrola"

    # V šabloně by měl být checklist
    assert ("- [ ]" in txt) or ("- [x]" in txt),         "small.md neobsahuje žádný checklist ('- [ ]')"

def test_ci_workflow_mentions_tools():
    p = Path(".github/workflows/ci.yml")
    assert p.exists(), "ci.yml chybí"
    txt = p.read_text(encoding="utf-8").lower()
    for k in ["jobs:", "pytest", "ruff", "mypy"]:
        assert k in txt, f"ci.yml neobsahuje '{k}'"
