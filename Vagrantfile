Vagrant.configure("2") do |config|
 config.vm.define "httpd" do |httpd|
 httpd.vm.box = "jaca1805/debian12" 
 httpd.vm.network "private_network", ip: "192.168.33.10"
 httpd.vm.provider "virtualbox" do |vb|
 vb.memory = "2048"
 vb.cpus = "2"
 end
 end
end 