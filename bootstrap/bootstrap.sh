#!/bin/bash

cd ~
git clone https://github.com/slv-alt/kubespray.git
cd kubespray
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
