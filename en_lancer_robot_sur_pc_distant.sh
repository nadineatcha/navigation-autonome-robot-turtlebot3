#cat en_lancer_robot_sur_pc_distant.sh 
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

# Configurer la variable d'environnement ROS_MASTER_URI avec l'IP saisie
export ROS_MASTER_URI="http://$turtlebot_ip:11311"
echo "🔧 ROS_MASTER_URI configuré à : $ROS_MASTER_URI"

# Charger l'environnement ROS (nécessaire pour les commandes ROS)
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