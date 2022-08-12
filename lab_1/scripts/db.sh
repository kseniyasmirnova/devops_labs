#!/bin/bash

if [[ "$1" != "help" && "$1" != "" && ! -f /study/lab_1/data/users.db ]]; then
	read -p "Do you want to create file? [y/n] " answer
	if [[ "$answer" == "y" ]]; then
		touch /study/lab_1/data/users.db
	else
		echo "there is no such file"
		exit 1
	fi
fi

function backup {
	backupName=$(date '+%Y-%m-%d')-users.db.backup
	cp /study/lab_1/data/users.db /study/lab_1/data/$backupName
}

function checkLatinLetters {
	if [[ $1 =~ ^[A-Za-z_]+$ ]]; then
		return 0; else
		echo "Only latin letters";
		return 1;
	fi
}

function add {
	read -p "Enter username: " username
	checkLatinLetters $username
        if [[ "$?" == 1 ]];
	then 
		exit 1
	fi

	read -p "Enter role: " role
	checkLatinLetters $role
	if [[ "$?" == 1 ]];
	then 
		exit 1
	fi
	echo "${username}, ${role}" >> /study/lab_1/data/users.db
}

function help {
	echo "Commands:"
	echo
	echo "add: add users"
	echo
	echo "backup: create backup file"
	echo
	echo "find: find user in database"
	echo
	echo "list: prints users from database"
}

function restore {
	lastFile=$(ls /study/lab_1/data/*-users.db.backup | tail -n 1)

	if [[ ! -f $lastFile ]]
	then 
		echo "no file"
		exit 1
	fi
	cat $lastFile > /study/lab_1/data/users.db
}

function find {
	read -p "Enter username: " username
	searchResult=`grep -i $username /study/lab_1/data/users.db`
	if [[ -z "$searchResult" ]]; then
		echo "No result"
       	else
		echo $searchResult
	fi
}

inverseParam=$2

function list {
 if [[ $inverseParam != '' ]]; then
	 echo `cat --number /study/lab_1/data/users.db | tac`
 else 
	 echo `cat --number /study/lab_1/data/users.db`
 fi
}

case $1 in
	add) add ;;
	backup) backup ;;
	help) help ;;
	restore) restore ;;
	find) find ;;
	list) list ;;
esac
