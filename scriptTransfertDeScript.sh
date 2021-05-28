#!/bin/bash
# Nicolas Alphonso - TP3 OpenClassrooms
# Script de transfert de script
# Version 1 - 23/05/2021

## Fonction de transfert du script d'initialisation
transfert()
{
	echo "Transfert au PC: $1"
	# ajout de l'adresse IP aux hôtes connus (~/.ssh/known hosts)
	# si elle est inconnue - sans interaction utilisateur
	sshpass -p administrateur ssh -tt -o StrictHostkeyChecking=no administrateur@$1 << 'EOF'
		crontab -r
		(crontab -l 2>/dev/null; echo "14 11 * * 5 /home/administrateur/scriptInitialisation.sh > RapportInitialisation.log") | crontab -
		exit
EOF
	# transfert du script d'initialisation
	sshpass -p administrateur scp -p /root/scripts/scriptInitialisation.sh administrateur@$1:/home/administrateur/scriptInitialisation.sh 
}

## création de la liste des ip des ordinateurs connectés
adressesIpAbeille=$(fping -agq 192.168.100.2 192.168.100.254)
echo -e "Adresses actives du réseau abeille:\n$adressesIpAbeille"

adressesIpBaobab=$(fping -agq 192.168.101.2 192.168.101.254)
echo -e "Adresses actives du réseau baobab:\n$adressesIpBaobab"

## transfert du fichier aux PC connectés au réseau Abeille
for adresseAbeille in $adressesIpAbeille
do
	transfert $adresseAbeille
done

## transfert du fichier aux PC connectés au réseau Baobab
for adresseBaobab in $adressesIpBaobab
do
	transfert $adresseBaobab
done
