# 🔍 Guide de Vérification des Credentials Orange SMS

## ❌ Problème Actuel

L'erreur `"Unknown client 'eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG'"` signifie que le **Client ID** n'est pas reconnu par l'API Orange.

## ✅ Solution : Vérifier les Credentials dans le Portail Orange

### Étape 1 : Accéder au Portail Orange Developer

1. Allez sur **https://developer.orange.com/**
2. Connectez-vous avec votre compte
3. Allez dans la section **"MyApps"** ou **"Mes Applications"**

### Étape 2 : Vérifier votre Application

1. Trouvez votre application **FasoDocs** (ou le nom de votre application)
2. Cliquez sur l'application pour voir les détails
3. Vérifiez que l'API **SMS Middle East and Africa** est bien **activée** et **souscrite**

### Étape 3 : Récupérer les VRAIS Credentials

Dans la section **"MyApps"**, vous devriez voir :

- **Client ID** (ou Application Key)
- **Client Secret** (ou Application Secret)
- **Application ID**

⚠️ **IMPORTANT** : Ces valeurs peuvent être différentes de celles dans votre `application.properties` !

### Étape 4 : Vérifier le Client Secret

1. Si le **Client Secret** a été régénéré dans le portail, l'ancien ne fonctionnera plus
2. Si vous avez régénéré le secret, vous devez mettre à jour `application.properties`

### Étape 5 : Vérifier l'Association API SMS

1. Dans votre application, vérifiez que l'API **SMS Middle East and Africa** est bien associée
2. Vérifiez que vous avez un **bundle SMS actif** (crédits disponibles)
3. Vérifiez la date d'expiration du bundle

## 🔧 Mise à Jour de la Configuration

Une fois que vous avez les **vrais credentials** du portail :

### 1. Mettre à jour `application.properties`

```properties
# Configuration Orange SMS API pour le Mali
orange.sms.enabled=true
orange.sms.base.url=https://api.orange.com/smsmessaging/v1
orange.sms.client.id=VOTRE_VRAI_CLIENT_ID_DU_PORTAL
orange.sms.client.secret=VOTRE_VRAI_CLIENT_SECRET_DU_PORTAL
orange.sms.application.id=VOTRE_VRAI_APPLICATION_ID
orange.sms.sender.address=tel:+22383784097
orange.sms.sender.name=SMS 948223
```

### 2. Ne PAS utiliser `authorization.header`

⚠️ **Supprimez** cette ligne si elle existe :
```properties
# orange.sms.authorization.header=...  ← SUPPRIMEZ CETTE LIGNE
```

Le header d'autorisation est généré automatiquement à partir du Client ID et Client Secret.

## 🧪 Test des Credentials

### Méthode 1 : Via le Portail Orange

1. Dans le portail Orange, utilisez l'outil de test intégré
2. Testez l'authentification avec vos credentials

### Méthode 2 : Via cURL

```bash
# Remplacer CLIENT_ID et CLIENT_SECRET par vos vrais credentials
curl -X POST \
  "https://api.orange.com/oauth/v3/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic $(echo -n 'CLIENT_ID:CLIENT_SECRET' | base64)" \
  -d "grant_type=client_credentials"
```

Si cela fonctionne, vous devriez recevoir :
```json
{
  "token_type": "Bearer",
  "access_token": "...",
  "expires_in": "3600"
}
```

## 📋 Checklist de Vérification

- [ ] J'ai accédé au portail Orange Developer
- [ ] J'ai trouvé mon application dans "MyApps"
- [ ] L'API SMS Middle East and Africa est activée
- [ ] J'ai un bundle SMS actif avec des crédits
- [ ] J'ai copié le **Client ID** depuis le portail
- [ ] J'ai copié le **Client Secret** depuis le portail (sans le régénérer)
- [ ] J'ai copié l'**Application ID** depuis le portail
- [ ] J'ai mis à jour `application.properties` avec les vrais credentials
- [ ] J'ai redémarré l'application
- [ ] Le test cURL fonctionne

## 🆘 Si le Problème Persiste

### Contactez le Support Orange Mali

Avec les informations suivantes :
- **Client ID** : `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
- **Application ID** : `iy3KWH9GiNK0evSY`
- **Erreur** : `401 UNAUTHORIZED - Unknown client`
- **URL testée** : `https://api.orange.com/oauth/v3/token`
- **Pays** : Mali

### Formulaire de Contact Orange

Utilisez le formulaire de contact sur le portail Orange Developer pour demander :
- Vérification de l'activation de l'API SMS
- Vérification des credentials
- Vérification du bundle SMS

## 📚 Documentation de Référence

- [Orange SMS Getting Started](https://developer.orange.com/apis/sms/getting-started)
- Section "1. Souscription à une API" pour vérifier la configuration

## ⚠️ Points Importants

1. **Ne régénérez PAS le Client Secret** sauf si nécessaire (cela invalidera l'ancien)
2. **Vérifiez que le bundle SMS n'a pas expiré**
3. **Assurez-vous que l'API SMS est bien activée** pour votre application
4. **Les credentials dans le portail sont la source de vérité** - pas ceux dans votre code

