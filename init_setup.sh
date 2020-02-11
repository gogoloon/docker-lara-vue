#!/bin/sh

# .envファイルの読み込み
. .env

# Laravelプロジェクトを作成
docker exec -it $COMPOSE_PROJECT_NAME composer create-project "laravel/laravel=6.0.*" $COMPOSE_PROJECT_NAME
docker exec -it $COMPOSE_PROJECT_NAME /bin/bash -c "cd /var/www/html/$COMPOSE_PROJECT_NAME; chmod -R 777 ./storage; chmod -R 777 ./bootstrap/cache/"
docker exec -it $COMPOSE_PROJECT_NAME composer require laravel/ui
docker exec -it $COMPOSE_PROJECT_NAME php artisan ui vue --auth
docker exec -it $COMPOSE_PROJECT_NAME npm install
docker exec -it $COMPOSE_PROJECT_NAME npm run dev

# はじめにhttp.confを初期化する
cp ./apache-php/httpd.conf.ori ./apache-php/httpd.conf
sed -i '' "s/DocumentRoot \"\(.*\)\"/DocumentRoot \"\/var\/www\/html\/$COMPOSE_PROJECT_NAME\/public\"/g" ./apache-php/httpd.conf
sed -i '' "s/\<Directory \"\/var\/www\/html\">/\<Directory \"\/var\/www\/html\/$COMPOSE_PROJECT_NAME\/public\"\>/g" ./apache-php/httpd.conf
sed -i '' "s/AllowOverride None/AllowOverride All/" ./apache-php/httpd.conf

# .envのDB設定を書き換え
docker exec -it $COMPOSE_PROJECT_NAME /bin/bash -c "cd /var/www/html/$COMPOSE_PROJECT_NAME; sed -i '' \"s/DB_HOST=\(.*\)/DB_HOST=mysql/g\" .env"
docker exec -it $COMPOSE_PROJECT_NAME /bin/bash -c "cd /var/www/html/$COMPOSE_PROJECT_NAME; sed -i '' \"s/DB_DATABASE=\(.*\)/DB_DATABASE=$COMPOSE_PROJECT_NAME/g\" .env"
docker exec -it $COMPOSE_PROJECT_NAME /bin/bash -c "cd /var/www/html/$COMPOSE_PROJECT_NAME; sed -i '' \"s/DB_PASSWORD=\(.*\)/DB_PASSWORD=$PASSWORD/g\" .env"

# Laravel Migrate実行
docker exec -it $COMPOSE_PROJECT_NAME /bin/bash -c "cd /var/www/html/$COMPOSE_PROJECT_NAME; php artisan migrate"

# Laravelコンテナの再起動
docker restart $COMPOSE_PROJECT_NAME

echo "-------------------------------------"
echo "Laravelの初期設定が完了しました!"
echo "Laravelプロジェクト：$COMPOSE_PROJECT_NAME"
echo "以下のURLへアクセスしてください!"
echo " - Laravel"
echo "   http://localhost:$PORT_WEB/"
echo " - PhpMyAdmin"
echo "   http://localhost:$PORT_PHPMYADMIN/"
echo "DB情報は以下となります"
echo " - DB port : $PORT_DB"
echo " - DB name : $COMPOSE_PROJECT_NAME"
echo " - DB root password : $PASSWORD"
echo "-------------------------------------"

