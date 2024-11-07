#!/bin/bash

# Для инфраструктурных нод добавляем taint:
kubectl taint nodes node1 node-role=infra:NoSchedule
kubectl taint nodes node2 node-role=infra:NoSchedule
kubectl taint nodes node3 node-role=infra:NoSchedule

# Для инфраструктурных нод добавляем метки:
kubectl label nodes node1 infra=true
kubectl label nodes node2 infra=true
kubectl label nodes node3 infra=true

# Для рабочих нод добавляем метки:
kubectl label nodes node4 work=true
kubectl label nodes node5 work=true

# Для S3 хранилища добавим метку на node5
kubectl label nodes node5 storage=true

