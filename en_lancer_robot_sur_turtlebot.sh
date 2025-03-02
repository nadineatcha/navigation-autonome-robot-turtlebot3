# Script pour le Turtlebot3 (turtlebot_startup.sh)
#!/bin/bash

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

# Attendre que roscore soit complètement démarré
sleep 5
show_separator "ROSCORE est maintenant actif et fonctionnel!"

# Lancement du bringup
echo "🤖 Lancement du bringup Turtlebot3..."
roslaunch turtlebot3_bringup turtlebot3_robot.launch &
show_separator "BRINGUP est maintenant actif et fonctionnel!"