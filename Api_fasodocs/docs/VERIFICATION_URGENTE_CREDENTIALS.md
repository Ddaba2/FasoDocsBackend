# ⚠️ VÉRIFICATION URGENTE DES CREDENTIALS ORANGE SMS

## Le problème

L'API Orange retourne systématiquement :
```json
{"error":"invalid_client","error_description":"Unknown client 'eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG'"}
```

Cela signifie que **l'API Orange ne connaît PAS ce Client ID**.

## ✅ Checklist de vérification (URGENT)

### 1. Connectez-vous à Orange Developer Portal

🔗 https://developer.orange.com/

### 2. Vérifiez l'existence de votre application

Dans "My Apps" ou "Mes Applications", recherchez:

- [ ] Une application avec le **Client ID**: `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`
- [ ] OU une application avec l'**Application ID**: `iy3KWH9GiNK0evSY`

### 3. Scénarios possibles

#### ✅ Scénario A: L'application existe

Si vous la trouvez, vérifiez:

- [ ] L'application est **ACTIVE** (pas désactivée/suspendue)
- [ ] L'API **SMS** est bien activée
- [ ] La région **Mali (223)** est configurée
- [ ] Le **Client ID** affiché correspond exactement: `eeQIIfQYVsDYRDHvG5ziEHMpJ18bHlcG`

Si le Client ID est différent → **Copiez le bon Client ID et Client Secret**

#### ❌ Scénario B: L'application n'existe PAS

Si vous ne trouvez aucune application avec ces IDs:

1. Vérifiez que vous êtes connecté au **bon compte Orange Developer**
2. L'application a peut-être été **supprimée** → Il faut en créer une nouvelle
3. Vous utilisez peut-être des credentials d'**un autre compte** → Vérifiez

### 4. Test de validation

Une fois que vous avez vérifié/récupéré les bons credentials:

```powershell
# Dans PowerShell, testez l'authentification
cd C:\Users\dabad\Desktop\FasoDocs-Backend\Api_fasodocs
.\test_orange_auth.ps1
```

**Résultat attendu:** "SUCCESS! Authentication works!"

## 🚨 Si le test échoue toujours

Cela signifierait que:

1. **Les credentials ne sont pas corrects** → Copiez-les à nouveau depuis le portail
2. **Le Client Secret a changé** → Régénérez-le sur Orange Developer
3. **L'application n'est pas activée pour l'API SMS** → Activez l'API SMS
4. **Problème de compte Orange** → Contactez le support Orange

## 📋 Informations à me fournir après vérification

Répondez à ces questions:

1. **L'application existe-t-elle sur Orange Developer ?** (Oui/Non)
2. **Si oui, quel est le Client ID affiché ?** (Copier depuis le portail)
3. **L'API SMS est-elle activée ?** (Oui/Non)
4. **L'application est-elle active ?** (Oui/Non)

---

**⏰ Cette vérification est CRITIQUE car sans credentials valides, aucun SMS ne peut être envoyé.**
