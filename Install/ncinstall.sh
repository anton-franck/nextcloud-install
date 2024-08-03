#!/bin/bash

echo "Willkommen zur Nextcloud-Installation!"
echo "Welche Version von Nextcloud möchten Sie installieren?"
echo "1. Nextcloud 27"
echo "2. Nextcloud 28"
echo "3. Neueste Version"
read -p "Geben Sie die Nummer der gewünschten Version ein: " version

if [ "$version" == "1" ]; then
    echo "Nextcloud 27 wird installiert..."
    # Hier kannst du den Code für die Installation von Nextcloud 27 einfügen
    version="27" # Ändere den Wert der Variable version auf "27"
elif [ "$version" == "2" ]; then
    echo "Nextcloud 28 wird installiert..."
    # Hier kannst du den Code für die Installation von Nextcloud 28 einfügen
    version="28" # Ändere den Wert der Variable version auf "28"
elif [ "$version" == "3" ]; then
    echo "Neueste Version wird installiert..."
    # Hier kannst du den Code für die Installation der neuesten Version einfügen
    version="latest" # Ändere den Wert der Variable version auf "latest"
else
    echo "Ungültige Eingabe. Bitte geben Sie entweder 1, 2 oder 3 ein."
fi

echo "$version"