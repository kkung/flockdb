#!/bin/sh

echo deleting unattached shards
cat unattached-shards.txt | xargs gizzmo delete

echo renaming tables
for ID in `cat unattached-tables.txt`; do
  HOST=`echo $ID | egrep -o '^[^/]+'`
  TABLE=`echo $ID | egrep -o '[^/]+\$'`
  echo renaming $TABLE on $HOST
  echo "rename table $TABLE TO ${TABLE}_todelete" | mysql -utwitteradmin -prcycW2ytto -h$HOST edges -A
done
