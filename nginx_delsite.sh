#!/bin/bash

# Set config options here if needed
# These *should* work for any installations on
# Ubuntu 10.04 via apt-get

SITES_AVAILABLE_DIR='/etc/nginx/sites-available'
SITES_ENABLED_DIR='/etc/nginx/sites-enabled'
WWW_DIR='/srv/www'
WWW_USER='www-data'
WWW_GROUP='www-data'
SCRIPT_NAME=`basename $0`
SED=`which sed`

# Should't need to edit anything below this line
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
	echo "Deleting site for:" $DOMAIN
else
	echo "Invalid domain name given:" $DOMAIN
	exit 1
fi

echo -n "Are you sure you wish to delete this site? (Y/n) "
read CONFIRM
if [ ! $CONFIRM = "Y" ]; then
	echo $DOMAIN "not deleted"
	exit 1
fi

# Check if site already exists
if [ ! -d "$WWW_DIR" ]; then
  echo "Site doesnt exist at (" $WWW_DIR ")"
  exit 1
fi

# Remove hyphens and dots
SITE_DIR_NAME=`echo $DOMAIN | $SED -E 's/([\.-]+)//g'`

# Update WWW_DIR to include SITE_DIR_NAME
WWW_DIR=$WWW_DIR"/"$SITE_DIR_NAME
SITES_AVAILABLE_CONFIG=$SITES_AVAILABLE_DIR/$DOMAIN.conf
SITES_ENABLED_CONFIG=$SITES_ENABLED_DIR/$DOMAIN.conf

sudo rm -rf $WWW_DIR
sudo rm -rf $SITES_AVAILABLE_CONFIG
sudo rm -rf $SITES_ENABLED_CONFIG

sudo /etc/init.d/nginx reload

echo "Site Deleted for $DOMAIN"
