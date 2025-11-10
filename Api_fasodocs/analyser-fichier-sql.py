#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script d'analyse du fichier fasodocs-data-complete.sql
Vérifie si toutes les procédures ont toutes les sections requises :
- INSERT INTO procedures
- UPDATE procedures SET cout_id
- UPDATE procedures SET centre_id  
- INSERT INTO etapes
- INSERT INTO documents_requis
- INSERT INTO lois_articles
- delai renseigné dans l'INSERT
"""

import re
import sys
from collections import defaultdict

def analyser_fichier_sql(fichier_path):
    """Analyse le fichier SQL pour identifier les procédures incomplètes"""
    
    with open(fichier_path, 'r', encoding='utf-8') as f:
        contenu = f.read()
    
    # Dictionnaire pour stocker les informations sur chaque procédure
    procedures = {}
    
    # Pattern pour trouver les INSERT INTO procedures
    # Format: INSERT INTO procedures (nom, titre, delai, ...) VALUES ('Nom', 'Titre', 'Délai', ...)
    # Gérer les quotes échappées avec ['"] ou ''
    pattern_procedure = r"INSERT\s+INTO\s+procedures[^V]+VALUES\s*\([^)]+\)"
    
    # Trouver toutes les procédures
    for match in re.finditer(pattern_procedure, contenu, re.IGNORECASE | re.DOTALL):
        insert_statement = match.group(0)
        # Extraire le nom de la procédure (première valeur dans VALUES)
        # Format: ('Nom de procédure', ...)
        nom_match = re.search(r"VALUES\s*\(\s*'((?:[^']|'')*)'", insert_statement, re.IGNORECASE)
        if not nom_match:
            continue
        nom_procedure = nom_match.group(1).replace("''", "'")  # Remplacer '' par '
        
        # Extraire le titre (2ème valeur)
        titre_match = re.search(r"',\s*'((?:[^']|'')*)'", insert_statement, re.IGNORECASE)
        titre = titre_match.group(1).replace("''", "'") if titre_match else ""
        
        # Extraire le délai (3ème valeur)
        # Après le titre, il y a le délai
        if titre_match:
            delai_match = re.search(r"',\s*'((?:[^']|'')*)'", insert_statement[titre_match.end():], re.IGNORECASE)
            delai = delai_match.group(1).replace("''", "'") if delai_match else ""
        else:
            delai = ""
        
        procedures[nom_procedure] = {
            'titre': titre,
            'delai': delai.strip() if delai else "",
            'a_cout': False,
            'a_centre': False,
            'a_etapes': False,
            'a_documents': False,
            'a_lois': False,
            'ligne_procedure': match.start()
        }
    
    # Vérifier les UPDATE pour cout_id - Format: UPDATE procedures SET cout_id = ... WHERE nom = 'Nom'
    pattern_cout = r"UPDATE\s+procedures.*?WHERE\s+nom\s*=\s*'((?:[^']|'')+)'"
    for match in re.finditer(pattern_cout, contenu, re.IGNORECASE | re.DOTALL):
        context = match.group(0)
        if 'cout_id' in context or "SET cout_id" in context:
            nom_procedure = match.group(1).replace("''", "'")
            if nom_procedure in procedures:
                procedures[nom_procedure]['a_cout'] = True
    
    # Vérifier les UPDATE pour centre_id
    pattern_centre = r"UPDATE\s+procedures.*?WHERE\s+nom\s*=\s*'((?:[^']|'')+)'"
    for match in re.finditer(pattern_centre, contenu, re.IGNORECASE | re.DOTALL):
        context = match.group(0)
        if 'centre_id' in context or "SET centre_id" in context:
            nom_procedure = match.group(1).replace("''", "'")
            if nom_procedure in procedures:
                procedures[nom_procedure]['a_centre'] = True
    
    # Vérifier les INSERT INTO etapes - Format: INSERT INTO etapes ... (SELECT id FROM procedures WHERE nom = 'Nom')
    pattern_etapes = r"INSERT\s+INTO\s+etapes.*?WHERE\s+nom\s*=\s*'((?:[^']|'')+)'"
    for match in re.finditer(pattern_etapes, contenu, re.IGNORECASE | re.DOTALL):
        nom_procedure = match.group(1).replace("''", "'")
        if nom_procedure in procedures:
            procedures[nom_procedure]['a_etapes'] = True
    
    # Vérifier les INSERT INTO documents_requis
    pattern_documents = r"INSERT\s+INTO\s+documents_requis.*?WHERE\s+nom\s*=\s*'((?:[^']|'')+)'"
    for match in re.finditer(pattern_documents, contenu, re.IGNORECASE | re.DOTALL):
        nom_procedure = match.group(1).replace("''", "'")
        if nom_procedure in procedures:
            procedures[nom_procedure]['a_documents'] = True
    
    # Vérifier les INSERT INTO lois_articles
    pattern_lois = r"INSERT\s+INTO\s+lois_articles.*?WHERE\s+nom\s*=\s*'((?:[^']|'')+)'"
    for match in re.finditer(pattern_lois, contenu, re.IGNORECASE | re.DOTALL):
        nom_procedure = match.group(1).replace("''", "'")
        if nom_procedure in procedures:
            procedures[nom_procedure]['a_lois'] = True
    
    return procedures

def generer_rapport(procedures):
    """Génère un rapport des procédures incomplètes"""
    
    total = len(procedures)
    completes = 0
    incompletes = 0
    
    problemes = {
        'sans_cout': [],
        'sans_centre': [],
        'sans_delai': [],
        'sans_etapes': [],
        'sans_documents': [],
        'sans_lois': [],
        'multiples_problemes': []
    }
    
    for nom, info in procedures.items():
        est_complete = (
            info['a_cout'] and
            info['a_centre'] and
            info['delai'] != "" and
            info['a_etapes'] and
            info['a_documents'] and
            info['a_lois']
        )
        
        if est_complete:
            completes += 1
        else:
            incompletes += 1
            nb_problemes = sum([
                not info['a_cout'],
                not info['a_centre'],
                info['delai'] == "",
                not info['a_etapes'],
                not info['a_documents'],
                not info['a_lois']
            ])
            
            if nb_problemes > 1:
                problemes['multiples_problemes'].append((nom, info, nb_problemes))
            else:
                if not info['a_cout']:
                    problemes['sans_cout'].append((nom, info))
                if not info['a_centre']:
                    problemes['sans_centre'].append((nom, info))
                if info['delai'] == "":
                    problemes['sans_delai'].append((nom, info))
                if not info['a_etapes']:
                    problemes['sans_etapes'].append((nom, info))
                if not info['a_documents']:
                    problemes['sans_documents'].append((nom, info))
                if not info['a_lois']:
                    problemes['sans_lois'].append((nom, info))
    
    # Générer le rapport
    rapport = []
    rapport.append("=" * 80)
    rapport.append("RAPPORT D'ANALYSE DU FICHIER fasodocs-data-complete.sql")
    rapport.append("=" * 80)
    rapport.append("")
    rapport.append(f"Total procédures trouvées: {total}")
    rapport.append(f"Procédures complètes: {completes}")
    rapport.append(f"Procédures incomplètes: {incompletes}")
    rapport.append(f"Taux de complétude: {(completes/total*100) if total > 0 else 0:.2f}%")
    rapport.append("")
    
    # Détail par type de problème
    rapport.append("=" * 80)
    rapport.append("DÉTAIL DES PROBLÈMES")
    rapport.append("=" * 80)
    rapport.append("")
    
    if problemes['multiples_problemes']:
        rapport.append(f"⚠️  Procédures avec PLUSIEURS problèmes ({len(problemes['multiples_problemes'])}):")
        for nom, info, nb in sorted(problemes['multiples_problemes'], key=lambda x: x[2], reverse=True):
            problemes_list = []
            if not info['a_cout']: problemes_list.append("Coût")
            if not info['a_centre']: problemes_list.append("Centre")
            if info['delai'] == "": problemes_list.append("Délai")
            if not info['a_etapes']: problemes_list.append("Étapes")
            if not info['a_documents']: problemes_list.append("Documents")
            if not info['a_lois']: problemes_list.append("Lois")
            rapport.append(f"  ❌ {nom}")
            rapport.append(f"     Manque: {', '.join(problemes_list)}")
        rapport.append("")
    
    if problemes['sans_cout']:
        rapport.append(f"❌ Procédures sans COÛT ({len(problemes['sans_cout'])}):")
        for nom, info in problemes['sans_cout']:
            rapport.append(f"  - {nom}")
        rapport.append("")
    
    if problemes['sans_centre']:
        rapport.append(f"❌ Procédures sans CENTRE ({len(problemes['sans_centre'])}):")
        for nom, info in problemes['sans_centre']:
            rapport.append(f"  - {nom}")
        rapport.append("")
    
    if problemes['sans_delai']:
        rapport.append(f"❌ Procédures sans DÉLAI ({len(problemes['sans_delai'])}):")
        for nom, info in problemes['sans_delai']:
            rapport.append(f"  - {nom}")
        rapport.append("")
    
    if problemes['sans_etapes']:
        rapport.append(f"❌ Procédures sans ÉTAPES ({len(problemes['sans_etapes'])}):")
        for nom, info in problemes['sans_etapes']:
            rapport.append(f"  - {nom}")
        rapport.append("")
    
    if problemes['sans_documents']:
        rapport.append(f"❌ Procédures sans DOCUMENTS REQUIS ({len(problemes['sans_documents'])}):")
        for nom, info in problemes['sans_documents']:
            rapport.append(f"  - {nom}")
        rapport.append("")
    
    if problemes['sans_lois']:
        rapport.append(f"❌ Procédures sans RÉFÉRENCES DE LOI ({len(problemes['sans_lois'])}):")
        for nom, info in problemes['sans_lois']:
            rapport.append(f"  - {nom}")
        rapport.append("")
    
    return "\n".join(rapport)

if __name__ == "__main__":
    fichier_sql = "src/main/resources/fasodocs-data-complete.sql"
    
    try:
        print("🔍 Analyse du fichier SQL en cours...")
        procedures = analyser_fichier_sql(fichier_sql)
        rapport = generer_rapport(procedures)
        print(rapport)
        
        # Sauvegarder le rapport dans un fichier
        with open("rapport-analyse-sql.txt", "w", encoding="utf-8") as f:
            f.write(rapport)
        print("\n✅ Rapport sauvegardé dans: rapport-analyse-sql.txt")
        
    except FileNotFoundError:
        print(f"❌ Erreur: Fichier {fichier_sql} non trouvé")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Erreur lors de l'analyse: {e}")
        sys.exit(1)

