sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum -y install java-11-openjdk-headless git mock python3-pyyaml python3-pyxdg python3-six

sudo tee -a /etc/modprobe.d/nested.conf > /dev/null <<EOF
options kvm-intel nested=y
EOF

# jenkins-staging user only
sudo useradd jenkins-staging -G mock
sudo mkdir -p /home/jenkins-staging/.ssh
sudo chmod 700 /home/jenkins-staging/.ssh

sudo tee -a /home/jenkins-staging/.ssh/authorized_keys > /dev/null <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcaW1eHhuFfPKgDcSir/D2/qZlBwMSSXUXZi4F8SOt0C6WFggRcZB6kjk73GyzkZ879Wlr97WITAPXaaEFSNnaa0TSfTpuElqhOipR/IEM9KYDDfYIIoABBebhn6kpBBQ81gd3L4+8Lv6xse6YBu4/HhfILBbUN20DVUYd9vGUc2y0c9RasJjotdg7+1iUzbT/dqPG1OX/S4M/qIF6wcygnedHt2KtPE+QosCACNdtshGHwngO9H+wXv9e/37WFwU6dRMESCxrBAM+gxO8+0nLANW28GDr5EGYNs4gy5reyTKS8qqswHqK4h5bi7Ad1BSx29DUa8wEOUO/TV2eiUsz
EOF


sudo chown -R jenkins-staging:jenkins-staging /home/jenkins/.ssh/authorized_keys
sudo chmod 600 /home/jenkins-staging/.ssh/authorized_keys
sudo alternatives --set python /usr/bin/python3
