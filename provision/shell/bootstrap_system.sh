sudo apt-get update > /dev/null 2>&1
sudo add-apt-repository -y ppa:openjdk-r/ppa > /dev/null 2>&1
sudo apt-get -y install  openjdk-8-jdk scala maven > /dev/null 2>&1
# setup /etc/hosts
sudo hostname system 
sudo cat >> /etc/hosts <<EOF
10.10.10.100 ci
10.10.10.10 system
10.10.10.20 framework
EOF

