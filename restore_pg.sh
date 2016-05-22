#!/bin/bash

# Postgresql quick and dirty db restore script (c) odayny, 2016
# https://github.com/odayny/restore_pg_sh

# Usage ./restore_pg.sh <backups location> <host> <port> <username> <password>

# Default variables

LOCATION="."
HOST="localhost"
PORT="5432"
USER="postgres"
PASSWORD="postgres"

# Read parameters

if [ $1 ]; then
	LOCATION=$1
fi
if [ $2 ]; then
	HOST=$2
fi
if [ $3 ]; then
	PORT=$2
fi
if [ $3 ]; then
	USER=$3
fi
if [ $4 ]; then
	PASSWORD=$5
fi

# Read filelist

cd $LOCATION
shopt -s nullglob
FILES=(*.backup)

for FILE in $FILES; do
	if [[ $FILE =~ (.+).backup ]]; then
    	DBNAME=${BASH_REMATCH[1]}
	else
    	echo "unable to parse string " $FILE
    	exit
	fi
	psql -c "DROP DATABASE IF EXISTS $DBNAME" -h $HOST -p $PORT -U $USER
	psql -c "CREATE DATABASE $DBNAME WITH OWNER = $USER" -h $HOST -p $PORT -U $USER
	pg_restore -d $DBNAME -F c -S $USER -h $HOST -p $PORT -U $USER -w $FILE
done
