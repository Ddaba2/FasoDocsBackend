# 📱 Application Android - Architecture FasoDocs

## 🎯 Réponse Directe

### ❌ L'App Android NE doit PAS appeler Djelia AI directement

### ✅ L'App Android DOIT appeler FasoDocs Backend (port 8080)

---

## 🏗️ Architecture Mobile

```
┌─────────────────────────────────────────────┐
│      Application Android (Flutter/React)    │
│                                             │
│  Configuration :                            │
│  - API Base URL                             │
│    http://10.0.2.2:8080/api (émulateur)   │
│    http://192.168.1.100:8080/api (device)  │
└─────────────────┬───────────────────────────┘
                  │
                  │ HTTP/HTTPS
                  ↓
┌─────────────────────────────────────────────┐
│       FasoDocs Backend (Spring Boot)       │
│              Port 8080                     │
│                                             │
│  /api/auth/**                              │
│  /api/procedures/**                        │
│  /api/chatbot/** ← Utilise Djelia en interne │
└──────────┬──────────────────────────────────┘
           │
           │ Appel interne
           ↓
┌─────────────────────────────────────────────┐
│      Djelia AI Backend (Python Flask)      │
│              Port 5000                      │
│                                             │
│  Service INTERNE                            │
│  L'application Android ne le voit JAMAIS   │
└─────────────────────────────────────────────┘
```

---

## ⚙️ Configuration Android

### Flutter

#### configuration.dart

```dart
class ApiConfig {
  // ✅ Utiliser 10.0.2.2 pour l'émulateur Android
  // C'est l'adresse IP spéciale qui pointe vers l'host de votre PC
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  
  // ✅ Pour un device physique, utiliser l'IP de votre PC
  // static const String baseUrl = 'http://192.168.1.100:8080/api';
  
  // Endpoints
  static const String auth = '$baseUrl/auth';
  static const String procedures = '$baseUrl/procedures';
  static const String chatbot = '$baseUrl/chatbot';
}
```

#### audio_service.dart

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'configuration.dart';

class AudioService {
  
  // ✅ Icône micro : Traduction + Audio
  Future<Map<String, dynamic>> jouerAudio(String texteFrancais) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.chatbot}/read-quick'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(texteFrancais), // String direct, pas JSON
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lecture audio');
    }
  }
  
  // ✅ Jouer l'audio retourné
  Future<void> jouerAudioUrl(String audioUrl) async {
    // Utiliser un package audio comme audioplayers
    // final player = AudioPlayer();
    // await player.play(audioUrl);
  }
}
```

#### auth_service.dart

```dart
class AuthService {
  
  // ✅ Connexion par téléphone
  Future<Map<String, dynamic>> connecterParTelephone(String telephone) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.auth}/connexion-telephone'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'telephone': telephone}),
    );
    
    return json.decode(response.body);
  }
  
  // ✅ Vérification code SMS
  Future<Map<String, dynamic>> verifierCodeSms(
    String telephone, 
    String code
  ) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.auth}/verifier-sms'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'telephone': telephone,
        'code': code
      }),
    );
    
    return json.decode(response.body);
  }
}
```

---

### React Native

#### config/api.js

```javascript
export const API_CONFIG = {
  // ✅ 10.0.2.2 pour émulateur Android
  // C'est l'adresse de l'host (votre PC) depuis l'émulateur
  BASE_URL: 'http://10.0.2.2:8080/api',
  
  // ✅ Pour device physique Android
  // BASE_URL: 'http://192.168.1.100:8080/api',
  
  ENDPOINTS: {
    auth: '/auth',
    procedures: '/procedures',
    chatbot: '/chatbot',
  }
};
```

#### services/audioService.js

```javascript
import API_CONFIG from '../config/api';
import axios from 'axios';
import Sound from 'react-native-sound';

export class AudioService {
  
