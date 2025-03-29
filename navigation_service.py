#!/usr/bin/env python3

import rospy
import subprocess
import os
from std_srvs.srv import Trigger, TriggerResponse
import glob

# Répertoire où les cartes sont sauvegardées avec chemin absolu
MAPS_DIR = os.path.expanduser("~/maps/")

def handle_start_navigation(req):
    """Gestionnaire pour le service de lancement de navigation"""
    response = TriggerResponse()
    
    try:
        # Vérifier si des cartes existent
        map_files = glob.glob(os.path.join(MAPS_DIR, "*.yaml"))
        
        if not map_files:
            response.success = False
            response.message = "Aucune carte trouvée. Veuillez d'abord créer et sauvegarder une carte."
            rospy.logerr("Aucune carte trouvée dans " + MAPS_DIR)
            return response
        
        # Trier les cartes par date de modification (la plus récente en premier)
        map_files.sort(key=os.path.getmtime, reverse=True)
        latest_map = os.path.abspath(map_files[0])  # Utiliser le chemin absolu
        
        # Vérifier si navigation est déjà en cours
        ps_output = subprocess.check_output(["ps", "-ef"]).decode("utf-8")
        if "turtlebot3_navigation" in ps_output:
            response.success = False
            response.message = "La navigation est déjà en cours d'exécution."
            rospy.logwarn("Tentative de lancement alors que navigation est déjà en cours")
            return response
        
        # Lancer navigation avec la carte la plus récente en utilisant le chemin absolu
        cmd = ["roslaunch", "turtlebot3_navigation", "turtlebot3_navigation.launch", 
               f"map_file:={latest_map}", "initial_pose_x:=0.0", "initial_pose_y:=0.0", "initial_pose_a:=0.0"]
        
        subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        response.success = True
        response.message = f"Navigation démarrée avec la carte: {os.path.basename(latest_map)}"
        rospy.loginfo(f"Navigation démarrée avec: {latest_map}")
        
    except Exception as e:
        response.success = False
        response.message = f"Erreur lors du lancement de la navigation: {str(e)}"
        rospy.logerr(f"Exception lors du lancement de la navigation: {str(e)}")
    
    return response

def handle_stop_navigation(req):
    """Gestionnaire pour le service d'arrêt de navigation"""
    response = TriggerResponse()
    
    try:
        # Arrêter tous les processus de navigation
        subprocess.call(["pkill", "-f", "turtlebot3_navigation"])
        
        response.success = True
        response.message = "Navigation arrêtée avec succès"
        rospy.loginfo("Navigation arrêtée")
        
    except Exception as e:
        response.success = False
        response.message = f"Erreur lors de l'arrêt de la navigation: {str(e)}"
        rospy.logerr(f"Exception lors de l'arrêt de la navigation: {str(e)}")
    
    return response

def navigation_service_server():
    """Démarrer les services de gestion de la navigation"""
    rospy.init_node('navigation_service')
    
    # Service pour démarrer la navigation
    start_service = rospy.Service('/start_navigation', Trigger, handle_start_navigation)
    
    # Service pour arrêter la navigation
    stop_service = rospy.Service('/stop_navigation', Trigger, handle_stop_navigation)
    
    rospy.loginfo("Services de navigation prêts")
    rospy.spin()

if __name__ == "__main__":
    navigation_service_server()