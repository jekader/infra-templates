sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum -y install java-11-openjdk-headless git mock python3-pyyaml python3-pyxdg python3-six

cat << EOF > /etc/modprobe.d/nested.conf
options kvm-intel nested=y
EOF

useradd jenkins-staging -G mock
useradd jenkins -G mock
mkdir -p /home/{jenkins-staging,jenkins}/.ssh
chmod 700 /home/{jenkins-staging,jenkins}/.ssh

cat << EOF > /home/jenkins-staging/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcaW1eHhuFfPKgDcSir/D2/qZlBwMSSXUXZi4F8SOt0C6WFggRcZB6kjk73GyzkZ879Wlr97WITAPXaaEFSNnaa0TSfTpuElqhOipR/IEM9KYDDfYIIoABBebhn6kpBBQ81gd3L4+8Lv6xse6YBu4/HhfILBbUN20DVUYd9vGUc2y0c9RasJjotdg7+1iUzbT/dqPG1OX/S4M/qIF6wcygnedHt2KtPE+QosCACNdtshGHwngO9H+wXv9e/37WFwU6dRMESCxrBAM+gxO8+0nLANW28GDr5EGYNs4gy5reyTKS8qqswHqK4h5bi7Ad1BSx29DUa8wEOUO/TV2eiUsz
EOF
cat << EOF > /home/jenkins/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsZ34L+B3YzL7a6zCrJB41r/IqM/s1ILXyjslApSrtquQRtUcbeoE7kS4PdyhO2U4Pu91EzYMPWc7JVnQirwKX5ksXwxZn/Y8f5KzKm5IfPRJfX6sBWS9eGRsyLj5JQjHiVYiBSsACidIr8zc3lJo/nxhp18wj5Ao4h5rhqpw/P+u53/NQ0KvRQtrBFxgWR9JM6KpcjB6rVzm1OBJQPe9aSm97NLh3ijXxYNrbIpXt/YoyByP36QVlcM+L9idFAWY2TkCX5mWclCJJeCint9+SxD0gRW3/tgNWwxx7nkFDGdl/WKhgT0JjmCVFqSG/cGNYYMX+A25zKqqD1SqPNFhx
EOF

cat << EOF > /etc/sudoers.d/jenkins-staging
Defaults:jenkins-staging    !requiretty
jenkins-staging ALL = (ALL) NOPASSWD : ALL
EOF
cat << EOF > /etc/sudoers.d/jenkins
Defaults:jenkins    !requiretty
jenkins ALL = (ALL) NOPASSWD : ALL
EOF

chmod 0640 /etc/sudoers.d/{jenkins-staging,jenkins}

chown -R jenkins-staging:jenkins-staging /home/jenkins-staging
chown -R jenkins:jenkins /home/jenkins
chmod 600 /home/{jenkins-staging,jenkins}/.ssh/authorized_keys
alternatives --set python /usr/bin/python3