  // ✅ Lire l'audio en bambara
  static async jouerAudio(texteFrancais) {
    try {
      const response = await axios.post(
        `${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.chatbot}/read-quick`,
        texteFrancais, // Texte directement comme string
        {
          headers: { 'Content-Type': 'application/json' }
        }
      );
      
      // Jouer l'audio
      if (response.data.success && response.data.audioUrl) {
        const sound = new Sound(response.data.audioUrl, '', (error) => {
          if (error) {
            console.log('Erreur lecture audio:', error);
          } else {
            sound.play();
          }
        });
      }
      
      return response.data;
      
    } catch (error) {
      console.error('Erreur appel audio:', error);
      throw error;
    }
  }
}
```

---

## 🧪 Test depuis Émulateur Android

### Configuration du CORS dans FasoDocs

**Dans `application.properties`** :
```properties
# Autoriser l'émulateur Android
app.cors.allowed-origins=http://localhost:3000,http://localhost:4200,http://10.0.2.2:8080
```

**Dans `SecurityConfig.java`** :
```java
@Value("${app.cors.allowed-origins}")
private String[] allowedOrigins;
```

---

## 📱 Configuration Réseau

### Émulateur Android

| Adresse | Description |
|---------|-------------|
| `10.0.2.2` | Adresse de votre PC (host) depuis l'émulateur |
| `127.0.0.1` | ❌ Ne fonctionne PAS dans l'émulateur |
| `localhost` | ❌ Ne fonctionne PAS dans l'émulateur |

### Device Physique Android

```dart
// Trouver l'IP de votre PC
// Windows : ipconfig
// Linux/Mac : ifconfig

// Exemple :
static const String baseUrl = 'http://192.168.1.100:8080/api';
```

---

## 🎤 Exemple Complet : Icône Micro

### Android Widget

```dart
import 'package:flutter/material.dart';
import 'services/audio_service.dart';

class ProcedureCard extends StatelessWidget {
  final String description;
  final AudioService audioService = AudioService();
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(description),
          
          // ✅ Bouton icône micro
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () async {
              // Afficher loading
              showDialog(
                context: context,
                builder: (_) => Center(child: CircularProgressIndicator()),
              );
              
              try {
                // Appeler FasoDocs backend
                final result = await audioService.jouerAudio(description);
                
                if (result['success']) {
                  // Jouer l'audio
                  await audioService.jouerAudioUrl(result['audioUrl']);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur : $e')),
                );
              } finally {
                Navigator.pop(context); // Fermer loading
              }
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 🔒 Configuration Sécurité

### AndroidManifest.xml

```xml
<!-- Permettre les connexions HTTP (dev uniquement) -->
<application
    android:usesCleartextTraffic="true"
    ...>
    
    <!-- OU configurer network_security_config.xml pour HTTPS -->
</application>
```

### network_security_config.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <!-- Pour développement : autoriser HTTP -->
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
</network-security-config>
```

---

## 📊 Récapitulatif

### ✅ Ce que l'App Android doit faire

1. **Un seul URL à configurer** :
   ```dart
   // Émulateur
   http://10.0.2.2:8080/api
   
   // Device physique
   http://192.168.1.100:8080/api
   ```

2. **Utiliser les endpoints FasoDocs** :
   - `/api/auth/**` : Authentification
   - `/api/procedures/**` : Procédures
   - `/api/chatbot/read-quick` : Icône micro

### ❌ Ce que l'App Android NE doit PAS faire

- ❌ Appeler directement `http://localhost:5000` (Djelia AI)
- ❌ Configurer l'URL de Djelia AI
- ❌ Connaître l'existence de Djelia AI

---

## 🎯 Résumé Final

### Architecture Mobile

```
Android App
    ↓
http://10.0.2.2:8080/api (émulateur)
    ↓
FasoDocs Backend
    ↓ (interne)
Djelia AI
```

### Configuration Android

```dart
// ✅ Correct : Un seul URL
static const String baseUrl = 'http://10.0.2.2:8080/api';

// ❌ Incorrect : Ne pas appeler Djelia directement
// static const String baseUrl = 'http://10.0.2.2:5000';
```

---

## ✅ Conclusion

**L'application Android utilise exactement le même point d'entrée que le frontend web :**

- ✅ **Un seul port** : 8080
- ✅ **Un seul backend** : FasoDocs
- ✅ **Djelia AI reste interne** : Invisible pour l'app Android

**L'app Android a accès à tout ce dont elle a besoin via `/api/*` sur le port 8080 !**

🎉 **Prêt pour le développement Android !**

