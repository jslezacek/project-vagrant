# install jenkins

wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update 
sudo apt-get -y install jenkins
echo "Initial admin pwd: "
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo "Installing jenkins plugins"
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin <name>
