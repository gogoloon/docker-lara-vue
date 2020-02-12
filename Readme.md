
# Docker for Laravel and Vue.js

# Description
Create a Laravel + Vue.js development environment (LAMP) with Docker.
Create three containers.
 1. Apache + php (laravel + vue.js)
 1. Mysql
 1. PhpMyAdmin

# Installation

```
git clone https://github.com/gogoloon/docker-laravel.git [FolderName]
cd [FolderName]
```


Copy ”.env.sample” to ”.env” and set the laravel project name and port number.
```
copy .env.sample .env

vi .env
# Note: Do not use hyphens
COMPOSE_PROJECT_NAME=laravel <-change
# laravel / DB / PhpMyAdmin Port
PORT_WEB=8080
PORT_DB=3306
PORT_PHPMYADMIN=8081
# DB Password
PASSWORD=P@ssw0rd

```


```
docker-compose up -d
```

```
./init_setup.sh
```

