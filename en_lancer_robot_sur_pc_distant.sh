# Script pour le PC distant 
#!/bin/bash

# Fonction pour afficher un séparateur
show_separator() {
    echo -e "\n🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹"
    echo -e "✅ $1"
    echo -e "🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹\n"
}

echo "🖥️  Démarrage des processus sur le PC distant..."
echo -e "----------------------------------------\n"

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
