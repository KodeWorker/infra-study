## Deploy image registry on K8s

1. install helm
2. deploy harbor
  - helm show values harbor/harbor >> values.yaml
  - deploy with custom values
3. helm delete harbor -n harbor

4. config values.yaml
    - set nodePort (for now)
    - Startup probe failed: Get "http://192.168.28.118:8080/api/v2.0/ping": dial tcp 192.168.28.118:8080: connect: connection refused
    - failed to ping redis://harbor-redis:6379/0?idle_timeout_seconds=30
    - https://openforum.hand-china.com/t/topic/5327
    - pod has unbound immediate PersistentVolumeClaims
    persistence -> false (for now)

5. 

## Reference
1. https://kb.leaseweb.com/kb/kubernetes/kubernetes-deploying-a-docker-registry-on-kubernetes/
2. https://www.cnblogs.com/qiuhom-1874/p/17301455.html
3. https://unix.stackexchange.com/questions/150523/bash-iptables-command-not-found
4. https://vishynit.medium.com/setting-up-harbor-registry-on-kubernetes-using-helm-chart-5989d7c8df2a
5. https://blog.csdn.net/shida_csdn/article/details/104334372
6. https://blog.csdn.net/tankpanv/article/details/132296924

