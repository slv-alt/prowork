
apt-get install pip

https://github.com/kubernetes-sigs/kubespray
###git clone https://github.com/kubernetes-sigs/kubespray.git
Мой форк kubespray
git clone https://github.com/slv-alt/kubespray.git
cd kubespray
pip3 install -r contrib/inventory_builder/requirements.txt --break-system-packages
pip3 install -r requirements.txt --break-system-packages
cp -rfp inventory/sample inventory/mycluster
declare -a IPS=(192.168.1.31 192.168.1.32 192.168.1.33 192.168.1.34 192.168.1.35)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

Меняем, если нужно, настройки кластера
inventory/mycluster/group_vars/k8s_cluster/addons.yaml

Прибить старый кластер
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root reset.yml

Установить новый
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml

Обновить кластер, например если изменить устанавливаемые компоненты в inventory/mycluster/group_vars/k8s_cluster/addons.yml
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root upgrade-cluster.yml

Для MetalLB надо установить
kube_proxy_strict_arp: true
в файле
inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml

