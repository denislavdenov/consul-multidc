#!/usr/bin/env bash
set -x
sudo systemctl stop consul
sleep 5
sudo systemctl status consul
DOMAIN=${DOMAIN}
DCNAME=${DCS}
DC=${DC}
var2=$(hostname)
mkdir -p /vagrant/logs
mkdir -p /etc/consul.d


# Starting consul
killall consul

LOG_LEVEL=${LOG_LEVEL}
if [ -z "${LOG_LEVEL}" ]; then
    LOG_LEVEL="info"
fi

if [ -d /vagrant ]; then
  mkdir /vagrant/logs
  LOG="/vagrant/logs/${var2}.log"
else
  LOG="vault.log"
fi

IP=$(hostname -I | cut -f2 -d' ')

sudo useradd --system --home /etc/consul.d --shell /bin/false consul
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod -R 755 /etc/consul.d/
sudo mkdir --parents /tmp/consul
sudo chown --recursive consul:consul /tmp/consul
mkdir -p /tmp/consul_logs/
sudo chown --recursive consul:consul /tmp/consul_logs/

cat << EOF > /etc/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target

[Service]
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/local/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536


[Install]
WantedBy=multi-user.target

EOF



if [[ "${var2}" =~ "consul-server" ]]; then
    killall consul
    
    
    SERVER_COUNT=${SERVER_COUNT}
    echo $SERVER_COUNT
    if [[ "${var2}" =~ "sofia" ]]; then
    #cp /vagrant/config_${DCNAME}.json /etc/consul.d/config_${DCNAME}.json
    cat << EOF > /etc/consul.d/config_${DCNAME}.json
    
    {
        
        "server": true,
        "node_name": "${var2}",
        "bind_addr": "${IP}",
        "client_addr": "0.0.0.0",
        "bootstrap_expect": ${SERVER_COUNT},
        "retry_join": ["10.10.56.11"],
        "retry_join_wan": ["10.20.56.11"],
        "log_level": "${LOG_LEVEL}",
        "data_dir": "/tmp/consul",
        "enable_script_checks": true,
        "domain": "${DOMAIN}",
        "datacenter": "${DCNAME}",
        "ui": true,
        "disable_remote_exec": true

    }

EOF
    fi

    if [[ "${var2}" =~ "botevgrad" ]]; then
    #cp /vagrant/config_${DCNAME}.json /etc/consul.d/config_${DCNAME}.json
    cat << EOF > /etc/consul.d/config_${DCNAME}.json
    
    {
        
        "server": true,
        "node_name": "${var2}",
        "bind_addr": "${IP}",
        "client_addr": "0.0.0.0",
        "bootstrap_expect": ${SERVER_COUNT},
        "retry_join": ["10.20.56.11"],
        "retry_join_wan": ["10.10.56.11"],
        "log_level": "${LOG_LEVEL}",
        "data_dir": "/tmp/consul",
        "enable_script_checks": true,
        "domain": "${DOMAIN}",
        "datacenter": "${DCNAME}",
        "ui": true,
        "disable_remote_exec": true

    }

EOF
    fi


    sleep 1
    sudo systemctl enable consul
    sudo systemctl start consul
    journalctl -f -u consul.service > /vagrant/logs/${var2}.log &
    sleep 5
    sudo systemctl status consul

else
    if [[ "${var2}" =~ "client" ]]; then
        killall consul
       
        cat << EOF > /etc/consul.d/consul_client.json

        {
            "node_name": "${var2}",
            "bind_addr": "${IP}",
            "client_addr": "0.0.0.0",
            "retry_join": ["10.${DC}0.56.11"],
            "log_level": "${LOG_LEVEL}",
            "data_dir": "/tmp/consul",
            "enable_script_checks": true,
            "domain": "${DOMAIN}",
            "datacenter": "${DCNAME}",
            "ui": true,
            "disable_remote_exec": true
        }

EOF
    fi

    sleep 1

    sudo systemctl enable consul
    sudo systemctl start consul
    journalctl -f -u consul.service > /vagrant/logs/${var2}.log &
    sleep 5
    sudo systemctl status consul
    
fi


sleep 5
consul members
consul members -wan
set +x