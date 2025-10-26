#!/bin/bash
# ========================================
# Script de démarrage FasoDocs Backend
# Démarrera FasoDocs Backend ET Djelia AI
# ========================================

echo ""
echo "========================================"
echo "  Démarrage FasoDocs Backend"
echo "  avec Djelia AI Integration"
echo "========================================"
echo ""

# Vérifier si Python est installé
if ! command -v python3 &> /dev/null; then
    echo "[ERREUR] Python 3 n'est pas installé"
    echo "Installez Python depuis https://www.python.org/downloads/"
    exit 1
fi

# Vérifier si le backend Djelia AI existe
if [ ! -d "../Djelia-AI-Backend" ]; then
    echo "[ERREUR] Le dossier Djelia-AI-Backend n'existe pas"
    echo "Créez le dossier ../Djelia-AI-Backend ou ajustez le chemin"
    exit 1
fi

# Fonction pour nettoyer les processus au signal de terminaison
cleanup() {
    echo ""
    echo "[INFO] Arrêt des services..."
    pkill -f "python.*app.py" 2>/dev/null
    pkill -f "djelia" 2>/dev/null
    exit 0
}

# Capturer les signaux pour nettoyer
trap cleanup SIGINT SIGTERM

echo "[1/3] Démarrage de Djelia AI Backend..."
echo ""

# Démarrer Djelia AI en arrière-plan
cd ../Djelia-AI-Backend 2>/dev/null || {
    echo "[ERREUR] Impossible d'accéder au dossier Djelia-AI-Backend"
    echo "Vérifiez que le chemin ../Djelia-AI-Backend est correct"
    exit 1
}

# Démarrer Djelia AI dans un terminal séparé
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    osascript -e 'tell application "Terminal" to do script "cd \"'$(pwd)'\" && python3 app.py"' >/dev/null 2>&1 &
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    gnome-terminal -- bash -c "cd \"$(pwd)\" && python3 app.py" >/dev/null 2>&1 &
fi

# Retourner au dossier FasoDocs
cd - >/dev/null

# Attendre que Djelia AI soit prêt
echo "[2/3] Attente du démarrage de Djelia AI..."
sleep 5

# Vérifier si Djelia AI est accessible
echo ""
echo "[INFO] Vérification de la connexion à Djelia AI..."
if curl -s http://localhost:5000/health >/dev/null 2>&1; then
    echo "[OK] Djelia AI est accessible sur http://localhost:5000"
    echo ""
else
    echo "[WARNING] Djelia AI ne répond pas encore. Il démarrera en arrière-plan."
    echo "Si Djelia AI n'est pas accessible après 30 secondes, vérifiez qu'il est bien démarré."
    echo ""
fi

echo "[3/3] Démarrage de FasoDocs Backend..."
echo ""
echo "========================================"
echo "  Backend FasoDocs démarrage..."
echo "========================================"
echo ""

# Démarrer le backend FasoDocs
./mvnw spring-boot:run

