# Day 23 Lab Reflection

> Fill in each section. Grader reads the "What I'd change" paragraph closest.

**Student:** Lê Văn Hâu

**Submission date:** 2026-05-11

**Lab repo URL:** 
---

## 1. Hardware + setup output

Paste output of `python3 00-setup/verify-docker.py`:

```json
{
  "docker": {
    "ok": true,
    "version": "29.4.0"
  },
  "compose_v2": {
    "ok": true,
    "version": "5.1.3"
  },
  "ram_gb_available": 14.81,
  "ram_ok": true,
  "required_ports": [
    8000,
    9090,
    9093,
    3000,
    3100,
    16686,
    4317,
    4318,
    8888
  ],
  "bound_ports": [],
  "all_ports_free": true
}
```

---

## 2. Track 02 — Dashboards & Alerts

### 6 essential panels (screenshot)

Drop `submission/screenshots/task01-dashboard-overview.png`.

### Burn-rate panel

Drop `submission/screenshots/task02-slo-burn-rate.png`.

### Alert fire + resolve

| When | What | Evidence |
|---|---|---|
| _T0_ | killed `day23-app`         | screenshot `task03-slack-firing.png` |
| _T0+90s_ | `ServiceDown` fired   | screenshot `task03-slack-firing.png` |
| _T1_ | restored app              | — |
| _T1+60s_ | alert resolved        | screenshot `task03-slack-resolved.png` |

### One thing surprised me about Prometheus / Grafana

I was surprised by how seamless Prometheus and Grafana feel when using Dashboards-as-Code. There was no manual UI setup for data sources or dashboards; everything came up automatically from `grafana/provisioning` at startup.

---

## 3. Track 03 — Tracing & Logs

### One trace screenshot from Jaeger

Drop `submission/screenshots/task04-jaeger-trace.png` showing `embed-text → vector-search → generate-tokens` spans.

### Log line correlated to trace

Paste the log line and the trace_id it links to:

```json
{"model": "llama3-mock", "input_tokens": 4, "output_tokens": 54, "quality": 0.82, "duration_seconds": 0.1539, "trace_id": "29aa81eadd9a3befda6bdb9d7013e71f", "event": "prediction served", "level": "info", "timestamp": "2026-05-11T03:43:36.347807Z"}
```

### Tail-sampling math

Assume the service emits N traces/sec, with error rate E (e.g., 5%), slow rate S (e.g., 1%), and overlap O.
`keep-errors` retains E * N traces.
`keep-slow` retains S * N traces.
`probabilistic-1pct` applies to the remainder and keeps 1%.
So the total kept fraction is: (E + S - O) + 0.01 * (1 - E - S + O).
Example: with no errors and no slow requests, it keeps 1% (0.01 * N). If the system is fully failing (E=100%), it keeps 100% of traces.

---

## 4. Track 04 — Drift Detection

### PSI scores

Paste `04-drift-detection/reports/drift-summary.json`:

```json
{
  "prompt_length": {
    "psi": 3.461,
    "kl": 1.7982,
    "ks_stat": 0.702,
    "ks_pvalue": 0.0,
    "drift": "yes"
  },
  "embedding_norm": {
    "psi": 0.0187,
    "kl": 0.0324,
    "ks_stat": 0.052,
    "ks_pvalue": 0.133853,
    "drift": "no"
  },
  "response_length": {
    "psi": 0.0162,
    "kl": 0.0178,
    "ks_stat": 0.056,
    "ks_pvalue": 0.086899,
    "drift": "no"
  },
  "response_quality": {
    "psi": 8.8486,
    "kl": 13.5011,
    "ks_stat": 0.941,
    "ks_pvalue": 0.0,
    "drift": "yes"
  }
}
```

### Which test fits which feature?

- `prompt_length`: PSI (Population Stability Index). PSI is great for binned numerical data to measure the overall shift in distribution, making it suitable for prompt lengths which naturally fall into buckets.
- `embedding_norm`: KS (Kolmogorov-Smirnov). KS is sensitive to changes in the shape and location of continuous distributions, making it ideal for tight distributions like vector norms where small deviations matter.
- `response_length`: PSI. Similar to prompt length, response length is best binned and compared using PSI.
- `response_quality`: KL (Kullback-Leibler) Divergence. KL divergence is excellent for comparing probabilities or scores bounded between 0 and 1, as it measures the information lost when approximating the reference distribution with the current one.

---

## 5. Track 05 — Cross-Day Integration

### Which prior-day metric was hardest to expose? Why?

The hardest prior-day metric to expose was the Vector Store (Day 19) because it depends on an external Qdrant instance on a different port/network. That means updating the Prometheus scrape config with the right `.env` values and confirming the Docker network can reach it.

---

## 6. The single change that mattered most

As an SRE, the most impactful change was switching to multi-window, multi-burn-rate alerts (SLO burn-rate) rather than a single static error threshold. Static thresholds (e.g., errors > 5%) are noisy and often fire on short spikes, which creates alert fatigue.

Using burn rates (deck §5) measures how quickly the error budget is being spent across multiple windows (for example, 1 hour vs 6 hours). That way, on-call only gets paged when the budget is draining fast enough to threaten the monthly SLO, while slower degradation produces warnings. It moves the stack from merely "working" to being "useful" with higher-signal, actionable alerts.
