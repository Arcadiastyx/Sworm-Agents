@"
# Sworm-Agents - Traducteur & Correcteur

Un service de traduction et correction automatique utilisant Ollama avec le modèle Mistral.

## Prérequis

- Docker
- Docker Compose
- PowerShell (Windows) ou Bash (Linux/Mac)
- Make (optionnel)

## Installation

1. **Cloner le projet**
\`\`\`bash
git clone [git@github.com:Arcadiastyx/Sworm-Agents.git]
cd Sworm-Agents
\`\`\`

2. **Configuration**
\`\`\`bash
# Copier le fichier d'environnement
cp .env.example .env
\`\`\`

3. **Démarrage**
\`\`\`bash
# Avec Make
make build-full

# Sans Make
docker compose up --build -d
\`\`\`

## Utilisation

### 1. Script PowerShell (Recommandé)
\`\`\`powershell
# Lancer le script de traduction interactif
.\translate.ps1
\`\`\`
Ce script vous permet de :
- Entrer du texte de manière interactive
- Voir la traduction et la correction en temps réel
- Quitter avec la commande 'quit'

### 2. Via PowerShell (Manuel)
\`\`\`powershell
`$body = @{
    text = "Your text here"
} | ConvertTo-Json

Invoke-RestMethod -Method Post -Uri "http://localhost:5001/process" -ContentType "application/json" -Body `$body
\`\`\`

### 3. Interface Web (En développement)
⚠️ Note : L'interface web (\`test.html\`) est actuellement en développement et n'est pas encore fonctionnelle.

## Commandes Make disponibles

- \`make help\` : Affiche l'aide
- \`make up\` : Démarre les services
- \`make down\` : Arrête les services
- \`make logs\` : Affiche les logs
- \`make clean-all\` : Nettoie tous les conteneurs et volumes
- \`make build-full\` : Construction complète avec installation de Mistral

## Structure du projet

\`\`\`
Sworm-Agents/
├── agent-ortho.py      # API Flask principale
├── docker-compose.yml  # Configuration Docker
├── Dockerfile         # Configuration de l'image
├── init-ollama.sh    # Script d'initialisation
├── requirements.txt  # Dépendances Python
├── test-translator.html # Interface web
└── Makefile         # Commandes Make
\`\`\`

## API Endpoints

- \`GET /health\` : Vérifie l'état du service
- \`POST /process\` : Traite et traduit le texte
  \`\`\`json
  {
    "text": "Text to translate"
  }
  \`\`\`
