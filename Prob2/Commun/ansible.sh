#!/bin/bash

# NewTech First Problematic
# 
# Install and configure ansible

sudo apt update
# sudo apt upgrade -y

# @TODO We are still installing expect even though we couldn't
# make it work. The objective is to make the addkey.sh automatic
sudo apt install python3-full python-is-python3 ansible expect -y

sudo apt autoremove -y

ssh-keygen -t rsa -C "andrew@ways2code.com" -N "" -f /home/vagrant/.ssh/id_rsa
sudo chown vagrant:vagrant /home/vagrant/.ssh/id_rsa*