#!/usr/bin/env bash

TLS=${TLS}
# Check for nginx
which nginx || {
apt-get update -y
apt-get install nginx -y
}

export HN=$(hostname)
var2=$(hostname)
# Create script check

cat << EOF > /usr/local/bin/check_wel.sh
#!/usr/bin/env bash

curl 127.0.0.1:80 | grep "Welcome to"
EOF

chmod +x /usr/local/bin/check_wel.sh

# Register nginx in consul
cat << EOF > /etc/consul.d/web.json
{
    "service": {
        "name": "web",
        "tags": ["${var2}"],
        "port": 80
    },
    "checks": [
        {
            "id": "nginx_http_check",
            "name": "Check nginx1",
            "http": "http://127.0.0.1:80",
            "tls_skip_verify": false,
            "method": "GET",
            "interval": "10s",
            "timeout": "1s"
        },
        {
            "id": "nginx_tcp_check",
            "name": "TCP on port 80",
            "tcp": "127.0.0.1:80",
            "interval": "10s",
            "timeout": "1s"
        },
        {
            "id": "nginx_script_check",
            "name": "Welcome check",
            "args": ["/usr/local/bin/check_wel.sh", "-limit", "256MB"],
            "interval": "10s",
            "timeout": "1s"
        }
    ]
}
EOF

if [ ${TLS} = true ]; then
    consul-template -consul-ssl-key=/etc/tls/consul-agent-key.pem -consul-ssl-cert=/etc/tls/consul-agent.pem -consul-addr "https://127.0.0.1:8501" -consul-ssl-ca-path=/etc/tls/consul-agent-ca.pem -config /vagrant/config.hcl &
else
    consul-template -config /vagrant/config.hcl &

fi


sleep 1
if [ ${TLS} = true ]; then
    consul reload -ca-file=/etc/tls/consul-agent-ca.pem -client-cert=/etc/tls/consul-agent.pem -client-key=/etc/tls/consul-agent-key.pem -http-addr="https://127.0.0.1:8501"
else
    consul reload
fi