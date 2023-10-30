# Creation de conteneurs avec docker-compose

La création des conteneurs sera fait à l'aide de docker-compose

## Serveurs crées
- APP (api)
- DB

### Étapes
1. Ouvrir un terminal et se placer à la racine du projet
2. Faire la commande <`docker build -t 'nom de votre image' .`> sans les chevrons
3. Faire la commande <`docker-compose up`> sans les chevrons

## S'assurer que le tout fonctionne bien

Dans le fichier test.rest, roules les 3 tests en ordre.


## Mise à jour

Lors d'une mise à jour du code, le tout devrait se mettre à jour automatiquement. Cela fonctionne sur l'ordinateur de Michael Beauchamps avec mon code. 
Par contre, présentement, simplement faire un `docker-compose up` afin d'avoir les mises à jour.


## Projet fait par 
> Maxime Marchand et Francis Maynard