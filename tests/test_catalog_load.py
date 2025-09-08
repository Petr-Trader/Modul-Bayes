import yaml
from pathlib import Path

def test_catalog_loads():
    p = Path("catalog/indicators.yaml")
    assert p.exists()
    data = yaml.safe_load(p.read_text(encoding="utf-8"))
    assert data.get("version") == "1.00"
    assert "indicators" in data
    for key in ["RSI", "EMA", "ATR", "Stochastic", "ADX"]:
        assert key in data["indicators"]
