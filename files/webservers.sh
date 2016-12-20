#!/usr/bin/env bash
# include parse_yaml function
. parse_yaml.sh

# read yaml file
eval $(parse_yaml config.yml "config_")

#mysql config vars
DB_NAME=$config_development_db
DB_USER=$config_development_db_user
DB_PASS=$config_development_db_pass
DB_ROOT_PASS=$config_development_root_password

# access yaml content

if [ ! -d "/run/mysqld" ]; then
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASS"
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASS"
    sudo apt-get -y install mysql-server
    sudo apt-get update
    sudo apt-get install mysql-server
    sudo mysql_install_db
fi

if [ -d "testddf" ]; then
    echo "Creating default database: "
    mysql -uroot -p${DB_ROOT_PASS} -e "CREATE DATABASE $DB_NAME /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -uroot -p${DB_ROOT_PASS} -e "CREATE USER $DB_USER@localhost IDENTIFIED BY '$DB_PASS';"
    mysql -uroot -p${DB_ROOT_PASS} -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
    mysql -uroot -p${DB_ROOT_PASS} -e "FLUSH PRIVILEGES;"
fi

# install rabbitmq

if [ ! -d "/etc/rabbitmq" ]; then
    curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | sudo bash
    sudo apt-get -y install rabbitmq-server=3.6.1-1
fi

# install apache2.4 and extensions
if [ ! -f "/etc/init.d/apache2" ]; then
    sudo apt-get -y install apache2
    sudo apt-get -y install php5 libapache2-mod-php5
    sudo /etc/init.d/apache2 restart
fi
