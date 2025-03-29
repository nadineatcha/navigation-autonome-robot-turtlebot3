#!/bin/bash
# Script de lancement avec cartographie d'abord, puis navigation

# Fonction pour afficher un séparateur
show_separator() {
    echo -e "\n🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹"
    echo -e "✅ $1"
    echo -e "🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹 🔹\n"
}

# Configuration ROS
# [...]

# Demander à l'utilisateur ce qu'il souhaite faire
echo "Que souhaitez-vous faire?"
echo "1 - Cartographie (SLAM)"
echo "2 - Navigation (nécessite une carte préexistante)"
read -p "Votre choix (1/2): " choice

case $choice in
    1)
        # Mode Cartographie
        echo "🗺️ Lancement du mode Cartographie..."
        
        # Lancement du pont websocket
        roslaunch rosbridge_server rosbridge_websocket.launch &
        sleep 3
        
        # Lancement du SLAM
        roslaunch turtlebot3_slam turtlebot3_slam.launch &
        sleep 3
        
        # Service de sauvegarde de carte
        python3 map_saver_service.py &
        
        echo "✅ Mode Cartographie activé. Utilisez l'interface web pour contrôler le robot et sauvegarder la carte."
        echo "Une fois la carte créée et sauvegardée, relancez ce script et choisissez l'option 2 pour la navigation."
        ;;
        
    2)
        # Mode Navigation
        echo "🧭 Lancement du mode Navigation..."
        
        # Vérifier si des cartes existent
        MAPS_DIR=~/maps
        if [ ! -d "$MAPS_DIR" ] || [ -z "$(ls -A $MAPS_DIR/*.yaml 2>/dev/null)" ]; then
            echo "❌ Aucune carte trouvée dans $MAPS_DIR"
            echo "Veuillez d'abord créer une carte avec l'option 1."
            exit 1
        fi
        
        # Lister les cartes disponibles
        echo "Cartes disponibles:"
        ls -1 $MAPS_DIR/*.yaml | cat -n
        
        # Sélectionner une carte
        read -p "Entrez le numéro de la carte à utiliser: " map_number
        selected_map=$(ls -1 $MAPS_DIR/*.yaml | sed -n "${map_number}p")
        
        if [ -z "$selected_map" ]; then
            echo "❌ Sélection invalide."
            exit 1
        fi
        
        echo "🗺️ Utilisation de la carte: $selected_map"
        
        # Lancement du pont websocket
        roslaunch rosbridge_server rosbridge_websocket.launch &
        sleep 3
        
        # Lancement de la navigation avec la carte sélectionnée
        roslaunch turtlebot3_navigation turtlebot3_navigation.launch map_file:=$selected_map &
        sleep 3
        
        echo "✅ Mode Navigation activé. Utilisez l'interface web pour définir des points de navigation."
        echo "N'oubliez pas de définir la position initiale du robot dans RViz."
        
        # Lancement de RViz pour la localisation initiale
        rosrun rviz rviz -d $(rospack find turtlebot3_navigation)/rviz/turtlebot3_navigation.rviz &
        ;;
        
    *)
        echo "❌ Choix invalide."
        exit 1
        ;;
esac

# Attente que l'utilisateur termine
echo "Appuyez sur Ctrl+C pour arrêter..."
wait