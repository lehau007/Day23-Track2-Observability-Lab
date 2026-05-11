# Runbook: Day 20 llama.cpp SLO burn-rate

## Alert

- `Day20LlamaCppSLOFastBurn` or `Day20LlamaCppSLOSlowBurn`
- SLO: tokens/sec >= 12 for 99% of time (bad fraction <= 0.01)

## Immediate actions (first 10 minutes)

1. Check the dashboard: tokens/sec trend, queue depth, and completions rate.
2. If tokens/sec is low AND queue depth is rising, treat this as capacity saturation.
3. Verify the Day 20 metrics source (stub vs real). If the metrics source is down, fix the scrape first.
4. If real llama.cpp is running, restart the process and confirm tokens/sec recovers within 5 minutes.
5. If traffic is unusually high, apply a temporary rate limit or reduce concurrent requests.

## Follow-up

- Capture the time window and any errors from the Day 20 server logs.
- If the issue is model regression (slower tokens/sec), consider rollback to a smaller model or a lower context length.
- Update the dashboard with a new panel if the root cause was not visible (e.g., GPU memory or KV cache pressure).

## Success criteria

- Tokens/sec returns above 12 and queue depth stabilizes within 15 minutes.
