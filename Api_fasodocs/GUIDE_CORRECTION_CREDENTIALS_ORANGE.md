# 🔧 Guide de Correction des Credentials Orange SMS

## ✅ Votre Configuration Actuelle (Portail Orange)

D'après les informations que vous avez partagées :
- **Client ID** : `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG` ✅ (correct)
- **Application ID** : `iy3KWH9GiNK0evSY` ✅ (correct)
- **API** : SMS Mali - Entreprise, version 3.0, statut "Approuvé" ✅
- **Client Secret** : Masqué (●●●●●●●●) ⚠️ **À VÉRIFIER**

## 🔍 Problème Identifié

L'erreur `"Unknown client"` signifie que le **Client Secret** dans votre `application.properties` ne correspond **PAS** au vrai secret dans le portail Orange.

### Votre configuration actuelle (application.properties) :
```properties
orange.sms.client.secret=EJn9NPCK51YtFfq3AE5pKiWGdVmYdVdYLTb68cCtfaXt
```

⚠️ **Ce secret est probablement incorrect ou a été régénéré.**

## ✅ Solution : Récupérer le Vrai Client Secret

### Étape 1 : Dans le Portail Orange Developer

1. Allez sur **https://developer.orange.com/**
2. Connectez-vous
3. Allez dans **"MyApps"** ou **"Mes Applications"**
4. Cliquez sur votre application
5. Dans la section **"Identifiant client"**, vous verrez :
   - **ID client** : `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG` ✅
   - **Secret client** : `●●●●●●●●` (masqué)

### Étape 2 : Récupérer le Client Secret

**Option A : Si le secret est visible**
- Cliquez sur l'icône "👁️" ou "Afficher" pour révéler le secret
- **Copiez-le exactement** (sans espaces)

**Option B : Si le secret a été régénéré**
- Si vous avez régénéré le secret, l'ancien ne fonctionnera plus
- Utilisez le **nouveau secret** généré

**Option C : Régénérer le secret (si nécessaire)**
1. Cliquez sur **"Régénérer"** ou **"Generate new secret"**
2. **⚠️ ATTENTION** : L'ancien secret sera invalidé
3. Copiez le nouveau secret immédiatement (il ne sera affiché qu'une fois)

### Étape 3 : Tester le Secret

Utilisez le script `test_credentials_orange.ps1` pour tester :

1. Ouvrez `test_credentials_orange.ps1`
2. Remplacez `VOTRE_VRAI_CLIENT_SECRET_DU_PORTAL` par le secret du portail
3. Exécutez le script :
   ```powershell
   .\test_credentials_orange.ps1
   ```

Si le test réussit, vous verrez :
```
✅ SUCCÈS - Authentification réussie!
Access Token: ...
Expires in: 3600 seconds
```

### Étape 4 : Mettre à Jour application.properties

Une fois le test réussi, mettez à jour `application.properties` :

```properties
# Configuration Orange SMS API pour le Mali
orange.sms.enabled=true
orange.sms.base.url=https://api.orange.com/smsmessaging/v1
orange.sms.client.id=eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG
orange.sms.client.secret=VOTRE_VRAI_SECRET_DU_PORTAL  # ← REMPLACEZ ICI
orange.sms.application.id=iy3KWH9GiNK0evSY
orange.sms.sender.address=tel:+22383784097
orange.sms.sender.name=SMS 948223
```

**⚠️ IMPORTANT** : Supprimez cette ligne si elle existe :
```properties
# orange.sms.authorization.header=...  ← SUPPRIMEZ CETTE LIGNE
```

Le header d'autorisation est généré automatiquement.

### Étape 5 : Vérifier le Bundle SMS

1. Dans le portail Orange, vérifiez que vous avez un **bundle SMS actif**
2. Vérifiez que vous avez des **crédits disponibles**
3. Vérifiez la **date d'expiration** du bundle

Si le bundle a expiré ou si vous n'avez plus de crédits :
- Achetez un nouveau bundle depuis le portail
- Ou contactez le support Orange pour activer un bundle

## 🧪 Test Rapide avec cURL

Si vous préférez tester manuellement :

```bash
# Remplacez CLIENT_SECRET par le vrai secret du portail
curl -X POST \
  "https://api.orange.com/oauth/v3/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic $(echo -n 'eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG:CLIENT_SECRET' | base64)" \
  -d "grant_type=client_credentials"
```

**Résultat attendu (succès) :**
```json
{
  "token_type": "Bearer",
  "access_token": "...",
  "expires_in": "3600"
}
```

**Résultat si échec :**
```json
{
  "error": "invalid_client",
  "error_description": "Unknown client '...'"
}
```

## 📋 Checklist de Vérification

- [ ] J'ai accédé au portail Orange Developer
- [ ] J'ai trouvé mon application dans "MyApps"
- [ ] J'ai récupéré le **Client Secret** depuis le portail (pas celui dans application.properties)
- [ ] J'ai testé le secret avec `test_credentials_orange.ps1` → ✅ SUCCÈS
- [ ] J'ai un bundle SMS actif avec des crédits
- [ ] J'ai mis à jour `application.properties` avec le vrai secret
- [ ] J'ai supprimé la ligne `orange.sms.authorization.header` si elle existe
- [ ] J'ai redémarré l'application
- [ ] Le test d'envoi SMS fonctionne maintenant

## 🆘 Si le Problème Persiste

### Vérifications Supplémentaires

1. **Vérifiez que l'API est bien activée** :
   - Dans le portail, section "API auxquelles je suis abonné"
   - L'API "SMS Mali - Entreprise" doit être "Approuvé" ✅

2. **Vérifiez le bundle SMS** :
   - Allez dans la section "Bundles" ou "Achats"
   - Vérifiez qu'il y a un bundle actif avec des crédits

3. **Contactez le Support Orange Mali** :
   - Utilisez le formulaire de contact sur le portail
   - Mentionnez :
     - Client ID : `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
     - Application ID : `iy3KWH9GiNK0evSY`
     - Erreur : `401 UNAUTHORIZED - Unknown client`
     - API : SMS Mali - Entreprise 3.0

## 💡 Points Importants

1. **Le Client Secret est sensible** : Ne le partagez jamais publiquement
2. **Si vous régénérez le secret** : L'ancien sera invalidé immédiatement
3. **Le secret dans le portail est la source de vérité** : Pas celui dans votre code
4. **Testez toujours avant de redémarrer** : Utilisez le script de test

## ✅ Après Correction

Une fois que vous avez mis à jour le Client Secret et redémarré l'application, vous devriez voir dans les logs :

```
✅✅✅ AUTHENTIFICATION RÉUSSIE AVEC L'API ORANGE SMS ✅✅✅
   Configuration utilisée: URL=https://api.orange.com/oauth/v3/token, scope=false
   Token valide pendant: 3600 secondes
   ✅ Les SMS peuvent maintenant être envoyés
```

Et les SMS seront envoyés avec succès ! 🎉

