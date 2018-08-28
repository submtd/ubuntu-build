#!/bin/bash

# php 7.2 ppa
sudo add-apt-repository -y ppa:ondrej/php

# nginx ppa
sudo add-apt-repository -y ppa:nginx/development

# redis ppa
sudo add-apt-repository -y ppa:chris-lea/redis-server

# node 9x ppa
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -

# update apt
sudo apt update

# install stuff
sudo apt install -y git curl wget htop tree ranger gnome-tweak-tool google-chrome-stable \
	php7.2-fpm php7.2-cli php7.2-sqlite3 php7.2-mysql php7.2-gd php7.2-curl php7.2-memcached \
	php7.2-imap php7.2-mbstring php7.2-xml php7.2-zip php7.2-bcmath php7.2-soap php7.2-intl \
	php7.2-readline php7.2-dev php-pear nginx redis-server nodejs mariadb-server mariadb-client \
	net-tools iproute2

# install composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# update some php.ini settings
sudo sed -i -e 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/g' /etc/php/7.2/fpm/php.ini
sudo sed -i -e 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/7.2/fpm/php.ini
sudo sed -i -e 's/;date.timezone =/date.timezone = UTC/g' /etc/php/7.2/fpm/php.ini
sudo sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.2/fpm/php.ini

# update php-fpm user
sudo sed -i -e "s/user = www-data/user = $USER/g" /etc/php/7.2/fpm/pool.d/www.conf
sudo sed -i -e "s/owner = www-data/owner = $USER/g" /etc/php/7.2/fpm/pool.d/www.conf
sudo sed -i -e "s/group = www-data/group = $(id -gn)/g" /etc/php/7.2/fpm/pool.d/www.conf

# set up the ~/Code directory and http://info.test website
mkdir -p /home/"$USER"/Code/info/public
echo "<?php phpinfo();" > /home/"$USER"/Code/info/public/index.php

# remove default nginx config and create our own test.conf
sudo rm /etc/nginx/sites-enabled/default
sudo dd of=/etc/nginx/sites-available/test.conf << EOF
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  server_name ~^(?<vhost>.+)\\.localtest.me\$;
  root /home/$USER/Code/\$vhost/public;
  index index.php index.html;
  server_name _;
  location / {
    try_files \$uri \$uri/ /index.php\$is_args\$args;
  }
  location ~ \.php\$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/run/php/php7.2-fpm.sock;
  }
}
EOF
sudo rm /etc/nginx/sites-enabled/test.conf
sudo ln -s /etc/nginx/sites-available/test.conf /etc/nginx/sites-enabled/

# update the nginx user
sudo sed -i -e "s/user www-data;/user $USER;/g" /etc/nginx/nginx.conf

# install some npm utils
sudo npm install -g gulp
sudo npm install -g yarn

# allow non sudo for mysql
sudo mysql -u root -e "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user = 'root' AND plugin = 'auth_socket';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

# restart all services
sudo systemctl restart php7.2-fpm
sudo systemctl restart nginx
sudo systemctl restart mysql
sudo systemctl restart redis-server

# fix permissions on home directory
sudo chown -R $USER:$(id -gn $USER) ~/

# install php-cs-fixer
composer global require friendsofphp/php-cs-fixer
composer global require phpunit/phpunit
composer global require phpunit/dbunit
composer global require phing/phing
composer global require phpdocumentor/phpdocumentor
composer global require sebastian/phpcpd
composer global require phploc/phploc
composer global require phpmd/phpmd
composer global require squizlabs/php_codesniffer

# add composer bin to path
cat >> ~/.profile << EOF

if [ -d "\$HOME/.composer/vendor/bin" ] ; then
    PATH="\$HOME/.composer/vendor/bin:\$PATH"
fi

EOF


