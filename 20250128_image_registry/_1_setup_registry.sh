kubectl create namespace harbor

# wget https://github.com/goharbor/harbor/releases/download/v2.12.2/harbor-offline-installer-v2.12.2.tgz
# tar xvzf harbor-offline-installer*.tgz
# cd harbor
# cp harbor.yml.tmpl harbor.yml

# Install Helm
# wget https://get.helm.sh/helm-v3.17.0-linux-amd64.tar.gz
# tar -zxvf helm-v3.17.0-linux-amd64.tar.gz
# mv linux-amd64/helm /usr/local/bin/helm
# rm -rf linux-amd64
# rm helm-v3.17.0-linux-amd64.tar.gz

# Add Harbor Helm repository
helm repo add harbor https://helm.goharbor.io
helm repo update

# Create SSL Certs
openssl req -newkey rsa:4096 -nodes -sha256 -keyout ca.key -x509 -days 365 -out ca.crt -subj "/C=US/ST=CA/L=San Francisco/O=Harbor/CN=harbor-ca"
kubectl create secret tls harbor-cert --key ca.key --cert ca.crt -n harbor

# Deploy Harbor with custom values
helm install harbor harbor/harbor --namespace harbor -f values.yaml
helm status harbor -n harbor
