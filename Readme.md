
# Docker for Laravel and Vue.js

# Description
Create a Laravel + Vue.js development environment (LAMP) with Docker.
Create three containers.
 1. Apache + php (laravel + vue.js)
 1. Mysql
 1. PhpMyAdmin
 2. 
# Envroiment

``` plantuml
node HostPC(Mac){
   
  folder "/Users/<User>/Docker/Laravel/"{
    folder "./html" as hhtml
    file "./apache-php/httpd.conf" as hhttpd
    folder "./mysql-db" as hmysql
  }
  cloud {
    interface "port 8080" as h8080
    interface "port 8081" as h8081
  }
    rectangle Docker{
        node laravel{
            cloud laravel as dlara {
                folder "/var/www/html" as dhtml
                interface "port 8080" as lara8080
            }
            file "/etc/httpd/conf/httpd.conf" as dhttpd
        }
        node mysql5.7{
            database mysql as my{
            }
            folder "/var/lib/mysql" as dmysql
        }

        node phpmyadmin{
            cloud phpmyadmin as dadmin{
            interface "port 8081" as admin8081
            }
            
        }
    }
    hhtml <--> dhtml : volume
    hhttpd <--> dhttpd : volume
    hmysql <--> dmysql : volume
    dhtml ..> my : migrate
    dadmin ..> my : 参照
    lara8080 <-[#0000FF]up-> h8080
    admin8081 <-[#0000FF]up-> h8081
}
```

# Quick Start : Installation

As an example, the Laravel project name will be described as [laravue].

## Git Clone
```
$ git clone https://github.com/gogoloon/docker-lara-vue.git laravue
```

## Setting ".env" file
Copy ”.env.sample” to ”.env” and set the laravel project name and port number.
```
$ cd laravue/
$ cp .env.sample .env
$ vi .env 

# Note: Do not use hyphens
COMPOSE_PROJECT_NAME=laravel <-change
# laravel / DB / PhpMyAdmin Port
PORT_WEB=8080
PORT_DB=3306
PORT_PHPMYADMIN=8081
# DB Password
PASSWORD=P@ssw0rd

```



## docker-compose
Run "Docker-compose up -d" command to create a Docker Container.
Confirm that three containers starting with the project name have been created.
```
$ docker-compose up -d
Creating network "laravue_default" with the default driver
Creating laravue_mysql_1 ... done
Creating laravue              ... done
Creating laravue_phpmyadmin_1 ... done

$ docker-compose ps
        Name                      Command               State                 Ports              
-------------------------------------------------------------------------------------------------
laravue                /usr/sbin/httpd -D FOREGROUND    Up      0.0.0.0:8080->80/tcp             
laravue_mysql_1        docker-entrypoint.sh mysqld      Up      0.0.0.0:3306->3306/tcp, 33060/tcp
laravue_phpmyadmin_1   /docker-entrypoint.sh apac ...   Up      0.0.0.0:8081->80/tcp 
```


## Execute inital setup script

Finally, execute the initial setup script. This script does the following:
 1. Create laravel project
 2. Vue.js installation and settings
 3. Modify httpd.conf to change DocumentRoot and change setting of AllowOverride for laravel project
 4. Modify .env and set DATABASE param
 5. Implementation of Laravel DB Migrate
 6. Restart the container to update the setting of httpd

```
./init_setup.sh
```


