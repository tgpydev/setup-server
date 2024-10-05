#!/bin/bash

set -e  # Прерывать выполнение при ошибках

# Функция для вывода сообщений
echo_info() {
    echo -e "\e[32m$1\e[0m"
}

echo_info "Шаг 0: Обновление системы..."
sudo apt update && sudo apt upgrade -y

echo_info "Шаг 1: Настройка SSH..."

SSH_CONFIG_FILE="/etc/ssh/sshd_config"

# Создаём резервную копию оригинального файла конфигурации
sudo cp $SSH_CONFIG_FILE ${SSH_CONFIG_FILE}.bak

# Изменяем необходимые параметры в файле конфигурации
sudo sed -i 's/^Port .*/Port 53444/' $SSH_CONFIG_FILE
sudo sed -i 's/^#HostKeyAlgorithms .*/HostKeyAlgorithms +ssh-rsa/' $SSH_CONFIG_FILE
sudo sed -i 's/^#PubkeyAcceptedAlgorithms .*/PubkeyAcceptedAlgorithms +ssh-rsa/' $SSH_CONFIG_FILE
sudo sed -i 's/^PasswordAuthentication .*/PasswordAuthentication no/' $SSH_CONFIG_FILE

# Перезапускаем SSH-сервис
sudo systemctl restart ssh
sudo service ssh restart

echo_info "Шаг 2: Установка Python 3.11..."

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.11 -y

# echo_info "Установка Python 3.12 (если необходимо)..."
# Предполагается, что Python 3.12 уже доступен. Если нет, добавьте соответствующий PPA или источник.

# Установка альтернатив для Python
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.12 2

# Установка Python 3.11 как версии по умолчанию
sudo update-alternatives --set python /usr/bin/python3.11

echo_info "Шаг 3: Установка Poetry..."

sudo apt update
sudo apt install pipx -y
pipx ensurepath

# Перезагружаем текущий сеанс для применения изменений PATH
export PATH=$PATH:$HOME/.local/bin

pipx install poetry
poetry config virtualenvs.in-project true
poetry config virtualenvs.prefer-active-python true

echo_info "Шаг 4: Установка Docker..."

# Установка зависимостей
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release -y

# Добавление ключа GPG Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Добавление репозитория Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Установка Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Добавление текущего пользователя в группу docker (опционально)
# sudo usermod -aG docker $USER

echo_info "Шаг 5: Установка GitHub CLI (gh)..."

sudo apt install gh -y

echo_info "Все шаги выполнены успешно. Пожалуйста, перезагрузите систему, чтобы изменения вступили в силу"

