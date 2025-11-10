# 🔐 Configuration des Secrets - FasoDocs

## ⚠️ Problème GitHub Détecté

GitHub a bloqué le push car des **secrets** (credentials) sont présents dans `application.properties`.

---

## ✅ Solution : Variables d'Environnement

### Étape 1 : Créer `.env` Local (Ne Pas Commit)

Crée un fichier `.env` à la racine avec tes vrais secrets :

```env
# Email Gmail
MAIL_USERNAME=dabadiallo694@gmail.com
MAIL_PASSWORD=retw rklx oabi xnpd

# Orange SMS
ORANGE_SMS_CLIENT_ID=iy3KWH9GiNK0evSY
ORANGE_SMS_CLIENT_SECRET=5LywHmVzKBh2xiUWsqY17wiLfjqcPluDMrAojfcRFhEX
ORANGE_SMS_AUTH_HEADER=ZWVRSUlmUVlWc0RZUkRIdkc1emlFSE1wSjE4YkhsY0c6NUx5d0htVnpLQmgyeGlVV3NxWTE3d2lMZmpxY1BsdURNckFvamZjUkZoRVg=
ORANGE_SMS_APP_ID=iy3KWH9GiNK0evSY
ORANGE_SMS_SENDER=tel:+22383784097

# Djelia AI
DJELIA_API_KEY=83c313b9-aeba-441b-8b7f-a194720ad1d3
```

⚠️ **IMPORTANT** : Le fichier `.env` est déjà dans `.gitignore` - il ne sera PAS poussé sur GitHub.

---

### Étape 2 : Modifier `application.properties`

Remplace les valeurs sensibles par des variables :

```properties
# Email
spring.mail.username=${MAIL_USERNAME:}
spring.mail.password=${MAIL_PASSWORD:}

# Orange SMS
orange.sms.client.id=${ORANGE_SMS_CLIENT_ID:}
orange.sms.client.secret=${ORANGE_SMS_CLIENT_SECRET:}
orange.sms.authorization.header=${ORANGE_SMS_AUTH_HEADER:}
orange.sms.application.id=${ORANGE_SMS_APP_ID:}
orange.sms.sender.address=${ORANGE_SMS_SENDER:tel:+223XXXXXXXX}

# Djelia AI
djelia.ai.api.key=${DJELIA_API_KEY:}
```

---

### Étape 3 : Retirer du Commit Git

```bash
# Retirer application.properties de Git (garder en local)
git rm --cached src/main/resources/application.properties

# Ajouter au .gitignore
echo "src/main/resources/application.properties" >> .gitignore

# Commit
git add .gitignore
git commit -m "Sécurité: Retrait des secrets (variables d'environnement)"
git push
```

---

## 🚀 Utilisation

### Développement Local

1. Copie `.env.example` → `.env`
2. Remplis tes secrets dans `.env`
3. Spring Boot lit automatiquement `.env` (avec spring-dotenv)

OU simplement garde ton `application.properties` **local** (ne pas commit).

---

### Production

Définis les variables d'environnement sur ton serveur :

```bash
export MAIL_USERNAME=...
export MAIL_PASSWORD=...
export ORANGE_SMS_CLIENT_ID=...
# etc.
```

---

## 📋 Fichiers Créés

- ✅ `.env.example` - Template des secrets
- ✅ `application.properties.example` - Config template
- ✅ Ce guide

---

## 🎯 Actions Maintenant

```bash
# 1. Retirer application.properties de Git
git rm --cached src/main/resources/application.properties

# 2. Commit
git add .
git commit -m "Sécurité: Utilisation variables d'environnement"

# 3. Push (devrait marcher)
git push
```

---

**Tes secrets seront protégés !** 🔒

