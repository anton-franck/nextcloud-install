#!/bin/bash

# This Script is from Anton-Franck (https://github.com/anton-franck) to install Nextcloud Easy

echo "Welcome to the Nextcloud-Installscript V1.9.2!"
echo "Which version of Nextcloud would you like to install?"
echo "1. Nextcloud 28"
echo "2. Nextcloud 29"
echo "3. Latest version"
echo "4. Custom version"
read -p "Enter the number which Version you want to install: " version

    if [ "$version" == "1" ]; then
        echo "Downloading Nextcloud 28..."
        version="https://download.nextcloud.com/server/releases/nextcloud-28.0.8.zip"
        zip="nextcloud-28.0.8.zip"
    elif [ "$version" == "2" ]; then
        echo "Downloading Nextcloud 29..."
        version="https://download.nextcloud.com/server/releases/nextcloud-29.0.4.zip"
        zip="nextcloud-29.0.4.zip"
    elif [ "$version" == "3" ]; then
        echo "Downloading latest version..."
        version="https://download.nextcloud.com/server/releases/latest.zip"
        zip="latest.zip"
    elif [ "$version" == "4" ]; then
    read -p "Enter the URL of the desired Nextcloud version: " version

    if [ "$version" != "" ]; then
        zip=$(basename "$version")
        
        if [[ "$zip" == *.zip ]]; then
            echo "The zip file to download is: $zip"
        else
            echo "The URL does not point to a .zip file. Please provide a valid Nextcloud .zip URL."
        fi
    else
        echo "Invalid input. Please enter a valid URL."
    fi

    else
        echo "Invalid input. Please enter either 1, 2, 3, or 4."
    fi

cd /tmp
echo "Downloading Nextcloud..."
wget $version #Download Nextcloud from http://download.nextcloud.com/server/

echo Install Lampstack

apt update  -y #Update Package List
apt upgrade -y #Upgrade Packages
apt install apache2 -y #Install Apache2
apt install mariadb-server -y #Install MariaDB
apt install php libapache2-mod-php php-mysql php-curl php-gd php-json php-mbstring php-intl php-imagick php-xml php-zip php-bcmath php-gmp -y #Install PHP and its modules
apt install unzip -y #Install Unzip

echo Setup Database

mysql_secure_installation #Secure MariaDB Installation

myql CREATE DATABASE nextcloud; #Create Database for Nextcloud

echo "Setup PhP"

echo "Now we ask you some Questions for PHP:"
read -p "Enter the memory limit maybe(2048M): " memoryphp

if [ "$memoryphp" != "" ]; then
    echo "The memory limit will be set to $memoryphp."
else
    echo "Invalid input. The memory limit will remain unchanged."
fi

read -p "Enter the desired upload size: " uploadphp

if [ "$uploadphp" != "" ]; then
    echo "The upload limit will be set to $uploadphp."
else
    echo "Invalid input. The upload limit will remain unchanged. maybe (50G)?"
fi

read -p "Please enter the timezone (e.g., Europe/Berlin): " timephp

if [ "$timephp" != "" ]; then
    echo "The timezone will be set to $timephp."
else
    echo "Invalid input. The timezone will remain unchanged."
fi


BASE_PATH="/etc/php"

for VERSION in 8.{1..3} #Look who is the PHP-File
do
    INI_FILE="$BASE_PATH/$VERSION/apache2/php.ini"
    
    if [ -f "$INI_FILE" ]; then
        echo "Gefundene php.ini: $INI_FILE"
        break
    fi
done

if [ ! -f "$INI_FILE" ]; then
    echo "Keine php.ini gefunden."
fi


declare -A config_changes=( #All Changes for Php.ini
    ["memory_limit"]="$memoryphp"
    ["upload_max_filesize"]="$uploadphp"
    ["post_max_size"]="$uploadphp"
    ["date.timezone"]="$timephp"
    ["output_buffering"]="Off"
    ["opcache.enable"]="1"
    ["opcache.enable_cli"]="1"
    ["opcache.interned_strings_buffer"]="64"
    ["opcache.max_accelerated_files"]="10000"
    ["opcache.memory_consumption"]="1024"
    ["opcache.save_comments"]="1"
    ["opcache.revalidate_freq"]="1"
)

if [ ! -f "$INI_FILE" ]; then #Check if Php.ini exists
    echo "The php.ini file does not exist."
    exit 1
fi

# Create a backup of the php.ini file
cp "$INI_FILE" "${INI_FILE}.bak"

# Change your Changes in the php.ini file
for param in "${!config_changes[@]}"; do
    new_value=${config_changes[$param]}
    if grep -q "^$param" "$INI_FILE"; then
        sed -i "s/^$param.*/$param = $new_value/" "$INI_FILE"
        echo "$param has been set to $new_value."
        else
        echo "$param = $new_value" >> "$INI_FILE"
        echo "$param has been added and set to $new_value."
    fi
done
echo "All changes successfully completed."

echo "Installing server"

cd /tmp 
unzip $zip #Unzip Nextcloud
rm $zip #Remove Zip File

rm -rf /var/www/html #Remove Apache2 Default Page
mv nextcloud/ /var/www/ #Move Nextcloud Files to Apache2 Directory

chown -R www-data:www-data /var/www/nextcloud/ #Change Owner of Nextcloud-Directory
chmod -R 755 /var/www/nextcloud/   #Change Permissions of Nextcloud-Directory

cat <<EOL > /etc/apache2/sites-available/nextcloud.conf #Make a new Config File for Apache2
<VirtualHost *:80>
     DocumentRoot /var/www/nextcloud/
     ServerAlias *
     <Directory /var/www/nextcloud/>
        Options +FollowSymlinks
        AllowOverride All
        Require all granted
          <IfModule mod_dav.c>
            Dav off
          </IfModule>
        SetEnv HOME /var/www/nextcloud
        SetEnv HTTP_HOME /var/www/nextcloud
     </Directory>
     ErrorLog \${APACHE_LOG_DIR}/error.log
     CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

a2ensite nextcloud.conf #Enable new config

systemctl restart apache2

echo "Die nextcloud.conf wurde erfolgreich erstellt und Apache2 wurde neu gestartet."

a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime #Enable Apache2 Modules

service apache2 start #Start Apache2
service apache2 restart #Restart Apache2

echo "Nextcloud was successfully installed. Open your browser and enter the IP address of your server to complete the configuration"
echo "First write your Account Data. Setup it with root and the Databasepassword. The Database Name is nextcloud"

# This Script is from Anton-Franck (https://github.com/anton-franck) to install Nextcloud Easy