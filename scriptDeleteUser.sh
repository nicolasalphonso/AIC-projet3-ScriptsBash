##Script pour supprimer tous les utilisateurs d'une machine
#excepté root et administrateur
# Nicolas Alphonso V1

#sudo car le premier sudo est dans une boucle
echo administrateur | sudo -S echo ""

#tableau des utilisateurs
tab=$(grep bash /etc/passwd | cut -f1 -d:)

# On enlève root
tab=("${tab[@]/root}")

# On enlève administrateur
tab=("${tab[@]/administrateur}")

# On efface chaque utilisateur affiché dans le tableau
for $user in $tab
do
	sudo userdel $user
	sudo rm -r /home/$user
done

