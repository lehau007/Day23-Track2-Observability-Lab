while true; do
  curl -sS -X POST http://localhost:8000/predict -H "Content-Type: application/json" -d '{"prompt":"hello", "fail": false}' > /dev/null
  curl -sS -X POST http://localhost:8000/predict -H "Content-Type: application/json" -d '{"prompt":"hello", "fail": false}' > /dev/null
  curl -sS -X POST http://localhost:8000/predict -H "Content-Type: application/json" -d '{"prompt":"hello", "fail": false}' > /dev/null
  curl -sS -X POST http://localhost:8000/predict -H "Content-Type: application/json" -d '{"prompt":"hello", "fail": false}' > /dev/null
  curl -sS -X POST http://localhost:8000/predict -H "Content-Type: application/json" -d '{"prompt":"hello", "fail": true}' > /dev/null
  sleep 0.5
done
