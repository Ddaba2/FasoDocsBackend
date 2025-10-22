# 🔍 Vérification Rapide de la Configuration Twilio

## ✅ Checklist de Vérification

### 1. Fichiers Créés
- [ ] `TwilioSmsService.java` existe dans `src/main/java/ml/fasodocs/backend/service/`
- [ ] `ConnexionTelephoneRequest.java` existe dans `src/main/java/ml/fasodocs/backend/dto/request/`
- [ ] `VerificationSmsRequest.java` existe dans `src/main/java/ml/fasodocs/backend/dto/request/`

### 2. Configuration application.properties

Ouvrez `src/main/resources/application.properties` et vérifiez :

```properties
# Ces lignes doivent exister :
twilio.account.sid=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
twilio.auth.token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
twilio.phone.number=+1234567890
twilio.sms.enabled=true
```

**État actuel** :
- Si `twilio.sms.enabled=true` → Les SMS seront envoyés via Twilio
- Si `twilio.sms.enabled=false` → Le code sera affiché dans les logs (mode développement)

### 3. Base de Données

La table `citoyens` doit avoir ces colonnes :

| Colonne | Type | Description |
|---------|------|-------------|
| `code_sms` | VARCHAR(6) | Le code SMS à 6 chiffres |
| `code_sms_expiration` | DATETIME | Date d'expiration du code |
| `telephone_verifie` | BOOLEAN | Si le téléphone est vérifié |

**Vérification** :
1. Ouvrez MySQL Workbench ou phpMyAdmin
2. Sélectionnez la base `FasoDocs`
3. Exécutez :
```sql
DESCRIBE citoyens;
```
4. Vérifiez que les 3 colonnes existent

**Si les colonnes manquent** :
- Vérifiez que `spring.jpa.hibernate.ddl-auto=update` dans `application.properties`
- Redémarrez l'application
- Les colonnes seront créées automatiquement

### 4. Dépendances Maven

Dans `pom.xml`, vérifiez que cette dépendance existe :

```xml
<!-- Twilio pour l'envoi de SMS -->
<dependency>
    <groupId>com.twilio.sdk</groupId>
    <artifactId>twilio</artifactId>
    <version>9.10.0</version>
</dependency>
```

### 5. Endpoints REST Disponibles

L'application doit exposer ces endpoints :

| Endpoint | Méthode | Description | Authentification |
|----------|---------|-------------|------------------|
| `/api/auth/inscription` | POST | Inscription | Non |
| `/api/auth/connexion-telephone` | POST | Demande code SMS | Non |
| `/api/auth/verifier-sms` | POST | Vérifie code et donne JWT | Non |
| `/api/auth/profil` | GET | Obtient profil | Oui (JWT) |
| `/api/procedures` | GET | Liste procédures | Non |
| `/api/notifications` | GET | Liste notifications | Oui (JWT) |

---

## 🧪 Tests de Vérification

### Test 1 : Application Démarre Correctement

**Démarrez l'application** et cherchez dans les logs :

✅ **Succès** :
```
INFO - Twilio initialisé avec succès
INFO - Started FasodocsBackendApplication in X seconds
```

❌ **Erreur** :
```
ERROR - Erreur lors de l'initialisation de Twilio: Invalid credentials
```
→ Vérifiez vos identifiants Twilio

⚠️ **Avertissement** (OK en dev) :
```
WARN - Twilio désactivé ou mal configuré
```
→ Si `twilio.sms.enabled=false`, c'est normal

### Test 2 : Endpoints Accessibles

Dans Postman ou votre navigateur, testez :

```
GET http://localhost:8080/api/procedures
```

✅ **Succès** : Statut `200 OK`, liste JSON retournée
❌ **Erreur** : Statut `401 Unauthorized`

**Si erreur 401** :
- Les endpoints publics ne sont pas configurés
- Vérifiez que la correction du préfixe `/api` a été faite
- Redémarrez l'application

### Test 3 : Inscription Fonctionne

**Avec Postman** :
```http
POST http://localhost:8080/api/auth/inscription
Content-Type: application/json

{
  "telephone": "+22370999999",
  "email": "test-verif@fasodocs.ml",
  "motDePasse": "Test123!",
  "confirmerMotDePasse": "Test123!"
}
```

✅ **Succès** :
```json
{
  "success": true,
  "message": "Inscription réussie! Vous pouvez maintenant vous connecter."
}
```

❌ **Erreur** :
```json
{
  "success": false,
  "message": "Erreur: Le téléphone est déjà utilisé!"
}
```
→ Changez le numéro de téléphone

### Test 4 : Envoi de Code SMS

**Avec Postman** :
```http
POST http://localhost:8080/api/auth/connexion-telephone
Content-Type: application/json

{
  "telephone": "+22370999999"
}
```

✅ **Succès** :
```json
{
  "success": true,
  "message": "Un code de vérification a été envoyé à votre téléphone."
}
```

