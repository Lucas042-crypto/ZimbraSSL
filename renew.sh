#!/bin/bash -x

PATH=/usr/sbin:/usr/local/bin:/usr/bin:/bin
export PATH

## VÁRIAVEIS

rootCa=/tmp/root.ca
## CAMINHO DO SCRIPT LETSENCRIPT letsencrypt-auto
dirLetsencryptRenew=/usr/local/sbin/letsencrypt/
##
dirLetsencrypt=/etc/letsencrypt/live/$1
dirSslZimbra=/opt/zimbra/ssl/letsencrypt

####

echo "RENOVANDO CERTIFICADO ZIMBRA"

touch  $rootCa

cat /dev/null > $rootCa

echo "-----BEGIN CERTIFICATE-----" > $rootCa

curl -sS "https://www.identrust.com/dst-root-ca-x3" | grep -C31 "BEGIN CERTIFICATE" | tail -n 31 | awk -F '/>' '{print $1}'| head -n19 | tee -a  $rootCa

## PARANDO OS SERVIÇOS

/etc/init.d/zimbra stop

## RENOVANDO OS ARQUIVOS DO LETSENCRIPT

echo "RENOVANDO AS CHAVES DO letsencrypt"

cd $dirLetsencryptRenew

./letsencrypt-auto renew

## COPIANDO PARA A PASTA DO ZIMBRA

cp $dirLetsencrypt/* $dirSslZimbra/

mv $rootCa $dirSslZimbra/chain.pem

cat $dirLetsencrypt/chain.pem | tee -a $dirSslZimbra/chain.pem

chown zimbra:zimbra $dirSslZimbra/*

## VERFICANDO AS CHAVES
cd $dirSslZimbra

su zimbra -c '/opt/zimbra/bin/zmcertmgr verifycrt comm privkey.pem cert.pem chain.pem'

mv /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key

su zimbra -c '/opt/zimbra/bin/zmcertmgr deploycrt comm cert.pem chain.pem'

/etc/init.d/zimbra start

exit 0


