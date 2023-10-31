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

Lors d'une mise à jour du code et de la sauvegarde de celui ci, le conteneur se met a jour avec le nouveau code et il repart automatiquement


## Projet fait par 
> Maxime Marchand et Francis Maynard