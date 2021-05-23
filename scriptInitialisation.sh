#!/bin/bash
#Nicolas Alphonso - TP3 OpenClassrooms
#Script version 2
# test de l'initialisation du compte utilisateur et changement du hostname
# +test de la réinitialisation de la machine

# récupération de l'adresse ip
adresseIp=$(hostname -I)
echo "Adresse Ip du PC : $adresseIp"

# détermination du numéro de la machine en gardant
# je garde la partie hôte de l'adresse ip
numeroHostname=$(echo $adresseIp | cut -c13-)
numeroHostname=$(printf %03d $numeroHostname)
echo "le numéro d'hôte est : $numeroHostname"

# détermination du réseau auquel appartient le PC
# cela donne le début du nom du hostname

debutNomHostname=""

if [[ $adresseIp == "192.168.100."* ]]
then
echo "Ce PC appartient au réseau Abeille"
debutNomHostname+="abeille"
elif [[ $adresseIp == "192.168.101."* ]]
then
echo "Ce PC appartient au réseau Baobab"
debutNomHostname+="baobab"
else
echo "Ce PC n'est connecté à aucun réseau auquel il devrait l'être"
exit 1
fi

# concaténation du hostname choisi
hostnameChoisi=${debutNomHostname}${numeroHostname}
echo "Le hostname est: $hostnameChoisi"

# changement du hostname de l'ordinateur
hostnamectl set-hostname $hostnameChoisi

# creation de l'utilisateur
# avec création préalable du groupe
addgroup $debutNomHostname

usernameChoisi=u${hostnameChoisi}

useradd ${usernameChoisi} --home /home/${usernameChoisi} --create-home --groups ${debutNomHostname} --gid ${debutNomHostname} --shell /bin/bash

echo -e "mdp\nmdp" | passwd -e ${usernameChoisi}

echo "Ce PC est initialisé avec l'utilisateur ${usernameChoisi}, le mot de passe initial \"mdp\". Il est connecté au réseau ${debutNomHostname}"

# on supprime l utilisateur d installation
userdel -r -f nicolasalphonso
echo "l'effacement du compte nicolasalphonso est confirmée"
