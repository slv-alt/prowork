#!/bin/bash

cd ~
rm -r kubespray
git clone https://github.com/slv-alt/kubespray.git
cd kubespray
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
