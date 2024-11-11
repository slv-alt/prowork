# Проектная работа

## Подготовка инфраструктурной платформы для демо-приложения Online Boutique by Google

# Общее описание

В данной работе будем реализовывать платформу для работы приложения на kubernetes self-hosted на основе виртуальных машин.
Для реализации проекта было развернуто 6 виртуальных машин на ОС Debian/Ubuntu:

1. Одна управляющая машина (mgm). Данная машина предоставляет:
  - консоль управления кластером с установленными kubectl, k9s, helm, ansible, kubespray
  - сервер Gitlab и gitlab-runner для реализации pipeline развертывания платформы, средствами ansible и скриптами bash
2. Пять нод (node1-5):
  - node1-3 - Control Plane Nodes, управляющие/инфраструктурные ноды с сервисами мониторинга, логирования и доставки приложения
  - node4-5 - Worker Nodes, рабочие ноды для функционирования приложения и хранилища

# Управляющая машина

## Установка и настройка компонентов

### Установка k9s через pkgx

Установка pkgx
```sh
curl -Ssf https://pkgx.sh | sh
```
Установка и запуск k9s
```sh
pkgx k9s
```

### Установка helm
```sh
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install helm
```
### Kubespray и Ansible
Для процедуры bootstrap кластера выбрано программное обеспечение kubespray:
https://github.com/kubernetes-sigs/kubespray

Для обеспечения стабильности и хранения настроек нашего кластера был сделан форк:
https://github.com/slv-alt/kubespray.git

Настройка kubespray, установка ansible  
Установка pip:
```sh
apt-get install pip  
```
Клонируем форк:
```sh
git clone https://github.com/slv-alt/kubespray.git
```
Устанавливаем зависимости, ansible
```sh
cd kubespray
pip3 install -r requirements.txt --break-system-packages
```
Делаем копию конфигурационного каталога
```sh
cp -rfp inventory/sample inventory/mycluster
```
Объявляем список IP-адресов наших нод, формируем файл hosts.yaml
```sh
declare -a IPS=(192.168.1.31 192.168.1.32 192.168.1.33 192.168.1.34 192.168.1.35)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```
Меняем настройки кластера
  - inventory/mycluster/group_vars/k8s_cluster/addons.yaml
     - Установка Helm: helm_enabled: false -> true
     - Метрики: metrics_server_enabled: false -> true
     - Провижининг LocalPath и LocalVolume:
         - local_path_provisioner_enabled: false -> true
         - local_volume_provisioner_enabled: false -> true
     - Плагины: krew_enabled: false -> true
  - inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
     - Сетевой плагин: kube_network_plugin: flannel
     - Настройка, необходимая для работы MetalLB: kube_proxy_strict_arp: true
  - inventory/mycluster/group_vars/k8s_cluster/k8s-net-flannel.yml
      - flannel_interface_regexp: '192\\.168\\.1\\.\\d{1,3}'
      - flannel_backend_type: "host-gw"

Развернуть новый кластер
```sh
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
```

Обновить кластер, например если изменить устанавливаемые компоненты в inventory/mycluster/group_vars/k8s_cluster/addons.yml
```sh
inventory/mycluster/group_vars/k8s_cluster/addons.yml
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root upgrade-cluster.yml
```

Сброс (удаление) кластера
```sh
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root reset.yml
```
В процессе многочисленных развертываний кластера, с какого-то момента процесс установки кластера стал завершаться ошибкой
на одной из нод Control Plane. Ошибка была вида:  
The conditional check 'kubeadm_certificate_key is not defined' failed. The error was: An unhandled exception occurred while templating '{{ lookup('password', credentials_dir + '/kubeadm_certificate_key.creds length=64

Ошибка имела не постоянный характер и могла появиться на одной из нод или сразу нескольких, какие либо изменения мне
не помогали, пока не был найден патч:
https://github.com/kubernetes-sigs/kubespray/pull/10523/files

Данный патч применен в моем форке репозитория Kuberspray: https://github.com/slv-alt/kubespray/blob/master/roles/kubernetes/control-plane/tasks/kubeadm-setup.yml

Bootstrap кластера автоматизирован скриптом:  https://github.com/slv-alt/prowork/blob/main/bootstrap/bootstrap.sh  
Аналогичние сценарий реализован в pipeline этапе bootstrap.  
В этой же папке находятся конфигурационные файла kubespray, которые были изменены в данном проекте.

Также для управления нодами предусмотрены несколько вспомогательных плейбуков в каталоге:  
https://github.com/slv-alt/prowork/tree/main/ansible

Например, перезагрузить все ноды:  
```sh
ansible-playbook -i inventory.yaml play-reboot.yaml
```

## Gitlab
Каталог с конфигурациями и скриптами:  
https://github.com/slv-alt/prowork/tree/main/gitlab

### Gitlab-server
Gitlab server будем устанавливать через Docker.

### Установка Docker
```sh
apt-get update
apt-get install ca-certificates curl gnupg
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Был создан docker-compose.yml. Перед стартом запустить скрипт подготовки необходимых каталогов:
gitlab_docker_prepare.sh  
Запуск Gitlab:
```sh
docker compose up -d
```

### Gitlab-runner
Gitlab-runner будем устанавливать напосредственно в ОС управляющей машины:
```sh
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
apt install gitlab-runner
```

### Настройка Gitlab
Учетные данные для входа в веб-интерфейс Gitlab получаем в выводе после запуска скрипта:
```sh
get_pasword.sh
```
Меняем учетные данные на:
root:Password1@  
Создаем проект "otus". В этом проекте создаем Pipeline:
gitlab-ci.yml

Далее регистрируем Runner для нашего Pipeline. Теперь можно приступать к созданию pipeline.




