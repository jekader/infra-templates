yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
pkg_list=(epel-release java-1.8.0-openjdk-headless kernel gdbm glibc sssd systemd git mock PyYAML python2-pyxdg python2-six \
python-paramiko PyYAML python2-pyxdg python-jinja2 python-py python-six python36-PyYAML python36-pyxdg rpm-libs haveged libvirt \
qemu-kvm-rhev nosync libselinux-utils kmod)

yum -y install "${pkg_list[@]}"

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

cat << EOF > /etc/security/limits.d/10-nofile.conf
* soft nofile 64000
* hard nofile 96000
EOF

cat << EOF > /etc/selinux/config
SELINUX=permissive
SELINUXTYPE=targeted
EOF

chmod 0644 /etc/modprobe.d/nested.conf /etc/security/limits.d/10-nofile.conf /etc/selinux/config

#systemctl start ovirt-guest-agent
#systemctl enable ovirt-guest-agent
systemctl mask cloud-init-local
systemctl mask cloud-init
#rm -rf /etc/hostname
