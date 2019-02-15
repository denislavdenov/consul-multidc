#!/usr/bin/env bash

set -x
n=${I}
TLS=${TLS}


########################
#    Using REST API    #
########################

# Adding key/values
if [ ${TLS} = true ]; then

    if [ ${n} == 1 ]; then

        curl \
            --request PUT \
            --cacert /etc/tls/consul-agent-ca.pem \
            --data '
        <!DOCTYPE html>
        <html>
        <head>
        <title>Welcome to client-nginx1!</title>
        <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
        </style>
        </head>
        <body>
        <h1>Welcome to client-nginx1!</h1>
        <p><em>Thank you for using client-nginx1.</em></p>
        </body>
        </html>'  \
            https://127.0.0.1:8501/v1/kv/client-nginx1-sofia/site

    else
        if [ ${n} == 2 ]; then
            curl \
                --request PUT \
                --cacert /etc/tls/consul-agent-ca.pem \
                --data '
        <!DOCTYPE html>
        <html>
        <head>
        <title>Welcome to client-nginx2!</title>
        <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
        </style>
        </head>
        <body>
        <h1>Welcome to client-nginx2!</h1>
        <p><em>Thank you for using client-nginx2.</em></p>
        </body>
        </html>'  \
                https://127.0.0.1:8501/v1/kv/client-nginx1-botevgrad/site
        fi 
    fi
else
    if [ ${n} == 1 ]; then

        curl \
            --request PUT \
            --data '
        <!DOCTYPE html>
        <html>
        <head>
        <title>Welcome to client-nginx1!</title>
        <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
        </style>
        </head>
        <body>
        <h1>Welcome to client-nginx1!</h1>
        <p><em>Thank you for using client-nginx1.</em></p>
        </body>
        </html>'  \
            http://127.0.0.1:8500/v1/kv/client-nginx1-sofia/site

    else
        if [ ${n} == 2 ]; then
            curl \
                --request PUT \
                --data '
        <!DOCTYPE html>
        <html>
        <head>
        <title>Welcome to client-nginx2!</title>
        <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
        </style>
        </head>
        <body>
        <h1>Welcome to client-nginx2!</h1>
        <p><em>Thank you for using client-nginx2.</em></p>
        </body>
        </html>'  \
                http://127.0.0.1:8500/v1/kv/client-nginx1-botevgrad/site
        fi 
    fi

fi
set +x

