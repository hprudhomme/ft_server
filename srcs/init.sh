service nginx start
service mysql start
service php7.3-fpm start

chown -R www-data /var/www/*
chmod -R 755 /var/www/*

mkdir /var/www/mysite && touch /var/www/mysite/index.php
echo "<?php phpinfo(); ?>" >> /var/www/mysite/index.php

mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/mysite.pem -keyout /etc/nginx/ssl/mysite.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=rchallie/CN=mysite"

# Config NGINX
rm -f /etc/nginx/sites-enabled/default
mv /tmp/nginx_config /etc/nginx/sites-available/default.conf
cd /etc/nginx/sites-enabled
ln -s ../sites-available/default.conf .

# Configure a wordpress database
echo "CREATE DATABASE wordpress;"| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;"| mysql -u root --skip-password
echo "FLUSH PRIVILEGES;"| mysql -u root --skip-password
echo "update mysql.user set plugin='' where user='root';"| mysql -u root --skip-password

# DL phpmyadmin
mkdir /var/www/mysite/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/mysite/phpmyadmin
mv /tmp/phpmyadmin.inc.php /var/www/mysite/phpmyadmin/config.inc.php

# DL wordpress
cd /tmp/
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/ /var/www/mysite
mv /tmp/wp_config.php /var/www/mysite/wordpress

bash