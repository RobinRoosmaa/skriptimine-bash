#!/bin/Bash
#Skript, mis kontrollib määratud serverite toimivust ping abil.
#Autor: Robin Roosmaa
#Viimati muudetud: 06.05.2025

#IP adressid, mida pingitakse. Soovi korral saab muuta juurde lisada või eemaldada.
declare -a IPs=(10.100.0.22 10.100.0.185 10.100.0.200)

#For loop, mis teaostab protsessi eraldi iga IP kohta.
for IP in "${IPs[@]}"
do
	#Pingib märgitud IP-d 5 korda ja suunab output-i prügisse.
	ping -c 5 $IP &> /dev/null
	#if lause pingi õnnestumise põhjal.
	if [ $? -eq 0 ]
	then
		#Pingi toimimisel teatatakse sellest ja kontrollitakse serveri uptimei.
		echo "Server aadressil $IP on võrgus kättesaadav."
		echo "Server on töös olnud alates:"
		#Antud olukorras on kasutatud ühist kasutajat student, mis on kõigil serveritel.
		#Vajadusel tuleb see luua serveritele, mida pingitakse või muuta siin see kasutajaks, mis eksisteerib kõigil serveritel.
		echo $(ssh student@$IP "uptime -s")
	else
		#Pingi ebaõnnestumisel öeldakse seda kasutajale ja kirjutatakse skripti käivitamise asukohas olevasse serverid.txt faili tulemus ja selle toimumise aeg.
		echo "Server aadressil $IP pole võrgus kättesaadav."
		#Soovi korral muuta siin salvestuskoht staatiliseks soovitud logide kohaks.
		echo "Server $IP polnud saadaval $(date +%d-%m-%Y"_"%T)" >> serverid.txt
	fi
done

