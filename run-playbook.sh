#!/usr/bin/bash

echo "This will get all memebrs in a load-balancer and run the same playbook to all"
echo "Param 1: $1"
echo "Param 2: $2"

export LOAD_BALANCER_ID=$1
export CLOUDCLI_PLAYBOOK_PATH=$2
export SSC_CLOUD_API_KEY=$3

export EXISTING_LB_POOL_JSON_FILE=existing_lb.json

echo "LOAD_BALANCER_ID: ${LOAD_BALANCER_ID}"
echo "Platbook Path: ${CLOUDCLI_PLAYBOOK_PATH}"
if [ -z ${LOAD_BALANCER_ID} ]
then
    echo "LOAD_BALANCER_ID is not set."
    exit 1
fi



echo "-------------------------------- Hot Deploy ----------------------------------------"

cloudcli loadbalancer poolmembers get -l ${LOAD_BALANCER_ID} --json > ${EXISTING_LB_POOL_JSON_FILE}
cat ${EXISTING_LB_POOL_JSON_FILE}

for HOST_IP in $(jq -r '.[].instance.ip'  ${EXISTING_LB_POOL_JSON_FILE} ); do
    echo "HOST_IP: ${HOST_IP}"
    echo "Run playbook................."
    cloudcli bolt pipeline --host-ips ${HOST_IP}
    echo "------------------------------------------------------------------------"
done
