#!/bin/bash

echo "Willkommen zur Nextcloud-Installation!"
echo "Welche Version von Nextcloud möchten Sie installieren?"
echo "1. Nextcloud 28"
echo "2. Nextcloud 29"
echo "3. Neueste Version"
read -p "Geben Sie die Nummer der gewünschten Version ein: " version

if [ "$version" == "1" ]; then
    echo "Nextcloud 28 wird heruntergeladen..."
    # Hier kannst du den Code für die Installation von Nextcloud 27 einfügen
    version="https://download.nextcloud.com/server/releases/nextcloud-28.0.8.zip" # Ändere den Wert der Variable version auf "27"
    zip="nextcloud-28.0.8.zip"
elif [ "$version" == "2" ]; then
    echo "Nextcloud 29 wird heruntergeladen..."
    # Hier kannst du den Code für die Installation von Nextcloud 28 einfügen
    version="https://download.nextcloud.com/server/releases/nextcloud-29.0.4.zip" # Ändere den Wert der Variable version auf "28"
    zip="nextcloud-29.0.4.zip"
elif [ "$version" == "3" ]; then
    echo "Neueste Version wird heruntergeladen..."
    # Hier kannst du den Code für die Installation der neuesten Version einfügen
    version="https://download.nextcloud.com/server/releases/latest.zip" # Ändere den Wert der Variable version auf "latest"
    zip="latest.zip"
else
    echo "Ungültige Eingabe. Bitte geben Sie entweder 1, 2 oder 3 ein."
fi

cd /tmp
wget $version

echo Install Lampstack

apt install apache2 -y
apt install mariadb-server -y
apt install php libapache2-mod-php php-mysql php-curl php-gd php-json php-mbstring php-intl php-imagick php-xml php-zip -y
apt install unzip -y

echo Setup Database

mysql_secure_installation

myql create database nextcloud;

echo "Setup PhP"

echo "Please enter the memory limit:"
read -p "Geben Sie das gewünschte Memory-Limit ein: " memoryphp

if [ "$memoryphp" != "" ]; then
    echo "Das Memory-Limit wird auf $memoryphp gesetzt."
else
    echo "Ungültige Eingabe. Das Memory-Limit bleibt unverändert."
fi

echo "Please enter the upload limit:"
read -p "Geben Sie das gewünschte Memory-Limit ein: " uploadphp

if [ "$uploadphp" != "" ]; then
    echo "Das Memory-Limit wird auf $uploadphp gesetzt."
else
    echo "Ungültige Eingabe. Das Memory-Limit bleibt unverändert."
fi

echo "Please enter the Timezone bsp:(Europe/Berlin):"
read -p "Geben Sie das gewünschte Memory-Limit ein: " timephp

if [ "$timephp" != "" ]; then
    echo "Das Memory-Limit wird auf $timephp gesetzt."
else
    echo "Ungültige Eingabe. Das Memory-Limit bleibt unverändert."
fi

# Pfad zur php.ini Datei
INI_FILE="/etc/php/8.2/apache2/php.ini"

# Array von Konfigurationsparametern und ihren neuen Werten
declare -A config_changes=(
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

# Überprüfen, ob die php.ini existiert
if [ ! -f "$INI_FILE" ]; then
    echo "Die php.ini Datei existiert nicht."
    exit 1
fi

# Sichern der Originaldatei
cp "$INI_FILE" "${INI_FILE}.bak"

# Ändern der Konfigurationen in der php.ini
for param in "${!config_changes[@]}"; do
    new_value=${config_changes[$param]}
    if grep -q "^$param" "$INI_FILE"; then
        # Wenn der Parameter existiert, wird er ersetzt
        sed -i "s/^$param.*/$param = $new_value/" "$INI_FILE"
        echo "$param wurde auf $new_value gesetzt."
    else
        # Wenn der Parameter nicht existiert, wird er hinzugefügt
        echo "$param = $new_value" >> "$INI_FILE"
        echo "$param wurde hinzugefügt und auf $new_value gesetzt."
    fi
done

echo "Alle Änderungen erfolgreich abgeschlossen."

echo "Installiere Server"

cd /tmp
unzip $zip

mv nextcloud /var/www/html/

chown -R www-data:www-data /var/www/nextcloud/html/
chmod -R 755 /var/www/nextcloud/html/

a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime

service apache2 start

echo "Nextcloud wurde erfolgreich installiert. Öffnen Sie Ihren Browser und geben Sie die IP-Adresse Ihres Servers ein, um die Konfiguration abzuschließen."