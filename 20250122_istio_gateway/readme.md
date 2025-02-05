## Install Istio and Gateway API demo
---

1. install istio according to official web site (do not clean up for the samples below)

2. deploy Bookinfo sample application
    - kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/bookinfo/platform/kube/bookinfo.yaml
    - kubectl get svc
    - kubectl get pod # wait a while for PodInitializing (2-3m on single-node)

3. validate the app deployment
    - kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
    - <title>Simple Bookstore App</title> # expected result

4. create gateway for sample application
    - kubectl apply -f istio-1.24.2/samples/bookinfo/gateway-api/bookinfo-gateway.yaml

5. change service type to ClusterIP by an annotating the gateway
    - kubectl annotate gateway bookinfo-gateway networking.istio.io/service-type=ClusterIP --namespace=default

6. check gateway status
    - kubectl get gateway

    ```
    NAME               CLASS   ADDRESS                                            PROGRAMMED   AGE
    bookinfo-gateway   istio   bookinfo-gateway-istio.default.svc.cluster.local   True         4m42s
    ```

7. access the application
    - kubectl port-forward svc/bookinfo-gateway-istio 8080:80
    - go to http://localhost:8080/productpage

8. view the dashboard
    - kubectl apply -f istio-1.24.2/samples/addons
    - kubectl rollout status deployment/kiali -n istio-system # 檢視pod滾動升級狀態

9. access kiali dashboard
    - istioctl dashboard kiali
    - for i in $(seq 1 100); do curl -s -o /dev/null "http://localhost:8080/productpage"; done # fake traffic

10. cleanup samples
    kubectl delete -f istio-1.24.2/samples/addons
    kubectl delete -f istio-1.24.2/samples/bookinfo/gateway-api/bookinfo-gateway.yaml
    kubectl delete -f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/bookinfo/platform/kube/bookinfo.yaml
    see images and rm: crictl image ls (specify tag)


- git remote set-url origin https://<my-personal-token>@github.com/KodeWorker/infra-study.git
- check selected repo and content permission (RW)

## Reference
1. https://istio.io/latest/docs/setup/getting-started/
2. https://stackoverflow.com/questions/68833701/how-do-i-set-up-my-local-git-repo-to-use-the-new-personal-access-token-i-just-cr
