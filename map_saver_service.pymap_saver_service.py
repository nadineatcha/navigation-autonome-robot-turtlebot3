#!/usr/bin/env python3

import rospy
import subprocess
import os
from std_srvs.srv import Trigger, TriggerResponse

# Répertoire où les cartes seront sauvegardées
MAPS_DIR = os.path.expanduser("~/maps")

def handle_save_map(req):
    """Gestionnaire pour le service de sauvegarde de carte"""
    response = TriggerResponse()
    
    # Créer le répertoire maps s'il n'existe pas
    if not os.path.exists(MAPS_DIR):
        os.makedirs(MAPS_DIR)
    
    # Générer un nom de fichier avec horodatage
    from datetime import datetime
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    map_name = f"map_{timestamp}"
    map_path = os.path.join(MAPS_DIR, map_name)
    
    try:
        # Exécuter la commande map_saver
        cmd = ["rosrun", "map_server", "map_saver", "-f", map_path]
        process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = process.communicate()
        
        if process.returncode == 0:
            response.success = True
            response.message = f"Carte sauvegardée avec succès: {map_path}"
            rospy.loginfo(f"Carte sauvegardée: {map_path}")
        else:
            response.success = False
            response.message = f"Erreur lors de la sauvegarde: {stderr.decode('utf-8')}"
            rospy.logerr(f"Erreur de sauvegarde: {stderr.decode('utf-8')}")
    
    except Exception as e:
        response.success = False
        response.message = f"Exception: {str(e)}"
        rospy.logerr(f"Exception lors de la sauvegarde: {str(e)}")
    
    return response

def map_saver_server():
    """Démarrer le service de sauvegarde de carte"""
    rospy.init_node('map_saver_service')
    s = rospy.Service('/save_map', Trigger, handle_save_map)
    rospy.loginfo("Service de sauvegarde de carte prêt")
    rospy.spin()

if __name__ == "__main__":
    map_saver_server()