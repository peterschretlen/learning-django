# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "rudolfochrist/ubuntu-desktop"
  config.vm.network "forwarded_port", guest: 8888, host: 8080
  config.vm.network "forwarded_port", guest: 5432, host: 15432
  config.vm.hostname = "learn-django"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
    vb.name = "learn-django"
  
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus = 2
  end

  config.vm.provision :shell, path: "provision.sh"

end
