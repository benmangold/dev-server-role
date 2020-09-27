dev-server-role
=========

ephemeral ubuntu development environment configs

postgresql, docker, nodejs 12, oh-my-zsh

a role used by [benmangold/dev-server](https://github.com/benmangold/dev-server)

Makefile
--------

Before running `make` commands:

Export AWS Credentials

Add ssh key locally

Optionally, set a required Terraform variable with your AWS key name

Example setup:

```bash
# Example command, exporting creds from LastPass notes `access-key-id` and `secret-access-key` with jq:
export AWS_ACCESS_KEY_ID=$(lpass show access-key-id --json | jq -r '.[0].note')
export AWS_SECRET_ACCESS_KEY=$(lpass show secret-access-key --json | jq -r '.[0].note')

# Set up ssh key for access
ssh-add /path/to/my-key-name.pem

# Optionally, export AWS key name for ssh as Terraform var:
export TF_VAR_key_name=my-key-name

```

```bash
make init # initialize terraform

make apply # create ephemeral EC2 instance for role dev. 

# NOTE: wait 30s after apply before running ansible
make ansible # run ansible role tasks against EC2

make connect # connect to EC2 via ssh

make destroy # destroy EC2

```

Role Variables
--------------

```text
git_username: git-user # username for git config

git_email: email@email.com # email for git config

```

Example Playbook
----------------

```fs
/ansible
  playbook.yml
  requirements.yml
  variables.yml
 
```

playbook.yml
```ansible
---

- name: Provision Ubuntu
  hosts: all
  gather_facts: yes
  become: yes

  vars_files:
    - ./variables.yml

  tasks:
    - name: Dev Env Install
      import_role:
        name: dev-server-role

```

requirements.yml
```ansible
---

- src: https://github.com/benmangold/dev-server-role
  version: v0.0.1

```

variables.yml
```ansible
---

git_username: git-username
git_email: email@email.com

```