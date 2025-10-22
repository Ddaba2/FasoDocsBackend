# 📱 Guide de Configuration Twilio pour FasoDocs

## 🎯 Vue d'ensemble

Ce guide vous explique comment configurer Twilio pour l'envoi de SMS dans votre application FasoDocs. Le système utilise maintenant Twilio pour envoyer des codes de vérification SMS lors de la connexion.

## 🔧 Configuration Twilio

### 1. **Créer un Compte Twilio**

1. Allez sur [https://www.twilio.com](https://www.twilio.com)
2. Créez un compte gratuit
3. Vérifiez votre numéro de téléphone
4. Obtenez vos identifiants dans le dashboard

### 2. **Obtenir les Identifiants**

Dans votre dashboard Twilio, vous trouverez :
- **Account SID** : `ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **Auth Token** : `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
- **Phone Number** : `+1234567890` (numéro Twilio)

### 3. **Configuration dans FasoDocs**

Modifiez le fichier `src/main/resources/application.properties` :

```properties
# Configuration Twilio pour l'envoi de SMS
twilio.account.sid=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
twilio.auth.token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
twilio.phone.number=+1234567890
twilio.sms.enabled=true
```

### 4. **Variables d'Environnement (Recommandé)**

Pour la sécurité, utilisez des variables d'environnement :

```bash
# Windows
set TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
set TWILIO_AUTH_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
set TWILIO_PHONE_NUMBER=+1234567890

# Linux/Mac
export TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export TWILIO_AUTH_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export TWILIO_PHONE_NUMBER=+1234567890
```

Puis modifiez `application.properties` :

```properties
# Configuration Twilio pour l'envoi de SMS
twilio.account.sid=${TWILIO_ACCOUNT_SID}
twilio.auth.token=${TWILIO_AUTH_TOKEN}
twilio.phone.number=${TWILIO_PHONE_NUMBER}
twilio.sms.enabled=true
```

## 📱 Flux d'Authentification

### **Nouveau Flux de Connexion**

1. **Étape 1** : L'utilisateur saisit son numéro de téléphone
   ```
   POST /api/auth/connexion-telephone
   {
     "telephone": "+22370000001"
   }
   ```

2. **Étape 2** : Un code SMS est envoyé via Twilio
   ```
   "Votre code de vérification FasoDocs est: 123456
   
   Ce code expire dans 5 minutes.
   
   Ne partagez jamais ce code avec personne."
   ```

3. **Étape 3** : L'utilisateur saisit le code reçu
   ```
   POST /api/auth/verifier-sms
   {
     "telephone": "+22370000001",
     "code": "123456"
   }
   ```

4. **Étape 4** : Un token JWT est retourné pour l'authentification

## 🧪 Tests

### **Test avec Postman**

1. **Connexion par téléphone** :
   ```json
   POST {{base_url}}/api/auth/connexion-telephone
   {
     "telephone": "+22370000001"
   }
   ```

2. **Vérification SMS** :
   ```json
   POST {{base_url}}/api/auth/verifier-sms
   {
     "telephone": "+22370000001",
     "code": "123456"
   }
   ```

### **Test en Mode Développement**

Si vous n'avez pas encore configuré Twilio, le service fonctionne en mode simulation :

```properties
twilio.sms.enabled=false
```

Dans ce cas, le code SMS sera affiché dans les logs :
```
SMS désactivé. Code généré: 123456
```

## 🔒 Sécurité

### **Bonnes Pratiques**

1. **Ne jamais commiter les identifiants** dans le code
2. **Utiliser des variables d'environnement** en production
3. **Limiter les tentatives** de connexion par téléphone
4. **Expiration des codes** : 5 minutes maximum
5. **Validation du format** de téléphone

### **Format de Téléphone Mali**

Le système valide le format malien :
- **Format** : `+223XXXXXXXX`
- **Exemple** : `+22370000001`
- **Validation** : Regex `^\\+223[0-9]{8}$`

## 📊 Monitoring

### **Logs Twilio**

Le service log automatiquement :
- ✅ **SMS envoyés** avec succès
- ❌ **Erreurs d'envoi**
- ⚠️ **SMS désactivés** en mode dev

### **Exemple de Logs**

```
INFO  - Twilio initialisé avec succès
INFO  - SMS envoyé avec succès. SID: SM1234567890abcdef, Téléphone: +22370000001
INFO  - Code SMS envoyé pour la connexion par téléphone: +22370000001
```

## 🚨 Dépannage

### **Problèmes Courants**

#### 1. **Erreur d'initialisation Twilio**
```
Erreur lors de l'initialisation de Twilio: Invalid credentials
```
**Solution** : Vérifiez vos Account SID et Auth Token

#### 2. **Numéro de téléphone invalide**
```
Format de téléphone invalide. Utilisez le format +223XXXXXXXX
```
**Solution** : Utilisez le format malien `+223XXXXXXXX`

#### 3. **SMS non reçu**
- Vérifiez que le numéro Twilio est correct
- Vérifiez votre crédit Twilio
- Vérifiez les logs pour les erreurs

#### 4. **Code SMS expiré**
```
Code SMS expiré
```
**Solution** : Demandez un nouveau code (le code expire après 5 minutes)

### **Vérification de la Configuration**

```bash
# Vérifier que l'application démarre sans erreur
mvn spring-boot:run

# Vérifier les logs Twilio
tail -f logs/application.log | grep -i twilio
```

## 💰 Coûts Twilio

### **Compte Gratuit**
- **Crédit initial** : $15
- **SMS** : ~$0.0075 par SMS
- **Limite** : SMS uniquement vers numéros vérifiés

### **Compte Payant**
- **SMS** : ~$0.0075 par SMS
- **SMS vers tous numéros** : Disponible
- **Support** : 24/7

## 🔄 Migration depuis l'Ancien Système

### **Changements Effectués**

1. ✅ **Nouveau service** : `TwilioSmsService`
2. ✅ **Nouveau endpoint** : `/api/auth/connexion-telephone`
3. ✅ **Nouveau DTO** : `ConnexionTelephoneRequest`
4. ✅ **Validation** : Format téléphone malien
5. ✅ **Sécurité** : Codes à 6 chiffres, expiration 5 min

### **Compatibilité**

- ✅ **Ancien endpoint** : `/api/auth/connexion` toujours disponible
- ✅ **Nouveau endpoint** : `/api/auth/connexion-telephone` pour le nouveau flux
- ✅ **Vérification SMS** : Même endpoint `/api/auth/verifier-sms`

## 🎉 Avantages du Nouveau Système

### ✅ **Sécurité Renforcée**
- Pas de mot de passe à retenir
- Code SMS temporaire
- Validation par téléphone

### ✅ **Expérience Utilisateur**
- Connexion simplifiée
- Pas de mot de passe oublié
- SMS en français

### ✅ **Fiabilité**
- Twilio : service professionnel
- Délivrabilité élevée
- Monitoring intégré

---

**🎯 Résultat** : Système d'authentification par SMS sécurisé et fiable avec Twilio ! 📱✨
