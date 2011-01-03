#!/bin/sh

# Simple character encoding for fast, consistant sorts
LC_ALL=c

if [ -f subtrees.txt ]; then 
  echo using cached subtrees.txt
else
  echo generating subtrees.txt
  gizzmo forwardings | awk '{print $3}' | gizzmo subtree > subtrees.txt
fi

if [ -f allshards.txt ]; then
  echo using allshards.txt
else
  echo generating allshards.txt
  gizzmo hosts | gizzmo find > allshards.txt
fi

echo sorting subtrees
cat subtrees.txt | sed 's/ //g' | sort | uniq > subtrees.sorted.txt

echo sorting full shards
cat allshards.txt | sort | uniq > allshards.sorted.txt

echo calculating unattached shards
diff subtrees.sorted.txt allshards.sorted.txt | grep "^>" | sed 's/^> //g' > unattached-shards.txt

echo generating valid tables lists
cat /dev/null > valid-tables.txt
for TABLE in `cat subtrees.sorted.txt`; do
  echo "${TABLE}_edges" >> valid-tables.txt
  echo "${TABLE}_metadata" >> valid-tables.txt
done
sort valid-tables.txt > valid-tables.sorted.txt

echo generating table lists
cat /dev/null > tables.txt
HOSTS=`gizzmo hosts | grep -v localhost | grep -v hadoop`
for HOST in $HOSTS; do
  echo generating $HOST
  TABLES=`echo show tables | mysql -utwitteradmin -prcycW2ytto -h$HOST edges -A --skip-column-names`
  for TABLE in $TABLES; do
    echo "$HOST/$TABLE" >> tables.txt
  done
done
sort tables.txt > tables.sorted.txt

echo generating unattached-tables.txt
diff valid-tables.sorted.txt tables.sorted.txt | grep "^>" | sed 's/^> //g' > unattached-tables.txt

