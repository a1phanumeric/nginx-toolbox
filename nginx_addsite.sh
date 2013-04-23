#!/bin/bash

# Set config options here if needed
# These *should* work for any installations on
# Ubuntu 10.04 via apt-get

SITES_AVAILABLE_DIR='/etc/nginx/sites-available'
SITES_ENABLED_DIR='/etc/nginx/sites-enabled'
WWW_DIR='/srv/www'
WWW_USER='www-data'
WWW_GROUP='www-data'


# Should't need to edit anything below this line
SED=`which sed`
CURRENT_DIR=`dirname $0`
SCRIPT_NAME=`basename $0`

if [ -z $1 ]; then
	echo "Usage: ./"$SCRIPT_NAME" <domain name>"
	exit 1
fi

# Clean domain (strip http:// and/or www.)
DOMAIN=`echo "$1" | sed -E 's~(http[s]*://)?(www\.)?~~g'`

# Validate domain
PATTERN="^([[:alnum:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)+[[:alpha:]]{2,6}$"
if [[ "$DOMAIN" =~ $PATTERN ]]; then
	DOMAIN=`echo $DOMAIN | tr '[A-Z]' '[a-z]'`
	echo "Creating site for:" $DOMAIN
else
	echo "Invalid domain name given:" $DOMAIN
	exit 1
fi

# Remove hyphens and dots
SITE_DIR_NAME=`echo $DOMAIN | $SED -E 's/([\.-]+)//g'`

# Update WWW_DIR to include SITE_DIR_NAME
WWW_DIR=$WWW_DIR"/"$SITE_DIR_NAME

# Check if site already exists
if [ -d "$WWW_DIR" ]; then
  echo "Site already exists at" $WWW_DIR
  exit 1
fi

# Now we need to copy the virtual host template
VHOST_CONFIG=$SITES_AVAILABLE_DIR/$DOMAIN.conf
sudo cp $CURRENT_DIR/virtual_host.template $VHOST_CONFIG
sudo $SED -i "s/DOMAIN/$DOMAIN/g" $VHOST_CONFIG
sudo $SED -i "s/SITE_DIR_NAME/$SITE_DIR_NAME/g" $VHOST_CONFIG
sudo $SED -i "s!ROOT!$WWW_DIR/public_html!g" $VHOST_CONFIG

# set up web root
sudo mkdir -p $WWW_DIR/public_html
sudo mkdir $WWW_DIR/logs
sudo chown $WWW_USER:$WWW_GROUP -R $WWW_DIR
sudo chmod 600 $VHOST_CONFIG

# create symlink to enable site
sudo ln -s $VHOST_CONFIG $SITES_ENABLED_DIR/$DOMAIN.conf

# reload Nginx to pull in new config
sudo /etc/init.d/nginx reload

# put the template index.html file into the new domains web dir
sudo cp $CURRENT_DIR/index.html.template $WWW_DIR/public_html/index.html
sudo $SED -i "s/SITE/$DOMAIN/g" $WWW_DIR/public_html/index.html
sudo chown $WWW_USER:$WWW_GROUP $WWW_DIR/public_html/index.html

echo "Site Created for $DOMAIN"
