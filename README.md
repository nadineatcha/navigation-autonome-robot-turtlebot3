# 🤖 Plateforme de Navigation TurtleBot3

Une interface web complète pour le contrôle, la cartographie et la navigation autonome des robots TurtleBot3, utilisant ROS Noetic.

![TurtleBot3](https://raw.githubusercontent.com/ROBOTIS-GIT/emanual/master/assets/images/platform/turtlebot3/logo_turtlebot3.png)

## 📋 Table des Matières

- [À propos](#à-propos)
- [Fonctionnalités](#fonctionnalités)
- [Architecture](#architecture)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Services](#services)
- [Dépannage](#dépannage)
- [Contribution](#contribution)
- [Licence](#licence)
- [Contact](#contact)

## 🔍 À propos

Cette plateforme offre une solution complète pour piloter et automatiser des robots TurtleBot3, rendant accessibles les technologies robotiques avancées sans nécessiter de connaissances techniques approfondies. Le système combine une interface web intuitive avec des services backend robustes pour permettre un contrôle précis, une cartographie efficace et une navigation autonome.

## ✨ Fonctionnalités

### 🎮 Contrôle à Distance
- Interface web intuitive pour piloter manuellement le robot
- Contrôle précis avec retour d'état en temps réel
- Compatible avec tous les navigateurs modernes

### 🗺️ Cartographie 
- Génération automatique de cartes détaillées de l'environnement via SLAM
- Visualisation en temps réel de la carte en cours de création
- Sauvegarde automatique des cartes avec horodatage

### 🧭 Navigation Autonome
- Définition de points de passage par simple clic sur la carte
- Planification automatique des trajectoires optimisées
- Fonctionnalités de pause, reprise et arrêt d'urgence
- Visualisation en temps réel du parcours et de la position du robot

## 🏛️ Architecture

Le système repose sur une architecture client-serveur :

- **Frontend** : Interface utilisateur responsive en HTML/CSS/JavaScript
- **Communication** : WebSockets via rosbridge pour une communication bidirectionnelle en temps réel
- **Backend** : Services ROS en Python et scripts bash pour l'automatisation
- **Framework** : ROS Noetic pour la communication inter-processus robotique

## 💻 Installation

### Prérequis

- Ubuntu 20.04
- ROS Noetic
- TurtleBot3 (réel ou simulé avec Gazebo)
- Node.js et npm (pour le développement frontend)
- Python 3.8+

### Installation sur le PC de contrôle

```bash
# Cloner le dépôt
git clone https://github.com/votre-username/turtlebot3-nav-platform.git
cd turtlebot3-nav-platform

# Installer les dépendances ROS
sudo apt-get update
sudo apt-get install -y ros-noetic-rosbridge-server
sudo apt-get install -y ros-noetic-turtlebot3-*

# Configurer le workspace
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
cp -r ~/turtlebot3-nav-platform/* .
cd ..
catkin_make

# Rendre les scripts exécutables
chmod +x ~/catkin_ws/src/scripts/*.sh
chmod +x ~/catkin_ws/src/scripts/*.py
```

### Configuration sur le TurtleBot3

```bash
# Sur le robot TurtleBot3
ssh ubuntu@<IP-DU-TURTLEBOT>

# Copier le script de démarrage
scp ~/catkin_ws/src/scripts/en_lancer_robot_sur_turtlebot.sh ubuntu@<IP-DU-TURTLEBOT>:~/

# Configurer le service systemd
sudo cp ~/catkin_ws/src/config/turtlebot_startup.service /etc/systemd/system/
sudo systemctl enable turtlebot_startup.service
sudo systemctl start turtlebot_startup.service
```

## 🚀 Utilisation

### Démarrer le système sur le PC de contrôle

```bash
# Configurer l'environnement ROS
export TURTLEBOT3_MODEL=burger  # ou waffle ou waffle_pi selon votre modèle

# Lancer la plateforme
cd ~/catkin_ws
./src/scripts/en_lancer_robot_sur_pc_distant.sh
```

### Accéder à l'interface web

Ouvrez votre navigateur et accédez à :
```
http://localhost:8000
```

### Utilisation de l'interface

1. **Page d'accueil** : Vue d'ensemble des fonctionnalités disponibles
2. **Contrôle** : Pilotage manuel du robot avec les flèches directionnelles
3. **Cartographie** : Création et sauvegarde de cartes de l'environnement
4. **Navigation** : Configuration et exécution de parcours autonomes

## 🔧 Services

Le système comprend plusieurs services pour faciliter les opérations :

### `map_saver_service.py`
Sauvegarde automatique des cartes avec horodatage et correction des chemins.

### `navigation_service.py`
Gestion des opérations de navigation autonome, avec démarrage/arrêt automatisés.

### Scripts d'automatisation
- `en_lancer_robot_sur_turtlebot.sh` : Script de démarrage sur le robot
- `en_lancer_robot_sur_pc_distant.sh` : Script de démarrage sur le PC de contrôle
- `arret_robot.sh` : Arrêt propre de tous les services ROS

## ⚠️ Dépannage

### Problèmes de connexion WebSocket
Vérifiez que rosbridge est correctement lancé :
```bash
roslaunch rosbridge_server rosbridge_websocket.launch
```

### Erreurs de sauvegarde de carte
Assurez-vous que le répertoire `~/maps` existe et que l'utilisateur courant a les droits d'écriture.

### Navigation non fonctionnelle
- Vérifiez que la carte est correctement chargée
- Assurez-vous que la position initiale du robot est définie
- Vérifiez les logs ROS avec `roslaunch --screen`

## 👥 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :

1. Fork le projet
2. Créer une branche pour votre fonctionnalité (`git checkout -b feature/amazing-feature`)
3. Commit vos changements (`git commit -m 'Add some amazing feature'`)
4. Push sur la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus d'informations.

## 📞 Contact

Nadine ATCHA - Développeuse et responsable du projet

Développé avec ❤️ pour simplifier l'utilisation des robots TurtleBot3.
