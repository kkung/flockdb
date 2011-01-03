#!/bin/sh

echo dropping tables
HOSTS=`gizzmo hosts | grep -v localhost | grep -v hadoop`
for HOST in $HOSTS; do
  TABLES=`echo show tables | mysql -utwitteradmin -prcycW2ytto -h$HOST edges -A --skip-column-names | grep todelete`
  for TABLE in $TABLES; do
    echo dropping $TABLE on $HOST
    echo DROP TABLE $TABLE | mysql -utwitteradmin -prcycW2ytto -h$HOST edges -A
    sleep 0.2
  done
  # Give host chance to possibly un-darkmode, if neccessary.
  sleep 120
done

