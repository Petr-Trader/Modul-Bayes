from pathlib import Path
import numbers
import yaml

ALLOWED_TFS = {"H1", "H4", "D1"}
ALLOWED_TYPES = {"int", "float", "enum", "bool", "string", "str", "number"}

def load_catalog():
    p = Path("catalog/indicators.yaml")
    assert p.exists(), "catalog/indicators.yaml must exist"
    data = yaml.safe_load(p.read_text(encoding="utf-8"))
    assert isinstance(data, dict), "YAML root must be a mapping"
    assert data.get("version"), "Missing catalog version"
    indicators = data.get("indicators")
    assert isinstance(indicators, dict) and indicators, "Missing indicators mapping"
    return data, indicators

def _ok_alias(spec):
    # alias: "rsi" nebo ["rsi","iRSI"]
    if "alias" not in spec:
        return False
    a = spec["alias"]
    if isinstance(a, str):
        return bool(a.strip())
    if isinstance(a, list):
        return all(isinstance(x, str) and x for x in a)
    return False

def _norm_min_max_step(obj):
    """
    Přijmeme buď dict s klíči min/max[/step], nebo trojici [start,end,step].
    Vrací (start, end, step) jako floaty, step default=1.
    """
    if isinstance(obj, (list, tuple)) and len(obj) == 3:
        s, e, st = obj
    elif isinstance(obj, dict):
        s = obj.get("min")
        e = obj.get("max")
        st = obj.get("step", 1)
    else:
        raise AssertionError(f"Neznámý tvar rozsahu: {obj!r}")
    for v in (s, e, st):
        assert isinstance(v, numbers.Number), f"Hodnoty musí být čísla: {obj!r}"
    assert s <= e, f"start musí být ≤ end: {obj!r}"
    assert st > 0, f"step musí být > 0: {obj!r}"
    return float(s), float(e), float(st)

def test_inputs_and_by_tf_shape():
    """
    Pro každého indikátora:
      - existuje alias
      - existují inputs (dict, neprázdný)
      - každý parametr má type ∈ ALLOWED_TYPES
      - pokud je definováno by_tf: TF ⊆ {H1,H4,D1}, rozsahy min/max(/step) dávají smysl
      - pokud jsou globální min/max/step, rámcově pokrývají TF rozsahy
    """
    _, indicators = load_catalog()
    for name, spec in indicators.items():
        assert _ok_alias(spec), f"{name}: chybí nebo je prázdný 'alias'"

        inputs = spec.get("inputs")
        assert isinstance(inputs, dict) and inputs, f"{name}: chybí 'inputs' (dict)"

        for p_name, p in inputs.items():
            assert "type" in p, f"{name}.{p_name}: chybí 'type'"
            ptype = str(p["type"]).lower()
            assert ptype in ALLOWED_TYPES, f"{name}.{p_name}: nepovolený type={p['type']}"

            gmin = p.get("min")
            gmax = p.get("max")
            gstep = p.get("step")
            if gmin is not None: assert isinstance(gmin, numbers.Number)
            if gmax is not None: assert isinstance(gmax, numbers.Number)
            if gstep is not None: assert isinstance(gstep, numbers.Number) and gstep > 0

            if "by_tf" in p:
                by_tf = p["by_tf"]
                assert isinstance(by_tf, dict) and by_tf, f"{name}.{p_name}: 'by_tf' musí být dict"
                for tf, rng in by_tf.items():
                    assert tf in ALLOWED_TFS, f"{name}.{p_name}: neznámý TF {tf}"
                    s, e, st = _norm_min_max_step(rng)
                    if gmin is not None: assert s >= gmin, f"{name}.{p_name}.{tf}: start < min"
                    if gmax is not None: assert e <= gmax, f"{name}.{p_name}.{tf}: end > max"

def test_enum_values_and_outputs_schema():
    """
    - outputs: pokud existují, MUSÍ být dict: { output_name: {type: <typ>} }
      kde <typ> je string z ALLOWED_TYPES (case-insensitive).
    - enum parametry musí mít 'values': list (neprázdný) nebo '@odkaz'.
    """
    data, indicators = load_catalog()
    for name, spec in indicators.items():
        # outputs musí být slovník s názvy a meta {type: ...}
        outs = spec.get("outputs")
        if outs is not None:
            assert isinstance(outs, dict) and outs, f"{name}: 'outputs' musí být dict s položkami"
            for out_name, meta in outs.items():
                assert isinstance(out_name, str) and out_name, f"{name}: klíče v 'outputs' musí být názvy (string)"
                if meta is not None:
                    assert isinstance(meta, dict), f"{name}.{out_name}: metadata outputu musí být dict"
                    otype = meta.get("type")
                    assert isinstance(otype, str) and otype.lower() in {t.lower() for t in ALLOWED_TYPES}, \
                        f"{name}.{out_name}: 'type' výstupu musí být v {ALLOWED_TYPES}, dostal {otype!r}"

        # enum parametry (ve schématu inputs/by_tf/alias)
        inputs = spec.get("inputs", {})
        for p_name, p in inputs.items():
            if str(p.get("type")).lower() == "enum":
                values = p.get("values")
                ok = False
                if isinstance(values, list) and values:
                    ok = True
                elif isinstance(values, str) and values.startswith("@") and len(values) > 1:
                    ok = True
                assert ok, f"{name}.{p_name}: enum musí mít 'values' (list nebo '@odkaz')"
