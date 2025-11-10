# 📱 Guide d'Intégration - Orange SMS API (Mali)

**Authentification par SMS pour FasoDocs**

---

## 📋 Table des Matières

- [Vue d'Ensemble](#vue-densemble)
- [Architecture](#architecture)
- [Fichiers Impliqués](#fichiers-impliqués)
- [Configuration](#configuration)
- [Flux d'Authentification](#flux-dauthentification)
- [Intégration Frontend](#intégration-frontend)
- [Mode Développement](#mode-développement)
- [Production](#production)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Vue d'Ensemble

FasoDocs utilise l'**API Orange SMS du Mali** pour l'authentification par téléphone :
- ✅ Connexion sans mot de passe
- ✅ Envoi de codes de vérification par SMS
- ✅ Authentification sécurisée
- ✅ Conformité aux standards Orange Mali

---

## 🏗️ Architecture

```
┌──────────────────────┐
│   Flutter Mobile     │
└──────────┬───────────┘
           │ POST /auth/connexion-telephone
           │ {"telephone": "+22376123456"}
           ↓
┌──────────────────────────────────────────┐
│      Spring Boot Backend                 │
│                                          │
│  • AuthController                        │
│  • AuthService                           │
│  • SmsService (Orchestrateur)            │
│  • OrangeSmsService                      │
└──────────┬───────────────────────────────┘
           │ HTTPS
           │ OAuth 2.0 + SMS
           ↓
┌──────────────────────────────────────────┐
│     Orange SMS API (Mali)                │
│  https://api.orange.com/smsmessaging/v1  │
│                                          │
│  • /oauth/v3/token (Authentification)    │
│  • /outbound/{sender}/requests (SMS)     │
└──────────────────────────────────────────┘
           │
           ↓
┌──────────────────────────────────────────┐
│   Téléphone de l'Utilisateur            │
│   📱 Reçoit le code SMS                  │
└──────────────────────────────────────────┘
```

---

## 📁 Fichiers Impliqués

### 1. **OrangeSmsService.java** ⭐
**Emplacement** : `src/main/java/ml/fasodocs/backend/service/OrangeSmsService.java`

**Rôle** : Service principal pour interaction avec l'API Orange SMS

**Méthodes Principales** :

```java
// Génère un code à 4 chiffres
public String genererCodeVerification()

// Vérifie si Orange SMS est configuré
public boolean isOrangeSmsConfigured()

// Authentifie avec OAuth 2.0 et obtient access token
private boolean authenticate()

// Envoie SMS de connexion avec code
public void envoyerSmsConnexion(String telephone, String code)

// Envoie SMS d'inscription
public void envoyerSmsInscription(String telephone, String code)

// Rate limiting (5 SMS/seconde max)
private void checkRateLimit()

// Statistiques du service
public Map<String, Object> getServiceStatus()
```

**Lignes Clés** :
- **Ligne 32-51** : Configuration (credentials Orange)
- **Ligne 56-58** : Rate Limiting (Semaphore)
- **Ligne 85-151** : Authentification OAuth 2.0
- **Ligne 153-196** : Envoi SMS connexion
- **Ligne 198-241** : Envoi SMS inscription
- **Ligne 274-314** : Méthode privée d'envoi SMS générique

---

### 2. **SmsService.java**
**Emplacement** : `src/main/java/ml/fasodocs/backend/service/SmsService.java`

**Rôle** : Orchestrateur SMS (choisit entre Orange SMS ou mode dev)

**Méthodes** :

```java
public String genererCodeVerification()
public void envoyerSmsVerification(String telephone, String code)
public void envoyerSmsConnexion(String telephone, String code)
public void envoyerSmsInscription(String telephone, String code)
```

**Logique** :
```java
if (orangeSmsEnabled && orangeSmsService != null) {
    // Utiliser Orange SMS (production)
    orangeSmsService.envoyerSmsConnexion(telephone, code);
} else {
    // Mode développement: log le code
    logger.info("📱 SMS au {} - Code: {}", telephone, code);
}
```

---

### 3. **AuthService.java**
**Emplacement** : `src/main/java/ml/fasodocs/backend/service/AuthService.java`

**Rôle** : Gestion authentification utilisateurs

**Méthodes SMS** :
```java
// Connexion par téléphone (envoie SMS)
public MessageResponse connexionParTelephone(ConnexionTelephoneRequest request)

// Vérification code SMS et génération JWT
public JwtResponse verifierSms(VerificationSmsRequest request)
```

**Flux** :
1. Générer code 4 chiffres
2. Enregistrer code + expiration en BD (5 min)
3. Appeler `smsService.envoyerSmsConnexion()`
4. Retourner succès au client

---

### 4. **AuthController.java**
**Emplacement** : `src/main/java/ml/fasodocs/backend/controller/AuthController.java`

**Rôle** : Endpoints REST d'authentification

**Endpoints SMS** :

```java
@PostMapping("/connexion-telephone")
public ResponseEntity<?> connexionParTelephone(@RequestBody ConnexionTelephoneRequest request)

@PostMapping("/verifier-sms")
public ResponseEntity<?> verifierSms(@RequestBody VerificationSmsRequest request)
```

---

### 5. **AdminController.java**
**Emplacement** : `src/main/java/ml/fasodocs/backend/controller/AdminController.java`

**Endpoint de Monitoring** :

```java
@GetMapping("/admin/sms/status")
public ResponseEntity<?> getOrangeSmsStatus()
```

**Retourne** :
```json
{
  "enabled": true,
  "configured": true,
  "rateLimitAvailable": 5,
  "rateLimitMax": 5,
  "info": "Rate limit: 5 SMS par seconde"
}
```

---

### 6. **DTOs**

| Fichier | Rôle |
|---------|------|
| **ConnexionTelephoneRequest** | Requête connexion (téléphone uniquement) |
| **VerificationSmsRequest** | Requête vérification (téléphone + code) |
| **JwtResponse** | Réponse avec token JWT |
| **MessageResponse** | Réponse générique succès/erreur |

---

## ⚙️ Configuration

### application.properties

```properties
# Configuration Orange SMS API pour le Mali
# IMPORTANT: Mettre à true SEULEMENT avec des credentials Orange valides
orange.sms.enabled=false                # true en production
orange.sms.base.url=https://api.orange.com/smsmessaging/v1
orange.sms.client.id=votre_client_id
orange.sms.client.secret=votre_client_secret
orange.sms.authorization.header=base64(client_id:client_secret)
orange.sms.application.id=votre_client_id
orange.sms.sender.address=tel:+22383784097
orange.sms.sender.name=FasoDocs
```

### Variables d'Environnement (Production)

```bash
export ORANGE_SMS_CLIENT_ID=...
export ORANGE_SMS_CLIENT_SECRET=...
export ORANGE_SMS_SENDER_ADDRESS=tel:+223...
```

---

## 🔄 Flux d'Authentification Complet

### Étape 1 : Demande de Connexion

**Frontend** → **Backend** :
```http
POST /api/auth/connexion-telephone
{
  "telephone": "+22376123456"
}
```

**Backend** :
```java
// AuthService.java
public MessageResponse connexionParTelephone(request) {
    // 1. Chercher ou créer citoyen
    Citoyen citoyen = findOrCreateByTelephone(telephone);
    
    // 2. Générer code 4 chiffres
    String code = smsService.genererCodeVerification(); // "1234"
    
    // 3. Enregistrer en BD avec expiration
    citoyen.setCodeSms(code);
    citoyen.setCodeSmsExpiration(LocalDateTime.now().plusMinutes(5));
    citoyenRepository.save(citoyen);
    
    // 4. Envoyer SMS
    smsService.envoyerSmsConnexion(telephone, code);
    
    return MessageResponse.success("Code envoyé par SMS");
}
```

---

### Étape 2 : Envoi SMS via Orange

**SmsService** → **OrangeSmsService** :

```java
// OrangeSmsService.java
public void envoyerSmsConnexion(String telephone, String code) {
    // 1. S'authentifier si besoin
    if (!isTokenValid()) {
        authenticate();  // OAuth 2.0
    }
    
    // 2. Vérifier rate limit
    checkRateLimit();  // Max 5 SMS/seconde
    
    // 3. Construire message
    String message = String.format(
        "Votre code FasoDocs : %s\nValide 5 minutes.\nNe le partagez pas.",
        code
    );
    
    // 4. Envoyer SMS
    sendSms(telephone, message);
}
```

**Requête OAuth 2.0** :
```http
POST https://api.orange.com/oauth/v3/token
Authorization: Basic <base64(client_id:client_secret)>
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
```

**Réponse** :
```json
{
  "access_token": "eyJhbGc...",
  "token_type": "Bearer",
  "expires_in": 7200
}
```

**Requête SMS** :
```http
POST https://api.orange.com/smsmessaging/v1/outbound/tel:+22383784097/requests
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "outboundSMSMessageRequest": {
    "address": "tel:+22376123456",
    "senderAddress": "tel:+22383784097",
    "senderName": "FasoDocs",
    "outboundSMSTextMessage": {
      "message": "Votre code FasoDocs : 1234..."
    }
  }
}
```

---

### Étape 3 : Utilisateur Reçoit SMS

📱 **Téléphone** : "Votre code FasoDocs : 1234. Valide 5 minutes."

---

### Étape 4 : Vérification du Code

**Frontend** → **Backend** :
```http
POST /api/auth/verifier-sms
{
  "telephone": "+22376123456",
  "code": "1234"
}
```

**Backend** :
```java
// AuthService.java
public JwtResponse verifierSms(request) {
    // 1. Trouver citoyen
    Citoyen citoyen = findByTelephone(telephone);
    
    // 2. Vérifier code
    if (!code.equals(citoyen.getCodeSms())) {
        throw new RuntimeException("Code invalide");
    }
    
    // 3. Vérifier expiration
    if (LocalDateTime.now().isAfter(citoyen.getCodeSmsExpiration())) {
        throw new RuntimeException("Code expiré");
    }
    
    // 4. Marquer téléphone comme vérifié
    citoyen.setTelephoneVerifie(true);
    citoyen.setCodeSms(null);
    citoyenRepository.save(citoyen);
    
    // 5. Générer JWT
    String token = jwtUtils.generateJwtToken(citoyen);
    
    return new JwtResponse(token, citoyen);
}
```

**Réponse** :
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "type": "Bearer",
  "id": 1,
  "telephone": "+22376123456",
  "nom": "Diallo",
  "prenom": "Amadou",
  "roles": ["ROLE_CITOYEN"]
}
```

---

## 📱 Intégration Frontend Flutter

### Service Auth

**Fichier** : `lib/services/auth_service.dart`

```dart
class AuthService {
  static const String baseUrl = 'http://192.168.X.X:8080/api';
  
  // Étape 1 : Demander code SMS
  Future<bool> connexionParTelephone(String telephone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/connexion-telephone'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'telephone': telephone}),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    }
    return false;
  }
  
  // Étape 2 : Vérifier code SMS
  Future<String?> verifierSms(String telephone, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verifier-sms'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'telephone': telephone,
        'code': code,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      
      // Sauvegarder token
      await storage.write(key: 'jwt_token', value: token);
      
      return token;
    }
    return null;
  }
}
```

### Écrans Flutter

#### Écran 1 : Saisie Téléphone

```dart
class LoginScreen extends StatelessWidget {
  Future<void> _login() async {
    final telephone = phoneController.text;
    
    // Envoyer requête
    bool success = await AuthService().connexionParTelephone(telephone);
    
    if (success) {
      // Naviguer vers écran de vérification
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationScreen(telephone: telephone),
        ),
      );
    }
  }
}
```

#### Écran 2 : Vérification Code

```dart
class VerificationScreen extends StatelessWidget {
  final String telephone;
  
  Future<void> _verify() async {
    final code = codeController.text;
    
    // Vérifier code
    String? token = await AuthService().verifierSms(telephone, code);
    
    if (token != null) {
      // Connexion réussie
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      // Code invalide
      showError('Code invalide ou expiré');
    }
  }
}
```

---

## 🛠️ Mode Développement

### Configuration

```properties
# application.properties
orange.sms.enabled=false  # ← Mode développement
```

### Comportement

Quand `orange.sms.enabled=false` :
- ❌ Pas d'appel à l'API Orange
- ✅ Le code SMS est **affiché dans les logs du serveur**
- ✅ Pas besoin de credentials Orange
- ✅ Idéal pour développement/tests

### Logs en Mode Dev

```
📱 ====================================
📱 CODE SMS GÉNÉRÉ (MODE DEV)
📱 ====================================
📱 Téléphone : +22376123456
📱 Code      : 1234
📱 Expiration: 5 minutes
📱 ====================================
⚠️  Mode développement actif
```

**Pour tester** : Utilise le code affiché dans les logs !

---

## 🚀 Production

### 1. Obtenir Credentials Orange

**Contact Orange Mali** :
- Email : developers.orange.com
- Site : https://developer.orange.com/
- Créer un compte développeur
- Créer une application SMS
- Obtenir : `client_id`, `client_secret`, `sender_address`

### 2. Configuration Production

```properties
# application.properties (PRODUCTION)
orange.sms.enabled=true  # ← Activer Orange SMS

# Credentials Orange (depuis compte développeur)
orange.sms.client.id=VotreClientId
orange.sms.client.secret=VotreClientSecret
orange.sms.sender.address=tel:+223XXXXXXXX
orange.sms.sender.name=FasoDocs

# Base URL Orange Mali
orange.sms.base.url=https://api.orange.com/smsmessaging/v1
```

### 3. Authorization Header

Générer le header d'autorisation :

```bash
echo -n "client_id:client_secret" | base64
```

Copier le résultat dans :
```properties
orange.sms.authorization.header=<base64_result>
```

---

## 📊 Rate Limiting

Orange impose **5 SMS maximum par seconde**.

**Implémentation** :
```java
// OrangeSmsService.java:56-58
private final Semaphore rateLimiter = new Semaphore(5);
private long lastResetTime = System.currentTimeMillis();

private void checkRateLimit() {
    long currentTime = System.currentTimeMillis();
    
    // Reset toutes les secondes
    if (currentTime - lastResetTime >= 1000) {
        rateLimiter.release(5 - rateLimiter.availablePermits());
        lastResetTime = currentTime;
    }
    
    // Acquérir permit
    try {
        if (!rateLimiter.tryAcquire(1, 2, TimeUnit.SECONDS)) {
            throw new SmsSendException("Rate limit dépassé");
        }
    } catch (InterruptedException e) {
        throw new SmsSendException("Interruption rate limiting");
    }
}
```

---

## 🔒 Sécurité

### 1. Expiration des Codes

- **Durée** : 5 minutes
- **Stockage** : `code_sms_expiration` dans BD
- **Vérification** : Avant validation

### 2. Validation Téléphone

```java
// Format attendu : +223XXXXXXXX
String cleanTelephone = telephone.startsWith("+") ? telephone : "+" + telephone;
```

### 3. Protection contre Abus

- ✅ Rate limiting (5 SMS/seconde)
- ✅ Expiration des codes (5 minutes)
- ⚠️ TODO : Limiter nombre de demandes par IP/téléphone

---

## 🐛 Troubleshooting

### Erreur : Credentials invalides

**Logs** :
```
❌ Erreur authentification Orange: 401 Unauthorized
```

**Solution** :
1. Vérifier `client_id` et `client_secret`
2. Vérifier `authorization.header` (Base64 correct)
3. Vérifier que l'application est active sur Orange Developer Portal

---

### Erreur : SMS non reçu (Production)

**Vérifications** :
1. `orange.sms.enabled=true` ?
2. Credentials corrects ?
3. `sender.address` validé par Orange ?
4. Téléphone au bon format (+223...) ?
5. Quota SMS Orange pas dépassé ?

---

### Erreur : Rate limit dépassé

**Logs** :
```
⚠️ Rate limit: 4/5 disponibles
❌ Rate limit dépassé
```

**Solution** : Attendre 1 seconde ou optimiser flux d'envoi

---

## 📈 Monitoring

### Endpoint de Statut

```bash
curl http://localhost:8080/api/admin/sms/status \
  -H "Authorization: Bearer <token_admin>"
```

**Réponse** :
```json
{
  "enabled": true,
  "configured": true,
  "rateLimitAvailable": 5,
  "rateLimitMax": 5,
  "info": "Rate limit: 5 SMS par seconde (limite Orange)"
}
```

---

## 📚 Documentation Orange

- **Portail Développeur** : https://developer.orange.com
- **API SMS Doc** : https://developer.orange.com/apis/sms
- **Support** : Via portail développeur

---

## 🎯 Points Clés

✅ **OAuth 2.0** : Authentification automatique avec refresh token  
✅ **Rate Limiting** : 5 SMS/seconde respectés  
✅ **Mode Dev** : Codes dans les logs (pas d'appel Orange)  
✅ **Expiration** : Codes valides 5 minutes  
✅ **Format SMS** : Clair et professionnel  
✅ **Sécurité** : JWT après vérification  

---

## 📝 Format des Messages SMS

### Connexion
```
Votre code FasoDocs : 1234
Valide 5 minutes.
Ne le partagez pas.
```

### Inscription
```
Bienvenue sur FasoDocs !
Votre code de vérification : 1234
Valide 5 minutes.
```

---

**© 2025 FasoDocs - Authentification SMS Orange** 🇲🇱📱

