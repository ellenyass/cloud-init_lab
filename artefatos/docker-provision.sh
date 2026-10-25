#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y cloud-init curl udev

mkdir -p /var/lib/cloud/seed/nocloud
install -m 0644 /tmp/user-data /var/lib/cloud/seed/nocloud/user-data
cat > /var/lib/cloud/seed/nocloud/meta-data <<'EOF'
instance-id: devops-lab-001
local-hostname: servidor-devops
EOF

cat > /etc/cloud/cloud.cfg.d/99-nocloud.cfg <<'EOF'
datasource:
  NoCloud:
    seedfrom: file:///var/lib/cloud/seed/nocloud/
EOF

cloud-init clean --logs

cloud-init init --local
cloud-init init
cloud-init modules --mode=config
cloud-init modules --mode=final

bash /tmp/verificar-cloud-init.sh
