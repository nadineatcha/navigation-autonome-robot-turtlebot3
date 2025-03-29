.#!/usr/bin/env python3

import rospy
import subprocess
import os
import signal
import psutil
from std_srvs.srv import Trigger, TriggerResponse

# Chemin où se trouvent les scripts
SCRIPTS_PATH = '/home/USER/catkin_ws/scripts'  # Remplacer USER par votre nom d'utilisateur

# Dictionnaire pour suivre les processus lancés
process_pids = {
    'roscore': None,
    'bringup': None, 
    'bridge': None,
    'slam': None
}

# Chemins des scripts
script_paths = {
    'roscore': os.path.join(SCRIPTS_PATH, 'turtlebot_startup.sh'),
    'bringup': os.path.join(SCRIPTS_PATH, 'turtlebot_startup.sh'),  # Même script que roscore
    'bridge': os.path.join(SCRIPTS_PATH, 'remote_pc_startup.sh'),
    'slam': os.path.join(SCRIPTS_PATH, 'remote_pc_startup.sh'),    # Même script que bridge
    'all_stop': os.path.join(SCRIPTS_PATH, 'ros_shutdown.sh')
}

def is_process_running(pid):
    """Vérifie si un processus est en cours d'exécution"""
    if pid is None:
        return False
    try:
        process = psutil.Process(pid)
        return process.is_running()
    except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
        return False

def start_service_handler(req):
    """Gestionnaire pour démarrer un service"""
    service_name = req.data if hasattr(req, 'data') else 'all'
    response = TriggerResponse()
    
    try:
        if service_name == 'roscore':
            # Démarrer roscore
            process = subprocess.Popen(['bash', script_paths['roscore']], 
                                       stdout=subprocess.PIPE, 
                                       stderr=subprocess.PIPE)
            process_pids['roscore'] = process.pid
            response.success = True
            response.message = f"Service {service_name} démarré avec PID {process.pid}"
        
        elif service_name == 'bringup':
            # Vérifier que roscore est en cours d'exécution
            if not is_process_running(process_pids['roscore']):
                response.success = False
                response.message = "Roscore n'est pas en cours d'exécution"
                return response
                
            # Démarrer bringup
            process = subprocess.Popen(['bash', script_paths['bringup']], 
                                       stdout=subprocess.PIPE, 
                                       stderr=subprocess.PIPE)
            process_pids['bringup'] = process.pid
            response.success = True
            response.message = f"Service {service_name} démarré avec PID {process.pid}"
            
        elif service_name == 'bridge':
            # Démarrer bridge
            process = subprocess.Popen(['bash', script_paths['bridge']], 
                                       stdout=subprocess.PIPE, 
                                       stderr=subprocess.PIPE)
            process_pids['bridge'] = process.pid
            response.success = True
            response.message = f"Service {service_name} démarré avec PID {process.pid}"
            
        elif service_name == 'slam':
            # Démarrer slam
            process = subprocess.Popen(['bash', script_paths['slam']], 
                                       stdout=subprocess.PIPE, 
                                       stderr=subprocess.PIPE)
            process_pids['slam'] = process.pid
            response.success = True
            response.message = f"Service {service_name} démarré avec PID {process.pid}"
            
        elif service_name == 'all':
            # Démarrer tous les services
            for svc in ['roscore', 'bringup', 'bridge', 'slam']:
                if not is_process_running(process_pids[svc]):
                    process = subprocess.Popen(['bash', script_paths[svc]], 
                                               stdout=subprocess.PIPE, 
                                               stderr=subprocess.PIPE)
                    process_pids[svc] = process.pid
            response.success = True
            response.message = "Tous les services démarrés"
        
        else:
            response.success = False
            response.message = f"Service inconnu: {service_name}"
            
    except Exception as e:
        response.success = False
        response.message = f"Erreur lors du démarrage du service: {str(e)}"
    
    return response

def stop_service_handler(req):
    """Gestionnaire pour arrêter un service"""
    service_name = req.data if hasattr(req, 'data') else 'all'
    response = TriggerResponse()
    
    try:
        if service_name == 'all':
            # Arrêter tous les services d'un coup
            subprocess.call(['bash', script_paths['all_stop']])
            for svc in process_pids:
                process_pids[svc] = None
            response.success = True
            response.message = "Tous les services arrêtés"
            
        elif service_name in process_pids:
            # Arrêter un service spécifique
            pid = process_pids[service_name]
            if pid and is_process_running(pid):
                os.kill(pid, signal.SIGTERM)
                process_pids[service_name] = None
                response.success = True
                response.message = f"Service {service_name} arrêté"
            else:
                response.success = False
                response.message = f"Service {service_name} n'est pas en cours d'exécution"
        
        else:
            response.success = False
            response.message = f"Service inconnu: {service_name}"
            
    except Exception as e:
        response.success = False
        response.message = f"Erreur lors de l'arrêt du service: {str(e)}"
    
    return response

def check_service_handler(req):
    """Gestionnaire pour vérifier l'état d'un service"""
    service_name = req.data if hasattr(req, 'data') else 'all'
    response = TriggerResponse()
    
    if service_name in process_pids:
        is_running = is_process_running(process_pids[service_name])
        response.success = is_running
        response.message = f"Service {service_name} est {'en cours d'exécution' if is_running else 'arrêté'}"
    
    elif service_name == 'all':
        all_status = {}
        for svc in process_pids:
            all_status[svc] = is_process_running(process_pids[svc])
        
        response.success = any(all_status.values())  # Au moins un service en cours d'exécution
        response.message = str(all_status)
    
    else:
        response.success = False
        response.message = f"Service inconnu: {service_name}"
    
    return response

def main():
    rospy.init_node('ros_service_manager')
    
    # Enregistrer les services
    start_service = rospy.Service('/start_service', Trigger, start_service_handler)
    stop_service = rospy.Service('/stop_service', Trigger, stop_service_handler)
    check_service = rospy.Service('/check_service', Trigger, check_service_handler)
    
    rospy.loginfo("Gestionnaire de services ROS démarré")
    
    # S'assurer que tous les services sont arrêtés au démarrage
    try:
        subprocess.call(['bash', script_paths['all_stop']])
    except Exception as e:
        rospy.logerr(f"Erreur lors de l'arrêt initial des services: {str(e)}")
    
    rospy.spin()

if __name__ == '__main__':
    main()