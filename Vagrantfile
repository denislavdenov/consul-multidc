SERVER_COUNT = 1
CONSUL_VER = "1.4.2"
CT_VER = "0.19.5"
LOG_LEVEL = "debug" #The available log levels are "trace", "debug", "info", "warn", and "err". if empty - default is "info"
DOMAIN = "denislav"


Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: false
  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 2
  
  end
  ["sofia", "botevgrad"].to_enum.with_index(1).each do |dcname, dc|

    
    (1..SERVER_COUNT).each do |i|
      
      config.vm.define "consul-server#{i}-#{dcname}" do |node|
        node.vm.box = "denislavd/xenial64"
        node.vm.hostname = "consul-server#{i}-#{dcname}"
        node.vm.provision :shell, path: "scripts/install_consul.sh", env: {"CONSUL_VER" => CONSUL_VER}
        node.vm.provision :shell, path: "scripts/start_consul.sh", env: {"SERVER_COUNT" => SERVER_COUNT,"LOG_LEVEL" => LOG_LEVEL,"DOMAIN" => DOMAIN,"DCS" => "#{dcname}","DC" => "#{dc}"}
        node.vm.provision :shell, path: "scripts/keyvalue.sh", env: {"I" => "#{dc}"}
        node.vm.network "private_network", ip: "10.#{dc}0.56.1#{i}"
        node.vm.network "forwarded_port", guest: 8500, host: 8500 + dc
      end
    end

    config.vm.define "client-nginx1-#{dcname}" do |nginx|
      nginx.vm.box = "denislavd/nginx64"
      nginx.vm.hostname = "client-nginx1-#{dcname}"
      nginx.vm.provision :shell, path: "scripts/install_consul.sh", env: {"CONSUL_VER" => CONSUL_VER}
      nginx.vm.provision :shell, path: "scripts/start_consul.sh", env: {"SERVER_COUNT" => SERVER_COUNT,"LOG_LEVEL" => LOG_LEVEL,"DOMAIN" => DOMAIN,"DCS" => "#{dcname}","DC" => "#{dc}"}
      nginx.vm.provision :shell, path: "scripts/consul-template.sh", env: {"CT_VER" => CT_VER}
      nginx.vm.provision :shell, path: "scripts/conf-dnsmasq.sh"
      nginx.vm.provision :shell, path: "scripts/check_nginx.sh"
      nginx.vm.network "private_network", ip: "10.#{dc}0.66.11"
      nginx.vm.network "forwarded_port", guest: 80, host: 8080 + dc
    end  

  end
end