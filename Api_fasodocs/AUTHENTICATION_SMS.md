# Système d'Authentification avec SMS

## Nouveau Flux d'Authentification

### 1. Inscription
L'utilisateur s'inscrit avec seulement 4 informations :
- **Téléphone** (obligatoire, unique)
- **Email** (obligatoire, unique)
- **Mot de passe** (obligatoire, min 6 caractères)
- **Confirmer mot de passe** (obligatoire, doit correspondre au mot de passe)

**Endpoint:** `POST /api/auth/inscription`

**Exemple de requête:**
```json
{
  "telephone": "+22370123456",
  "email": "user@example.com",
  "motDePasse": "password123",
  "confirmerMotDePasse": "password123"
}
```

**Réponse:**
```json
{
  "message": "Inscription réussie! Vous pouvez maintenant vous connecter.",
  "success": true
}
```

### 2. Connexion (Envoi du code SMS)
L'utilisateur se connecte avec son identifiant (email ou téléphone) et son mot de passe.
Le système envoie un code SMS à 6 chiffres valide pendant 5 minutes.

**Endpoint:** `POST /api/auth/connexion`

**Exemple de requête:**
```json
{
  "identifiant": "+22370123456",
  "motDePasse": "password123"
}
```

**Réponse:**
```json
{
  "message": "Un code de vérification a été envoyé à votre téléphone.",
  "success": true
}
```

### 3. Vérification du code SMS
L'utilisateur entre le code reçu par SMS pour finaliser la connexion et recevoir le JWT.

**Endpoint:** `POST /api/auth/verifier-sms`

**Exemple de requête:**
```json
{
  "telephone": "+22370123456",
  "code": "123456",
  "tokenFcm": "firebase-token-optional"
}
```

**Réponse:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "id": 1,
  "nom": null,
  "prenom": null,
  "email": "user@example.com",
  "telephone": "+22370123456",
  "languePreferee": "fr"
}
```

## Modifications de la Base de Données

### Nouvelles colonnes dans la table `citoyens`
- `code_sms` VARCHAR(6) - Code SMS temporaire
- `code_sms_expiration` DATETIME - Date d'expiration du code (5 minutes)
- `telephone_verifie` BOOLEAN - Statut de vérification du téléphone

### Colonnes modifiées
- `nom` - Maintenant NULL (optionnel)
- `prenom` - Maintenant NULL (optionnel)
- `telephone` - Maintenant NOT NULL et UNIQUE
- `email` - Maintenant NOT NULL et UNIQUE

**⚠️ Important:** Exécuter le script de migration `migration-sms-auth.sql` sur votre base de données existante.

## Configuration du Service SMS

### Mode Développement (Actuel)
Le service SMS log actuellement les codes dans la console :
```
📱 SMS de connexion envoyé au +22370123456 - Code: 123456
Message: Votre code de connexion FasoDocs est: 123456. Valide 5 minutes.
```

### Mode Production
Pour activer l'envoi réel de SMS, intégrez un fournisseur SMS dans `SmsService.java` :

#### Option 1: Twilio
```java
// Ajouter la dépendance Twilio dans pom.xml
// Configurer dans application.properties
twilio.account.sid=YOUR_ACCOUNT_SID
twilio.auth.token=YOUR_AUTH_TOKEN
twilio.phone.number=YOUR_TWILIO_NUMBER
```

#### Option 2: Orange SMS API (Mali)
```java
// Configuration Orange SMS API
orange.api.key=YOUR_API_KEY
orange.sender.name=FasoDocs
```

#### Option 3: Africa's Talking
```java
// Configuration Africa's Talking
africastalking.username=YOUR_USERNAME
africastalking.api.key=YOUR_API_KEY
```

## Sécurité

### Protection contre les abus
- Code SMS valide pendant 5 minutes seulement
- Un seul code actif par utilisateur
- Le code est régénéré à chaque tentative de connexion

### Recommandations
- Implémenter un rate limiting sur `/api/auth/connexion`
- Limiter le nombre de tentatives de vérification SMS
- Logger les tentatives échouées
- Ajouter un CAPTCHA après plusieurs échecs

## Tests

### Test d'inscription
```bash
curl -X POST http://localhost:8080/api/auth/inscription \
  -H "Content-Type: application/json" \
  -d '{
    "telephone": "+22370123456",
    "email": "test@example.com",
    "motDePasse": "password123",
    "confirmerMotDePasse": "password123"
  }'
```

### Test de connexion
```bash
curl -X POST http://localhost:8080/api/auth/connexion \
  -H "Content-Type: application/json" \
  -d '{
    "identifiant": "+22370123456",
    "motDePasse": "password123"
  }'
```

### Test de vérification SMS
```bash
# Récupérer le code dans les logs de l'application
curl -X POST http://localhost:8080/api/auth/verifier-sms \
  -H "Content-Type: application/json" \
  -d '{
    "telephone": "+22370123456",
    "code": "123456"
  }'
```

## Migration des Utilisateurs Existants

Si vous avez déjà des utilisateurs dans la base de données :

1. Exécuter le script de migration SQL
2. Les utilisateurs existants auront `telephone_verifie = TRUE`
3. Ils devront suivre le nouveau flux à leur prochaine connexion
4. Les champs `nom` et `prenom` peuvent rester NULL temporairement

