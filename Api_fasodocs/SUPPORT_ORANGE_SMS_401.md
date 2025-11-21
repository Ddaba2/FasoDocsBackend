# 📞 Support Orange SMS - Erreur 401 UNAUTHORIZED

## 🔍 Problème

L'authentification avec l'API Orange SMS échoue systématiquement avec une erreur **401 UNAUTHORIZED**, malgré des credentials corrects et vérifiés.

## ✅ Credentials vérifiés

- **Client ID**: `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
- **Client Secret**: `MKAh6Y2TWs3kBdeUlVtVfmnAzckniO2GvJwzgwYSMdt1`
- **Application ID**: `iy3KWH9GiNK0evSY`
- **API souscrite**: SMS Mali - Entreprise v3.0
- **Statut API**: Approuvé

## 🧪 Tests effectués

Toutes les configurations suivantes ont été testées et échouent avec 401 :

1. ✅ `https://api.orange.com/oauth/v3/token` avec `scope=SMS`
2. ✅ `https://api.orange.com/oauth/v3/token` sans scope
3. ✅ `https://api.orange.com/oauth/v2/token` avec `scope=SMS`
4. ✅ `https://api.orange.com/oauth/v2/token` sans scope
5. ✅ `https://api.orange.com/oauth/v1/token` avec `scope=SMS`
6. ✅ `https://api.orange.com/oauth/v1/token` sans scope

## 📋 Informations à fournir au support Orange

Lors du contact avec le support Orange Mali, fournissez :

```
Application: FasoDocs
Client ID: eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG
Application ID: iy3KWH9GiNK0evSY
API: SMS Mali - Entreprise v3.0
Statut API: Approuvé

Problème: 
- Erreur 401 UNAUTHORIZED lors de l'authentification OAuth
- Toutes les URLs d'authentification testées échouent
- Les credentials sont corrects et vérifiés dans le portail
- L'API est approuvée mais l'authentification échoue

Requête testée:
POST https://api.orange.com/oauth/v3/token
Headers:
  Content-Type: application/x-www-form-urlencoded
  Authorization: Basic ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6TUtBaDZZMlRXczNrQmRlVWxWdFZmbW5BemNrbmlPMkd2Snd6Z3dZU01kdDE=
Body: grant_type=client_credentials&scope=SMS

Réponse: 401 UNAUTHORIZED
```

## 🔧 Actions suggérées par le support Orange

1. Vérifier que l'application est bien activée pour l'envoi de SMS
2. Vérifier que les permissions SMS sont accordées
3. Vérifier s'il y a des restrictions sur l'application
4. Vérifier si l'API nécessite une activation supplémentaire
5. Vérifier si le Client Secret nécessite un délai d'activation après régénération

## 📞 Contact Support Orange

- **Portail**: https://developer.orange.com/
- **Support**: Via le portail développeur Orange
- **Email**: (selon les informations du portail)

## ⚠️ Solution temporaire

En attendant la résolution, le code SMS est disponible dans les logs du serveur (mode fallback) pour permettre les tests de développement.









