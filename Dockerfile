# image
FROM python:3.10-slim

# répertoire de travail dans le conteneur
WORKDIR /app

# Installer git et les dépendances système nécessaires
RUN apt-get update && \
    apt-get install -y git curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copier les fichiers nécessaires
COPY requirements.txt /app/
COPY init-ollama.sh /app/
COPY . /app/

# Rendre le script exécutable
RUN chmod +x /app/init-ollama.sh

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Exposer le port utilisé par l'API Flask
EXPOSE 5001

# Vérification de santé
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:5001/health || exit 1

# Utiliser le script d'initialisation comme point d'entrée
CMD ["/app/init-ollama.sh"]
