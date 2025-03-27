#!/bin/bash

# Charger l'environnement ROS
source /opt/ros/noetic/setup.bash  # Remplacez "noetic" par votre version

# Configurer les variables réseau
export ROS_IP="192.168.216.178"  # Ou utilisez : export ROS_IP=$(hostname -I | awk '{print $1}')
export ROS_HOSTNAME="192.168.216.178"

# Fonction pour afficher un séparateur
show_separator() {
    echo -e "\n⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️"
    echo -e "✅ $1"
    echo -e "⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ ⭐️\n"
}

echo "🚀 Démarrage des processus Turtlebot3..."
echo -e "----------------------------------------\n"

# Démarrage de roscore
echo "📡 Lancement de roscore..."
roscore &
roscore_pid=$!
sleep 5
show_separator "ROSCORE est maintenant actif et fonctionnel!"

# Lancement du bringup
echo "🤖 Lancement du bringup Turtlebot3..."
roslaunch turtlebot3_bringup turtlebot3_robot.launch &
bringup_pid=$!

# Attendre que les processus se terminent (pour que systemd ne coupe pas)
wait $roscore_pid $bringup_pid