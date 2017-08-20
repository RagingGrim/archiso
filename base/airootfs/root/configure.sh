#!/bin/bash

##
##	Clones a dotfiles repository.
##


## Git Functions
function clone(){
	return $(clone_adv $1 "dotfiles")
}

function clone_adv(){
	user=$1
	repo=$2

	return $(git clone https://github.com/$user/$repo ~/Github/$repo --depth=1)
}


## Helpers

function set_config(){
	return $(set_config_adv "./dotfiles" $1)
}

function set_config_adv(){
	repo=$1
	flavour=$2

	if [ -z "$repo" ]
	then
		repo="./dotfiles"
	fi

	if [ -z "$flavour" ]
	then
		flavour="default"
	fi
	
	ls $repo/$flavour
	if [ -e $repo/$flavour/link.sh ]
	then
		if [ -x $repo/$flavour/link.sh ]
		then
			$repo/$flavour/link.sh
			return $?
		else
			bash $repo/$flavour/link.sh
			return $?
		fi
	else
		echo "The specified flavour does not exist."
	fi
}



## Main
if [ -z "$1" ]
then
	echo "Usage: "
	echo "./configure.sh <user> <dotfiles_repository_name> <flavour>"
	exit 1
fi

mkdir -p ~/Github
clone_adv $1 $2
set_config_adv ~/Github/$2 $3
