#!/bin/Bash
#Arvestus töö skript. Interaktiivne varundusskript.
#Autor: Robin Roosmaa
#Viimati muudetud: 20.05.2025

#Failinimi muutujana, mida korduvalt kasutatakse.
varnimi="logbu"_"$(date +%d-%m-%Y"_"%T).tar.gz"
#Alustuseks küsitakse kasutajalt, kas soovitakse varundada samas masinas asuvasse kausta või teise.
echo "Kas soovid varundada kausta või andmebaasi?"
echo
echo "a = Kausta"
echo "b = Andmebaasi"
echo
read valik
#Selle põhjal teostatakse valitud tegevus.
case $valik in
	a) #Programm küsib kasutajalt interaktiivselt kausta, mida soovitakse Varundada.
	echo "Millist kausta soovid varundada?"
	echo
	read varundatav
	#Kontrollitakse, kas see eksisteerib ja jätkatakse kui see eksisteerib. "Varexist" pole skriptis kasutusel. Siin ta täidab ainult then-ile tegevuse andmise >
	if [ -d $varundatav ]
	then
	        Varexist=True
	else
	        Varexist=False
	        echo "Kausta $varundatav ei leitud, skript seiskub."
	        exit
	fi
	echo "Kas soovid varundada siinsesse serverisse või teisse?"
	echo
	echo "a = Siinsesse"
	echo "b = Teisse"
	echo
	read varvarjant
	case $varvarjant in
		a) #Siis küsib kasutajalt kausta kuhu valitud kausta varundada.
		echo "Sisesta kaust kuhu soovid varundada?"
		echo
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
		tar -czvf $sihtkoht/$varnimi $varundatav &> /dev/null
		#Kontrollime, kas loodud fail eksisteerib ja anname kasutajale tulemusest teada.
		if [ -f $sihtkoht/$varnimi ]
		then
			echo "Kausta $varundatav varundamine kausta $sihtkoht on lõppenud"
			echo "Varundusfaili nimi on $varnimi"
		else
			echo "Varundamine asukohta $sihtkoht ebaõnnestus. Kontrolli, et kasutajal on vajalikud õigused või käivita skript sudo käsuga."
		fi ;;
		b) #Kasutajalt küsitakse varundus serveri IP adressi, kuhu soovitakse varundada.
		echo "Serveri IP address kuhu soovid faile varundada."
		echo
		read varsrv
		ping -c 5 $varsrv &> /dev/null
		#if lause pingi õnnestumise põhjal.
		if [ $? -eq 0 ]
		then
			echo "Sisestage kasutaja, kellel on õigus /var/veebivarundus folderisse kirjutada ja kellega on jagatud ssh võti."
			echo
			read kasutaja
			tar -czvf $HOME/$varnimi $varundatav &> /dev/null
			scp $HOME/$varnimi $kasutaja@$varsrv:/var/veebivarundus &> /dev/null
			if [ $? -eq 0 ]
			then
				echo "Faili varundamine õnnestus asukohta /var/veebivarundus soovitud serveril."
				echo "Varundusfaili nimi on $varnimi"
			else
				echo "Faili kopeerimine ebaõnnestus. Kontrollige, et kasutajal on õigus kirjutada /var/veebivarundus folderisse ja see eksisteerib valitud serveris."
			fi
			rm $HOME/$varnimi
		else
                	#Pingi ebaõnnestumisel öeldakse seda kasutajale ja kirjutatakse >
			echo "Server aadressil $IP pole võrgus kättesaadav."
		fi ;;
		*) echo "Tundmatu valik, skript peatub";;
	esac ;;
	b) #Skript küsib kasutajalt andmebaasi nime mida varundada.
	echo "Sisesta andmebaasi nimi, mida soovite varundada."
	echo
	read db
	echo "Sisestage andmebaasi kasutaja, kellel on õigus andmebaasi varundada."
	echo
	read user
	echo "Sisesta folder kuhu soovite andmebaasi varundada."
	echo
	read dest
	echo "Sisestage andmebaasi kasutaja parool."
	echo 
	mysqldump -u $user -p $db > $dest/temp &> /dev/null
	if [ $? -eq 0 ]
	then
		tar -czvf $dest/$varnimi $dest/temp &> /dev/null
		if [ -f $dest/$varnimi ]
		then
			echo "Andmebaasi $db varundamine kausta $dest on lõppenud"
                	echo "Varundusfaili nimi on $varnimi"
		else
			echo "Varundamine asukohta $dest ebaõnnestus. Kontrolli, et sisestasite andmed õigesti ja teie kasutajal on õigus sihtkohta kirjutada."
        	fi
	else
		echo "Andmebaasi varundamine ebaõnnestus. Kontrollige, et sisestasite andmed õigesti ja mysql andmebaas on üles seadud ja töötab."
	fi
	rm $dest/temp ;;
	*) echo "Tundmatu valik, skript peatub";;
esac
