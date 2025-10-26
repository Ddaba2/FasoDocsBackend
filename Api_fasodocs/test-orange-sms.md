# 🧪 Test Orange SMS - FasoDocs

## 📱 Numéro de Test
**Numéro à utiliser** : `+22383784097`

---

## 🧪 ÉTAPE 1 : Test de Connexion par Téléphone

### Avec Postman

```http
POST http://localhost:8080/api/auth/connexion-telephone
Content-Type: application/json

{
  "telephone": "+22383784097"
}
```

### Réponse Attendue

Si le numéro **existe déjà** dans la base de données :
```json
{
  "success": true,
  "message": "Un code de vérification a été envoyé au +223837***"
}
```

Si le numéro **n'existe pas** :
```json
{
  "success": false,
  "message": "Numéro de téléphone non enregistré. Veuillez vous inscrire d'abord."
}
```

---

## 📝 ÉTAPE 2 : Récupérer le Code

### Mode Développement (orange.sms.enabled=false)

**Dans les logs de l'application**, cherchez :
```
WARN - Orange SMS désactivé. Message: Votre code de vérification FasoDocs est: 123456...
WARN - Destinataire: +22383784097, Code: 123456
```

**Le code** : Notez les 6 chiffres affichés (ex: `123456`)

---

### Mode Production (orange.sms.enabled=true)

Vous recevrez un SMS sur `+22383784097` avec le message :
```
Votre code de vérification FasoDocs est: 123456

Ce code expire dans 5 minutes.

Ne partagez jamais ce code avec personne.
```

---

## 🔐 ÉTAPE 3 : Vérifier le Code

### Avec Postman

```http
POST http://localhost:8080/api/auth/verifier-sms
Content-Type: application/json

{
  "telephone": "+22383784097",
  "code": "123456"
}
```

**Remplacez `123456` par le vrai code reçu !**

### Réponse Attendue

**Succès** :
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyMDE5OTE0NTQwMjQ4ODEyMTg3NiIsImlhdCI6MTY3Nzg5OTE2MywiZXhwIjoxNjc3OTg1NTYzfQ...",
  "id": 1,
  "nom": "Test",
  "prenom": "User",
  "email": "test@fasodocs.ml",
  "telephone": "+22383784097",
  "languePreferee": "fr"
}
```

**Erreur** :
```json
{
  "success": false,
  "message": "Code SMS invalide. Vérifiez le code reçu."
}
```

---

## ⚠️ IMPORTANT : Si le Numéro n'Existe Pas

Si vous obtenez l'erreur "Numéro non enregistré", vous devez d'abord **créer un compte** :

### Inscription

```http
POST http://localhost:8080/api/auth/inscription
Content-Type: application/json

{
  "telephone": "+22383784097",
  "email": "test@example.com",
  "motDePasse": "Test123!",
  "confirmerMotDePasse": "Test123!"
}
```

Puis relancez le test de connexion.

---

## 📊 Ce Qui Doit Se Passer

1. ✅ **Vérification du numéro** dans la base de données
2. ✅ **Génération d'un code** à 6 chiffres
3. ✅ **Stockage du code** en base avec expiration (5 min)
4. ✅ **Envoi SMS** via Orange API
5. ✅ **Code affiché** dans les logs (si mode dev)

---

## 🚨 Erreurs Possibles et Solutions

### Erreur 401 Unauthorized
**Cause** : Authorization header Orange invalide  
**Solution** : Vérifiez l'`authorization.header` dans `application.properties`

### Code SMS Invalide
**Cause** : Code expiré (5 minutes) ou code incorrect  
**Solution** : Redemandez un nouveau code

### Numéro Non Enregistré
**Cause** : Le numéro n'existe pas en base  
**Solution** : Créez d'abord un compte avec `/auth/inscription`

---

**Testez maintenant avec votre numéro réel !** 📱
