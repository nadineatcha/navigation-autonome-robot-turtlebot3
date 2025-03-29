#!/bin/bash

# Fonction pour afficher un séparateur
show_separator() {
    echo -e "\n🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹"
    echo -e "✅ $1"
    echo -e "🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹\n"
}

echo "🖥️  Démarrage des processus sur le PC distant..."
echo -e "----------------------------------------\n"

# Demander l'adresse IP du Turtlebot3 à l'utilisateur
echo -n "📡 Veuillez entrer l'adresse IP du Turtlebot3 : "
read turtlebot_ip

# Sauvegarde du fichier .bashrc
cp ~/.bashrc ~/.bashrc.bak

# Supprimer l'ancienne configuration ROS si elle existe
grep -v "ROS_MASTER_URI\|TURTLEBOT3_MODEL" ~/.bashrc > ~/.bashrc.tmp
mv ~/.bashrc.tmp ~/.bashrc

# Ajouter la nouvelle configuration à la fin du fichier
echo -e "\n# Configuration ROS Turtlebot3" >> ~/.bashrc
echo "export ROS_MASTER_URI=http://$turtlebot_ip:11311" >> ~/.bashrc
echo "export TURTLEBOT3_MODEL=burger" >> ~/.bashrc

# Exporter les variables pour la session courante
export ROS_MASTER_URI=http://$turtlebot_ip:11311
export TURTLEBOT3_MODEL=burger

echo "🔧 ROS_MASTER_URI configuré à : $ROS_MASTER_URI"
echo "💾 Configuration ajoutée au fichier ~/.bashrc"
echo "💾 Une sauvegarde de votre fichier .bashrc a été créée : ~/.bashrc.bak"
echo "ℹ️  Ces paramètres seront chargés automatiquement dans tous les nouveaux terminaux"

# Charger l'environnement ROS
source /opt/ros/noetic/setup.bash  # Remplacez "noetic" par votre version de ROS
source ~/catkin_ws/devel/setup.bash  # Chargement de votre workspace

# Création du répertoire pour les cartes s'il n'existe pas
MAPS_DIR=~/maps
if [ ! -d "$MAPS_DIR" ]; then
    mkdir -p "$MAPS_DIR"
    echo "📁 Création du répertoire pour les cartes: $MAPS_DIR"
fi

# Lancement du pont websocket
echo "🌐 Lancement du pont websocket..."
roslaunch rosbridge_server rosbridge_websocket.launch &
websocket_pid=$!

# Attendre que le pont websocket soit initialisé
sleep 3
show_separator "WEBSOCKET est maintenant actif et fonctionnel!"

# Lancement du SLAM
echo "🗺️  Lancement du SLAM..."
roslaunch turtlebot3_slam turtlebot3_slam.launch &
slam_pid=$!
sleep 3
show_separator "SLAM est maintenant actif et fonctionnel!"

# Lancement du service de sauvegarde de carte
echo "💾 Lancement du service de sauvegarde de carte..."
python3 map_saver_service.py &
map_saver_pid=$!
sleep 1
show_separator "SERVICE DE SAUVEGARDE est maintenant actif et fonctionnel!"

# Lancement du service de navigation
echo "🧭 Lancement du service de navigation..."
python3 navigation_service.py &
navigation_service_pid=$!
sleep 1
show_separator "SERVICE DE NAVIGATION est maintenant actif et fonctionnel!"

# Rappel à la fin du script
echo -e "\n🔔 RAPPEL: La navigation peut être démarrée depuis l'interface web après avoir sauvegardé une carte."
echo -e "\n🤖 Tous les services sont maintenant en cours d'exécution. Pressez Ctrl+C pour tout arrêter."

# Attendre que l'utilisateur termine avec Ctrl+C
wait $websocket_pid $slam_pid $map_saver_pid $navigation_service_pid

# Nettoyage lors de la sortie
echo -e "\n🛑 Arrêt des processus..."
kill $websocket_pid $slam_pid $map_saver_pid $navigation_service_pid 2>/dev/null
pkill -f "turtlebot3_navigation" 2>/dev/null
echo "✅ Tous les processus ont été arrêtés."