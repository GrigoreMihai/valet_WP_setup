#!/bin/bash

# Check if all required arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <directory_name> <themes/plugins_folder> <git_repo_url> <valet_link>"
    exit 1
fi

# Extracting command line arguments
dir_name="$1"
folder_name="$2"
git_repo_url="$3"
valet_link="$4"

# Step 1: Create a directory
echo "Creating directory: $dir_name"
mkdir "$dir_name"

# Step 2: Navigate to the directory
cd "$dir_name" || exit

# Step 3: Download WordPress core
wp core download

# Step 4: Navigate to themes/plugins folder
cd "$folder_name" || exit

# Step 5: Clone the specified Git repository
echo "Cloning Git repository: $git_repo_url"
git clone "$git_repo_url"

# Step 6: Navigate back to the root of the project folder
cd ../../

# Step 7: Create a Valet link
echo "Creating Valet link for the project"
valet link "$valet_link"

valet_link="$valet_link.test"
# Step 8: Secure the Valet link with HTTPS
echo "Securing Valet link with HTTPS"
valet secure

# Step 9: Create and edit wp-config.php
echo "Creating and editing wp-config.php"
echo "<?php
define( 'DB_NAME', '$dir_name' );
define( 'DB_USER', 'root' );
define( 'DB_PASSWORD', '' );
define( 'DB_HOST', 'localhost:3306' );
define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', '' );
define( 'AUTH_KEY',         '$rqv;y{sGGuzc@=2P OOR}>9bVTS3%>I0{3j0/|TXx+PO`M6/;%I_|KY6[ubo2>J' );
define( 'SECURE_AUTH_KEY',  '5eBG%|BQF=FA7_92lFK*OQ:.urY=t3vw3&C:Rf3ymhz!X2k@ol7:V0DcME/t*pv@' );
define( 'LOGGED_IN_KEY',    'y 2_m2dzMn`>j(kLo&O%`c!|[r_)QBV%FxfnqVyl!-`1RG3Lcf7=@!`m~mGIu[e6' );
define( 'NONCE_KEY',        '~c=3Itq;ve=%_Y(^hP%fL}@m^FRpLo(I&=~ti#SogIbktlE@-m*#,H.g1iwH@[/A' );
define( 'AUTH_SALT',        'Kyc[;hbka_r[[%HqZYOZ$e #r_Hjc)SCyz4Qt|eUQ%%M|A~_:#Twt~aJ3]/nslU?' );
define( 'SECURE_AUTH_SALT', 'tZT(IN=YR_FqLy^XF/?F*4$.wCk4U}rN$.K&~9,^p8ss4|x0l)n;R6tg,/HJwqgr' );
define( 'LOGGED_IN_SALT',   '0G+L3p/4<Tabf/]|;e7T>p)?52h4e=MB!Q~Q<eCBC$=F`&0) @0/ceH5&X`-l7A:' );
define( 'NONCE_SALT',       'V;(v_W/0o7?s<P=saYW9j63w`654_B=L;dR0x5}~Y=BDY_cMEz9lfDR8>XDnxTQD' );
\$table_prefix = 'wp_';
if ( isset( \$_SERVER['HTTP_X_FORWARDED_PROTO'] ) && strpos( \$_SERVER['HTTP_X_FORWARDED_PROTO'], 'https' ) !== false ) {
    \$_SERVER['HTTPS'] = 'on';
}
define( 'REQUEST_ORIGIN', ( ! empty( \$_SERVER['HTTPS'] ) ? 'https://' : 'http://' ) . ( ! empty( \$_SERVER['HTTP_X_FORWARDED_HOST'] ) ? \$_SERVER['HTTP_X_FORWARDED_HOST'] : '$valet_link' ) );
define( 'WP_SITEURL', REQUEST_ORIGIN );
define( 'WP_HOME', REQUEST_ORIGIN );
define( 'WP_DEBUG', true);
define( 'WP_DEBUG_LOG', true);
define( 'WP_DEBUG_DISPLAY', false );
require_once ABSPATH . 'wp-settings.php';" > wp-config.php

# Step 10: Create an empty MySQL schema
echo "Creating MySQL schema: $dir_name"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS $dir_name;"

echo "Setup completed successfully."
