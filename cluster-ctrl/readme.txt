Для управления кластером копируем конфиг с модификацией IP-адреса с помощью скрипта:
cluster-ctrl.sh

### Установка k9s через pkgx:
Установка pkgx:
curl -Ssf https://pkgx.sh | sh
Установка и запуск k9s:
pkgx k9s

### Установка helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install helm
