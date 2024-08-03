#!/bin/bash

echo "Willkommen zur Nextcloud-Installation!"
echo "Welche Version von Nextcloud möchten Sie installieren?"
echo "1. Nextcloud 27"
echo "2. Nextcloud 28"
echo "3. Neueste Version"
read -p "Geben Sie die Nummer der gewünschten Version ein: " version

if [ "$version" == "1" ]; then
    echo "Nextcloud 28 wird installiert..."
    # Hier kannst du den Code für die Installation von Nextcloud 27 einfügen
    version="https://download.nextcloud.com/server/releases/nextcloud-28.0.8.zip" # Ändere den Wert der Variable version auf "27"
elif [ "$version" == "2" ]; then
    echo "Nextcloud 29 wird installiert..."
    # Hier kannst du den Code für die Installation von Nextcloud 28 einfügen
    version="https://download.nextcloud.com/server/releases/nextcloud-29.0.4.zip" # Ändere den Wert der Variable version auf "28"
elif [ "$version" == "3" ]; then
    echo "Neueste Version wird installiert..."
    # Hier kannst du den Code für die Installation der neuesten Version einfügen
    version="https://download.nextcloud.com/server/releases/latest.zip" # Ändere den Wert der Variable version auf "latest"
else
    echo "Ungültige Eingabe. Bitte geben Sie entweder 1, 2 oder 3 ein."
fi

echo "$version"