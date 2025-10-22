# ✅ Checklist Configuration Twilio - FasoDocs

## 🎯 Ce qui est déjà fait (dans le code)

- ✅ Service `TwilioSmsService` créé
- ✅ Flux d'authentification SMS configuré
- ✅ Endpoints REST disponibles
- ✅ Validation du format téléphone malien (+223XXXXXXXX)
- ✅ Code de vérification à 6 chiffres
- ✅ Expiration automatique après 5 minutes
- ✅ Dépendance Twilio dans `pom.xml`

---

## 🚀 ÉTAPES À SUIVRE (dans l'ordre)

### Étape 1 : Créer un compte Twilio (5 min)

1. **Allez sur** : https://www.twilio.com/try-twilio
2. **Créez un compte gratuit** (vous recevrez $15 de crédit)
3. **Vérifiez votre email**
4. **Vérifiez votre numéro de téléphone personnel**

### Étape 2 : Obtenir vos identifiants Twilio (2 min)

Une fois connecté au dashboard Twilio :

1. **Account SID** : Visible sur le dashboard principal
   - Format : `ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   - Cliquez sur "Copy" pour le copier

2. **Auth Token** : À côté du Account SID
   - Cliquez sur "Show" pour l'afficher
   - Format : `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   - Cliquez sur "Copy" pour le copier

3. **Numéro de téléphone Twilio** :
   - Menu : **Phone Numbers** → **Manage** → **Buy a number**
   - En version d'essai gratuite : choisissez un numéro US (+1)
   - Format : `+1234567890`

### Étape 3 : Configurer application.properties (1 min)

Ouvrez : `src/main/resources/application.properties`

Remplacez les lignes suivantes avec vos **vrais identifiants** :

```properties
# Configuration Twilio pour l'envoi de SMS
twilio.account.sid=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   # ← REMPLACER
twilio.auth.token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx       # ← REMPLACER
twilio.phone.number=+1234567890                           # ← REMPLACER
twilio.sms.enabled=true                                   # ← true pour activer
```

**⚠️ MODE DÉVELOPPEMENT (sans Twilio configuré)** :
```properties
twilio.sms.enabled=false
```
→ Le code SMS sera affiché dans les logs au lieu d'être envoyé

### Étape 4 : Redémarrer l'application

1. **Arrêtez** l'application si elle tourne
2. **Redémarrez** l'application
3. **Vérifiez les logs** pour voir :
   ```
   INFO - Twilio initialisé avec succès
   ```

### Étape 5 : Tester dans Postman

#### Test 1 : Inscription d'un utilisateur

```http
POST http://localhost:8080/api/auth/inscription
Content-Type: application/json

{
  "telephone": "+22370000001",
  "email": "test@fasodocs.ml",
  "motDePasse": "Test123!",
  "confirmerMotDePasse": "Test123!"
}
```

**Réponse attendue** :
```json
{
  "success": true,
  "message": "Inscription réussie! Vous pouvez maintenant vous connecter."
}
```

#### Test 2 : Connexion par téléphone (envoie le code SMS)

```http
POST http://localhost:8080/api/auth/connexion-telephone
Content-Type: application/json

{
  "telephone": "+22370000001"
}
```

**Réponse attendue** :
```json
{
  "success": true,
  "message": "Un code de vérification a été envoyé à votre téléphone."
}
```

**📱 VOUS RECEVEZ UN SMS** :
```
Votre code de vérification FasoDocs est: 123456

Ce code expire dans 5 minutes.

Ne partagez jamais ce code avec personne.
```

**Si `twilio.sms.enabled=false`**, regardez les logs :
```
WARN - SMS désactivé. Code généré: 123456
```

#### Test 3 : Vérifier le code SMS (obtenir le JWT)

```http
POST http://localhost:8080/api/auth/verifier-sms
Content-Type: application/json

{
  "telephone": "+22370000001",
  "code": "123456"
}
```

**Réponse attendue** :
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "id": 1,
  "nom": null,
  "prenom": null,
  "email": "test@fasodocs.ml",
  "telephone": "+22370000001",
  "languePreferee": "fr"
}
```

✅ **SUCCÈS !** Vous êtes connecté et avez reçu un token JWT !

---

## 🔍 Vérification de la Base de Données

Ouvrez **MySQL Workbench** ou **phpMyAdmin** et vérifiez :

```sql
-- Vérifier que la table citoyens a les bonnes colonnes
DESCRIBE citoyens;

