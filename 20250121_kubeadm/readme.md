## Start a single-node cluster with containerd
---

### build a cluster using kubeadm

1. remember to swapoff for kubeadm init

2. root user export KUBECONFIG=/etc/kubernetes/admin.conf not working

3. install cni: calico
    - container runtime 設定：SystemdCgroup = true <--很重要 calico failed 之後 control plane 直接掛點

4. test cluster
    - kubectl run my-nginx --image=nginx:alpine --port=80
    - kubectl expose pod my-nginx --type=NodePort --name=my-ng-srv --port=80 --target-port=80
    - kubectl get pod
    - kubectl get svc # see expoed port
    - curl localhost:32492

### Deploy a backend service

1. setup buildkit for nerdctl

2. nerdctl build -t backend ./backend

3. load local ctr image to cluster
    - ctr image ls
    - ctr image export --platform=linux/amd64 backend.tar.gz docker.io/library/backend:latest
    - ctr -n=k8s.io images import backend.tar.gz
    - crictl image ls

4. kubectl apply -f backend.yaml

5. see localhost:30001

6. kubectl delete -f backend.yaml

7. cleanup
    - crictl rmi docker.io/library/backend:latest
    - ctr image rm docker.io/library/backend:latest

## Reference
1. https://blog.ooopiz.com/post/2019/07/creating-kubernetes-single-node-cluster/
2. https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
3. https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
4. https://weng-albert.medium.com/%E6%90%AD%E5%BB%BAkubernetes%E7%B6%B2%E8%B7%AF%E5%9F%BA%E7%9F%B3-cni%E7%9A%84%E5%AE%89%E8%A3%9D%E8%88%87%E6%AF%94%E8%BC%83-250db9169863
5. https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart
6. https://blog.frognew.com/2021/05/relearning-container-05.html
7. https://stackoverflow.com/questions/69981852/how-to-use-local-docker-images-in-kubernetes-deployments-not-minikube
8. https://stackoverflow.com/questions/52647072/my-kubernetes-cluster-ip-address-changed-and-now-kubectl-will-no-longer-connect