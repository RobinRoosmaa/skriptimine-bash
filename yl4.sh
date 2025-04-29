#!/bin/Bash
#Failide varundamise skript
#Autor: Robin Roosmaa
#Viimati muudetud: 29.04.2025

#Defineerib muutujad varundatava directori ja varunduspaiga ning varundab lisades aja ja kustutades kõik outputid.
varundada=/var/log
asukoht=/varundus
tar -czvf $asukoht/logbu"_"$(date +%d-%m-%Y"_"%T).tar.gz $varundada &> /dev/null
