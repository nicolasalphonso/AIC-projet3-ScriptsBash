#!/bin/bash
# Nicolas Alphonso - TP3 OpenClassrooms
# Script d'initialisation / réinitialisation des machines
# connectées aux réseaux abeille et baobab

## on passe en sudo en passant une commande inutile
# car la première commande sudo est dans une boucle
echo administrateur | sudo -S echo ""


## Effacement de tous les utilisateurs sauf root et administrateur
# on récupère la liste des noms des utilisateurs
tableauUtilisateurs=$(grep bash /etc/passwd | cut -f1 -d:)

# on enlève root du tableau d'utilisateurs
tableauUtilisateurs=("${tableauUtilisateurs[@]/root}")

# on enlève administrateur du tableau d'utilisateurs
tableauUtilisateurs=("${tableauUtilisateurs[@]/administrateur}")

# on supprime les autres utilisateurs
# ainsi que leur espace personnel
for utilisateur in $tableauUtilisateurs
do
	echo "utilisateur à effacer: $utilisateur"
	sudo userdel $utilisateur
	sudo rm -r /home/$utilisateur
done

## détermination du hostname
# récupération de l'adresse ip
adresseIp=$(hostname -I)
echo "Adresse Ip du PC : $adresseIp"

# détermination du numéro de la machine en gardant
# la partie hôte de l'adresse ip sur 3 chiffres
numeroHostname=$(echo $adresseIp | cut -c13-)
numeroHostname=$(printf %03d $numeroHostname)
echo "le numéro d'hôte est : $numeroHostname"

# détermination du réseau auquel appartient le PC
# cela donne le début du nom du hostname = abeille ou baobab
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

# concaténation du hostname choisi avec le numéro d'hôte
hostnameChoisi=${debutNomHostname}${numeroHostname}
echo "Le hostname est: $hostnameChoisi"

# changement du hostname de l'ordinateur
sudo hostnamectl set-hostname $hostnameChoisi

## création de l'utilisateur
# création du groupe
# s'il existe déjà, il y aura juste un message d'avertissement
sudo addgroup $debutNomHostname

# détermination du nom d'utilisateur = u(+)réseau
usernameChoisi=u${hostnameChoisi}

# ajout de l'utilisateur avec création de son espace
sudo useradd --home-dir /home/${usernameChoisi} --create-home --groups ${debutNomHostname} --gid ${debutNomHostname} --shell /bin/bash ${usernameChoisi}

# activation de l'utilisateur en validant son mot de passe "mdp"
echo -e "mdp\nmdp" | sudo passwd ${usernameChoisi}

# le mot de passe devra être changé à la première connexion
sudo passwd -e ${usernameChoisi}

## message de fin
echo "Ce PC est initialisé avec l'utilisateur ${usernameChoisi}, le mot de passe initial \"mdp\". Il est connecté au réseau ${debutNomHostname}"
