#!/bin/Bash
#interactiivne skript folderi varundamiseks ja tühjendamiseks.
#Autor: Robin Roosmaa
#Viimati muudetud: 29.04.2025

#Defineeritakse muutujatega kausta, mida mõjutatakse ja varunduse asukoht.
kaust=/var/vanadfailid
asukoht=/varundus/backups
#if lause toimel kontrollitakse, kas määratud folderid eksisteerivad. "exist" muutuja on hetkel kasutu, aga then peab midagi tegema.
if [ -d $kaust ] && [ -d $asukoht ]
then
	exist=True
else
	exist=False
	echo "Kausta $kaust ja/või sihtkohta $asukoht ei leitud, skript seiskub."
	exit
fi
#Pärast kontrolli läbi minemist küsitakse kasutajalt, mida teha.
echo "Mida soovid kaustaga $kaust teha?"
echo
echo "a = Soovin kausta varundada."
echo "b = Soovin kausta sisu kustutada."
echo
read valik
#Sisestatud valiku põhjal kas varundatakse failid kuupäevaga soovitud kausta või kustutatakse mõjutatava folderi sisu. Tundmatu valik annab veateate.
case $valik in
	a) tar -czvf $asukoht/logbu"_"$(date +%d-%m-%Y).tar.gz $kaust &> /dev/null
	echo "Varundus asukohta $asukoht/logbu"_"$(date +%d-%m-%Y"_"%T).tar.gz teostatud.";;
	b) rm -r $kaust/* &> /dev/null #Lisatud väljastuse kustutus, et vältida veateadet failide puudumise korral folderist.
	echo "Kausta $kaust sisu on kustutatud";;
	*) echo "Tundmatu valik (oodatud a või b), skript peatatud";;
esac
