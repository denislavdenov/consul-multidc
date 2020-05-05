#!/usr/bin/env bash

CT_VER=${CT_VER}

which consul-template || {
if [ -f "/vagrant/pkg/consul-template_${CT_VER}_linux_amd64.zip" ]; then
		echo "Found Consul in /vagrant/pkg"
else
    echo "Fetching consul-template version ${CT_VER} ..."
    mkdir -p /vagrant/pkg/
    curl -s https://releases.hashicorp.com/consul-template/${CT_VER}/consul-template_${CT_VER}_linux_amd64.zip -o /vagrant/pkg/consul-template_${CT_VER}_linux_amd64.zip
    if [ $? -ne 0 ]; then
        echo "Download failed! Exiting."
        exit 1
    fi
fi


echo "Installing consul-template version ${CT_VER} ..."
pushd /tmp
unzip /vagrant/pkg/consul-template_${CT_VER}_linux_amd64.zip 
sudo chmod +x consul-template
mv consul-template /usr/local/bin/consul-template

}