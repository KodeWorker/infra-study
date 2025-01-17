## Transfer services from local to cluster

1. minikube (test networking)
    1. build images:
        ```docker build ./backend -f backend/Dockerfile -t backend```

        ```docker build ./frontend -f frontend/Dockerfile -t frontend```

        (change get ip to local ip address:  http://192.168.49.2:30001)

        ```docker image pull prom/prometheus:latest```

        ```docker image pull grafana/grafana:latest```
        
    2. push images:
        ```minikube start --nodes=2```

        ```minikube cache add backend:latest frontend:latest prom/prometheus:latest grafana/grafana:latest``` (BAD! minikube image load GOOD!)

        ```minikube image load backend:latest```

        ```minikube image load frontend:latest```

        ```minikube image load prom/prometheus:latest```

        ```minikube image load grafana/grafana:latest```

        minikube image ls -> docker.io/library/backend:latest ... WTF?
    3. write deployment and service yamls for frontend backend prometheus and grafana'
        - learn from kompose convert
        - ports: port/targetPort
        - imagePullPolicy: Never (IMPORTANT!)
        - volumes in k8s: 
            https://kubernetes.io/docs/concepts/storage/volumes/
            https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/

            ```kubectl create configmap prometheus-config --from-file=./prometheus/prometheus.yml```

            ```kubectl get configmap prometheus-config -o yaml```

            ```kubectl delete configmap prometheus-config```

            https://kubernetes.io/docs/concepts/storage/persistent-volumes/
            https://ashishkr99.medium.com/persistent-prometheus-grafana-on-kubernetes-71336d3c7a22

            ```kubectl get svc``` 見識cluster的裡世界

            pod-to-pod connection ~ container-to-container connection

        - grafana provisioning:
            https://grafana.com/docs/grafana/latest/setup-grafana/installation/kubernetes/
            apply yaml and then kubectl cp provinioning files (?!)
            不可能這樣吧？
            generate json and yaml as configmap
            
            檢視po錯誤: kubectl logs <pod-name> -c <container-name>

            ```
            GF_PATHS_DATA='/var/lib/grafana' is not writable.
            You may have issues with file permissions, more information here: http://docs.grafana.org/installation/docker/#migrate-to-v51-or-later
            mkdir: can't create directory '/var/lib/grafana/plugins': Permission denied
            ```
            uid=0解決

            https://stackoverflow.com/questions/60727107/how-can-i-give-grafana-user-appropriate-permission-so-that-it-can-start-successf

            ```kubectl exec --stdin --tty <pod-name> -- /bin/bash```
            
            來看看檔案是否正確！ls /etc/grafana/provisioning
        
        - 關掉prometheus對外exposure (service) 檢視監控是否正確
          連線架構： frontend (對外，固定port) --> backend (對外，固定port) <---內部--- prometheus ---內部---> grafana (對外，浮動port)

    4. NetworkPolicy (network isolation)
        TBD: 
        https://godleon.github.io/blog/Kubernetes/k8s-Network-Policy-Overview/
        https://feisky.gitbooks.io/kubernetes/content/concepts/network-policy.html

2. start cluster with kubeadm (on-premise)
    TBD:
    https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

## Reference
1. https://minikube.sigs.k8s.io/docs/handbook/pushing/
2. https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/