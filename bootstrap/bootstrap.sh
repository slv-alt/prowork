#!/bin/bash

kubespray_home_dir="/root"
cd ${kubespray_home_dir}
if ! [ -d ${kubespray_home_dir/}kubespray ]; then
git clone https://github.com/slv-alt/kubespray.git
fi
cd ${kubespray_home_dir}/kubespray
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
