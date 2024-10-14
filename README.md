Клонируем репозиторий Google Online Boutique (далее магазин)
git clone --depth 1 --branch v0 https://github.com/GoogleCloudPlatform/microservices-demo.git

Установка магазина

helm upgrade onlineboutique oci://us-docker.pkg.dev/online-boutique-ci/charts/onlineboutique --install --values val-butik.yaml --create-namespace -n onlineboutique
