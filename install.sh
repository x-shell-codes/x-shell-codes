#!/bin/bash

########################################################################################################################
# Find Us                                                                                                              #
# Author: Mehmet ÖĞMEN                                                                                                 #
# Web   : https://x-shell.codes                                                                                        #
# Email : mailto:script@x-shell.codes                                                                                  #
# GitHub: https://github.com/x-shell-codes                                                                             #
########################################################################################################################
# Contact The Developer:                                                                                               #
# https://www.mehmetogmen.com.tr - mailto:www@mehmetogmen.com.tr                                                       #
########################################################################################################################

########################################################################################################################
# Constants                                                                                                            #
########################################################################################################################
NORMAL_LINE=$(tput sgr0)
RED_LINE=$(tput setaf 1)
YELLOW_LINE=$(tput setaf 3)
GREEN_LINE=$(tput setaf 2)
BLUE_LINE=$(tput setaf 4)
POWDER_BLUE_LINE=$(tput setaf 153)
BRIGHT_LINE=$(tput bold)
REVERSE_LINE=$(tput smso)
UNDER_LINE=$(tput smul)

########################################################################################################################
# Line Helper Functions                                                                                                #
########################################################################################################################
function ErrorLine() {
  echo "${RED_LINE}$1${NORMAL_LINE}"
}

function WarningLine() {
  echo "${YELLOW_LINE}$1${NORMAL_LINE}"
}

function SuccessLine() {
  echo "${GREEN_LINE}$1${NORMAL_LINE}"
}

function InfoLine() {
  echo "${BLUE_LINE}$1${NORMAL_LINE}"
}

########################################################################################################################
# Version                                                                                                              #
########################################################################################################################
function Version() {
  echo "x-shell-codes version 1.0.0"
  echo
  echo "${BRIGHT_LINE}${UNDER_LINE}Find Us${NORMAL}"
  echo "${BRIGHT_LINE}Author${NORMAL}: Mehmet ÖĞMEN"
  echo "${BRIGHT_LINE}Web${NORMAL}   : https://x-shell.codes"
  echo "${BRIGHT_LINE}Email${NORMAL} : mailto:script@x-shell.codes"
  echo "${BRIGHT_LINE}GitHub${NORMAL}: https://github.com/x-shell-codes"
}

########################################################################################################################
# Help                                                                                                                 #
########################################################################################################################
function Help() {
  echo "A tool you can use to generate SSL certificates."
  echo
  echo "Options:"
  echo "-d | --domain        Domain name (example.com)"
  echo "-s | --subdomain     Subdomain name (api)"
  echo "     --dbPassword    Database password"
  echo "-r | --isRemote      Is remote access server? (true/false)."
  echo "-l | --isLocal       Is local env (auto-deject). Values: true, false"
  echo "-c | --certificate   SSL Certificate installation (true). Values: true, false"
  echo "-h | --help          Display this help."
  echo "-V | --version       Print software version and exit."
  echo
  echo "For more details see https://github.com/x-shell-codes/php."
}

########################################################################################################################
# Arguments Parsing                                                                                                    #
########################################################################################################################
dbPassword="secret"
isRemote="true"

isLocal="false"
if [ -d "/vagrant" ]; then
  isLocal="true"
fi

