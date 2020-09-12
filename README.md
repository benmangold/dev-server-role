dev-server-role
=========

ephemeral ubuntu development environment configs

postgresql, docker, nodejs 12, oh-my-zsh

a role used by [benmangold/dev-server](https://github.com/benmangold/dev-server)

Role Variables
--------------

git_username: git-user # username for git config

git_email: email@email.com # email for git config

Example Playbook
----------------

```
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
```absible
---

git_username: git-username
git_email: email@email.com

```