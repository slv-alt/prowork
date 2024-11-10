#!/bin/bash

### Мониторинг

# Для мониторинга развернем S3 хранилище - Minio
# Создадим каталог на node5 для Minio - /
ansible-playbook -i ../ansible/inventory.yaml play-node5-mkdir-mnt-disk1-data.yaml

# Применяем манифест
kubectl apply -f minio.yaml

# В браузере переходим в веб-интерфейс по ссылке http://192.168.1.41:9090/browser и настраиваем корзины и доступ.
# Креды minioadmin:minioadmin
# Создаем корзины: chunks,ruler,admin
# Пользователя с правами RW: loki-user:12345678

sleep 60

# Создадим пространство имен для мониторига
kubectl apply -f ns-monitoring.yaml

# Добавляем Grafana’s chart репозиторий в Helm:
helm repo add grafana https://grafana.github.io/helm-charts

# Устанавливаем Loki
helm install loki grafana/loki --values val-loki.yaml -n monitoring

sleep 60

# Устанавливаем Promtail
helm install promtail grafana/promtail --values val-prom.yaml -n monitoring

sleep 60

# Устанавлимаем стек мониторинга
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install kube-prom-stack prometheus-community/kube-prometheus-stack --values val-kub-prom-stack.yaml -n monitoring

sleep 60

### ПО для деплоя
# Argo

# Добавляем argo chart репозиторий в Helm:
helm repo add argo https://argoproj.github.io/argo-helm

# Установка argo-cd
helm install argo-cd argo/argo-cd --values val-argo-cd.yaml --namespace argo --create-namespace

# Пароль для веб-интерфейса, пользователь admin
#kubectl -n argo get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
