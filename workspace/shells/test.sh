#!/usr/bin/env bash

cd /etc/apache2/sites-available
for file in /etc/apache2/sites-available/*
do
  filename=$(basename "$file")

  if [ "$filename" != "sample.conf.example" ]
  then
      echo $filename
      a2ensite $filename
  fi
done

service apache2 restart;
