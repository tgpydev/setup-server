# Setup Server Automation Script

![Setup Server](https://img.shields.io/badge/Status-Active-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

Автоматизированный Bash-скрипт для первоначальной настройки новых серверов на основе Ubuntu. Скрипт выполняет следующие действия:

1. Обновление системы
2. Настройка SSH-сервера
3. Установка Python 3.11 и настройка альтернатив
4. Установка Poetry для управления зависимостями Python
5. Установка Docker
6. Установка GitHub CLI (`gh`)

## Содержание

- [Требования](#требования)
- [Установка и использование](#установка-и-использование)

## Требования

- **ОС:** Ubuntu 22.04 или выше
- **Права доступа:** Необходимы права суперпользователя (root)
- **Интернет-соединение:** Для загрузки пакетов и зависимостей

## Установка и использование

Выполните скрипт напрямую с помощью `curl` или `wget`:

```bash
curl -fsSL https://raw.githubusercontent.com/tgpydev/setup-server/main/setup.sh | sudo bash
```

или

```bash
wget -qO- https://raw.githubusercontent.com/tgpydev/setup-server/main/setup.sh | sudo bash
```