#!/bin/Bash
#Failide kopeerimise interaktiivne skript.
#Autor: Robin Roosmaa
#Viimati muudetud: 23.04.2025

varundada=/var/log
asukoht=/varundus
tar -czvf $asukoht/logbu"_"$(date +%d-%m-%Y"_"%T).tar.gz $varundada &> /dev/null
