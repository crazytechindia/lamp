#!/bin/bash
#Author crazytechindia.com
#mail: support@crazytechindia.com
#crazytechindia cheap budget hosting provider
clear
function fcheck() {
	if [ $? == 0 ];then
	echo "command completed successfully!!..."
	else
	echo "Something went wrong.Open support ticket from crazytechindia support portal"
	fi
}
while true
do
echo "###############################################"
echo "*************|| Web Host Manager ||************"
echo "-----------------------------------------------"
echo -e "Webhosting managment script for LAMP setup"
echo "**************************"
echo "        || Main Menu ||   "
echo "--------------------------"
echo " Please enter option!"
echo -e "\n"
echo "Type d to setup a database"
echo "Type r to remove a database"
echo "Type v to setup a domain"
echo "Type w to setup a domain with wordpress"
echo "Type x to exit "
echo -n "Type your Option here: "
read option
DBRPASS=$(cat /usr/local/src/mysqlrootpasswd.txt)
echo -e "\n\n"
case $option in 
d|D)
	while true
	do
	echo -n "Enter database name: "
        read DBNAME
        DBCHK=$(echo "show databases" | mysql -p"$DBRPASS" | grep $DBNAME)

                if [ "$DBNAME" == "$DBCHK" ];
                then
                echo "Database name already exist Please try another name"
                else
                echo "create database $DBNAME" | mysql -p"$DBRPASS"
                break
		fi
	done
	echo -n "Enter db username: "
	read DBUSR
	echo -n "Enter db user pass: "
	read DBUPASS
	echo "grant all on $DBNAME.* to $DBUSR@localhost identified by '$DBUPASS'" | mysql -p"$DBRPASS"
	echo -e " \n Your database details are \n Database name $DBNAME \n Database User name $DBUSR \n Database User pass $DBUPASS"
	fcheck
;;
r|R)
	echo -n "Type database name to delete: "
	read DBND
	echo "drop database if exists $DBND" | mysql -p"$DBRPASS"
	fcheck ;;
v|V)
	while true
	do
	echo -n "Type domain name to setup: "
	read DOMN
	DOMDIR=$(echo $DOMN | tr -d '.')
	DOMCHECK=$(cat /etc/apache2/sites-enabled/* | grep ServerName | grep "$DOMN" | awk '{print $2}')

	echo $DOMCHECK
		if [ "$DOMCHECK" == "$DOMN" ];then
		echo " Specified Domain name already setup try new"
        else
	        echo "your domin name can be setup"
        break
	fi
	done
	echo "Setting up your new domain virtual host...."
	mkdir /var/www/$DOMDIR
	cp /etc/apache2/sites-available/default.conf /etc/apache2/sites-enabled/$DOMDIR.conf
	sed -i "s/\/var\/www\/html/\/var\/www\/$DOMDIR/g" /etc/apache2/sites-enabled/$DOMDIR.conf
	sed -i "s/localhost/$DOMN/g" /etc/apache2/sites-enabled/$DOMDIR.conf
	service apache2 restart
#	cat /etc/apache2/sites-enabled/$DOMDIR.conf
	echo "Your new domain Details as bellow:-"
	echo "Domain name : $DOMN"
	echo "Document root is : /var/www/$DOMDIR"
	echo "Configuration file is : /etc/apache2/sites-enabled/$DOMDIR.conf "
;;

w|W)
        while true
        do
        echo -n "Type domain name to setup: "
        read DOMN
        DOMDIR=$(echo $DOMN | tr -d '.')
        DOMCHECK=$(cat /etc/apache2/sites-enabled/* | grep ServerName | grep "$DOMN" | awk '{print $2}')

        echo $DOMCHECK
                if [ "$DOMCHECK" == "$DOMN" ];then
                echo " Specified Domain name already setup try new"
        else
                echo "your domin name can be setup"
        break
        fi
        done
        echo "Setting up your new domain virtual host...."
        cd /tmp
	wget http://wordpress.org/latest.zip
	unzip latest.zip
	mv wordpress /var/www/$DOMDIR
	chown -R www-data. /var/www/$DOMDIR
	DBSTRING=wpdb_$(cat /dev/urandom  | tr -cd 'a-f0-9' | head -c 4)
	DBPASSSTRING=$(cat /dev/urandom  | tr -cd 'a-f0-9' | head -c 8)
	echo "Your new Virtualhost wordpress details" >> /root/$DOMN.wp
	echo "Database name : $DBSTRING" >> /root/$DOMN.wp
	echo "Database user name : $DBSTRING" >> /root/$DOMN.wp
	echo "Database user password : $DBPASSSTRING" >> /root/$DOMN.wp
	echo "Mysql host : localhost" >> /root/$DOMN.wp
	echo "Mysql root paa : $DBRPASS" >> /root/$DOMN.wp
	echo "create database $DBSTRING" | mysql -p"$DBRPASS"
	echo "grant all on $DBSTRING.* to $DBSTRING@localhost identified by '$DBPASSSTRING'" | mysql -p"$DBRPASS"
	
        cp /etc/apache2/sites-available/default.conf /etc/apache2/sites-enabled/$DOMDIR.conf
        sed -i "s/\/var\/www\/html/\/var\/www\/$DOMDIR/g" /etc/apache2/sites-enabled/$DOMDIR.conf
        sed -i "s/localhost/$DOMN/g" /etc/apache2/sites-enabled/$DOMDIR.conf
        service apache2 restart
        echo "Your new domain Details as bellow:-"
        echo "Domain name : $DOMN"
        echo "Document root is : /var/www/$DOMDIR"
        echo "Configuration file is : /etc/apache2/sites-enabled/$DOMDIR.conf "
	echo "Please Browse website and install wordpress by using details given in file /root/$DOMN.wp"
;;

x|X)exit;;
*) echo "Wrong Choice! Please select correct option menu!";;
esac
done
