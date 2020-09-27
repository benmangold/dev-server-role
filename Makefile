#!/usr/bin/env make

export TF_VAR_instance_name=dev_server_role_dev_env

init:
	cd terraform; terraform init;

apply:
	cd terraform; terraform apply;

destroy:
	cd terraform; terraform destroy;

connect:
	./scripts/connect-to-instance.sh

ansible:
	./scripts/ansible.sh
