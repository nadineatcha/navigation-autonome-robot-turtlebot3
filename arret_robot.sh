#!/bin/bash

# Fonction pour afficher un séparateur
show_separator() {
    echo -e "\n🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴"
    echo -e "❌ $1"
    echo -e "🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴\n"
}

echo "🛑 Début de l'arrêt des processus ROS..."
echo -e "----------------------------------------\n"

# Arrêt de tous les noeuds ROS
echo "📍 Arrêt de tous les noeuds ROS..."
rosnode kill -a
sleep 2
show_separator "Tous les noeuds ROS ont été arrêtés"

# Arrêt de roscore
echo "🔄 Arrêt de roscore..."
killall -9 roscore
killall -9 rosmaster
sleep 1
show_separator "Roscore a été arrêté"

# Arrêt des processus restants de ROS
echo "🧹 Nettoyage des processus ROS restants..."
pkill -f ros
sleep 1
show_separator "Tous les processus ROS ont été nettoyés"

echo -e "\n✨ Tous les processus ROS ont été arrêtés avec succès ✨\n"
