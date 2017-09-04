Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox"
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "ci" do |ci|
    # setup git ssh keys
    ci.vm.provision "provision_ssh", type: "file", source: "provision/shell/vagrant_git.pub", destination: "/tmp/vagrant_git.pub"
    ci.vm.provision "provision_ci", type: "shell", path: "provision/shell/bootstrap_ci.sh", privileged: false
    #ci.vm.provision "shell", inline: "echo -e 'Jenkins admin pwd: \n'; sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

    ci.vm.network :private_network, ip: "10.10.10.100"
    ci.vm.network "forwarded_port", guest: 8080, host: 8082
    ci.vm.network "forwarded_port", guest: 80, host: 80
    ci.vm.network "forwarded_port", guest: 8081, host: 8081

    ci.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--name", "ci"]
    end
    
# docker nexus3
    ci.vm.provision "docker" do |d| 
      d.pull_images "sonatype/nexus3:latest"
      d.run "sonatype/nexus3",
        args: "-d -p 8081:8081 -e JAVA_MAX_HEAP=756m"
    end
  end

  config.vm.define "system" do |system|
    system.vm.box = "ubuntu/trusty64"
    system.vm.provision "provision_system", type: "shell", path: "provision/shell/bootstrap_system.sh"

    system.vm.provision "docker" do |d| 
      d.pull_images "mariadb"
      d.run "mariadb",
        args: "-d -p 3306:3306 --name maria -e MYSQL_ROOT_PASSWORD=mypass"
    end

    system.vm.network :private_network, ip: "10.10.10.10"
    system.vm.network "forwarded_port", guest: 3306, host: 3306


    system.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "system"]
    end
  end

  config.vm.define "framework" do |framework|
    framework.vm.box = "ubuntu/trusty64"
    framework.vm.provision "provision_framework", type: "shell", path: "provision/shell/bootstrap_framework.sh"

    framework.vm.provision "docker" do |d|
      d.pull_images "spotify/kafka"
      d.run "spotify/kafka",
        args: "-d -p 2181:2181 -p 9092:9092 --env TOPICS=test --env ADVERTISED_PORT=9092 --env ADVERTISED_HOST=10.10.10.20"
    end

    framework.vm.network :private_network, ip: "10.10.10.20"
    framework.vm.network "forwarded_port", guest: 2181, host: 2181
    framework.vm.network "forwarded_port", guest: 9092, host: 9092

    framework.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--name", "framework"]
    end
  end
end
