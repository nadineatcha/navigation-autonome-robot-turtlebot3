Manuel Utilisateur - Plateforme de Navigation TurtleBot3

Sommaire
Introduction


Configuration initiale


Prérequis


Installation sur le TurtleBot3


Installation sur le PC distant


Fonctionnalités principales


Contrôle à distance


Cartographie


Navigation autonome


Guide d'utilisation détaillé


Démarrage du système


Interface de contrôle manuel


Création et sauvegarde d'une carte


Configuration et exécution d'un parcours autonome


Résolution de problèmes


Informations techniques



1. Introduction
La plateforme de navigation TurtleBot3 est une solution complète pour le contrôle, la cartographie et la navigation autonome de robots mobiles TurtleBot3. Cette documentation vous guide à travers l'installation et l'utilisation de l'interface web intuitive qui vous permet de :
Contrôler manuellement votre robot TurtleBot3


Générer et sauvegarder des cartes détaillées de l'environnement


Configurer et exécuter des parcours de navigation autonome


Cette solution est conçue pour être accessible aux utilisateurs sans connaissances techniques avancées en robotique.

2. Configuration initiale
2.1 Prérequis
TurtleBot3 (modèle Burger recommandé)


PC distant sous Ubuntu 20.04 avec ROS Noetic installé


Réseau WiFi commun entre le PC distant et le TurtleBot3


2.2 Installation sur le TurtleBot3
Copiez le script en_lancer_robot_sur_turtlebot.sh sur votre TurtleBot3 (ex: /home/ubuntu/).
Rendez le script exécutable :
 chmod +x /home/ubuntu/en_lancer_robot_sur_turtlebot.sh

Pour que le TurtleBot3 démarre automatiquement, copiez le fichier de service :
 sudo cp turtlebot_startup.service /etc/systemd/system/


sudo systemctl enable turtlebot_startup.service

Démarrez le service :
 sudo systemctl start turtlebot_startup.service


2.3 Installation sur le PC distant
Assurez-vous que ROS Noetic est installé et que votre workspace catkin est configuré.


Copiez les fichiers suivants dans votre répertoire personnel :


en_lancer_robot_sur_pc_distant.sh


arret_robot.sh


map_saver_service.py


navigation_service.py


correction-fichier.sh


Fichiers HTML : index.html, controle.html, cartographie.html, navigation.html


Rendez les scripts exécutables :
 chmod +x en_lancer_robot_sur_pc_distant.sh arret_robot.sh map_saver_service.py navigation_service.py correction-fichier.sh

Créez un serveur web local :
 sudo apt install python3-http.server


cd ~/chemin/vers/dossier/contenant/fichiers_html
python3 -m http.server 8080



3. Fonctionnalités principales
3.1 Contrôle à distance
L'interface web permet de piloter manuellement le TurtleBot3 avec des boutons intuitifs pour avancer, reculer, tourner et arrêter le robot.
3.2 Cartographie
Le mode cartographie permet de générer une carte de l'environnement en utilisant SLAM (Simultaneous Localization and Mapping). Les cartes peuvent être sauvegardées pour une utilisation ultérieure.
3.3 Navigation autonome
Le robot peut naviguer de manière autonome en suivant un itinéraire défini par des points de passage.

4. Guide d'utilisation détaillé
4.1 Démarrage du système
Allumez le TurtleBot 3.
Sur le PC distant, exécutez :
 ./en_lancer_robot_sur_pc_distant.sh

Ouvrez l'interface web : http://localhost:8080


4.2 Interface de contrôle manuel
Flèche haut : avancer


Flèche bas : reculer


Flèche gauche/droite : tourner


Bouton central : arrêter


4.3 Création et sauvegarde d'une carte
Démarrez SLAM.


Déplacez le robot pour générer la carte.


Sauvegardez la carte dans ~/maps/.


4.4 Configuration et exécution d'un parcours autonome
Ajoutez des points de passage.


Démarrez le parcours.


Suivez la progression du robot sur la carte.



5. Résolution de problèmes
Problème
Solution
Connexion perdue
Vérifiez l'adresse IP et le réseau. Redémarrez le service.
Carte non affichée
Vérifiez que SLAM est activé et déplacez le robot.
Navigation erronée
Ajustez les points de passage et assurez-vous que la carte est précise.
Arrêt d'urgence
Utilisez le bouton d'arrêt ou ./arret_robot.sh.




6. Informations techniques
Structure des répertoires :


Interface web : fichiers HTML/CSS/JS


Cartes : stockées dans ~/maps/


Services : gestion de la navigation et cartographie


Technologies utilisées :


ROS Noetic


SLAM


WebSockets


HTML/CSS/JavaScript


Arrêt propre du système :


 ./arret_robot.sh


