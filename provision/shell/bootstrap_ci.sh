# install jenkins
JENKINS_JAR="/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar"


wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update > /dev/null 2>&1
sudo apt-get -y install git maven openjdk-7-jdk jenkins curl > /dev/null 2>&1
sudo service jenkins start
sudo update-rc.d jenkins enable 2 > /dev/null 2>&1

# admin pwd for jenkins
#echo "Installing jenkins plugins"
#sudo java -jar $JENKINS_JAR -s http://127.0.0.1:8080/ install-plugin git

# setup git repository
echo "Setting up private git repo"
[[ $(id -u git 2> /dev/null) ]] || sudo adduser git --disabled-password --gecos ""
sudo -H -u git bash -c '[[ ! -d ~/.ssh ]] && mkdir ~/.ssh && chmod 700 ~/.ssh'
sudo -H -u git bash -c 'cat /tmp/vagrant_git.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
echo "You can run: git remote add vagrant ssh://git@localhost:2222"

# nexus setup
#[[ $(id -u nexus 2> /dev/null) ]] || sudo adduser nexus --disabled-password --gecos ""
#curl -L http://www.sonatype.org/downloads/nexus-latest-bundle.zip -o nexus-latest-bundle.zip

# setup /etc/hosts
sudo hostname ci
sudo bash -c 'cat >> /etc/hosts <<EOF
10.10.10.100 ci
10.10.10.10 system
10.10.10.20 framework
EOF'

# setup github repository
sudo -H -u jenkins bash -c 'cat /dev/zero | ssh-keygen -q -N "" -C "jenkins@vagrant_ci"' 2> /dev/null
echo -e "Add ssh public key to github: \n"
sudo -H -u jenkins bash -c 'cat ~/.ssh/id_rsa.pub'

echo -e "Initial admin pwd: \n"

sudo -H -u jenkins bash -c 'cat /var/lib/jenkins/secrets/initialAdminPassword' 2> /dev/null
echo -e "To jenkins admin pwd run:\nvagrant ssh ci -c 'sudo cat /var/lib/jenkins/secrets/initialAdminPassword'"
