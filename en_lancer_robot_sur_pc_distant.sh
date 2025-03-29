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
#export TURTLEBOT3_MODEL=burger

echo "🔧 ROS_MASTER_URI configuré à : $ROS_MASTER_URI"
echo "💾 Configuration ajoutée au fichier ~/.bashrc"
echo "💾 Une sauvegarde de votre fichier .bashrc a été créée : ~/.bashrc.bak"
echo "ℹ️  Ces paramètres seront chargés automatiquement dans tous les nouveaux terminaux"

# Charger l'environnement ROS
source /opt/ros/noetic/setup.bash  # Remplacez "noetic" par votre version de ROS

# Lancement du pont websocket
echo "🌐 Lancement du pont websocket..."
roslaunch rosbridge_server rosbridge_websocket.launch &

# Attendre que le pont websocket soit initialisé
sleep 3
show_separator "WEBSOCKET est maintenant actif et fonctionnel!"

# Lancement du SLAM
echo "🗺️  Lancement du SLAM..."
roslaunch turtlebot3_slam turtlebot3_slam.launch &
show_separator "SLAM est maintenant actif et fonctionnel!"

# Rappel à la fin du script
echo -e "\n🔔 RAPPEL: Vous devrez redémarrer vos terminaux existants ou exécuter 'source ~/.bashrc'"
echo -e "   Les nouveaux terminaux chargeront automatiquement cette configuration."