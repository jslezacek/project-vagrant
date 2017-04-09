# install jenkins
JENKINS_JAR="/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar"


wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update 
sudo apt-get -y install jenkins git maven
sudo service jenkins start
sudo update-rc.d jenkins enable 2

echo -e "Initial admin pwd: \n"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo ""

#echo "Installing jenkins plugins"
#sudo java -jar $JENKINS_JAR -s http://127.0.0.1:8080/ install-plugin git
