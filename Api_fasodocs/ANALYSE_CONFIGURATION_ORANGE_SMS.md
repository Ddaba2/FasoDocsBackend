# 📋 Analyse Configuration Orange SMS - Conformité Documentation Officielle

## 🔍 Comparaison avec la Documentation Orange

Référence : [Orange SMS API Getting Started](https://developer.orange.com/apis/sms/getting-started)

---

## ✅ Points conformes à la documentation

### 1. **OAuth Token URL** ✅

**Documentation Orange :**
```
Token URL: https://api.orange.com/oauth/v3/token
```

**Configuration actuelle :**
```properties
# Utilisé dans OrangeSmsService.java ligne 164
https://api.orange.com/oauth/v3/token
```

✅ **CONFORME** - URL correcte avec version v3

---

### 2. **Messaging Base URL** ✅

**Documentation Orange :**
```
Messaging base-url: https://api.orange.com/smsmessaging/v1
```

**Configuration actuelle :**
```properties
orange.sms.base.url=https://api.orange.com/smsmessaging/v1
```

✅ **CONFORME** - URL correcte

---

### 3. **Authentification OAuth 2.0** ✅

**Documentation Orange :**
```
POST https://api.orange.com/oauth/v3/token
Headers:
  Authorization: Basic {base64(client_id:client_secret)}
  Content-Type: application/x-www-form-urlencoded
Body:
  grant_type=client_credentials
```

**Implémentation actuelle (OrangeSmsService.java lignes 234-251) :**
```java
String credentials = clientId + ":" + clientSecret;
String encodedCredentials = Base64.getEncoder().encodeToString(
    credentials.getBytes(StandardCharsets.UTF_8));
String authHeaderValue = "Basic " + encodedCredentials;

HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
headers.set("Authorization", authHeaderValue);

MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
body.add("grant_type", "client_credentials");
```

✅ **CONFORME** - Format correct

---

### 4. **Gestion du Token (expiration)** ✅

**Documentation Orange :**
```
Token valide pendant: 3600 secondes (1 heure)
Gérer les erreurs "Expired credentials" (code 42)
```

**Implémentation actuelle :**
```java
// Ligne 153-156 : Vérification expiration
if (accessToken != null && System.currentTimeMillis() < tokenExpirationTime) {
    logger.debug("Using cached access token");
    return true;
}

// Ligne 273 : Calcul expiration avec marge de sécurité
tokenExpirationTime = System.currentTimeMillis() + (expiresIn * 1000) - 60000;
```

✅ **CONFORME** - Gestion du cache et expiration correcte

---

### 5. **Rate Limiting (5 SMS/seconde)** ✅

**Documentation Orange :**
```
TPS limité à 5 SMS par seconde
```

**Implémentation actuelle :**
```java
// Ligne 59 : Semaphore avec 5 permits
private final Semaphore rateLimiter = new Semaphore(5);

// Lignes 545-567 : Vérification du rate limit
private void checkRateLimit() throws InterruptedException {
    // Reset chaque seconde
    // Bloque si limite atteinte
}
```

✅ **CONFORME** - Rate limiting implémenté correctement

---

### 6. **Format du Destinataire** ✅

**Documentation Orange :**
```
Format: tel:+{country_code}{phone_number}
Exemple: tel:+223XXXXXXXX
```

**Implémentation actuelle :**
```java
// Ligne 578-582 : Normalisation
String normalizedPhone = normalizeMaliPhoneNumber(telephone);
String destinationAddress = "tel:" + normalizedPhone;
// Résultat: tel:+223XXXXXXXX
```

✅ **CONFORME** - Format correct dans le body

---

### 7. **Format du Sender Address dans le Body** ✅

**Documentation Orange :**
```
Dans le body JSON:
senderAddress: "tel:+{country_code}{phone_number}"
```

**Implémentation actuelle :**
```java
// Ligne 591-597 : Normalisation
String cleanSenderAddress = senderAddress;
if (!cleanSenderAddress.startsWith("tel:")) {
    cleanSenderAddress = "tel:" + (cleanSenderAddress.startsWith("+") 
        ? cleanSenderAddress : "+" + cleanSenderAddress);
}

// Ligne 637 : Utilisation dans le body
outboundSMSMessageRequest.put("senderAddress", cleanSenderAddress);
```

✅ **CONFORME** - Format `tel:+223...` correct dans le body

---

## ⚠️ Points à vérifier / Problèmes potentiels

### 1. **Format du Sender Address dans l'URL** ⚠️ **CRITIQUE**

**Documentation Orange :**
```
URL: /outbound/{senderAddress}/requests

Important: Le senderAddress dans l'URL doit utiliser le code pays
sans préfixe + ou 00.

Exemple pour le Mali:
- Code pays: 223
- Format URL: /outbound/tel:223XXXXXXXX/requests
  OU simplement: /outbound/223XXXXXXXX/requests
```

**Configuration actuelle :**
```properties
orange.sms.sender.address=tel:+22383784097
```

**Implémentation actuelle (lignes 602-606) :**
```java
String senderAddressForUrl = cleanSenderAddress
    .replace("+", "%2B")  // Encode + en %2B
    .replace(":", "%3A");  // Encode : en %3A

String smsUrl = baseUrl + "/outbound/" + senderAddressForUrl + "/requests";
// Résultat: /outbound/tel%3A%2B22383784097/requests
```

❌ **PROBLÈME POTENTIEL** : 

Selon la documentation Orange, le format dans l'URL devrait être :
- Soit `tel:22383784097` (sans le `+`)
- Soit simplement `22383784097` (sans `tel:` ni `+`)

**Recommandation :**
Extraire seulement le numéro avec le code pays sans le `+` :
```java
// Pour le Mali: 22383784097
// Format URL attendu: /outbound/tel:22383784097/requests
```

---

### 2. **Gestion du Scope dans OAuth** ⚠️

**Documentation Orange :**
La documentation n'indique pas explicitement l'utilisation du paramètre `scope=SMS`.

**Implémentation actuelle :**
```java
// Ligne 248-250 : Test avec et sans scope
if (withScope) {
    body.add("scope", "SMS");
}
```

✅ **ACCEPTABLE** : Le code teste plusieurs configurations, ce qui est une bonne approche de fallback.

---

### 3. **Code Pays dans l'URL** ⚠️

**Documentation Orange :**
```
Le senderAddress dans l'URL doit contenir le code pays
sans préfixe + ou 00

Pour le Mali:
- Code pays ISO: MLI
- Code téléphonique: 223
- Format recommandé dans l'URL: 223XXXXXXXX (sans +, sans tel:)
```

**Analyse de votre configuration :**

Dans `application.properties` :
```properties
orange.sms.sender.address=tel:+22383784097
```

**Pour le Mali, le format dans l'URL devrait être :**

**Option 1 (recommandé par Orange) :**
```
/outbound/tel:22383784097/requests
```
(sans le `+`)

**Option 2 :**
```
/outbound/22383784097/requests
```
(sans `tel:` et sans `+`)

**Votre format actuel :**
```
/outbound/tel%3A%2B22383784097/requests
```
(URL-encoded mais avec le `+`)

---

### 4. **Sender Name** ✅

**Documentation Orange :**
```
Sender name peut être:
- Par défaut (automatique)
- Personnalisé (nécessite enregistrement chez Orange)
```

**Configuration actuelle :**
```properties
orange.sms.sender.name=SMS 948223
```

**Implémentation :**
```java
// Lignes 647-655 : Ajout conditionnel du senderName
if (senderName != null && !senderName.trim().isEmpty()) {
    outboundSMSMessageRequest.put("senderName", senderName);
}
```

✅ **CONFORME** - Format correct

---

## 🔧 Corrections recommandées

### **Correction 1 : Format du Sender Address dans l'URL**

**Code actuel (lignes 599-606) :**
```java
String senderAddressForUrl = cleanSenderAddress
    .replace("+", "%2B")
    .replace(":", "%3A");
String smsUrl = baseUrl + "/outbound/" + senderAddressForUrl + "/requests";
```

**Code recommandé :**
```java
/**
 * Extrait le numéro pour l'URL (code pays sans préfixe +)
 * Exemple: tel:+22383784097 -> tel:22383784097
 */
private String extractSenderForUrl(String senderAddress) {
    // Enlever tel: si présent
    String number = senderAddress.replace("tel:", "").trim();
    
    // Enlever le + devant le code pays
    if (number.startsWith("+")) {
        number = number.substring(1); // Enlève le +
    }
    
    // Pour le Mali, on garde tel:223...
    // OU simplement 223... (selon préférence Orange)
    return "tel:" + number; // Format: tel:22383784097
}

// Utilisation
String senderForUrl = extractSenderForUrl(cleanSenderAddress);
// Encoder pour l'URL
String senderAddressForUrl = senderForUrl
    .replace(":", "%3A");  // Seulement le :, pas le +
String smsUrl = baseUrl + "/outbound/" + senderAddressForUrl + "/requests";
```

**Résultat :**
- URL générée : `/outbound/tel%3A22383784097/requests`
- Décodé : `/outbound/tel:22383784097/requests`

✅ **Conforme à la documentation Orange**

---

### **Correction 2 : Ajout du code pays dans la configuration**

Pour rendre le code plus flexible (si changement de pays) :

```properties
# Configuration Orange SMS pour le Mali
orange.sms.country.code=223
orange.sms.country.iso=MLI
orange.sms.sender.address=tel:+22383784097
```

Puis dans le code :
```java
@Value("${orange.sms.country.code:223}")
private String countryCode;

private String extractSenderForUrl(String senderAddress) {
    String number = senderAddress.replace("tel:", "").replace("+", "").trim();
    // Vérifier que le code pays correspond
    if (!number.startsWith(countryCode)) {
        logger.warn("Code pays du sender ne correspond pas: {}", countryCode);
    }
    return "tel:" + number;
}
```

---

## ✅ Checklist de conformité

| Élément | Documentation Orange | Votre Configuration | Statut |
|---------|---------------------|---------------------|--------|
| **OAuth URL** | `https://api.orange.com/oauth/v3/token` | ✅ `v3/token` | ✅ OK |
| **Messaging URL** | `https://api.orange.com/smsmessaging/v1` | ✅ Correct | ✅ OK |
| **Auth Header** | `Basic {base64(id:secret)}` | ✅ Correct | ✅ OK |
| **Grant Type** | `client_credentials` | ✅ Correct | ✅ OK |
| **Token Expiration** | 3600s (1h) | ✅ Géré avec cache | ✅ OK |
| **Rate Limit** | 5 SMS/seconde | ✅ Semaphore(5) | ✅ OK |
| **Destinataire Body** | `tel:+223...` | ✅ Correct | ✅ OK |
| **Sender Body** | `tel:+223...` | ✅ Correct | ✅ OK |
| **Sender URL** | `tel:223...` (sans +) | ⚠️ `tel:+223...` | ⚠️ À corriger |
| **Sender Name** | Optionnel | ✅ Configuré | ✅ OK |
| **Message Max** | 160 caractères | ✅ Vérifié | ✅ OK |

---

## 📊 Résumé

### ✅ **Points forts (8/10) :**
1. ✅ OAuth v3 correctement implémenté
2. ✅ Gestion du token avec cache et expiration
3. ✅ Rate limiting conforme (5 SMS/s)
4. ✅ Formats des destinataires corrects
5. ✅ Formats dans le body JSON corrects
6. ✅ Gestion d'erreurs complète
7. ✅ Fallback avec plusieurs configurations OAuth
8. ✅ Vérification longueur message (160 caractères)

### ⚠️ **Points à améliorer (2/10) :**
1. ⚠️ **Format senderAddress dans l'URL** : Retirer le `+` devant le code pays
2. ⚠️ **Documentation** : Ajouter commentaire sur le format URL attendu

---

## 🚀 Action immédiate recommandée

### **Modifier `OrangeSmsService.java` lignes 599-606**

**Avant :**
```java
String senderAddressForUrl = cleanSenderAddress
    .replace("+", "%2B")  // Encode + en %2B
    .replace(":", "%3A");  // Encode : en %3A
```

**Après :**
```java
/**
 * Extrait le numéro pour l'URL selon la doc Orange:
 * - Format dans l'URL: tel:223XXXXXXXX (sans le +)
 * - Format dans le body: tel:+223XXXXXXXX (avec le +)
 */
private String prepareSenderForUrl(String senderAddress) {
    // Enlever tel: si présent
    String number = senderAddress.replace("tel:", "").trim();
    
    // Enlever le + devant le code pays (pour l'URL)
    if (number.startsWith("+")) {
        number = number.substring(1);
    }
    
    // Retourner au format tel:223... (sans +)
    return "tel:" + number;
}

// Utilisation
String senderForUrl = prepareSenderForUrl(cleanSenderAddress);
String senderAddressForUrl = senderForUrl.replace(":", "%3A");
String smsUrl = baseUrl + "/outbound/" + senderAddressForUrl + "/requests";
```

---

## 📝 Test après correction

### **1. Test d'authentification**
```bash
curl -X POST https://api.orange.com/oauth/v3/token \
  -H "Authorization: Basic {your_base64_credentials}" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials"
```

### **2. Test d'envoi SMS**
```bash
curl -X POST "https://api.orange.com/smsmessaging/v1/outbound/tel%3A22383784097/requests" \
  -H "Authorization: Bearer {access_token}" \
  -H "Content-Type: application/json" \
  -d '{
    "outboundSMSMessageRequest": {
      "address": "tel:+223XXXXXXXX",
      "senderAddress": "tel:+22383784097",
      "outboundSMSTextMessage": {
        "message": "Test SMS"
      }
    }
  }'
```

**URL générée attendue :**
```
https://api.orange.com/smsmessaging/v1/outbound/tel%3A22383784097/requests
```

(Notez l'absence du `+` dans l'URL)

---

## ✅ Conclusion

**Votre configuration est globalement conforme à la documentation Orange (8/10).**

Le seul point critique est le **format du senderAddress dans l'URL** qui devrait être `tel:223...` (sans le `+`) plutôt que `tel:+223...`.

**Recommandation :** Appliquer la correction suggérée ci-dessus pour être 100% conforme à la documentation officielle Orange.

---

**Documentation de référence :**
- [Orange SMS Getting Started](https://developer.orange.com/apis/sms/getting-started)
- Votre code : `OrangeSmsService.java`
- Configuration : `application.properties`

