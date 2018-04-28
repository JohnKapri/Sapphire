#!/bin/bash

# if $MYSQL_USER is not set, set it to 'root'
MYSQL_USER="${MYSQL_USER:-root}"
# if $MYSQL_DATABASE is not set, set it to 'sapphire'
MYSQL_DATABASE="${MYSQL_DATABASE:-sapphire}"
# I think you get the gist
MYSQL_HOST="${MYSQL_HOST:-localhost}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
# If $MYSQL_PASSWORD is set, set $MYSQL_PWD accordingly, but don't set a
# default if it's not set. This also allows the user to set $MYSQL_PWD
# directly.
if [ ! -z $MYSQL_PASSWORD ]; then
  MYSQL_PWD=${MYSQL_PASSWORD}
fi

cd sql
mysql -u ${MYSQL_USER} -h ${MYSQL_HOST} -P ${MYSQL_PORT} -e "create database if not exists ${MYSQL_DATABASE};"
for f in *.sql
  do
    [ "$f" = "update.sql" ] && continue;
    echo -n "importing $f into the database..."
    mysql ${MYSQL_DATABASE} -u ${MYSQL_USER} -h ${MYSQL_HOST} -P ${MYSQL_PORT} < $f && echo "Success"
    CODE=$?
    if [ $CODE -ne 0 ]; then exit $CODE; fi
done
#mysql ${MYSQL_DATABASE} -u ${MYSQL_USER} -h ${MYSQL_HOST} -P ${MYSQL_PORT} < update.sql -f
echo 'todo: test update sql'
cd ..
