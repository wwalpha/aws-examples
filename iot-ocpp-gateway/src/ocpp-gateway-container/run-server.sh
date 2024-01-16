#!/bin/bash
echo "$IOT_AMAZON_ROOT_CA" > /etc/iot-certificates/AmazonRootCA1.pem
echo "$IOT_GATEWAY_PUBLIC_KEY" > /etc/iot-certificates/iot.pub
echo "$IOT_GATEWAY_PRIVATE_KEY" > /etc/iot-certificates/iot.key
echo "$IOT_GATEWAY_CERTIFICATE" > /etc/iot-certificates/iot.pem
echo "Successfully set IOT certificates"

ls /etc/iot-certificates

echo "Starting the gateway server"
cd /opt/ocpp-gateway
source bin/activate
exec python3.11 server.py
