# install jenkins
JENKINS_JAR="/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar"


wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update 
sudo apt-get -y install jenkins
sudo service jenkins start
sudo chkconfig jenkins on

echo "Initial admin pwd: "
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo "Installing jenkins plugins"
sudo java -jar $JENKINS_JAR -s http://127.0.0.1:8082/ install-plugin git
