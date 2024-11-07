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


 - Online Boutique by Google

Клонируем репозиторий для исследования
git clone --depth 1 --branch v0 https://github.com/GoogleCloudPlatform/microservices-demo.git

Пробная установка через helm
helm upgrade onlineboutique oci://us-docker.pkg.dev/online-boutique-ci/charts/onlineboutique --install --values val-butik.yaml --create-namespace -n onlineboutique

Делаем форк Online Boutique by Google в свой репозиторий
https://github.com/slv-alt/boutique.git

В вебинтерфйсе Argo создаем приложение - butik

Получаем данные для манифеста приложения butik для Argo
kubectl get Application butik -o yaml > app-butik-argo-getApp.yaml

На основе полученного файла создаем манифест - app-butik-argo.yaml

Проверка деплоя приложения Boutique через Argo
kubectl apply -f app-butik-argo.yaml -n argo


 - S3 хранилище - Minio

С сайта Minio забираем конфиг для развертывания в kubernetes
curl https://raw.githubusercontent.com/minio/docs/master/source/extra/examples/minio-dev.yaml -O

Применяем данный манифест
kubectl apply -f minio.yaml

В браузере переходим в веб-интерфейс по ссылке http://192.168.1.31:9090/browser и настраиваем корзины и доступ.
Креды minioadmin:minioadmin
Создаем корзины: chunks,ruler,admin


 - Monitoring

Добавляем Grafana’s chart репозиторий в Helm:
helm repo add grafana https://grafana.github.io/helm-charts

Проверяем список доступных:
helm repo list


 - Loki

Смотрим список доступных приложений grafana репозитория:
helm search repo grafana

Создаем файл "values" с полным списком значений для пакета grafana/loki
helm show values grafana/loki >val-loki.txt

Создаем файл val-loki.yaml

Установка
helm install --values val-loki.yaml loki grafana/loki -n monitoring


 - Promtail

Создаем файл "values" с полным списком значений для пакета promtail
helm show values grafana/promtail >val-prom.txt

Создаем файл val-prom.yaml

Устанавливаем Promtail
helm install --values val-prom.yaml promtail grafana/promtail -n monitoring

"""
 - Grafana

Создаем файл "values" с полным списком значений для пакета grafana
helm show values grafana/grafana >val-grafana.txt

Создаем файл val-grafana.yaml

Устанавливаем Grafana
helm install --values val-grafana.yaml grafana grafana/grafana
"""

 - Готовый стек мониторинга NodeExporter-Prometheus-Grafana

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo list
helm repo update
helm search repo prometheus-community
kubectl create namespace monitoring
helm install kube-prom-stack prometheus-community/kube-prometheus-stack --values val-kub-prom-stack.yaml -n monitoring

Креды в графану: admin:prom-operator

"""
Настройка просмотра логов в графане
Connections-Data sources-Add data source-Loki
  URL: (http://loki-gateway:80)
        http://loki-gateway.default.svc.cluster.local:80
       (http://NameService.NameSpace.svc.cluster.local:80)
  Save&test
Explore-Loki-Code-Label browser
"""
http://loki-gateway.default.svc.cluster.local:80


 - kubernetes-dashboard
https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

