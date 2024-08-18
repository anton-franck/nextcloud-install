# NC-Install-Scripts V2

This script installs Nextcloud.

### Prerequisites

- Ubuntu 20.04-24.04 or Debian 11 and 12
- Root privileges

## Easy Installation Guide

To install Nextcloud, follow these steps:

### Installation

1. Download the script to your local machine:
    ```shell
    wget https://raw.githubusercontent.com/anton-franck/nextcloud-install/main/install.sh
    ```

2. Give it root rights and start it:
    ```shell
    chmod +x install.sh
    ./install.sh
    ```

3. Follow the prompts to configure Nextcloud:
    1. Enter your version (you can type your own version with the .zip link).
    2. Database (set up your database password).
    3. PHP settings for your server.

4. Access Nextcloud through your web browser:
    ```plaintext
    http://{IP of your server}/
    ```

5. Create your account and add the following information:
    1. Database user: root
    2. Password: your password
    3. Database: nextcloud

Have fun!

---

**Important:**

This script is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

Copyright © 2024 Anton Franck.