#!/bin/sh

# コンテナ名
CONTAINER = laravel
# Laravelプロジェクト名/DB名
PROJECT=board
# DB Password
PASSWORD=P@ssw0rd

# Laravelプロジェクトを作詞
docker exec -it $CONTAINER composer create-project "laravel/laravel=6.0.*" $PROJECT
docker exec -it $CONTAINER /bin/bash -c "cd /voar/www/html/$PROJECT; chmod -R 777 ./storage; chmod -R 777 ./bootstrap/cache/"
docker exec -it $CONTAINER composer require laravel/ui
docker exec -it $CONTAINER php artisan ui vue --auth


# httpd.confをバックアップ後、Document Rootなどを書き換え
cp ./apache-php/httpd.conf ./apache-php/httpd.conf.bk
sed -i -e "s/DocumentRoot \"\(.*\)\"/DocumentRoot \"\/var\/www\/html\/$PROJECT\/public\"/g" ./apache-php/httpd.conf
sed -i -e "s/\<Directory \"\/var\/www\/html\">/\<Directory \"\/var\/www\/html\/$PROJECT\/public\"\>/g" ./apache-php/httpd.conf
sed -i -e "s/AllowOverride None/AllowOverride All/" ./apache-php/httpd.conf

# .envのDB設定を書き換え
docker exec -it $CONTAINER /bin/bash -c "cd /var/www/html/$PROJECT; sed -i -e \"s/DB_HOST=\(.*\)/DB_HOST=mysql/g\" .env"
docker exec -it $CONTAINER /bin/bash -c "cd /var/www/html/$PROJECT; sed -i -e \"s/DB_DATABASE=\(.*\)/DB_DATABASE=$PROJECT/g\" .env"
docker exec -it $CONTAINER /bin/bash -c "cd /var/www/html/$PROJECT; sed -i -e \"s/DB_PASSWORD=\(.*\)/DB_PASSWORD=$PASSWORD/g\" .env"

# Laravel Migrate実行
docker exec -it $CONTAINER /bin/bash -c "cd /var/www/html/$PROJECT; php artisan migrate"

# Laravelコンテナの再起動
docker restart $CONTAINER

# 以下を確認します。
# http://localhost/
# にアクセスしてLaravelの画面が開くこと
# http://localhost:8081
# にアクセスしてphpMyAdminが開いて、DB=boardにMigrateが正しく実行されてること
# (usersやpassword_resetsなどのテーブルが作成されている)
# End
