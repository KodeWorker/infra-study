# Install nerdctl
wget https://github.com/containerd/nerdctl/releases/download/v2.0.3/nerdctl-2.0.3-linux-amd64.tar.gz
mkdir nerdctl-2.0.3-linux-amd64
tar -xvf nerdctl-2.0.3-linux-amd64.tar.gz -C nerdctl-2.0.3-linux-amd64
mv nerdctl-2.0.3-linux-amd64/nerdctl /usr/local/bin/
rm nerdctl-2.0.3-linux-amd64.tar.gz && rm -rf nerdctl-2.0.3-linux-amd64

# Install BuildKit
wget https://github.com/moby/buildkit/releases/download/v0.19.0/buildkit-v0.19.0.linux-amd64.tar.gz
mkdir buildkit-v0.19.0.linux-amd64
tar -xvf buildkit-v0.19.0.linux-amd64.tar.gz -C buildkit-v0.19.0.linux-amd64
mv buildkit-v0.19.0.linux-amd64/bin/* /usr/local/bin
rm buildkit-v0.19.0.linux-amd64.tar.gz && rm -rf buildkit-v0.19.0.linux-amd64

# Setup systemd service
cat > /etc/systemd/system/buildkit.socket <<EOF
[Unit]
Description=BuildKit
Documentation=https://github.com/moby/buildkit

[Socket]
ListenStream=%t/buildkit/buildkitd.sock

[Install]
WantedBy=sockets.target
EOF

cat > /etc/systemd/system/buildkit.service <<EOF
[Unit]
Description=BuildKit
Requires=buildkit.socket
After=buildkit.socketDocumentation=https://github.com/moby/buildkit

[Service]
ExecStart=/usr/local/bin/buildkitd --oci-worker=false --containerd-worker=true

[Install]
WantedBy=multi-user.target
EOF

# Restart buildkit
systemctl daemon-reload
systemctl enable buildkit
systemctl start buildkit