for i in "$@"; do
  case $i in
  -d=* | --domain=*)
    domain="${i#*=}"

    if [ -z "$domain" ]; then
      ErrorLine "Domain name is empty."
      exit
    fi

    shift
    ;;
  -s=* | --subdomain=*)
    subdomain="${i#*=}"

    if [ -z "$subdomain" ]; then
      ErrorLine "Subdomain name is empty."
      exit
    fi

    shift
    ;;
  --dbPassword=*)
    dbPassword="${i#*=}"

    if [ -z "$dbPassword" ]; then
      ErrorLine "Subdomain name is empty."
      exit
    fi

    shift
    ;;
  -r=* | --isRemote=*)
    isRemote="${i#*=}"

    if [ "$isRemote" != "true" ] && [ "$isRemote" != "false" ]; then
      ErrorLine "Is remote value is invalid."
      Help
      exit
    fi

    shift
    ;;
  -l=* | --isLocal=*)
    isLocal="${i#*=}"

    if [ "$isLocal" != "true" ] && [ "$isLocal" != "false" ]; then
      ErrorLine "Is local value is invalid."
      Help
      exit
    fi

    shift
    ;;
  -h | --help)
    Help
    exit
    ;;
  -V | --version)
    Version
    exit
    ;;
  -* | --*)
    ErrorLine "Unexpected option: $1"
    echo
    echo "Help:"
    Help
    exit
    ;;
  esac
done

########################################################################################################################
# CheckRootUser Function                                                                                               #
########################################################################################################################
function CheckRootUser() {
  if [ "$(whoami)" != root ]; then
    ErrorLine "You need to run the script as user root or add sudo before command."
    exit 1
  fi
}

########################################################################################################################
# Main Program                                                                                                         #
########################################################################################################################
echo "${POWDER_BLUE_LINE}${BRIGHT_LINE}${REVERSE_LINE}INSTALLATION${NORMAL_LINE}"

CheckRootUser

export DEBIAN_FRONTEND=noninteractive

if [ -z "$domain" ]; then
  ErrorLine "Domain name is empty."
  exit
elif [ -z "$subdomain" ]; then
  ErrorLine "Subdomain name is empty."
  exit
fi

wget https://raw.githubusercontent.com/x-shell-codes/swap/master/swap.sh
sudo bash swap.sh
rm swap.sh

wget https://raw.githubusercontent.com/x-shell-codes/base/master/base.sh
sudo bash base.sh
rm base.sh

wget https://raw.githubusercontent.com/x-shell-codes/config/master/config.sh
sudo bash config.sh -d="$subdomain.$domain"
rm config.sh

wget https://raw.githubusercontent.com/x-shell-codes/nginx/master/nginx.sh
sudo bash nginx.sh -d="$domain" -s="$subdomain" -l="$isLocal" -c="false"
rm nginx.sh

wget https://raw.githubusercontent.com/x-shell-codes/php/master/php.sh
sudo bash php.sh -l="$isLocal"
rm php.sh

wget https://raw.githubusercontent.com/x-shell-codes/composer/master/composer.sh
sudo bash composer.sh
rm composer.sh

wget https://raw.githubusercontent.com/x-shell-codes/mysql/master/mysql.sh
sudo bash mysql.sh -p="$dbPassword" -r="$isRemote"
rm mysql.sh

wget https://raw.githubusercontent.com/x-shell-codes/phpmyadmin/master/phpmyadmin.sh
sudo bash phpmyadmin.sh -p="$dbPassword"
rm phpmyadmin.sh

wget https://raw.githubusercontent.com/x-shell-codes/nodejs/master/nodejs.sh
sudo bash nodejs.sh
rm nodejs.sh

wget https://raw.githubusercontent.com/x-shell-codes/redis/master/redis.sh
sudo bash redis.sh
rm redis.sh

wget https://raw.githubusercontent.com/x-shell-codes/memcached/master/memcached.sh
sudo bash memcached.sh
rm memcached.sh

wget https://raw.githubusercontent.com/x-shell-codes/puppeter/master/puppeter.sh
sudo bash puppeter.sh
rm puppeter.sh

wget https://raw.githubusercontent.com/x-shell-codes/postfix/master/postfix.sh
sudo bash postfix.sh -d="$subdomain.$domain"
rm postfix.sh

if [ "$isLocal" == "true" ]; then
  wget https://raw.githubusercontent.com/x-shell-codes/mailcatcher/master/mailcatcher.sh
  sudo bash mailcatcher.sh
  rm mailcatcher.sh
fi