-- Doit contenir :
-- - code_sms (varchar)
-- - code_sms_expiration (datetime)
-- - telephone_verifie (tinyint)
```

Si ces colonnes manquent, **redémarrez l'application** avec :
```properties
spring.jpa.hibernate.ddl-auto=update
```

---

## 🐛 Dépannage

### Problème 1 : "Twilio désactivé ou mal configuré"

**Cause** : Identifiants Twilio incorrects

**Solution** :
- Vérifiez que vous avez copié **Account SID** et **Auth Token** correctement
- Pas d'espaces avant/après
- Format correct : `ACxxxxx...` pour le SID

### Problème 2 : "SMS non reçu"

**Cause** : Version d'essai gratuite Twilio

**Solution** :
- En version gratuite, vous devez **vérifier les numéros destinataires**
- Allez sur : **Phone Numbers** → **Verified Caller IDs**
- Ajoutez votre numéro malien `+223XXXXXXXX`
- Twilio enverra un code de vérification à ce numéro

### Problème 3 : "Code SMS expiré"

**Cause** : Plus de 5 minutes écoulées

**Solution** :
- Redemandez un nouveau code avec `/api/auth/connexion-telephone`
- Le code expire automatiquement après 5 minutes

### Problème 4 : "Format de téléphone invalide"

**Cause** : Format incorrect

**Solution** :
- Utilisez le format **malien** : `+223XXXXXXXX`
- Exemple valide : `+22370123456`
- 8 chiffres après `+223`

---

## 💰 Coûts Twilio

### Version Gratuite (Trial)
- ✅ **$15 de crédit gratuit**
- ✅ Environ **2000 SMS**
- ⚠️ Seulement vers **numéros vérifiés**
- ⚠️ Message "Sent from a Twilio trial account" ajouté

### Version Payante
- 💵 **~$0.0075 par SMS** vers le Mali
- ✅ Vers **tous les numéros**
- ✅ Sans message "trial"
- ✅ Support 24/7

---

## 🔐 Sécurité

### ⚠️ NE JAMAIS commiter les identifiants

**Mauvais** ❌ :
```properties
twilio.account.sid=AC1234567890abcdef...  # Dans Git !
```

**Bon** ✅ :
```properties
# Option 1 : Variables d'environnement
twilio.account.sid=${TWILIO_ACCOUNT_SID}
twilio.auth.token=${TWILIO_AUTH_TOKEN}
twilio.phone.number=${TWILIO_PHONE_NUMBER}

# Option 2 : Fichier local non versionné
# application-local.properties (ajouté dans .gitignore)
```

### Créer des variables d'environnement (Windows) :

```cmd
setx TWILIO_ACCOUNT_SID "ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
setx TWILIO_AUTH_TOKEN "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
setx TWILIO_PHONE_NUMBER "+1234567890"
```

Puis redémarrez votre IDE.

---

## ✅ Checklist Finale

- [ ] Compte Twilio créé
- [ ] Account SID copié
- [ ] Auth Token copié
- [ ] Numéro Twilio obtenu
- [ ] `application.properties` configuré
- [ ] Application redémarrée
- [ ] Log "Twilio initialisé avec succès" visible
- [ ] Test inscription : ✅
- [ ] Test connexion : SMS reçu ✅
- [ ] Test vérification : Token reçu ✅

---

## 🎉 Résultat Final

Vous avez maintenant un système d'authentification **sécurisé par SMS** :
- 📱 L'utilisateur entre son numéro
- 💬 Il reçoit un code SMS
- ✅ Il entre le code
- 🔑 Il obtient un token JWT

**Prêt pour la production !** 🚀

---

## 📞 Support

Si vous avez des problèmes :
1. Vérifiez les logs de l'application
2. Vérifiez le dashboard Twilio (section "Logs")
3. Testez d'abord avec `twilio.sms.enabled=false`
4. Consultez : https://www.twilio.com/docs/sms

