# 🧪 Test Envoi SMS Orange - Validation de la Correction

## ✅ Correction appliquée

Le format du senderAddress dans l'URL a été corrigé selon la documentation Orange.

**Avant (incorrect) :**
```
URL: /outbound/tel%3A%2B22383784097/requests
Décodé: /outbound/tel:+22383784097/requests ❌
```

**Après (conforme) :**
```
URL: /outbound/tel%3A22383784097/requests
Décodé: /outbound/tel:22383784097/requests ✅
```

---

## 📋 Étapes de test

### **1. Démarrer le backend**

```bash
cd Api_fasodocs
./mvnw spring-boot:run
```

**Ou sur Windows :**
```cmd
cd Api_fasodocs
mvnw.cmd spring-boot:run
```

---

### **2. Vérifier la configuration dans les logs**

Au démarrage, vérifiez que les logs affichent :

```
✅ Configuration Orange SMS chargée
✅ Client ID: eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG
✅ Application ID: iy3KWH9GiNK0evSY
✅ Sender Address: tel:+22383784097
```

---

### **3. Test d'authentification**

#### **Via Swagger UI :**

1. Ouvrez votre navigateur : `http://localhost:8080/swagger-ui.html`
2. Cherchez l'endpoint **`POST /auth/connexion-telephone`**
3. Testez avec un numéro de téléphone malien

#### **Via curl :**

```bash
curl -X POST http://localhost:8080/api/auth/connexion-telephone \
  -H "Content-Type: application/json" \
  -d '{
    "telephone": "223XXXXXXXX"
  }'
```

**Remplacez `223XXXXXXXX` par un numéro de téléphone Orange Mali valide.**

---

### **4. Vérifier les logs lors de l'envoi SMS**

**Logs attendus lors de l'envoi SMS :**

```
═══════════════════════════════════════════════════════════
📱 CONFIGURATION SMS SELON DOCUMENTATION ORANGE
═══════════════════════════════════════════════════════════
   Sender pour BODY (avec +):    tel:+22383784097
   Sender pour URL (sans +):     tel:22383784097
   Sender URL-encodé:            tel%3A22383784097
   URL complète générée:         https://api.orange.com/smsmessaging/v1/outbound/tel%3A22383784097/requests
═══════════════════════════════════════════════════════════
```

**✅ Points à vérifier :**

1. **Sender pour BODY (avec +)** : `tel:+22383784097` ✅
   - Doit contenir le `+`

2. **Sender pour URL (sans +)** : `tel:22383784097` ✅
   - Ne doit **PAS** contenir le `+`

3. **URL complète générée** : 
   ```
   https://api.orange.com/smsmessaging/v1/outbound/tel%3A22383784097/requests
   ```
   - URL-encodé : `tel%3A22383784097`
   - Décodé : `tel:22383784097` (sans `+`)
   - ✅ **CONFORME à la documentation Orange**

---

### **5. Test d'authentification Orange**

**Logs attendus lors de l'authentification :**

```
🔐 Authentification avec l'API Orange SMS
✅✅✅ AUTHENTIFICATION RÉUSSIE AVEC L'API ORANGE SMS ✅✅✅
   Configuration utilisée: URL=https://api.orange.com/oauth/v3/token, scope=true
   Token valide pendant: 3600 secondes
   ✅ Les SMS peuvent maintenant être envoyés
```

**Si l'authentification échoue :**
- Vérifiez les credentials dans `application.properties`
- Vérifiez que le Client Secret n'a pas été régénéré
- Contactez le support Orange Mali

---

### **6. Test d'envoi SMS complet**

**Logs complets attendus :**

```
🔐 Tentative d'authentification Orange SMS pour l'envoi...
✅✅✅ AUTHENTIFICATION RÉUSSIE AVEC L'API ORANGE SMS ✅✅✅
✅ Authentification réussie - Envoi du SMS...
═══════════════════════════════════════════════════════════
📱 CONFIGURATION SMS SELON DOCUMENTATION ORANGE
═══════════════════════════════════════════════════════════
   Sender pour BODY (avec +):    tel:+22383784097
   Sender pour URL (sans +):     tel:22383784097
   Sender URL-encodé:            tel%3A22383784097
   URL complète générée:         https://api.orange.com/smsmessaging/v1/outbound/tel%3A22383784097/requests
═══════════════════════════════════════════════════════════
📱 Envoi SMS - Destinataire: +223XXXXXXXX, URL: ..., Sender: tel:+22383784097
✅ SMS envoyé avec succès à +223XXXXXXXX
```

---

