#!/bin/bash

sudo apt update
sudo apt upgrade -y

sudo apt install software-properties-common ansible expect -y

sudo apt autoremove -y

ssh-keygen -t rsa -C "m.marchand22@hotmail.com" -N "" -f ~/.ssh/id_rsa

 # ssh-copy-id vagrant@192.168.33.10