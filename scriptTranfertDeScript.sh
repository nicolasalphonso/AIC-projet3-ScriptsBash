#!/bin/bash
# Nicolas Alphonso - TP3 OpenClassrooms
# Script de transfert de script
# Version 1 - 23/05/2021

# Fonction de transfert de fichier
# argument : liste des IP des machines où il faut transférer le fichier
transfert_fichier()
{
for adresse in $1
	do
		echo "Transfert au PC : $adresse"
		sshpass -p administrateur scp -p /root/scripts/scriptInitialisation.sh administrateur@$adresse:/home/administrateur/scriptInitialisation.sh
	done
}

adresseFichierTransfert=""

#création de la liste des ip des ordinateurs connectés
adressesIpAbeille=$(fping -agq 192.168.100.2 192.168.100.254)
adressesIpBaobab=$(fping -agq 192.168.101.2 192.168.101.254)

echo "Adresses du réseau abeille actives: $adressesIpAbeille"
echo "Adresses du réseau baobab actives: $adressesIpBaobab"

transfert_fichier $adressesIpAbeille
transfert_fichier $adressesIpBaobab
