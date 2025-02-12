## Project Template

1. nerdctl build -t backend ./backend

- nerdctl compose -f ./docker-compose.yml up -d --force-recreate
- nerdctl compose down --rmi all

## Project Structure

- backend
    - fastapi
- dataset
    - redis cache
    - PostgreSQL
- frontend
    - vue.js
- monitor
    - grafana
    - prometheous
    - loki
    - sentry (?)
- storage
    - minio (alt?)
- worker
    - training-worker
    - inference-worker

## Reference
1. https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli