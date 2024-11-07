### Установка Gitlab

# Gitlab
Gitlab будем устанавливать через Docker.
Был создан docker-compose.yml. Перед запуском запустить скрипт подготовки необходимых каталогов:
gitlab_docker_prepare.sh
Запуск Gitlab:
docker compose up -d

# Gitlab-Runner
Gitlab-Runner будем устанавливать напосредственно в ОС управляющей машины:
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
apt install gitlab-runner

# Настройка Gitlab
Учетные данные для входа в веб-интерфейс Gitlab получаем в выводе после запуска скрипта:
get_pasword.sh
Меняем учетные данные на:
root:Password1@
Создаем проект "otus". В этом проекте создаем Pipeline:
gitlab-ci.yml

Далее регистрируем Runner для нашего Pipeline.
