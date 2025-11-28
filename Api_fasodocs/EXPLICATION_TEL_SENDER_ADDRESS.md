# 📱 Explication : "tel:" dans le Sender Address

## ❓ Question

Est-ce nécessaire de mettre "tel:" dans la configuration `orange.sms.sender.address` ?

## ✅ Réponse

**Non, ce n'est pas strictement nécessaire**, mais **c'est recommandé** pour être conforme à la documentation Orange.

---

## 🔍 Comment le Code Gère "tel:"

Le code **ajoute automatiquement "tel:"** si ce n'est pas présent :

```java
// Ligne 662-667 de OrangeSmsService.java
String cleanSenderAddress = senderAddress;
if (!cleanSenderAddress.startsWith("tel:")) {
    cleanSenderAddress = "tel:" + (cleanSenderAddress.startsWith("+") ? cleanSenderAddress : "+" + cleanSenderAddress);
} else if (!cleanSenderAddress.contains("+")) {
    // Si tel: mais sans +, ajouter +
    cleanSenderAddress = cleanSenderAddress.replace("tel:", "tel:+");
}
```

### Exemples de Formats Acceptés

Le code accepte **plusieurs formats** :

| Format dans `application.properties` | Format utilisé par le code |
|--------------------------------------|----------------------------|
| `tel:+2230000` ✅ | `tel:+2230000` (tel: déjà présent) |
| `+2230000` ✅ | `tel:+2230000` (tel: ajouté automatiquement) |
| `2230000` ✅ | `tel:+2230000` (tel: et + ajoutés automatiquement) |
| `tel:2230000` ⚠️ | `tel:+2230000` (+ ajouté automatiquement) |

---

## 📋 Selon la Documentation Orange

Selon la [documentation Orange](https://developer.orange.com/apis/sms/getting-started), le format attendu est :

**Dans le Body de la requête** :
```json
{
    "outboundSMSMessageRequest": {
        "senderAddress": "tel:+2230000"  // ← Avec "tel:" et "+"
    }
}
```

**Dans l'URL** :
```
https://api.orange.com/smsmessaging/v1/outbound/tel%3A2230000/requests
//                                                      ↑
//                                    tel:2230000 (sans +) encodé
```

---

## ✅ Recommandation

### Format Recommandé

```properties
orange.sms.sender.address=tel:+2230000
```

**Avantages** :
- ✅ Conforme à la documentation Orange
- ✅ Format explicite et clair
- ✅ Pas de transformation nécessaire
- ✅ Évite toute confusion

### Formats Alternatifs (Fonctionnent aussi)

```properties
# Format 1 : Sans "tel:" (le code l'ajoute)
orange.sms.sender.address=+2230000

# Format 2 : Sans "tel:" ni "+" (le code ajoute les deux)
orange.sms.sender.address=2230000
```

**Inconvénients** :
- ⚠️ Moins explicite
- ⚠️ Nécessite une transformation par le code
- ⚠️ Peut prêter à confusion

---

## 🔧 Conclusion

**Réponse courte** : Non, ce n'est pas strictement nécessaire, mais **c'est recommandé**.

**Format actuel** :
```properties
orange.sms.sender.address=tel:+2230000
```

**Statut** : ✅ **CORRECT et RECOMMANDÉ**

Vous pouvez garder ce format tel quel. Le code fonctionnera dans tous les cas, mais le format avec "tel:" est plus conforme à la documentation Orange.

---

## 📝 Note

Le problème actuel ("Unknown client") **n'est PAS lié** au format du sender address. C'est un problème de **credentials Orange** (Client ID non reconnu).

Le format `tel:+2230000` est correct ✅



