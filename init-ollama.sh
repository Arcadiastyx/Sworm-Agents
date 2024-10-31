#!/bin/bash

# Attendre que Ollama soit prêt
echo "Attente du serveur Ollama..."
until curl -s http://ollama:11434/api/tags > /dev/null; do
    sleep 1
done

# Vérifier si le modèle est déjà installé
if ! curl -s http://ollama:11434/api/tags | grep -q "mistral"; then
    echo "Installation du modèle Mistral..."
    curl -X POST http://ollama:11434/api/pull -d '{"name": "mistral"}'
fi

# Démarrer l'application Flask
echo "Démarrage de l'application..."
python agent-ortho.py 