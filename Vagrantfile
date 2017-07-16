Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox"

  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.define "ci" do |ci|
    # setup git ssh keys
    ci.vm.provision "provision_ssh", type: "file", source: "provision/shell/vagrant_git.pub", destination: "/tmp/vagrant_git.pub"
    ci.vm.provision "provision_ci", type: "shell", path: "provision/shell/bootstrap_ci.sh", privileged: false
    #ci.vm.provision "shell", inline: "echo -e 'Jenkins admin pwd: \n'; sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

    ci.vm.network :private_network, ip: "10.10.10.100"
    ci.vm.network "forwarded_port", guest: 8080, host: 8082
    ci.vm.network "forwarded_port", guest: 80, host: 80
#    ci.vm.network "forwarded_port", guest: 2299, host: 2299
#    ci.vm.network "forwarded_port", guest: 8089, host: 8089

    ci.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--name", "ci"]
    end

#    ci.vm.provision "docker" do |d| 
#      d.pull_images "gitlab/gitlab-ce:latest"
#      d.run "gitlab/gitlab-ce:latest",
#        args: "-d -p 8089:80 -p 2299:22 --name gitlab --restart always --volume /srv/gitlab/config:/etc/gitlab"
#    end
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

    framework.vm.network :private_network, ip: "10.10.10.20"

    framework.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "framework"]
    end
  end

end
