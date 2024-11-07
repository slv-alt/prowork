### Установка Gitlab

Gitlab будем устанавливать через Docker.
Был создан docker-compose.yml. Перед запуском запустить скрипт подготовки необходимых каталогов:
gitlab_docker_prepare.sh
Запуск Gitlab:
docker compose up -d

Gitlab-Runner будем устанавливать напосредственно в ОС управляющей машины:
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
apt install gitlab-runner

Далее регистрируем Runner для Pipeline в Gitlabe
