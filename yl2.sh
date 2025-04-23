#!/bin/Bash
#Failide kopeerimise interaktiivne skript.
#Autor: Robin Roosmaa
#Viimati muudetud: 23.04.2025

#Programm küsib kasutajalt interaktiivselt kausta, mida soovitakse kopeerida.
echo "Millist kausta soovid kopeerida?"
read kopeeritav
echo
#Siis küsib kasutajalt kausta kuhu valikud kaust kopeeritakse.
echo "Kuhu soovid selle kopeerida?"
read sihtkoht
#Teostab kopeerimise rekursiivselt.
cp $kopeeritav $sihtkoht -R
echo
#Ning teatab protsessi lõppemiset kasutajale.
echo "Kausta $kopeeritav kopeerimine kausta $sihtkoht on lõppenud"
