# Creation des serveurs pour un nouveau client en déploiement

La création des serveurs est souvent une tâche ardue, donc nous avons ici simplifié les tâches à faire pour la création de ceux-ci.

## Serveurs crées
- Static
- API
- PostsgreSQL

### Étapes
1. Se créer une variable d'environnement nommée GithubAccessToken qui contiendra le token pour l'accès au repo GITHUB de votre organisation ([Comment creer une variable d'environnement](https://www.malekal.com/variables-environnement-windows/ "Création de variables d'environnement"))
2. Ouvrir POWERSHELL via le TERMINAL en tant qu'administateur système
3. Inscrire la commande suivante : ``Install-Module -Name Az -Repository PSGallery -Force``
4. Se positionner dans le dossier dans lequel le fichier newclient.ps1 se situe
5. Lancer le fichier newclient.ps1 suivit du nom du client (Ex: .\newclient.ps1 nomduclient)
6. Le navigateur va s'ouvrir et vous devez vous connecter avec votre compte Azure
7. Suivre les indications à l'écran
8. Lancer la commande ``Vagrant up``
9. Lancer la commande ``Vagrant ssh``

Une fois que vous êtes logger dans la VM, faire les commandes suivantes : 
1. cd config
2. cd NOMDUCLIENT
3. dos2unix playbook.sh
4. dos2unix setupssh.sh
5. ./setupssh.sh
    - Pour les 3 vm
        - Inscrire yes la question 
        - Inscrire le password qui a été mis dans le $adminPass dans le script newclient.ps1
        - S'assurer que Number of key(s) added: 1 soit inscrit apres avoir entré le password
6. ./playbook.sh

## S'assurer que le tout fonctionne bien

Vous pouvez vous connecter via un navigateur au IP publique du serveur static. Vous devriez voir une page avec le nom du client et la mention en construction.