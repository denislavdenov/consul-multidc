SERVER_COUNT = 3
CONSUL_VER = "1.7.2"
CT_VER = "0.19.5"
LOG_LEVEL = "debug" #The available log levels are "trace", "debug", "info", "warn", and "err". if empty - default is "info"
DOMAIN = "denislav"
TLS = true
VAULT = "1.0.2"


Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: false
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  
  end

  if TLS 
    config.vm.define "vault-server" do |vault|
      vault.vm.box = "denislavd/xenial64"
      vault.vm.hostname = "vault-server"
      vault.vm.provision :shell, path: "scripts/install_vault.sh", env: {"VAULT" => VAULT,"DOMAIN" => DOMAIN}
      vault.vm.network "private_network", ip: "10.10.46.11"
    end
  end

  ["sofia", "botevgrad" ].to_enum.with_index(1).each do |dcname, dc|

    
    (1..SERVER_COUNT).each do |i|
      
      config.vm.define "consul-server#{i}-#{dcname}" do |node|
        node.vm.box = "denislavd/xenial64"
        node.vm.hostname = "consul-server#{i}-#{dcname}"
        node.vm.provision :shell, path: "scripts/install_consul.sh", env: {"CONSUL_VER" => CONSUL_VER}
        node.vm.provision :shell, path: "scripts/start_consul.sh", env: {"SERVER_COUNT" => SERVER_COUNT,"LOG_LEVEL" => LOG_LEVEL,"DOMAIN" => DOMAIN,"DCS" => "#{dcname}","DC" => "#{dc}","TLS" => TLS}
        node.vm.provision :shell, path: "scripts/keyvalue.sh", env: {"I" => "#{dc}","TLS" => TLS}
        node.vm.network "private_network", ip: "10.#{dc}0.56.1#{i}"
      end
    end


    config.vm.define "client-nginx1-#{dcname}" do |nginx|
      nginx.vm.box = "denislavd/nginx64"
      nginx.vm.hostname = "client-nginx1-#{dcname}"
      nginx.vm.provision :shell, path: "scripts/install_consul.sh", env: {"CONSUL_VER" => CONSUL_VER}
      nginx.vm.provision :shell, path: "scripts/start_consul.sh", env: {"SERVER_COUNT" => SERVER_COUNT,"LOG_LEVEL" => LOG_LEVEL,"DOMAIN" => DOMAIN,"DCS" => "#{dcname}","DC" => "#{dc}","TLS" => TLS}
      nginx.vm.provision :shell, path: "scripts/consul-template.sh", env: {"CT_VER" => CT_VER}
      nginx.vm.provision :shell, path: "scripts/conf-dnsmasq.sh"
      nginx.vm.provision :shell, path: "scripts/check_nginx.sh", env: {"TLS" => TLS}
      nginx.vm.network "private_network", ip: "10.#{dc}0.66.11"
    end  

    # config.vm.define "client-nginx2-#{dcname}" do |nginx|
    #   nginx.vm.box = "denislavd/nginx64"
    #   nginx.vm.hostname = "client-nginx2-#{dcname}"
    #   nginx.vm.provision :shell, path: "scripts/install_consul.sh", env: {"CONSUL_VER" => CONSUL_VER}
    #   nginx.vm.provision :shell, path: "scripts/start_consul.sh", env: {"SERVER_COUNT" => SERVER_COUNT,"LOG_LEVEL" => LOG_LEVEL,"DOMAIN" => DOMAIN,"DCS" => "#{dcname}","DC" => "#{dc}","TLS" => TLS}
    #   nginx.vm.provision :shell, path: "scripts/consul-template.sh", env: {"CT_VER" => CT_VER}
    #   nginx.vm.provision :shell, path: "scripts/conf-dnsmasq.sh"
    #   nginx.vm.provision :shell, path: "scripts/check_nginx.sh", env: {"TLS" => TLS}
    #   nginx.vm.network "private_network", ip: "10.#{dc}0.66.12"
    # end 

  end
end