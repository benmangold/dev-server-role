#! /bin/bash

##
## Use this script to run ansible on your instance after applying terraform
##
## Run via `make ansible`
## 
## This script requires $TF_VAR_instance_name to be exported in Makefile
##

if [[ -z "$TF_VAR_instance_name" ]]; then
    echo "Must provide TF_VAR_instance_name in environment" 1>&2
    echo "Run this script via `make connect`" 1>&2
    exit 1
fi

export PUBLIC_IP=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=running Name=tag:Name,Values=$TF_VAR_instance_name --region=us-east-2 | jq -r .Reservations[].Instances[].PublicIpAddress)

echo "$PUBLIC_IP" > "tests/inventory"

ansible-playbook -i ./tests/inventory --private-key ~/.ssh/lemur-pro.pem ./tests/test.yml
