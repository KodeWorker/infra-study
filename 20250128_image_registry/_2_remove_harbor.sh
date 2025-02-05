rm ca.crt ca.key
kubectl delete secret harbor-cert -n harbor
helm delete harbor -n harbor

kubectl delete pvc data-harbor-redis-0 -n harbor
kubectl delete pvc data-harbor-trivy-0 -n harbor
kubectl delete pvc database-data-harbor-database-0 -n harbor
kubectl delete pvc harbor-jobservice -n harbor
kubectl delete pvc harbor-registry -n harbor

kubectl delete namespace harbor