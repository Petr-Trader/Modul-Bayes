$ErrorActionPreference = 'Stop'
$branch = git rev-parse --abbrev-ref HEAD
$today  = Get-Date -Format 'yyyy-MM-dd'
$py     = (python --version) 2>&1

# Sem si dej switch podle PC/jmena stroje, pokud chces:
$mt5    = '"C:\MT5_Portable\MT5_A\terminal64.exe";"C:\MT5_Portable\MT5_B\terminal64.exe";"C:\MT5_Portable\MT5_C\terminal64.exe"'
$data   = 'C:\DATA'
$repo   = (Get-Location).Path

@"
# Briefing pro asistenta ($today)
Branch: $branch
Cíl na dnes: <doplň 1–2>
Stroj: <doma/práce>
Nové změny od včera:
- (spusť) git log --since="yesterday" --oneline
Blokery/omezení: <pokud jsou>
Co ověřit po dokončení: DoD/CI/artefakty

## Kontext (auto)
- Python: $py
- Repo: $repo
- MT5 terminals: $mt5
- Data root: $data
"@ | Out-File -Encoding UTF8 DAILY_BRIEFING.md

Write-Host "[OK] Vytvořeno: DAILY_BRIEFING.md"
