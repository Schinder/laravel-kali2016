#!/bin/bash
echo "#########################################################################################" 
echo "file: laravel-kali2016.sh"
echo "author: Adam P. Schinder"
echo "purpose: To automate the laravel setup process. There seem to be a lot of little nagging "
echo "         'issues' when trying to get laravel up.... This script should fix all of that.  "
echo "usage: I employed this as root on a x64 kali-2016 box.  It should work for any Debain OS."
echo "date: 23 May 2016 - Initial Creation..."
echo "#########################################################################################" 
######################################
# Laravel Homestead Install:
######################################
# WORK IN PROGRESS.......
#cd /var/www/
#mkdir laravel_homestead
#cd ~/Downloads/
#dpkg -i vagrant_1.8.1_x86_64.deb 
#cd /var/www/laravel_homestead/
#vagrant init
#vagrant box add laravel/homestead
#cat Vagrantfile 
#cd .vagrant/
#rm -rf laravel_homestead/
#mkdir Homestead
#git clone https://github.com/laravel/homestead.git Homestead
#cd Homestead/
#bash init.sh 
#cd .homestead/
#gedit Homestead.yaml &
#mkdir Homestead

######################################
# To setup Laravel on your host:
######################################
echo "First we need all of the required applications..."
echo "According to Laravel's website https://laravel.com/docs/5.2:"
echo "\"...you will need to make sure your server meets the following requirements: \""   
echo "        PHP >= 5.5.9             * we will install php7.0"
echo "        OpenSSL PHP Extension    * we will install libapache2-mod-php7.0"
echo "        PDO PHP Extension        * (PHP Data Objects) installed by default with php7.0-mysql"
echo "        Mbstring PHP Extension   * we will install php7.0-mbstring"
echo "        Tokenizer PHP Extension  * installed by default in php 4.3.*"
echo "--------------------------------------------------------------------------------"
echo "[*] First shutdown apache2..."
service apache2 stop
echo "[+] Service apache shutdown!"
echo "[*] Installing curl, git, git-gui, gitk, and mercurial..."
apt-get install curl git git-gui git-doc gitk mercurial -y -q
echo "[+] git and related complete!"
echo "[*] Installing chkconfig to enable or disable system services.  No different than up update-rc.d - I think...  not sure there..."
apt-get install chkconfig -y -q
apt-get -f install -y -q
echo "[+] chkconfig complete!"
echo "[*] Installing python-softlayer..."
apt-get install python-softlayer 
echo "[+] python-softlayer complete!"
echo "[*] Installing php 7.0 and related modules..."
#apt-get purge php*
apt-get install php7.0 php7.0-mysql php7.0-sqlite3 php7.0-xml php7.0-mbstring php7.0-phpdbg php7.0-pgsql php7.0-bcmath php7.0-cli php7.0-curl php7.0-dev php7.0-json php7.0-zip php7.0-bz2 libapache2-mod-php7.0 -y -q
apt-get -f install -y -q
echo "[+] php complete!"
echo "[*] Installing mysql and tools..."
apt-get install mysql-client mysql-common mysql-proxy mysql-sandbox mysql-server mysqltcl mysqltuner mysql-utilities mysql-workbench mysql-workbench-data -y -q
apt-get -f install -y -q
echo "[+] mysql complete!"
#########################################################################################
# PACKAGE MAINTAINER VERSION IS RATHER OLD... Like ver 0.9.3 or something... cmd below...
# apt-get install composer -y -q
# THESE ARE THE INSTRUCTIONS TO USE THE NON-PACKAGE VERSION OF COMPOSER...
# https://getcomposer.org/download/
#########################################################################################
echo "[*] Installing composer to manage php project dependencies... Yay package managers..."
cd ~/Downloads/
echo "cd ~/Downloads/"
echo "[*] Installing composer..."
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '92102166af5abdb03f49ce52a40591073a7b859a86e8ff13338cf7db58a19f7844fbc0bb79b2773bf30791e935dbd938') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
chmod 755 /usr/local/bin/composer
echo "[+] composer complete!"
apt-get -f install -y -q
composer -V
echo "[+] composer complete!"
echo "[*] Installing nodejs for javascript server functionality..."
apt-get install nodejs nodejs-dev nodejs-dbg -y -q
echo "[*] ln -s /usr/bin/nodejs /usr/bin/node"
ln -s /usr/bin/nodejs /usr/bin/node
apt-get -f install -y -q
echo "[+] nodejs complete!"
echo "[*] Installing the npm manager.... Yay package managers..."
apt-get install npm -y -q
apt-get -f install -y -q
echo "[+] npm complete!"
echo "----------------------------------------------------------------------------"
echo " Every Github synchronization will occur within the /root/Github directory. "
echo " You can have github sync wherever, I just prefer to have all the sync's in "
echo " the same place.  Web items, however, will be copied to /var/www as usual.  "
echo "----------------------------------------------------------------------------"
mkdir /root/Github
echo "[+] mkdir /root/Github"
git config --global user.email "adam.p.schinder@gmail.com"
echo "[+] git config --global user.email \"adam.p.schinder@gmail.com\""
git config --global user.name "Schinder"
echo "[+] git config --global user.name \"Schinder\""
git config --global core.editor "/usr/bin/gedit"
echo "[+] git config --global core.editor \"/usr/bin/gedit\""
echo "[+] mkdir /root/Github/laravel"
cd /root/Github/laravel
echo "[+] cd /root/Github/laravel"
git clone https://github.com/laravel/laravel.git .
echo "[+] git clone https://github.com/laravel/laravel.git ."
echo " We probably won't need the github version... This is just in case we feel like looking at it later..."
echo "----------------------------------------------------------------------------"
echo " We will start by creating a \"base\" version of laravel. This will be done "
echo " by configuring apache2, using composer to manage laravel's php             "
echo " dependencies, and bower for javascript dependency management.  We will use "
echo " a Composer folder for these projects... organization-ocd or whatever..."
echo "----------------------------------------------------------------------------"
mkdir /root/Composer
echo "[+] mkdir /root/Composer"
cd /root/Composer
echo "[+] cd /root/Composer"
echo "[*] Let's use composer to install laravel to the system globally..."
composer global require "laravel/installer"
echo "[+] 'composer global require \"laravel/installer\"' completed successfully!"
echo "export PATH=$PATH:/root/.composer/vendor/bin" >> /root/.bashrc
echo "[+] appended 'export PATH=$PATH:/root/.composer/vendor/bin' to '/root/.bashrc' so we can access the laravel command globally"
echo "[*] Now let's use laravel to create a new project called ... laravel..."
laravel new laravel
echo "[+] 'laravel new laravel' completed successfully! "
echo "[*] Before messing with laravel, let's install bower to manage javascript dependencies..."
npm install --global bower
echo "[+] 'npm install --global bower' was successful!"
bower init --allow-root
echo "[+] 'bower init --allow-root' was successful!"
echo "[*] ensure the permissions and ownership are set to www-data for the base laravel directory"
echo " !!! Don't forget to check this when you copy the project to /var/www !!!"
chmod -R 755 laravel/
echo "[+] -R 755 laravel/"
chown -Rf www-data laravel/
echo "[+] -Rf www-data laravel/"
chgrp -R root laravel/
echo "[+] -R root laravel/"
echo "[*] All right..... Let's bring up apache2 and php7.0-fpm..."
service apache2 start
service php7.0-fpm start
echo "[+] services started!"
echo "[*] Create a 'phpinfo.php' file in '/var/www/' to debug php errors..."
cd /var/www/
touch phpinfo.php
echo "<?php " >> phpinfo.php
echo "// Show all information, defaults to INFO_ALL " >> phpinfo.php
echo "phpinfo(); " >> phpinfo.php
echo "?> " >> phpinfo.php
echo "[+] 'phpinfo.php' created successfully"
echo "[*] Now let's enable mod-rewrite in apache2..."
echo "    in each directory, httpd.conf enable mod_rewrite allows the url to be hidden in the browser"
echo "    don't forget to paste in the url to app.php"
echo "[*] apache2ctl status"
apache2ctl status
echo "[*] a2enmod rewrite"
a2enmod rewrite
#apache2ctl mod_rewrite enable
echo "[*] service apache2 restart"
service apache2 restart
echo "[*] systemctl status apache2.service"
systemctl status apache2.service 
echo "[*] apache2ctl status (again)"
apache2ctl status
echo "[+] Should be working now!"
#application/config
#default => mysql
#enter in your credentials and the database you are using
#check phpmyadmin to ensure the database is up
cd /root/Composer/laravel 
echo "[*] cd /root/Composer/laravel"
mv .env .env.bak
echo "[*] mv .env .env.bak"
echo "APP_DEBUG=true" >> .env
echo "APP_URL=http://localhost" >> .env
echo "DB_CONNECTION=rds" >> .env
echo "DB_HOST=localhost" >> .env
echo "DB_PORT=3306" >> .env
echo "DB_DATABASE=database_name" >> .env
echo "DB_USERNAME=root" >> .env
echo "DB_PASSWORD=replace_me" >> .env
echo "APP_KEY=base64:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >> .env
echo "APP_URL=http://localhost" >> .env
echo "[+] New '.env' file created"

#echo "Delete the placeholder key in application.php!"
#gedit app.php
#php artisan key:generate
#cd bootstrap/
#gedit autoload.php &

#cd /var/www/spanner/
#gedit package.json 

echo "----------------------------------------------------------------------------"
echo " Well....  That ought to do it.  If you restart your computer, be sure to   "
echo " restart the apache2 and php services again!"
echo "----------------------------------------------------------------------------"

#cd /var/www/spanner/
#git clone https://github.com/danielklim/spanner.git .
#chown -Rf www-data spanner
#php artisan route:list
#php artisan make:model FakeModel


#cd /root/Github/
#mkdir flaggendieb-server
#mkdir flaggendieb-client
#cd /root/Github/flaggendieb-server
#git clone https://github.com/herrameise/FlaggenDiebServer.git .
#cd /root/Github/flaggendieb-client
#git clone https://github.com/herrameise/FlaggenDieb.git .


#sudo -u postgres createuser root
#rake db:create
#sudo su - postgres
#cd CCTC/
#cctc.sql
#python config.py
#python flaggendieb.py 6789









