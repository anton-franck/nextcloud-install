#!/bin/bash

echo "Willkommen zur Nextcloud-Installation!"
echo "Welche Version von Nextcloud möchten Sie installieren?"
echo "1. Nextcloud 27"
echo "2. Nextcloud 28"
read -p "Geben Sie die Nummer der gewünschten Version ein: " version

if [ "$version" == "1" ]; then
    echo "Nextcloud 27 wird installiert..."
    # Hier kannst du den Code für die Installation von Nextcloud 27 einfügen
elif [ "$version" == "2" ]; then
    echo "Nextcloud 28 wird installiert..."
    # Hier kannst du den Code für die Installation von Nextcloud 28 einfügen
else
    echo "Ungültige Eingabe. Bitte geben Sie entweder 1 oder 2 ein."
fi