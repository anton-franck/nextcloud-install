#!/bin/bash

echo "Welcome to Nextcloud installation!"
read -p "Enter the URL of the desired version: " version

if [ "$version" != "" ]; then
    echo "Downloading Nextcloud..."
    zip=$(basename "$version")
else
    echo "Invalid input. Please enter a valid URL."
fi

echo "Please enter the name of the .zip file:"
read -p "Enter the desired .zip file name: " zip

if [ "$zip" != "" ]; then
    echo "The .zip file name will be set to $zip."
else
    echo "Invalid input. The .zip file name will remain unchanged."
fi


cd /tmp
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

echo "Please enter the memory limit:"
read -p "Enter the desired memory limit: " memoryphp

if [ "$memoryphp" != "" ]; then
    echo "The memory limit will be set to $memoryphp."
else
    echo "Invalid input. The memory limit will remain unchanged."
fi


echo "Please enter the upload limit:"
read -p "Enter the desired upload size: " uploadphp

if [ "$uploadphp" != "" ]; then
    echo "The upload limit will be set to $uploadphp."
else
    echo "Invalid input. The upload limit will remain unchanged."
fi

echo "Please enter the timezone (e.g., Europe/Berlin):"
read -p "Enter the desired timezone: " timephp

if [ "$timephp" != "" ]; then
    echo "The timezone will be set to $timephp."
else
    echo "Invalid input. The timezone will remain unchanged."
fi


INI_FILE="/etc/php/8.1/apache2/php.ini"


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

rm /var/www/html/index.html #Remove Apache2 Default Page
mv nextcloud/* /var/www/html/ #Move Nextcloud Files to Apache2 Directory

chown -R www-data:www-data /var/www/html/ #Change Owner of Nextcloud-Directory
chmod -R 755 /var/www/html/   #Change Permissions of Nextcloud-Directory

a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime #Enable Apache2 Modules

service apache2 start #Start Apache2
service apache2 restart #Restart Apache2

echo "Nextcloud was successfully installed. Open your browser and enter the IP address of your server to complete the configuration."