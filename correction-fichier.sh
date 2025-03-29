#!/bin/bash
# Correction des fichiers YAML existants

MAPS_DIR=~/maps

echo "Correction des fichiers YAML dans $MAPS_DIR..."

for yaml_file in $MAPS_DIR/*.yaml; do
    # Sauvegarde du fichier original
    cp "$yaml_file" "$yaml_file.bak"
    
    # Correction du chemin de l'image
    sed -i 's/image: maps\//image: /g' "$yaml_file"
    
    echo "Fichier corrigé: $yaml_file"
done

echo "Tous les fichiers YAML ont été corrigés !"