#!/bin/Bash
#Skript kaustade varundamiseks, mis kontrollib nende olemasolu ja varundamise edu.
#Autor: Robin Roosmaa
#Viimati muudetud: 29.04.2025

#Programm küsib kasutajalt interaktiivselt kausta, mida soovitakse Varundada.
echo "Millist kausta soovid varundada?"
read varundatav
#Kontrollitakse, kas see eksisteerib ja jätkatakse kui see eksisteerib. "Varexist" pole skriptis kasutusel. Siin ta täidab ainult then-ile tegevuse andmise rolli.
if [ -d $varundatav ]
then
        Varexist=True
else
        Varexist=False
        echo "Kausta $varundatav ei leitud, skript seiskub."
        exit
fi
echo
#Siis küsib kasutajalt kausta kuhu valitud kausta varundada.
echo "Kuhu soovid selle varundada?"
read sihtkoht
#Taas kontrollime, kas folder eksisteerib ja jätkame kui jaa. Sama jutt "Skexist" kohta nagu enne.
if [ -d $sihtkoht ]
then
        Skexist=True
else
        Skexist=False
        echo "Kausta $sihtkoht ei leitud, skript seiskub."
        exit
fi
#Teostab varundamise nimetades varundus faili logbu nimega ja hetkese kuupäeva ja kellaajaga ning kustutab väljundi välja arvatud errorid.
tar -czvf $sihtkoht/logbu"_"$(date +%d-%m-%Y"_"%T).tar.gz $varundatav &> /dev/null
#Kontrollime, kas loodud fail eksisteerib ja anname kasutajale tulemusest teada.
if [ -f $sihtkoht/logbu"_"$(date +%d-%m-%Y"_"%T).tar.gz ]
then
        echo "Kausta $varundatav varundamine kausta $sihtkoht on lõppenud"
	echo "Varundusfaili nimi on logbu"_"$(date +%d-%m-%Y"_"%T).tar.gz"
else
        echo "Varundamine asukohta $sihtkoht ebaõnnestus. Kontrolli, et kasutajal on vajalikud õigused või käivita skript sudo käsuga."
fi
