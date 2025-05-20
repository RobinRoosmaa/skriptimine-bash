#!/bin/Bash
#Arvestustöö skript. Interaktiivne folderi ja andmebaasi varundusskrip, võimeline varundama kohalikku ja teistesse serveritesse.
#Autor: Robin Roosmaa
#Viimati muudetud: 20.05.2025

#Varundusfaili nime muutuja, mida kasutatakse kõigi lõpplike failide puhul. Kaasatakse kuupäev ja kellaaeg. Soovi korral muudetav.
varnimi="logbu"_"$(date +%d-%m-%Y"_"%T).tar.gz"
#Varundamise asukoht teisel serveril, mis on ülesandes staatiline, aga vajadusel siin muudetav.
varfile="/var/veebivarundus"

#Alustuseks küsitakse kasutajalt, kas soovitakse varundada samas masinas asuvasse kausta või teise.
echo "Kas soovid varundada kausta või andmebaasi?"
echo
echo "a = Kausta"
echo "b = Andmebaasi"
echo
read valik
#Selle põhjal teostatakse valitud tegevus.
case $valik in
	a) #Kausta varundamise puhul küsib programm kasutajalt kausta, mida soovitakse varundada.
	echo "Millist kausta soovid varundada?"
	echo
	read varundatav
	#Kontrollitakse, kas see eksisteerib ja jätkatakse kui see eksisteerib.
	if [ -d $varundatav ]
	then
		#"Varexist" pole skriptis mujal kasutusel. Siin ta täidab ainult then-ile tegevuse andmise ülessannet, mis ei saa olla tühi.
	        Varexist=True
	else
	        Varexist=False
	        echo "Kausta $varundatav ei leitud, skript seiskub."
	        exit
	fi
	#Küsitakse kasutajalt, kas varundada kohalikku või teisse serverisse.
	echo "Kas soovid varundada kohalikku või teisse võrgus asuvasse serverisse?"
	echo
	echo "a = Kohalikku"
	echo "b = Teisse"
	echo
	read varvarjant
	#Teostab vastuse põhjal kahte võimalikku protsessi.
	case $varvarjant in
		a) #Kohaliku seadme puhul küsib kasutajalt kausta kuhu valitud kausta varundada.
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
		#Teostab kokku pakkimise ja varundamise kasutades nime muutujat.
		tar -czvf $sihtkoht/$varnimi $varundatav &> /dev/null
		#Kontrollime, kas loodud fail eksisteerib ja anname kasutajale tulemusest teada.
		if [ -f $sihtkoht/$varnimi ]
		then
			echo "Kausta $varundatav varundamine kausta $sihtkoht on lõppenud"
			echo "Varundusfaili nimi on $varnimi"
		else
			echo "Varundamine asukohta $sihtkoht ebaõnnestus. Kontrolli, et kasutajal on vajalikud õigused või käivita skript sudo käsuga."
			echo "See error esineb samuti kui te sisestasite varundatava folderi nimeks mitte midagi."
		fi ;;
		b) #Teisse serverisse varundamise puhul küsitakse serveri IP addressi, kuhu soovitakse varundada.
		echo "Sisesta serveri IP address kuhu soovid faile varundada."
		echo
		read varsrv
		#Pingime 5 korda valitud IP addressi, et kontrollida, kas see eksisteerib.
		ping -c 5 $varsrv &> /dev/null
		#if lause pingi õnnestumise põhjal.
		if [ $? -eq 0 ]
		then
			#Pingi toimimisel küsime serveri kasutajakontot, kellel on õigus kirjutada $varfile folderisse ja kes on eelnevalt ühendatud kohaliku serveriga ssh võtmega.
			echo "Sisestage kasutaja, kellel on õigus $varfile folderisse kirjutada ja kellega on jagatud ssh võti."
			echo
			read kasutaja
			#Pakime varundatava folderi kokku tar käsuga ja hoiustame selle ajutiselt kasutaja kodukaustas, et vältida õiguste probleeme.
			tar -czvf $HOME/$varnimi $varundatav &> /dev/null
			#Kopeerime ajutise faili teise serverisse kasutades sisestatud kasutajat. Juhul kui SSH võtmed pole jagatud küsitakse selle kasutaja parooli.
			scp $HOME/$varnimi $kasutaja@$varsrv:$varfile &> /dev/null
			#If lause copeerimise toimimise põhjal.
			if [ $? -eq 0 ]
			then
				#Juhul kui kopeerimine toimis teatatakse sellest kasutajale
				echo "Faili varundamine õnnestus asukohta $varfile soovitud serveril."
				echo "Varundusfaili nimi on $varnimi"
			else
				#Juhul kui see ebaõnnestus teatatakse sellest kasutajale ja pakutakse võimalikke probleeme.
				echo "Faili kopeerimine ebaõnnestus. Kontrollige, et kasutajal on õigus kirjutada $varfile folderisse ja see eksisteerib valitud serveris."
				echo "See error esineb samuti kui te sisestasite varundatava folderi nimeks mitte midagi."
			fi
			#Pärast kopeerimist ja selle toimimise kontrolli kustutame ajutise faili.
			rm $HOME/$varnimi &> /dev/null
		else
			# Serveri pingimise ebaõnnestumisel öeldakse seda kasutajale.
			echo "Server aadressil $varsrv pole võrgus kättesaadav."
		fi ;;
		#Kontroll väärade valikute jaoks.
		*) echo "Tundmatu valik, skript peatub";;
	esac ;;
	b) # Andmebaasi varundamise puhul küsitakse kasutajalt andmebaasi nime mida varundada.
	echo "Sisesta andmebaasi nimi, mida soovite varundada."
	echo
	read db
	#Küsitakse andmebaasi kasutajakontot, millel on vajalikud õigused backupi loomiseks.
	echo "Sisestage andmebaasi kasutaja, kellel on õigus andmebaasi varundada."
	echo
	read user
	#Küsitakse folderit kuhu andmebaasi varundada.
	echo "Sisesta folder kuhu soovite andmebaasi varundada."
	echo
	read dest
	#Eelnevalt mysqldump käsu andmist kirjutame kasutajale konteksti, mille parooli küsitakse.
	echo "Sisestage andmebaasi kasutaja parool."
	echo
	#Sisestame andmebaasi andmed ja loome ajutise backup faili soovitud asukohta.
	mysqldump -u $user -p $db > $dest/temp &> /dev/null
	#Kontrollime käsu toimimist.
	if [ $? -eq 0 ]
	then
		#Backup faili loomise õnnestumisel anname selle tar-ile kokku pakkimiseks.
		tar -czvf $dest/$varnimi $dest/temp &> /dev/null
		#Kontrollime varunduse loomise õnnestumist.
		if [ -f $dest/$varnimi ]
		then
			#Anname kasutajale teada, et varundamine õnnestus kui see nii on.
			echo "Andmebaasi $db varundamine kausta $dest on lõppenud"
			echo "Varundusfaili nimi on $varnimi"
		else
			#Tagastame ebaõnnestumise teate kui tar ei loonud pakitud faili.
			echo "Varundamine asukohta $dest ebaõnnestus. Kontrolli, et sisestasite andmed õigesti ja teie kasutajal on õigus sihtkohta kirjutada."
        	fi
	else
		#Juhul kui andmebaasi backup faili loomine ebaõnnestus teatatakse sellest kasutajale.
		echo "Andmebaasi varundamine ebaõnnestus. Kontrollige, et sisestasite andmed õigesti ja mysql andmebaas on üles seadud ja töötab."
	fi
	#Kustutame ajutise faili pärast protsesside lõppemist.
	rm $dest/temp &> /dev/null ;;
	#Kontroll väärade valikute jaoks.
	*) echo "Tundmatu valik, skript peatub";;
esac
