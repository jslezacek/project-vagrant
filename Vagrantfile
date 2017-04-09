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
    ci.vm.network "forwarded_port", guest: 80, host: 8083

    ci.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "ci"]
    end
  end

  config.vm.define "system" do |system|
    system.vm.box = "ubuntu/trusty64"
    system.vm.provision "provision_system", type: "shell", path: "provision/shell/bootstrap_system.sh"
    system.vm.network :private_network, ip: "10.10.10.10"

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
