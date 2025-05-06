#!/bin/Bash
#Skript numbri arvamise mängu jaoks.
#Autor: Robin Roosmaa
#Viimati muudetud: 06.05.2025

#Programm loob suvalise numbri ühest kahekümneni ja algsed muutujate väärtused.
number=$(( $RANDOM % 20 + 1))
pakutu=0
pakkumised=0
#Skripti avamisel ütleb kasutajale mängu põhimõtte.
echo "Arva ära 1 number ühest kahekümneni."
#Skript küsib kasutajalt numbrit ja ütleb, kas genereeritud number on suurem või väiksem kui pakutu.
until [ "$number" = "$pakutu" ]
do
	read pakutu
	if [ $pakutu -lt $number ]
	then
		echo "Minu number on suurem kui $pakutu. Paku uuesti:"
	fi
	if [ $pakutu -gt $number ]
	then
		echo "Minu number on väiksem kui $pakutu. Paku uuesti:"
	fi
	#Lisab iga pakkumise järgselt loendile ühe, et pakkumiste arvu salvestada.
	(( pakkumised++ ))
done
#Kui tsükkel on katkenud tänu sellele, et pakuti õige number teatatakse seda kasutajale.
echo "Õige! Number on tõesti $pakutu."
#Ning öeldakse katsete arv, mis kuluse selleni jõudmiseks.
echo "Arvasid ära $pakkumised korraga!"
