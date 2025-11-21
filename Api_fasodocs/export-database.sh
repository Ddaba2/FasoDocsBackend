#!/bin/bash

# ========================================
#   EXPORT COMPLET DE LA BASE DE DONNÉES
#   FasoDocs - Toutes les données
# ========================================

echo ""
echo "📦 Export de la base de données FasoDocs..."
echo ""

# Vérifier si mysqldump est installé
if ! command -v mysqldump &> /dev/null; then
    echo "❌ mysqldump n'est pas trouvé dans le PATH"
    echo "Veuillez installer MySQL ou ajouter MySQL au PATH"
    exit 1
fi

echo "✅ mysqldump trouvé"
echo ""

# Configuration par défaut
DB_NAME="FasoDocs"
DB_USER="root"
DB_PASSWORD=""
DB_HOST="localhost"

# Demander confirmation
read -p "Voulez-vous exporter la base de données $DB_NAME? (O/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Oo]$ ]]; then
    echo "Export annulé."
    exit 0
fi

echo ""
echo "📊 Export en cours..."
echo ""

# Créer le répertoire de destination s'il n'existe pas
mkdir -p "src/main/resources"

# Exporter la base de données complète
if [ -z "$DB_PASSWORD" ]; then
    mysqldump -h "$DB_HOST" -u "$DB_USER" \
        --single-transaction \
        --routines \
        --triggers \
        --events \
        --add-drop-table \
        --complete-insert \
        "$DB_NAME" > "src/main/resources/fasodocs-full-dump.sql" 2>/dev/null
else
    mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" \
        --single-transaction \
        --routines \
        --triggers \
        --events \
        --add-drop-table \
        --complete-insert \
        "$DB_NAME" > "src/main/resources/fasodocs-full-dump.sql" 2>/dev/null
fi

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Export réussi !"
    echo ""
    echo "📁 Fichier créé: src/main/resources/fasodocs-full-dump.sql"
    echo ""
    
    # Afficher la taille du fichier
    FILE_SIZE=$(stat -f%z "src/main/resources/fasodocs-full-dump.sql" 2>/dev/null || stat -c%s "src/main/resources/fasodocs-full-dump.sql" 2>/dev/null)
    echo "📊 Taille: $FILE_SIZE octets"
    echo ""
    echo "✅ Vous pouvez maintenant commiter ce fichier dans Git"
    echo "   pour que les autres développeurs aient toutes les données."
else
    echo ""
    echo "❌ Erreur lors de l'export"
    echo ""
    echo "💡 Essayez avec mot de passe:"
    echo "   mysqldump -u root -p FasoDocs > src/main/resources/fasodocs-full-dump.sql"
fi

echo ""



