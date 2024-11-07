
 - Argo
Добавляем argo chart репозиторий в Helm:
helm repo add argo https://argoproj.github.io/argo-helm

Проверяем список доступных репозиториев:
helm repo list

Смотрим список доступных чартов:
helm search repo argo

Создаем файл "values.txt" с полным списком значений для чарта argo/argo-cd
helm show values argo/argo-cd >val-argo-cd.txt

Создаем файл val-argo.yaml

Установка argo-cd
helm install argo-cd argo/argo-cd --values val-argo-cd.yaml --namespace argo --create-namespace
