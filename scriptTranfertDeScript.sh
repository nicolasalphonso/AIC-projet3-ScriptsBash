#!/bin/bash
# Nicolas Alphonso - TP3 OpenClassrooms
# Script de transfert de script
# Version 1 - 23/05/2021

## création de la liste des ip des ordinateurs connectés
adressesIpAbeille=$(fping -agq 192.168.100.2 192.168.100.254)
echo -e "Adresses actives du réseau abeille:\n$adressesIpAbeille"

adressesIpBaobab=$(fping -agq 192.168.101.2 192.168.101.254)
echo -e "Adresses actives du réseau baobab:\n$adressesIpBaobab"

## transfert du fichier aux PC connectés au réseau Abeille
for adresseAbeille in $adressesIpAbeille
do
	echo "Transfert au PC: $adresseAbeille"
	# ajout de l'adresse IP aux hôtes connus (~/.ssh/known hosts)
	# si elle est inconnue - sans interaction utilisateur
	sshpass -p administrateur ssh -o StrictHostkeyChecking=no administrateur@$adresseAbeille "exit"
	# transfert du script d'initialisation
	sshpass -p administrateur scp -p /root/scripts/scriptInitialisation.sh administrateur@$adresseAbeille:/home/administrateur/scriptInitialisation.sh 
done

## transfert du fichier aux PC connectés au réseau Baobab
for adresseBaobab in $adressesIpBaobab
do
	echo "Transfert au PC: $adresseBaobab"
	sshpass -p administrateur ssh -o StrictHostkeyChecking=no administrateur@$adresseBaobab "exit"
	sshpass -p administrateur scp -p /root/scripts/scriptInitialisation.sh administrateur@$adresseBaobab:/home/administrateur/scriptInitialisation.sh

done
