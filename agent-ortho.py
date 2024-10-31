from flask import Flask, request, jsonify
from flask_cors import CORS
import sys
from langchain_ollama import OllamaLLM
from langchain.prompts import PromptTemplate
from langchain.schema.runnable import RunnableSequence
import os
from dotenv import load_dotenv

# Charger les variables d'environnement depuis .env
load_dotenv()

app = Flask(__name__)
# Configuration CORS plus explicite
CORS(app, resources={
    r"/*": {
        "origins": "*",
        "methods": ["GET", "POST", "OPTIONS"],
        "allow_headers": ["Content-Type"]
    }
})

@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type')
    response.headers.add('Access-Control-Allow-Methods', 'GET,POST,OPTIONS')
    return response

# Vérifier la version de Python
if sys.version_info < (3, 10):
    raise RuntimeError("Ce projet nécessite Python 3.10 ou supérieur")

# Initialiser Ollama avec le modèle Mistral
llm = OllamaLLM(
    model="mistral",
    base_url=os.getenv('OLLAMA_HOST', 'http://ollama:11434')
)

# Définir les templates
translation_prompt = PromptTemplate(
    input_variables=["text"],
    template="""Tu es un agent de traduction expert.
    Consignes :
    - Traduis le texte suivant en français
    - Conserve le style et le ton du texte original
    - Garde la même structure de paragraphes
    
    Texte à traduire : {text}
    
    Traduction :"""
)

correction_prompt = PromptTemplate(
    input_variables=["text"],
    template="""Tu es un agent de correction orthographique expert.
    Consignes :
    - Corrige les erreurs orthographiques et grammaticales
    - Améliore la ponctuation si nécessaire
    - Ne modifie pas le style ou le sens du texte
    
    Texte à corriger : {text}
    
    Version corrigée :"""
)

# Créer les chaînes de traitement avec RunnableSequence
translation_chain = translation_prompt | llm
correction_chain = correction_prompt | llm

@app.route('/health', methods=['GET'])
def health_check():
    """Point de terminaison pour vérifier la santé de l'API"""
    return jsonify({"status": "healthy", "ollama_url": os.getenv('OLLAMA_HOST')})

@app.route('/process', methods=['POST', 'OPTIONS'])
def process_text():
    if request.method == 'OPTIONS':
        return '', 204
        
    try:
        print("Requête reçue:", request.json)  # Log pour debug
        text = request.json.get('text', '')
        if not text:
            return jsonify({"error": "Texte manquant"}), 400
            
        print("Traduction en cours...")  # Log pour debug
        translated = translation_chain.invoke({"text": text})
        print("Traduction terminée:", translated)  # Log pour debug
        
        print("Correction en cours...")  # Log pour debug
        final = correction_chain.invoke({"text": translated})
        print("Correction terminée:", final)  # Log pour debug
        
        return jsonify({
            "original": text,
            "translated": translated,
            "final": final,
            "status": "success"
        })
    except Exception as e:
        print("Erreur:", str(e))  # Log pour debug
        return jsonify({
            "error": str(e),
            "status": "error"
        }), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
