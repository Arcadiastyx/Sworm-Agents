# Variables
COMPOSE = docker compose
PROJECT_NAME = sworm-agents

# Commandes principales
.PHONY: help build up down restart clean clean-all logs ps test

help:
	@echo "Usage:"
	@echo "  make [command]"
	@echo ""
	@echo "Commands:"
	@echo "  build         - Construit les images Docker"
	@echo "  up            - Démarre les conteneurs"
	@echo "  down          - Arrête les conteneurs"
	@echo "  restart       - Redémarre les conteneurs"
	@echo "  logs          - Affiche les logs"
	@echo "  clean         - Nettoie les conteneurs du projet"
	@echo "  clean-all     - Nettoie tout Docker"
	@echo "  test          - Test l'API"

build:
	@echo "Construction des images..."
	$(COMPOSE) build

up:
	@echo "Démarrage des conteneurs..."
	$(COMPOSE) up -d

down:
	@echo "Arrêt des conteneurs..."
	$(COMPOSE) down

restart: down up

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	@echo "Nettoyage des conteneurs et volumes..."
	$(COMPOSE) down -v

fclean:
	@echo "Nettoyage complet de Docker..."
	@powershell -Command "if (docker ps -q) { docker stop $(docker ps -q) }"
	@powershell -Command "if (docker ps -a -q) { docker rm $(docker ps -a -q) }"
	@powershell -Command "docker system prune -af"
	@powershell -Command "docker volume prune -f"
	@echo "Nettoyage terminé"

test:
	@echo "Test de l'API..."
	@powershell -Command "try { Invoke-RestMethod -Method Get -Uri http://localhost:5000/health } catch { echo 'API non disponible' }"

# Commandes de développement
.PHONY: install dev prod pull-model

install:
	@echo "Installation des dépendances..."
	pip install -r requirements.txt

dev:
	@echo "Démarrage en mode développement..."
	$(COMPOSE) up --build

prod:
	@echo "Démarrage en mode production..."
	set FLASK_ENV=production&& $(COMPOSE) up -d

pull-model:
	@echo "Téléchargement du modèle Mistral..."
	@powershell -Command "$body = @{name='mistral'} | ConvertTo-Json; Invoke-RestMethod -Method Post -Uri http://localhost:11434/api/pull -ContentType 'application/json' -Body $body"

# Commandes de maintenance
.PHONY: prune volumes images networks

prune:
	docker system prune -f

volumes:
	docker volume ls

images:
	docker images

networks:
	docker network ls