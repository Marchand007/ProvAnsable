#!/bin/bash

# ansible-playbook -i /home/vagrant/config/ansible/hosts /home/vagrant/config/clienttest11/upgrade.yml
ansible-playbook -i /home/vagrant/config/hosts /home/vagrant/config/clienttest11/install-static.yml
ansible-playbook -i /home/vagrant/config/hosts /home/vagrant/config/clienttest11/install-httpd.yml
ansible-playbook -i /home/vagrant/config/hosts /home/vagrant/config/clienttest11/install-postgresql.yml
