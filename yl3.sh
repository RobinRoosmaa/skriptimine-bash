#!/bin/Bash
#Skript kaustade varundamiseks.
#Autor: Robin Roosmaa
#Viimati muudetud: 16.04.2025

#Programm küsib kasutajalt interaktiivselt kausta, mida soovitakse Varundada.
echo "Millist kausta soovid varundada?"
read varundatav
echo
#Siis küsib kasutajalt kausta kuhu valikud kaust kopeeritakse.
echo "Kuhu soovid selle varundada?"
read sihtkoht
#Teostab kopeerimise rekursiivselt.
tar -czvf $sihtkoht/logbu"_"$(date +%d-%m-%Y"_"%T).tar.gz $varundatav > /dev/null
echo
#Ning teatab protsessi lõppemiset kasutajale.
echo "Kausta $varundatav varundamine kausta $sihtkoht on lõppenud"
echo "Varundusfaili nimi on logbu"_"$(date +%d-%m-%Y"_"%T).tar.gz"
