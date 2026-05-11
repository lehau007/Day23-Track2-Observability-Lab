# Bonus Challenge (Provocation #1)

This bonus wires Day 20 llama.cpp metrics into the Day 23 observability stack with a focused SLO and burn-rate alert.

## What is included

- Dashboard JSON: `bonus/dashboards/day20-llamacpp.json`
- SLO + burn-rate rules: `bonus/prometheus/rules/day20-llamacpp-slo-burn-rate.yml`
- Runbook: `bonus/RUNBOOK.md`
- Reflection: `bonus/REFLECTION.md`

## How to use (manual steps)

1. Start Day 20 metrics (real or stub):
   - Real: export `DAY20_LLAMACPP_METRICS_URL` and run `05-integration/monitor-day20-llama-cpp.py`
   - Stub: run `05-integration/monitor-day20-llama-cpp.py` with no env var
2. Add a Prometheus scrape job for the stub (`:9102`) or the real Day 20 endpoint.
3. Include the rule file from `bonus/prometheus/rules/` in your Prometheus rules config.
4. Import the dashboard JSON into Grafana (or add it to provisioning).

Notes: This keeps bonus artifacts in `bonus/` to avoid changing core lab behavior.