**Vérifiez ensuite** :

**Si `twilio.sms.enabled=true`** :
- 📱 Vous devez recevoir un SMS sur votre téléphone

**Si `twilio.sms.enabled=false`** :
- 📝 Cherchez dans les logs :
```
WARN - SMS désactivé. Code généré: 123456
INFO - Code SMS envoyé pour la connexion par téléphone: +22370999999
```

### Test 5 : Vérification du Code

**Utilisez le code reçu/vu dans les logs** :
```http
POST http://localhost:8080/api/auth/verifier-sms
Content-Type: application/json

{
  "telephone": "+22370999999",
  "code": "123456"
}
```

✅ **Succès** :
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "id": 2,
  "email": "test-verif@fasodocs.ml",
  "telephone": "+22370999999"
}
```

❌ **Erreur - Code invalide** :
```json
{
  "success": false,
  "message": "Erreur de vérification: Code SMS invalide"
}
```

❌ **Erreur - Code expiré** :
```json
{
  "success": false,
  "message": "Erreur de vérification: Code SMS expiré"
}
```

---

## 🔍 Logs à Surveiller

Voici ce que vous devez voir dans les logs lors d'une connexion réussie :

```
INFO  - Nouveau citoyen inscrit avec le téléphone: +22370999999
INFO  - SMS envoyé avec succès. SID: SM1234567890abcdef, Téléphone: +22370999999
INFO  - Code SMS envoyé pour la connexion par téléphone: +22370999999
INFO  - Citoyen connecté après vérification SMS: +22370999999
```

---

## 📊 État de la Configuration

### ✅ Configuration Complète (Production)

```
✅ Compte Twilio créé
✅ Identifiants Twilio configurés
✅ twilio.sms.enabled=true
✅ Numéro Twilio obtenu
✅ Base de données à jour
✅ Application redémarrée
✅ Logs "Twilio initialisé avec succès"
✅ Tests passent
```

### ⚠️ Configuration Partielle (Développement)

```
⚠️ Compte Twilio pas encore créé
⚠️ twilio.sms.enabled=false
✅ Code affiché dans les logs
✅ Tests fonctionnent (sans SMS)
```

---

## 🚨 Problèmes Courants et Solutions

### Problème 1 : "Le terme 'mvnw' n'est pas reconnu"

**Solution** :
- Utilisez votre IDE (IntelliJ, Eclipse) pour compiler
- OU installez Maven : https://maven.apache.org/download.cgi

### Problème 2 : "401 Unauthorized" sur tous les endpoints

**Cause** : Duplication du préfixe `/api`

**Vérification** :
1. Ouvrez `SecurityConfig.java`
2. Les chemins doivent être : `/auth/**`, `/procedures/**` (sans `/api`)
3. Ouvrez `AuthController.java`
4. Doit avoir : `@RequestMapping("/auth")` (sans `/api`)

**Si pas corrigé** :
- Relancez les corrections des contrôleurs
- Redémarrez l'application

### Problème 3 : Colonnes manquantes en base de données

**Solution** :
1. Arrêtez l'application
2. Dans `application.properties`, vérifiez :
   ```properties
   spring.jpa.hibernate.ddl-auto=update
   ```
3. Redémarrez l'application
4. Vérifiez les logs Hibernate :
   ```
   Hibernate: alter table citoyens add column code_sms varchar(6)
   ```

### Problème 4 : "Invalid credentials" Twilio

**Solution** :
1. Allez sur https://console.twilio.com
2. Vérifiez votre **Account SID** (commence par `AC`)
3. Vérifiez votre **Auth Token** (cliquez sur "Show")
4. Recopiez-les **exactement** dans `application.properties`
5. Redémarrez l'application

---

## 📝 Résumé de l'État

Cochez ce qui est fait :

- [ ] ✅ Code corrigé (préfixe `/api` enlevé des contrôleurs)
- [ ] ✅ Base de données à jour (colonnes SMS présentes)
- [ ] ✅ Dépendances Maven OK
- [ ] ✅ Application démarre sans erreur
- [ ] ⚠️ Compte Twilio créé (optionnel pour dev)
- [ ] ⚠️ Identifiants Twilio configurés (optionnel pour dev)
- [ ] ⚠️ Mode SMS activé/désactivé configuré

**État minimal pour tester** : 3 premiers ✅ + mode dev (`twilio.sms.enabled=false`)

**État complet pour production** : Tous ✅ avec SMS activé

---

## 🎯 Prochaine Étape

**Si tout est ✅** :
1. Importez `Test_Authentification_SMS.postman_collection.json` dans Postman
2. Lancez les requêtes dans l'ordre
3. Vérifiez que tout fonctionne

**Si problèmes** :
1. Consultez la section "Problèmes Courants" ci-dessus
2. Vérifiez les logs de l'application
3. Testez étape par étape

---

Bonne chance ! 🚀

