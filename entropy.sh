#!/bin/bash

shopt -s lastpipe
mktemp -d | readarray -t spo 
cd $spo
mkdir mic
shopt -s lastpipe
mktemp | readarray -t pass
shopt -s lastpipe
mktemp | readarray -t entropy
x=1
while [ $x -le 4 ]
do
    rec -c 2 mic/1.wav trim 0 15
    cat mic/1.wav | xxd -pu >> mic_entropy.txt
    sleep $(head -c 500 /dev/urandom | tr -dc '0-9' | fold -w 1 | head -n 1)
    rm -f mic/1.wav
    x=$(( $x + 1 ))
done
head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~!@#$%^&*_-' | fold -w 80 | head -n 1 > $pass
openssl enc -base64 -e -bf-cbc -in $spo/mic_entropy.txt -out $entropy -kfile $pass
shred -n 10 $pass
rm -f $pass
rm -f $spo/mic_entropy.txt
rm -rf $spo
sudo rngd -r $entropy
sleep 100
