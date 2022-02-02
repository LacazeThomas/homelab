Vagrant.configure("2") do |config|

    DEBIAN = "debian/buster64"
  
    if Vagrant.has_plugin?("vagrant-vbguest")
      config.vbguest.auto_update = false
    end
  
    config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end
  
    config.vm.define "space" do |subconfig|
      subconfig.vm.box = DEBIAN
      subconfig.vm.hostname = "space"
      subconfig.vm.network :private_network, ip: "192.168.56.10"
      subconfig.vm.synced_folder '.', '/vagrant', disabled: true
      config.vm.provision "ansible" do |ansible|
        ansible.playbook = "run.yml"
      end
    end


  end
  