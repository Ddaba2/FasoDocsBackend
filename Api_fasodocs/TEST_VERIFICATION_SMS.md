# 🧪 Guide de Test : Vérification du Code SMS

## ✅ Améliorations Effectuées

J'ai ajouté :
1. ✅ **Gestionnaire d'erreurs global** → Messages d'erreur clairs
2. ✅ **Logs détaillés** → Voir exactement ce qui se passe
3. ✅ **Messages d'erreur explicites** → Plus de "Bad Request" vague

---

## 🚀 CE QU'IL FAUT FAIRE MAINTENANT

### Étape 1 : Redémarrer l'Application ⏸️

**IMPORTANT** : Arrêtez et redémarrez votre application Spring Boot

**Attendez** que vous voyiez dans les logs :
```
INFO - Started FasodocsBackendApplication
```

---

### Étape 2 : Test Complet (Du Début) 🧪

#### A. Demander un code SMS

**Dans Postman** :
```http
POST http://localhost:8080/api/auth/connexion-telephone
Content-Type: application/json

{
  "telephone": "+22383784097"
}
```

**Réponse attendue** :
```json
{
  "success": true,
  "message": "Un code de vérification a été envoyé à votre téléphone."
}
```

**Vous recevez un SMS** avec un code à 6 chiffres, par exemple : `123456`

**NOTEZ L'HEURE** : Le code expire dans 5 minutes !

---

#### B. Vérifier le code (IMMÉDIATEMENT)

**Dans Postman** :
```http
POST http://localhost:8080/api/auth/verifier-sms
Content-Type: application/json

{
  "telephone": "+22383784097",
  "code": "123456"
}
```

⚠️ **IMPORTANT** :
- Remplacez `123456` par le **code exact** reçu par SMS
- Pas d'espaces avant/après le code
- Le numéro doit être **identique** à celui utilisé à l'étape A

---

### Étape 3 : Comprendre les Erreurs 🔍

Maintenant, si vous avez une erreur, vous aurez un message CLAIR :

#### Erreur 1 : Code Invalide
```json
{
  "success": false,
  "message": "Code SMS invalide. Vérifiez le code reçu."
}
```

**Solution** : Vérifiez que vous avez copié le bon code

---

#### Erreur 2 : Code Expiré
```json
{
  "success": false,
  "message": "Code SMS expiré. Veuillez demander un nouveau code."
}
```

**Solution** : Redemandez un nouveau code (étape A)

---

#### Erreur 3 : Numéro Non Trouvé
```json
{
  "success": false,
  "message": "Numéro de téléphone non trouvé"
}
```

**Solution** : 
- Vérifiez le numéro (format : `+22383784097`)
- Inscrivez-vous d'abord si pas encore fait

---

#### Erreur 4 : Champ Manquant
```json
{
  "success": false,
  "message": "Erreur de validation: code: Le code est obligatoire;"
}
```

**Solution** : Vérifiez votre JSON Postman :
```json
{
  "telephone": "+22383784097",
  "code": "123456"          ← NE PAS OUBLIER !
}
```

---

## 📝 Logs à Surveiller

Après avoir testé, regardez vos logs. Vous verrez maintenant :

### Logs de Connexion (Demande de Code)
```
INFO  - Tentative de connexion par téléphone: +22383784097
INFO  - SMS envoyé avec succès. SID: SM..., Téléphone: +22383784097
INFO  - Code SMS envoyé pour la connexion: +22383784097
```

### Logs de Vérification (Succès)
```
INFO  - Tentative de vérification SMS pour: +22383784097
DEBUG - Code en BDD: 123456, Code reçu: 123456
INFO  - Citoyen connecté après vérification SMS: +22383784097
```

### Logs de Vérification (Erreur - Code Invalide)
```
INFO  - Tentative de vérification SMS pour: +22383784097
DEBUG - Code en BDD: 123456, Code reçu: 654321
ERROR - Code SMS invalide. Attendu: 123456, Reçu: 654321
```

