#!/bin/bash

read -p "Enter migration name:" migration
version=$(date +%s)
name="migrations/${version}__${migration}.sql"
touch  $name
echo $name