## 🔍 Checklist de validation

### **Vérification du format de l'URL**

- [ ] **L'URL générée ne contient PAS de `+`** 
  ```
  ✅ Correct: /outbound/tel%3A22383784097/requests
  ❌ Incorrect: /outbound/tel%3A%2B22383784097/requests
  ```

- [ ] **Le body contient le `+`**
  ```json
  {
    "senderAddress": "tel:+22383784097"  ✅
  }
  ```

- [ ] **L'URL est correctement encodée**
  ```
  tel:22383784097 → tel%3A22383784097
  ```

---

## ⚠️ Erreurs possibles

### **Erreur 400 : Bad Request**

**Cause possible :**
- Format de l'URL incorrect
- Format du body incorrect

**Vérification :**
1. Vérifiez les logs pour voir l'URL générée
2. Vérifiez que l'URL ne contient pas de `+` (doit être `tel:223...` pas `tel:+223...`)
3. Vérifiez que le body contient le `+` (doit être `tel:+223...`)

---

### **Erreur 401 : Unauthorized**

**Cause possible :**
- Token expiré
- Credentials invalides

**Solution :**
1. Le code renouvelle automatiquement le token
2. Vérifiez les credentials dans `application.properties`
3. Vérifiez que le Client Secret est à jour

---

### **Erreur 403 : Forbidden**

**Cause possible :**
- Sender address non autorisé
- Application non autorisée pour ce pays

**Solution :**
1. Vérifiez que le sender address est enregistré chez Orange
2. Contactez le support Orange Mali

---

## 📊 Résultat attendu

### **Si tout fonctionne correctement :**

1. ✅ **Authentification réussie** avec logs détaillés
2. ✅ **URL générée conforme** à la documentation Orange :
   ```
   /outbound/tel%3A22383784097/requests
   ```
   (sans le `+`)

3. ✅ **Body JSON correct** :
   ```json
   {
     "senderAddress": "tel:+22383784097"
   }
   ```
   (avec le `+`)

4. ✅ **SMS envoyé avec succès** :
   ```
   ✅ SMS envoyé avec succès à +223XXXXXXXX
   ```

5. ✅ **Réception du SMS** sur le téléphone destinataire

---

## 🎯 Test manuel via Postman

### **1. Test d'authentification**

```http
POST http://localhost:8080/api/auth/connexion-telephone
Content-Type: application/json

{
  "telephone": "223XXXXXXXX"
}
```

**Remplacez `223XXXXXXXX` par un numéro Orange Mali valide.**

### **2. Vérifier les logs du backend**

Dans la console du backend, vous devriez voir :

```
═══════════════════════════════════════════════════════════
📱 CONFIGURATION SMS SELON DOCUMENTATION ORANGE
═══════════════════════════════════════════════════════════
   Sender pour BODY (avec +):    tel:+22383784097
   Sender pour URL (sans +):     tel:22383784097
   Sender URL-encodé:            tel%3A22383784097
   URL complète générée:         https://api.orange.com/smsmessaging/v1/outbound/tel%3A22383784097/requests
═══════════════════════════════════════════════════════════
```

**✅ Vérifiez que :**
- URL ne contient **PAS** de `+` : `tel%3A22383784097` (pas `tel%3A%2B22383784097`)
- Body contient le `+` : `tel:+22383784097`

---

## ✅ Validation finale

### **Format de l'URL conforme :**

✅ **URL générée (encodée) :**
```
https://api.orange.com/smsmessaging/v1/outbound/tel%3A22383784097/requests
```

✅ **URL décodée :**
```
https://api.orange.com/smsmessaging/v1/outbound/tel:22383784097/requests
```

✅ **Body JSON :**
```json
{
  "outboundSMSMessageRequest": {
    "senderAddress": "tel:+22383784097",
    "address": "tel:+223XXXXXXXX",
    "outboundSMSTextMessage": {
      "message": "FasoDocs: Votre code: 1234. Expire dans 1 min."
    }
  }
}
```

---

## 🎉 Si tous les tests passent

**✅ La correction est validée !**

Votre configuration Orange SMS est maintenant **100% conforme** à la documentation officielle Orange.

---

## 📞 Support

Si vous rencontrez des problèmes :

1. **Vérifiez les logs** du backend (sections détaillées ci-dessus)
2. **Vérifiez les credentials** dans `application.properties`
3. **Contactez le support Orange Mali** si les credentials sont valides mais l'envoi échoue

---

**Date du test :** _______________  
**Résultat :** ☐ Réussi ☐ Échoué  
**Remarques :** _________________________________

