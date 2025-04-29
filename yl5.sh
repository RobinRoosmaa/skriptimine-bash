#!/bin/Bash
#Skript faili või kausta liigutamiseks või kopeerimiseks kasutaja valikul.
#Autor: Robin Roosmaa
#Viimati muudetud: 29.04.2025

#Alustuseks küsitakse kasutajalt, kas soovitakse kopeerida või liigutada kausta.
echo "Kas soovid kausta kopeerida või liigutada, tee oma valik:"
echo
echo "a = kausta kopeerimine"
echo "b = kausta liigutamine"
echo
read valik
#Siis teostatalse selle põhjal 3 võimalikku tulemust.
case $valik in
	#Juhul kui valiti a teostatakse interaktiivne kopeerimine.
	a) echo "Millist kausta soovid kopeerida?"
	read kopeeritav
	echo "Kuhu kausta sa soovid seda kopeerida?"
	read cp_sihtkoht
	cp -R $kopeeritav $cp_sihtkoht
	echo "Kausta $kopeeritav kopeerimine kausta $cp_sihtkoht on lõppenud.";;
	#Juhul kui valiti b teostatakse interaktiivne liigutamine.
	b) echo "Millist kausta soovid liigutada?"
	read liigutatav
	echo "Kuhu kausta sa soovid seda liigutada?"
	read mv_sihtkoht
	mv $liigutatav $mv_sihtkoht
	echo "Kausta $liigutatav liigutamine kausta $mv_sihtkoht on lõppenud.";;
	#Vastasel juhul teatatakse, et valikut ei mõistetud ja skript lõppes.
	*) echo "Tundmatu valik, skript peatataud"
esac
