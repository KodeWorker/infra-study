# Study Project
---

1. install kubectl
2. install minikube (virtual cluster)

* watch out for docker unhealthy -> need sudo privileges
sudo usermod -aG docker $USER && newgrp docker

3. kompose convert 

4. kubectl create secret docker-registry docker-registry-credentials --docker-server=https://index.docker.io/v1/ --docker-username=user --docker-password=password --docker-email=example@example.com

- ingress (k8s loadbalancer - 流量分配/port映射)

- minikube port榜定尚未完成 （防火？）

# Reference
---
1. https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
2. https://kubernetes.io/docs/tutorials/hello-minikube/
3. https://smcgown.com/blog/kubernetes/kubernetes-for-dummies/
4. https://spacelift.io/blog/kubernetes-imagepullbackoff
5. https://stackoverflow.com/questions/38979231/imagepullbackoff-local-repository-with-minikube
6. https://medium.com/andy-blog/kubernetes-%E9%82%A3%E4%BA%9B%E4%BA%8B-service-%E7%AF%87-d19d4c6e945f

7. terraform 可以支援網路服護自動化雲端資源分配
