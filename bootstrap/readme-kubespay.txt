
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

Установить новый
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml

Обновить кластер, например если изменить устанавливаемые компоненты в inventory/mycluster/group_vars/k8s_cluster/addons.yml
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root upgrade-cluster.yml

Прибить старый кластер
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root reset.yml

В процессе многочисленных развертываний кластера с какого-то момента процесс установки кластера стал завершаться ошибкой
на одной из нод Control Plane. Ошибка была вида:
The conditional check 'kubeadm_certificate_key is not defined' failed. The error was: An unhandled exception occurred while templating '{{ lookup('password', credentials_dir + '/kubeadm_certificate_key.creds length=64

Ошибка имела не постоянный характер и могла появиться на одной из нод или сразу нескольких, какие либо изменения мне
не помогали, пока я не нашел патч:
https://github.com/kubernetes-sigs/kubespray/pull/10523/files
Данный патч применен в моем форке репозитория Kuberspray.

Для MetalLB надо установить
kube_proxy_strict_arp: true
в файле
inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml

Для управления кластером с управляющей машины надо скопировать конфиг кубика и kubectl
cp inventory/mycluster/artifacts/admin.conf ~/.kube/config
cp inventory/mycluster/artifacts/kubectl /usr/local/sbin/

Или скопировать конфиг кубика например с node1:
scp 192.168.1.31:/root/.kube/config /root/.kube/
sed -i 's/127.0.0.1/192.168.1.31/' /root/.kube/config

