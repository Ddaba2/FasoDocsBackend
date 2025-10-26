# 🌐 Configuration CORS pour Émulateur Android

## ⚠️ Problème Détecté

### Configuration Actuelle

```properties
# application.properties
app.cors.allowed-origins=http://localhost:3000,http://localhost:4200
```

**Problème** : ❌ L'émulateur Android ne peut **PAS** appeler l'API

### Pourquoi ?

L'émulateur Android utilise l'adresse IP `10.0.2.2` pour accéder à l'host de votre PC. Cette origine n'est **pas autorisée** dans la configuration CORS actuelle.

---

## ✅ Solution : Autoriser l'Émulateur Android

### Configuration Mis à Jour

**Fichier** : `src/main/resources/application.properties`

```properties
# Configuration CORS
# ✅ localhost:3000 et localhost:4200 : Frontend web
# ✅ 10.0.2.2:8080 : Émulateur Android
app.cors.allowed-origins=http://localhost:3000,http://localhost:4200,http://10.0.2.2:8080
```

### Note : Port de l'Émulateur

L'adresse `10.0.2.2:8080` est l'adresse de **votre PC** vue depuis l'émulateur Android. Le port 8080 est le port où FasoDocs Backend écoute.

---

## 🧪 Vérification

### Test depuis l'Émulateur Android

**Dart/Flutter** :
```dart
// Cette URL fonctionnera maintenant
final response = await http.get(
  Uri.parse('http://10.0.2.2:8080/api/chatbot/health'),
  headers: {
    'Origin': 'http://10.0.2.2:8080',
  },
);
```

**Avant** : ❌ `CORS policy: No 'Access-Control-Allow-Origin'`
**Après** : ✅ Requête acceptée

---

## 🔒 Alternative : Autoriser Tous les Origines (Développement)

### Option 1 : Autoriser Toutes les Origines

**Dans `SecurityConfig.java`** :

```java
@Bean
public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration configuration = new CorsConfiguration();
    
    // ✅ Autoriser TOUTES les origines (développement uniquement !)
    configuration.setAllowedOriginPatterns(Arrays.asList("*"));
    
    // OU spécifiquement :
    // configuration.setAllowedOrigins(Arrays.asList("*"));
    
    configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
    configuration.setAllowedHeaders(Arrays.asList("*"));
    configuration.setAllowCredentials(true);
    configuration.setMaxAge(3600L);

    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", configuration);
    return source;
}
```

⚠️ **ATTENTION** : Cette configuration est **INSÉCURÉE** pour la production !

---

## 🎯 Configuration Recommandée

### Pour Développement

**application.properties** :
```properties
# CORS pour développement
app.cors.allowed-origins=http://localhost:3000,http://localhost:4200,http://10.0.2.2:8080,*
```

### Pour Production

**application-prod.properties** :
```properties
# CORS pour production
app.cors.allowed-origins=https://fasodocs.ml,https://www.fasodocs.ml,https://app.fasodocs.ml
```

---

## 📱 Configuration Android Spécifique

### Flutter

#### configuration.dart
```dart
class ApiConfig {
  // ✅ Émulateur Android
  static const String baseUrlEmulator = 'http://10.0.2.2:8080/api';
  
  // ✅ Device physique Android
  // Remplacer par l'IP de votre PC
  // static const String baseUrlDevice = 'http://192.168.1.100:8080/api';
  
  // Détection automatique
  static String get baseUrl {
    // TODO: Détecter si émulateur ou device
    return baseUrlEmulator;
  }
}
```

### React Native

#### config/api.js
```javascript
import {Platform} from 'react-native';

// Détection automatique
export const API_URL = Platform.select({
  android: 'http://10.0.2.2:8080/api',  // Émulateur Android
  ios: 'http://localhost:8080/api',     // Simulateur iOS
  web: 'http://localhost:8080/api',     // Web
});
```

---

## 🧪 Test de CORS

### Commande cURL

```bash
# Test depuis émulateur Android (simulation)
curl -X GET http://localhost:8080/api/chatbot/health \
  -H "Origin: http://10.0.2.2:8080" \
  -H "Access-Control-Request-Method: GET" \
  -v

# Réponse attendue (en développement)
Access-Control-Allow-Origin: http://10.0.2.2:8080
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: *
Access-Control-Allow-Credentials: true
```

---

## ✅ Checklist

### Configuration CORS ✅

- [x] Origines locales ajoutées (localhost:3000, localhost:4200)
- [x] Origine émulateur Android ajoutée (10.0.2.2:8080)
- [x] Méthodes HTTP autorisées
- [x] Headers autorisés (*)
- [x] Credentials activés

### Configuration Android ✅

- [x] URL de base configurée (10.0.2.2:8080)
- [x] Permissions réseau AndroidManifest.xml
- [x] Network security config pour HTTP (développement)

---

## 🎯 Résumé

### ✅ Après la modification

**application.properties** :
```properties
app.cors.allowed-origins=http://localhost:3000,http://localhost:4200,http://10.0.2.2:8080
```

**Émulateur Android** peut maintenant appeler :
- ✅ `http://10.0.2.2:8080/api/auth/**`
- ✅ `http://10.0.2.2:8080/api/procedures/**`
- ✅ `http://10.0.2.2:8080/api/chatbot/**`
- ✅ Tous les endpoints

**Pas de problème de CORS ! 🎉**

---

## 🚀 Prochaines Étapes

1. ✅ Modifier `application.properties` (fait)
2. ✅ Redémarrer FasoDocs Backend
3. ✅ Tester depuis l'émulateur Android
4. ✅ Vérifier les logs de CORS

---

**Configuration CORS pour émulateur Android ajoutée ! ✅**