### Logs de Vérification (Erreur - Code Expiré)
```
INFO  - Tentative de vérification SMS pour: +22383784097
ERROR - Code SMS expiré. Expiration: 2025-10-21T12:30:00, Maintenant: 2025-10-21T12:36:00
```

---

## 🎯 Checklist de Test

Avant de tester, vérifiez :

- [ ] ✅ Application redémarrée
- [ ] ✅ `twilio.sms.enabled=true` dans `application.properties`
- [ ] ✅ Numéro vérifié sur Twilio (si compte trial)
- [ ] ✅ Postman prêt
- [ ] ✅ Logs de l'application visibles

---

## 🧪 Test Pas à Pas avec Vérification

### 1. Inscription (Si pas encore fait)

```http
POST http://localhost:8080/api/auth/inscription
Content-Type: application/json

{
  "telephone": "+22383784097",
  "email": "votre-email@example.com",
  "motDePasse": "Test123!",
  "confirmerMotDePasse": "Test123!"
}
```

---

### 2. Connexion par Téléphone

```http
POST http://localhost:8080/api/auth/connexion-telephone
Content-Type: application/json

{
  "telephone": "+22383784097"
}
```

**Regardez les logs** :
- Voyez-vous `"SMS envoyé avec succès"` ?
- Si mode dev, voyez-vous le code généré ?

---

### 3. Vérification du Code

```http
POST http://localhost:8080/api/auth/verifier-sms
Content-Type: application/json

{
  "telephone": "+22383784097",
  "code": "LE_CODE_RECU_PAR_SMS"
}
```

**Si SUCCÈS** :
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "id": 1,
  "telephone": "+22383784097",
  "email": "votre-email@example.com"
}
```

**Si ERREUR** : Message clair vous expliquant le problème

---

## 📊 Différences Entre Mode Dev et Production

| | Mode Dev (SMS désactivé) | Mode Production (SMS activé) |
|---|---|---|
| **Configuration** | `twilio.sms.enabled=false` | `twilio.sms.enabled=true` |
| **Code SMS** | Dans les logs | Reçu par SMS réel |
| **Twilio** | Pas nécessaire | Compte requis |
| **Numéro vérifié** | Non requis | Requis (compte trial) |

---

## 🔧 Dépannage

### Problème : Toujours "Bad Request" sans message

**Cause** : Application pas redémarrée

**Solution** : 
1. Arrêtez l'application
2. Relancez-la
3. Attendez "Started FasodocsBackendApplication"
4. Retestez

---

### Problème : "Code SMS invalide" mais le code est bon

**Cause possible** :
1. Espaces invisibles dans le code
2. Code copié d'un ancien SMS

**Solution** :
1. Tapez le code manuellement
2. Vérifiez qu'il n'y a pas d'espaces
3. Demandez un nouveau code et utilisez-le immédiatement

---

### Problème : "Numéro de téléphone non trouvé"

**Cause** : Le numéro n'est pas inscrit

**Solution** : 
1. Vérifiez dans la BDD :
   ```sql
   SELECT * FROM citoyens WHERE telephone = '+22383784097';
   ```
2. Si vide → Inscrivez-vous d'abord
3. Si existe → Vérifiez le format exact du numéro

---

## 🎉 Résultat Attendu

Après ces modifications, vous devriez :

1. ✅ Recevoir des messages d'erreur **clairs et explicites**
2. ✅ Voir des **logs détaillés** dans l'application
3. ✅ Comprendre **exactement** quel est le problème
4. ✅ Pouvoir **déboguer facilement**

---

## 📞 Prochaine Étape

**Redémarrez l'application et testez !**

Puis **copiez-moi** :
1. Le message d'erreur retourné par Postman
2. Les logs de l'application (dernières lignes)

Et je pourrai vous dire **exactement** quel est le problème ! 🔍

---

**🚀 Bonne chance !**




