#!/bin/sh

# Read file .env 
. .env

# Create laravel project and setup vue.js
docker exec -it $COMPOSE_PROJECT_NAME composer create-project "laravel/laravel=6.0.*" $COMPOSE_PROJECT_NAME
docker exec -it $COMPOSE_PROJECT_NAME /bin/bash -c "cd /var/www/html/$COMPOSE_PROJECT_NAME; chmod -R 777 ./storage; chmod -R 777 ./bootstrap/cache/"
docker exec -it $COMPOSE_PROJECT_NAME /bin/bash -c "cd /var/www/html/$COMPOSE_PROJECT_NAME; composer require laravel/ui=1.* ;php artisan ui vue --auth; npm install; npm run dev"

# Change httpd.conf 
cp ./apache-php/httpd.conf.ori ./apache-php/httpd.conf
sed -i '' "s/DocumentRoot \"\(.*\)\"/DocumentRoot \"\/var\/www\/html\/$COMPOSE_PROJECT_NAME\/public\"/g" ./apache-php/httpd.conf
sed -i '' "s/\<Directory \"\/var\/www\/html\">/\<Directory \"\/var\/www\/html\/$COMPOSE_PROJECT_NAME\/public\"\>/g" ./apache-php/httpd.conf
sed -i '' "s/AllowOverride None/AllowOverride All/" ./apache-php/httpd.conf

# Change laravel .env file to setting Database
docker exec -it $COMPOSE_PROJECT_NAME /bin/bash -c "cd /var/www/html/$COMPOSE_PROJECT_NAME; sed -i  \"s/DB_HOST=\(.*\)/DB_HOST=mysql/g\" .env"
docker exec -it $COMPOSE_PROJECT_NAME /bin/bash -c "cd /var/www/html/$COMPOSE_PROJECT_NAME; sed -i  \"s/DB_DATABASE=\(.*\)/DB_DATABASE=$COMPOSE_PROJECT_NAME/g\" .env"
docker exec -it $COMPOSE_PROJECT_NAME /bin/bash -c "cd /var/www/html/$COMPOSE_PROJECT_NAME; sed -i  \"s/DB_PASSWORD=\(.*\)/DB_PASSWORD=$PASSWORD/g\" .env"

# Execute laravel migrate
docker exec -it $COMPOSE_PROJECT_NAME /bin/bash -c "cd /var/www/html/$COMPOSE_PROJECT_NAME; php artisan migrate"

# Restart laravel docker container
docker restart $COMPOSE_PROJECT_NAME

echo "-------------------------------------"
echo "Laravel initial configuration is complete!!"
echo "Laravel Project Name : $COMPOSE_PROJECT_NAME"
echo "Please check the following URL!"
echo " - Laravel"
echo "   http://localhost:$PORT_WEB/"
echo " - PhpMyAdmin"
echo "   http://localhost:$PORT_PHPMYADMIN/"
echo "Database Infomation"
echo " - DB port : $PORT_DB"
echo " - DB name : $COMPOSE_PROJECT_NAME"
echo " - DB root password : $PASSWORD"
echo "-------------------------------------"
