dev-server-role
=========

ephemeral ubuntu development environment configs

postgresql, docker, nodejs 12, oh-my-zsh

a role used by [benmangold/dev-server](https://github.com/benmangold/dev-server)

Role Variables
--------------

git_username: git-user
git_email: git-user@email.com

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }
