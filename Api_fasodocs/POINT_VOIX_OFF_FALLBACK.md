# 🔊 Point sur l'Utilisation de la Voix Off (Fallback Audio)

**Date**: 2025-01-14  
**Version**: 1.0

---

## 📋 Vue d'Ensemble

Le système de **voix off (fallback audio)** permet d'utiliser des fichiers audio préenregistrés lorsque **Djelia AI ne fonctionne pas** ou rencontre une erreur.

---

## 🎯 Comment ça Fonctionne

### Flux Automatique

```
1. Utilisateur demande l'audio d'une procédure
   ↓
2. Système essaie Djelia AI (traduction + synthèse vocale)
   ↓
3. Si Djelia AI échoue :
   ├─ Vérifie si la procédure a un fichier audio de fallback
   ├─ Si OUI → Utilise l'audio préenregistré ✅
   └─ Si NON → Retourne une erreur ❌
```

---

## ✅ Conditions pour le Fallback

Pour que le fallback fonctionne, **2 conditions** doivent être remplies :

1. ✅ **`procedureId` doit être fourni** dans la requête
2. ✅ **La procédure doit avoir un fichier audio** configuré dans `audio_url`

---

## 📡 Endpoints Utilisés

### 1. **Traduction + Synthèse Vocale avec Fallback**

**POST** `/api/djelia/translate-and-speak`

**Body** :
```json
{
  "text": "Description de la procédure",
  "procedureId": 1  // ⚠️ IMPORTANT pour activer le fallback
}
```

**Comportement** :
- ✅ Essaie d'abord Djelia AI
- ✅ Si échec → Utilise l'audio de fallback (si disponible)
- ✅ Retourne l'audio en Base64

**Réponse** :
```json
{
  "originalText": "Description...",
  "translatedText": "Texte traduit (ou original si fallback)",
  "audioBase64": "base64_encoded_audio...",
  "format": "wav",
  "voiceDescription": "Audio de fallback" // ou "Djelia AI"
}
```

---

### 2. **Récupérer Directement l'Audio de Fallback**

**GET** `/api/procedures/{id}/audio`

**Description** : Récupère directement le fichier audio de fallback (sans passer par Djelia AI)

**Exemple** :
```bash
GET /api/procedures/1/audio
```

**Réponse** :
- **200 OK** : Fichier audio (WAV, MP3, OGG)
- **404 Not Found** : Aucun fichier audio trouvé

---

## 📁 Configuration des Fichiers Audio

### 1. **Emplacement des Fichiers**

Les fichiers audio doivent être placés dans :
```
src/main/resources/static/audio/procedures/
```

**Exemples** :
```
src/main/resources/static/audio/procedures/
├── carte_identite_nationale.wav
├── passeport.wav
├── acte_naissance.wav
└── permis_conduire.wav
```

---

### 2. **Enregistrement en Base de Données**

Le chemin du fichier audio est stocké dans la colonne `audio_url` de la table `procedures`.

**Exemple SQL** :
```sql
-- Ajouter un fichier audio à une procédure
UPDATE procedures 
SET audio_url = 'carte_identite_nationale.wav' 
WHERE id = 1;

-- Vérifier les procédures avec audio
SELECT id, nom, audio_url 
FROM procedures 
WHERE audio_url IS NOT NULL;
```

---

### 3. **Configuration dans application.properties**

```properties
# Configuration des fichiers audio de fallback
app.audio.directory=src/main/resources/static/audio/procedures
```

---

## 💻 Utilisation dans Flutter

### Option 1 : Avec Fallback Automatique

```dart
// Appel avec fallback automatique
final response = await dio.post(
  '/api/djelia/translate-and-speak',
  data: {
    'text': procedure.description,
    'procedureId': procedure.id, // ⚠️ IMPORTANT pour le fallback
  },
);

// L'audio sera soit généré par Djelia AI, soit récupéré depuis le fallback
final audioBase64 = response.data['audioBase64'];
final voiceDescription = response.data['voiceDescription']; // "Djelia AI" ou "Audio de fallback"

// Décoder et jouer l'audio
if (audioBase64 != null) {
  final audioBytes = base64Decode(audioBase64);
  await audioPlayer.play(audioBytes);
}
```

---

### Option 2 : Récupérer Directement l'Audio de Fallback

```dart
// Récupérer directement le fichier audio (sans Djelia AI)
try {
  final audioResponse = await dio.get(
    '/api/procedures/${procedure.id}/audio',
    options: Options(responseType: ResponseType.bytes),
  );
  
  // Jouer l'audio
  await audioPlayer.play(audioResponse.data);
} catch (e) {
  // Aucun fichier audio disponible
  print('Aucun audio de fallback disponible');
}
```

---

### Option 3 : Gestion avec Try-Catch

```dart
Future<void> playProcedureAudio(Procedure procedure) async {
  try {
    // Essayer d'abord avec Djelia AI (avec fallback automatique)
    final response = await dio.post(
      '/api/djelia/translate-and-speak',
      data: {
        'text': procedure.description,
        'procedureId': procedure.id, // Active le fallback
      },
    );
    
    final audioBase64 = response.data['audioBase64'];
    if (audioBase64 != null) {
      final audioBytes = base64Decode(audioBase64);
      await audioPlayer.play(audioBytes);
      
      // Afficher la source de l'audio
      final source = response.data['voiceDescription'];
      if (source == 'Audio de fallback') {
        showSnackBar('Audio préenregistré utilisé (Djelia AI indisponible)');
      }
    }
  } catch (e) {
    // Si tout échoue, essayer directement le fallback
    try {
      final audioResponse = await dio.get(
        '/api/procedures/${procedure.id}/audio',
        options: Options(responseType: ResponseType.bytes),
      );
      await audioPlayer.play(audioResponse.data);
    } catch (e2) {
      // Aucun audio disponible
      showSnackBar('Aucun audio disponible pour cette procédure');
    }
  }
}
```

---

## 📝 Format des Fichiers Audio

### Formats Supportés

- ✅ **WAV** (recommandé) : `audio/wav`
- ✅ **MP3** : `audio/mpeg`
- ✅ **OGG** : `audio/ogg`

### Recommandations

- **Taille** : < 5 MB par fichier
- **Qualité** : 16 kHz, mono ou stéréo
- **Durée** : Adaptée au contenu (généralement 1-5 minutes)

---

## 🎨 Nommage des Fichiers Audio

### Bonnes Pratiques

- ✅ Utiliser des **underscores (_)** ou des **tirets (-)** au lieu d'espaces
- ✅ Utiliser des noms en **minuscules** (recommandé)
- ✅ Utiliser des noms **descriptifs** et **uniques**
- ✅ Inclure l'**extension** du fichier (.wav, .mp3, .ogg)
- ❌ Éviter les **espaces** dans les noms de fichiers
- ❌ Éviter les **caractères spéciaux** (é, è, à, etc.)

### Exemples de Noms Valides

```
carte_identite_nationale.wav
carte-identite-nationale.wav
passeport.wav
acte_naissance.wav
permis_conduire.wav
carte_nina.wav
extrait_casier_judiciaire.wav
```

---

## 🔄 Exemples d'Utilisation SQL

### Ajouter un Audio à une Procédure

```sql
-- Carte d'identité nationale
UPDATE procedures 
SET audio_url = 'carte_identite_nationale.wav' 
WHERE id = 1;

-- Passeport
UPDATE procedures 
SET audio_url = 'passeport.wav' 
WHERE nom LIKE '%passeport%';

-- Acte de naissance
UPDATE procedures 
SET audio_url = 'acte_naissance.wav' 
WHERE titre LIKE '%acte%naissance%';
```

### Mise à Jour Multiple

```sql
-- Mettre à jour plusieurs procédures en une fois
UPDATE procedures 
SET audio_url = CASE 
    WHEN nom LIKE '%carte%identité%' THEN 'carte_identite_nationale.wav'
    WHEN nom LIKE '%passeport%' THEN 'passeport.wav'
    WHEN nom LIKE '%acte%naissance%' THEN 'acte_naissance.wav'
    WHEN nom LIKE '%permis%conduire%' THEN 'permis_conduire.wav'
    WHEN nom LIKE '%carte%nina%' THEN 'carte_nina.wav'
    ELSE audio_url
END
WHERE nom LIKE '%carte%' OR nom LIKE '%passeport%' OR nom LIKE '%acte%' 
   OR nom LIKE '%permis%' OR nom LIKE '%nina%';
```

---

## 🧪 Tests

### Test 1 : Vérifier qu'un Fichier Audio Existe

```bash
# Vérifier en base de données
SELECT id, nom, audio_url 
FROM procedures 
WHERE audio_url IS NOT NULL;

# Tester l'endpoint
curl http://localhost:8080/api/procedures/1/audio
```

### Test 2 : Tester le Fallback

```bash
# Désactiver Djelia AI temporairement
# Dans application.properties : djelia.ai.enabled=false

# Appeler translate-and-speak avec procedureId
curl -X POST http://localhost:8080/api/djelia/translate-and-speak \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Test de fallback",
    "procedureId": 1
  }'

# Devrait retourner l'audio de fallback
```

---

## ⚠️ Notes Importantes

### 1. **Fallback Automatique**

- ✅ Le fallback ne fonctionne que si `procedureId` est fourni dans la requête
- ✅ Si Djelia AI échoue ET qu'un audio de fallback existe → Utilisé automatiquement
- ✅ Si Djelia AI fonctionne → Audio généré par Djelia AI (même si fallback existe)

### 2. **Pas de Traduction en Fallback**

- ⚠️ L'audio de fallback est lu **tel quel**, sans traduction
- ⚠️ Si vous voulez un audio en bambara, vous devez enregistrer directement en bambara

### 3. **Chemin Relatif**

- ✅ Le champ `audio_url` doit contenir uniquement le **nom du fichier** ou un **chemin relatif**
- ✅ Exemple : `carte_identite_nationale.wav` (pas de chemin absolu)

### 4. **Performance**

- ⚠️ Les fichiers audio sont chargés depuis le système de fichiers à chaque requête
- 💡 Pour de meilleures performances, considérez un CDN ou un stockage cloud

---

## 📊 Comparaison : Djelia AI vs Fallback

| Caractéristique | Djelia AI | Fallback Audio |
|----------------|-----------|----------------|
| **Traduction** | ✅ Automatique (FR → BM) | ❌ Non (audio préenregistré) |
| **Synthèse vocale** | ✅ Générée à la volée | ❌ Préenregistré |
| **Qualité** | ✅ Variable (selon Djelia) | ✅ Fixe (selon enregistrement) |
| **Disponibilité** | ⚠️ Dépend de l'API | ✅ Toujours disponible |
| **Personnalisation** | ✅ Texte dynamique | ❌ Audio fixe |
| **Coût** | ⚠️ Appels API | ✅ Gratuit (stockage local) |

---

## 🚀 Recommandations

### Pour les Développeurs

1. ✅ **Toujours fournir `procedureId`** dans les requêtes `translate-and-speak`
2. ✅ **Ajouter des fichiers audio de fallback** pour les procédures importantes
3. ✅ **Tester le fallback** en désactivant temporairement Djelia AI
4. ✅ **Gérer les erreurs** dans Flutter pour afficher des messages clairs

### Pour les Admins

1. ✅ **Enregistrer des fichiers audio** pour les procédures les plus utilisées
2. ✅ **Utiliser des noms descriptifs** pour faciliter la maintenance
3. ✅ **Vérifier régulièrement** que les fichiers audio existent et sont accessibles

---

## 📚 Documentation Complète

Pour plus de détails, consultez :
- `GUIDE_AUDIO_FALLBACK_PROCEDURES.md` - Guide complet du système de fallback
- `EXEMPLES_NOMS_AUDIO_PROCEDURES.md` - Exemples de noms de fichiers audio

---

**Date de création**: 2025-01-14  
**Version**: 1.0

