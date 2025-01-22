# Install container runtime: containerd
apt-get update
apt-get install -y containerd

containerd config default | tee /etc/containerd/config.toml >/dev/null 2>&1
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

# Install kubeadm, kubelet, kubectl
apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Enable kubelet service
systemctl enable --now kubelet

# Configure cgroup driver
stat -fc %T /sys/fs/cgroup/ # cggroup2fs -> v2

# Deploy control plane

# configure crictl
cat > /etc/crictl.yaml <<EOF
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
debug: false
EOF

# remove local kubeconfig
rm -rf $HOME/.kube
rm /etc/cni/net.d/*
rm /etc/sysctl.d/kubernetes.conf
rm /etc/modules-load.d/containerd.conf
rm tigera-operator.yaml custom-resources.yaml

# kernel parameters
tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

tee /etc/sysctl.d/kubernetes.conf <<EOT
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOT

export PATH=$PATH:/usr/sbin
sysctl --system

# disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

ip=$(/sbin/ip -o -4 addr list wlo1 | awk '{print $4}' | cut -d/ -f1)

kubeadm init \
      --control-plane-endpoint $ip \
      --pod-network-cidr 192.168.0.0/16 \
      --cri-socket unix:///var/run/containerd/containerd.sock \
      --v 5 \
      --ignore-preflight-errors=all

# Set up local kubeconfig for single-node cluster
# export KUBECONFIG=/etc/kubernetes/admin.conf
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico
curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml -o tigera-operator.yaml
kubectl create -f tigera-operator.yaml

curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml -o custom-resources.yaml
kubectl create -f custom-resources.yaml

# # Check Calico pods
# watch kubectl get pods -n calico-system

# Untaint control plane node
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
# kubectl taint nodes kelvinwu-k8s-lab node-role.kubernetes.io/control-plane:NoSchedule