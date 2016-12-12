#!/bin/bash
#Author: crazytechindia.com
#aMail: support@crazytechindia.com
apt-get update
apt-get install fail2ban vim curl gcc htop sysstat unzip wget ufw -y
apt-get install apache2-mpm-event -y
echo -e "deb http://us.archive.ubuntu.com/ubuntu/ trusty multiverse \ndeb-src http://us.archive.ubuntu.com/ubuntu/ trusty multiverse \ndeb http://us.archive.ubuntu.com/ubuntu/ trusty-updates multiverse \ndeb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
apt-get update
apt-get install libapache2-mod-fastcgi -y
apt-get install php5-fpm php5-mysql php5-gd php5-mcrypt php5-curl php5-memcached memcached -y
wget -O /etc/apache2/conf-available/php5-fpm.conf http://repo.crazytechindia.com/conf/LAMP/php5-fpm.conf
a2enmod actions fastcgi alias
a2enconf php5-fpm
a2enmod rewrite
service apache2 restart
service php5-fpm restart
php5enmod curl
rm -rf /etc/apache2/sites-enabled/*
wget -O /etc/apache2/sites-available/default.conf http://repo.crazytechindia.com/conf/LAMP/default.conf
cp /etc/apache2/sites-available/default.conf /etc/apache2/sites-enabled/
service php5-fpm restart
sed -i "s/ENABLED=\"false\"/ENABLED=\"true\"/g" /etc/default/sysstat
service sysstat restart
DBRPASS=$(cat /dev/urandom  | tr -cd 'a-f0-9' | head -c 9)
echo $DBRPASS > /usr/local/src/mysqlrootpasswd.txt
debconf-set-selections <<< 'mysql-server mysql-server/root_password password $DBRPASS'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $DBRPASS'
apt-get install mysql-server -y
wget -O /tmp/phpmyadmin.zip http://repo.crazytechindia.com/src/phpmyadmin.zip
cd /tmp
unzip phpmyadmin.zip
mv phpMyAdmin-4.6.4-english /usr/share/phpmyadmin
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
rm -rf php*
cd
echo "My\$QLp@\$\$" /root/mysqlrootpass.txt
wget -O /etc/fail2ban/jail.local http://repo.crazytechindia.com/conf/LAMP/jail.local
wget -O /etc/fail2ban/filter.d/xmlrpc.conf http://repo.crazytechindia.com/conf/xmlrpc.conf
wget -O /usr/local/bin/manage  http://repo.crazytechindia.com/script/ubuntulamp/manage
chmod +x /usr/local/bin/manage
service apache2 restart ;service php5-fpm restart; service mysql restart
echo -e "Your Server has been setup and apache, mysql with php fpm installed \n your mysql database root password has been stored in /usr/local/src/mysqlrootpasswd.txt \n do not remove this file if you are using our amanage command"
echo " if you are using our amanage command then this file is needed"
