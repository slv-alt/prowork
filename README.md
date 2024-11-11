# Проектная работа

## Подготовка инфраструктурной платформы для демо-приложения Online Boutique by Google

# Общее описание

В данной работе будем реализовывать платформу для работы приложения на kubernetes self-hosted на основе виртуальных машин.
Для реализации проекта было развернуто 6 виртуальных машин на ОС Debian/Ubuntu:

1. Одна управляющая машина (mgm). Данная машина предоставляет:
  - консоль управления кластером с установленными kubectl, k9s, helm, ansible, kubespray
  - сервер Gitlab и gitlab-runner для реализации pipeline развертывания платформы, средствами ansible и скриптами bash
2. Пять нод (node1-5):
  - node1-3 - Control Plane Nodes, управляющие/инфраструктурные ноды с сервисами мониторинга и логирования
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





