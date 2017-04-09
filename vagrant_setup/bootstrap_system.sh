sudo apt-get update 
sudo apt-get -y install  openjdk-7-jre scala maven
# setup /etc/hosts
sudo hostname system 
sudo cat >> /etc/hosts <<EOF
10.10.10.100 ci
10.10.10.10 system
10.10.10.20 framework
EOF

