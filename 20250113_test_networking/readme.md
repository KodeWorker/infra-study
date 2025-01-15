## Simple example with Grafana
---

fastapi (backend) <-- prometheus (monitor metrcs) <-- grafana + postgresSQL (visualization)

1. docker-compose up -d --force-recreate
2. docker-compose down --rmi all
4. docker container相互連接，使用內部port而不是export的 (裡世界/表世界)

## Reference
---
 1. https://github.com/Kludex/fastapi-prometheus-grafana/tree/master
 2. https://dev.to/ken_mwaura1/getting-started-monitoring-a-fastapi-app-with-grafana-and-prometheus-a-step-by-step-guide-3fbn
 3. https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/
 4. https://community.grafana.com/t/mkdir-cant-create-directory-var-lib-grafana-plugins-permission-denied/68342
    docker-compose up grafana -> see logs
 5. https://community.grafana.com/t/cant-disable-login-page/28037/2

https://volkovlabs.io/blog/provisioning-grafana-20230509/
https://grafana.com/docs/grafana/latest/developers/http_api/data_source/
https://grafana.com/docs/grafana/latest/datasources/prometheus/