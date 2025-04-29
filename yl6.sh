#!/bin/Bash
#Skript failide varundamiseks sõltuvalt nädalapäevast.
#Autor: Robin Roosmaa
#Viimati muudetud: 29.04.2025

#Muutujaga määratud varundatav folder või fail.
varundada=/var/log
#Võetakse tänane kuupäev.
now=$(date +"%a")
#Määratakse varundamise asukoha muutuja nädalapäeva põhjal.
case $now in
	Mon|Wed|Fri) asukoht=/varundus/esimene;;
	Tue|Thu|Sat) asukoht=/varundus/teine;;
	Sun) asukoht=/varundus/kolmas;;
	*) ;;
esac
#Varundatakse kasutades muutujaid ja lisatakse varunduse aeg.
tar -czvf $asukoht/logbu"_"$(date +%d-%m-%Y"_"%T).tar.gz $varundada &> /dev/null
