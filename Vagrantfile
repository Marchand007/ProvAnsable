  Vagrant.configure("2") do |config|
    config.vm.define "ansible" do |ansible|
      ansible.vm.box = "jaca1805/debian12" 
      ansible.vm.network "private_network", ip: "192.168.33.5"
      ansible.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = "2"
      end
      ansible.vm.provision "shell", path: "httpd.sh"
      config.vm.synced_folder "/config", "/home/vagrant/config"
    end
  

 # config.vm.define "bd" do |bd|
 #   bd.vm.box = "jaca1805/debian12"
 #   bd.vm.network "private_network", ip: "192.168.33.20"
 #   bd.vm.provider "virtualbox" do |vb|
 #     vb.memory = "2048"
 #     vb.cpus = "2"
 #   end
 #   bd.vm.provision "shell", path: "bd.sh"
 # end
end
