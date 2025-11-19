# 🎯 Guide Flutter - Implémentation Voix Off (Audio)

**Date**: 2025-01-14  
**Version**: 1.0

---

## 📋 Vue d'Ensemble

Ce guide vous montre **exactement** comment implémenter la lecture audio dans votre application Flutter lorsque l'utilisateur clique sur l'icône haut-parleur.

---

## 📦 Dépendances Requises

Ajoutez ces dépendances dans votre `pubspec.yaml` :

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.0              # Pour les appels API
  audioplayers: ^5.2.1      # Pour jouer l'audio
  base64: ^3.0.0            # Pour décoder Base64 (optionnel si déjà dans dio)
```

Puis exécutez :
```bash
flutter pub get
```

---

## 🔧 Étape 1 : Créer le Service Audio

Créez un fichier `lib/services/audio_service.dart` :

```dart
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';

class AudioService {
  final Dio dio;
  final String baseUrl;
  final AudioPlayer audioPlayer = AudioPlayer();

  AudioService({required this.dio, required this.baseUrl});

  /// Récupère le token depuis le storage
  String? _getToken() {
    // TODO: Implémenter la récupération du token depuis votre storage
    // Exemple avec shared_preferences:
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString('token');
    return null; // Remplacez par votre logique
  }

  /// Options avec authentification
  Options _getOptions() {
    final token = _getToken();
    return Options(
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  /// Récupère et joue l'audio d'une procédure
  /// 
  /// Retourne true si l'audio a été joué avec succès, false sinon
  Future<bool> jouerAudioProcedure(int procedureId) async {
    try {
      // Récupérer l'audio en Base64
      final response = await dio.get(
        '$baseUrl/procedures/$procedureId/audio/base64',
        options: _getOptions(),
      );

      if (response.statusCode == 200) {
        final audioData = response.data;
        final audioBase64 = audioData['audioBase64'] as String?;
        
        if (audioBase64 == null || audioBase64.isEmpty) {
          print('⚠️ Audio Base64 vide');
          return false;
        }

        // Décoder Base64 en bytes
        final audioBytes = base64Decode(audioBase64);

        // Jouer l'audio
        await audioPlayer.play(BytesSource(audioBytes));
        
        print('✅ Audio joué avec succès');
        return true;
      } else {
        print('❌ Erreur HTTP: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('❌ Aucun fichier audio disponible pour cette procédure');
      } else {
        print('❌ Erreur lors de la récupération de l\'audio: ${e.message}');
      }
      return false;
    } catch (e) {
      print('❌ Erreur inconnue: $e');
      return false;
    }
  }

  /// Arrête la lecture audio
  Future<void> arreterAudio() async {
    await audioPlayer.stop();
  }

  /// Vérifie si l'audio est en cours de lecture
  bool get estEnLecture => audioPlayer.state == PlayerState.playing;

  /// Libère les ressources
  void dispose() {
    audioPlayer.dispose();
  }
}
```

---

## 🎨 Étape 2 : Créer le Widget Bouton Audio

Créez un fichier `lib/widgets/audio_button.dart` :

```dart
import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class AudioButton extends StatefulWidget {
  final int procedureId;
  final String? audioUrl; // Pour vérifier si l'audio existe
  final AudioService audioService;

  const AudioButton({
    Key? key,
    required this.procedureId,
    this.audioUrl,
    required this.audioService,
  }) : super(key: key);

  @override
  _AudioButtonState createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> {
  bool _isLoading = false;
  bool _isPlaying = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    
    // Écouter les changements d'état de l'audio
    widget.audioService.audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (state == PlayerState.completed) {
            _isPlaying = false;
          }
        });
      }
    });
  }

  Future<void> _jouerAudio() async {
    // Vérifier si l'audio est disponible
    if (widget.audioUrl == null || widget.audioUrl!.isEmpty) {
      _afficherErreur('Aucun audio disponible pour cette procédure');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await widget.audioService.jouerAudioProcedure(widget.procedureId);
      
      if (!success) {
        _afficherErreur('Impossible de lire l\'audio');
      }
    } catch (e) {
      _afficherErreur('Erreur: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _arreterAudio() async {
    await widget.audioService.arreterAudio();
    setState(() {
      _isPlaying = false;
    });
  }

  void _afficherErreur(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ne pas afficher le bouton si l'audio n'est pas disponible
    if (widget.audioUrl == null || widget.audioUrl!.isEmpty) {
      return SizedBox.shrink();
    }

    return IconButton(
      icon: _buildIcon(),
      onPressed: _isLoading ? null : (_isPlaying ? _arreterAudio : _jouerAudio),
      tooltip: _getTooltip(),
      color: _isPlaying ? Colors.red : Colors.blue,
    );
  }

  Widget _buildIcon() {
    if (_isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    }

    if (_isPlaying) {
      return Icon(Icons.stop);
    }

    return Icon(Icons.volume_up);
  }

  String _getTooltip() {
    if (_isLoading) {
      return 'Chargement...';
    }
    if (_isPlaying) {
      return 'Arrêter';
    }
    return 'Écouter';
  }
}
```

---

## 📱 Étape 3 : Utiliser dans une Carte de Procédure

Exemple d'utilisation dans une carte de procédure :

```dart
import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../widgets/audio_button.dart';

class ProcedureCard extends StatelessWidget {
  final Procedure procedure;
  final AudioService audioService;

  const ProcedureCard({
    Key? key,
    required this.procedure,
    required this.audioService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(procedure.titre),
        subtitle: Text(procedure.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton audio
            AudioButton(
              procedureId: procedure.id,
              audioUrl: procedure.audioUrl,
              audioService: audioService,
            ),
            // Autres boutons...
          ],
        ),
      ),
    );
  }
}
```

---

## 🔧 Étape 4 : Configuration Globale

Dans votre fichier principal (ex: `main.dart` ou `app.dart`) :

```dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'services/audio_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Créer le service audio (singleton)
    final dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8080/api', // Remplacez par votre URL
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ));

    final audioService = AudioService(
      dio: dio,
      baseUrl: 'http://localhost:8080/api',
    );

    return MaterialApp(
      title: 'FasoDocs',
      home: MyHomePage(audioService: audioService),
    );
  }
}
```

---

## 📦 Modèle Procedure

Assurez-vous que votre modèle `Procedure` inclut le champ `audioUrl` :

```dart
class Procedure {
  final int id;
  final String nom;
  final String titre;
  final String description;
  final String? audioUrl; // ⚠️ IMPORTANT pour vérifier si l'audio existe

  Procedure({
    required this.id,
    required this.nom,
    required this.titre,
    required this.description,
    this.audioUrl,
  });

  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure(
      id: json['id'],
      nom: json['nom'],
      titre: json['titre'],
      description: json['description'],
      audioUrl: json['audioUrl'], // ⚠️ Vérifier que l'API retourne ce champ
    );
  }

  // Vérifier si l'audio est disponible
  bool get aAudioDisponible => audioUrl != null && audioUrl!.isNotEmpty;
}
```

---

## 🎯 Étape 5 : Exemple Complet avec Gestion d'État

Voici un exemple complet avec gestion d'état avancée :

```dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';

class ProcedureDetailScreen extends StatefulWidget {
  final Procedure procedure;

  const ProcedureDetailScreen({required this.procedure});

  @override
  _ProcedureDetailScreenState createState() => _ProcedureDetailScreenState();
}

class _ProcedureDetailScreenState extends State<ProcedureDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    
    // Écouter les changements d'état
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _jouerAudio() async {
    if (!widget.procedure.aAudioDisponible) {
      _afficherErreur('Aucun audio disponible pour cette procédure');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'http://localhost:8080/api/procedures/${widget.procedure.id}/audio/base64',
        options: Options(
          headers: {
            // Ajouter le token si nécessaire
            // 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final audioData = response.data;
        final audioBase64 = audioData['audioBase64'] as String?;
        
        if (audioBase64 != null && audioBase64.isNotEmpty) {
          final audioBytes = base64Decode(audioBase64);
          await _audioPlayer.play(BytesSource(audioBytes));
          
          setState(() {
            _isLoading = false;
            _isPlaying = true;
          });
        } else {
          throw Exception('Audio Base64 vide');
        }
      } else {
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } on DioException catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (e.response?.statusCode == 404) {
        _afficherErreur('Aucun fichier audio disponible');
      } else {
        _afficherErreur('Erreur: ${e.message}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _afficherErreur('Erreur: ${e.toString()}');
    }
  }

  Future<void> _arreterAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  void _afficherErreur(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.procedure.titre),
        actions: [
          // Bouton audio dans l'AppBar
          if (widget.procedure.aAudioDisponible)
            IconButton(
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(_isPlaying ? Icons.stop : Icons.volume_up),
              onPressed: _isLoading
                  ? null
                  : (_isPlaying ? _arreterAudio : _jouerAudio),
              tooltip: _isPlaying ? 'Arrêter' : 'Écouter',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.procedure.titre,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Text(
              widget.procedure.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24),
            
            // Bouton audio dans le contenu
            if (widget.procedure.aAudioDisponible)
              ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : (_isPlaying ? _arreterAudio : _jouerAudio),
                icon: _isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_isPlaying ? Icons.stop : Icons.volume_up),
                label: Text(_isPlaying ? 'Arrêter l\'audio' : 'Écouter l\'audio'),
              ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔑 Points Clés

### 1. **Vérifier l'audio avant d'afficher l'icône**

```dart
if (procedure.audioUrl != null && procedure.audioUrl!.isNotEmpty) {
  // Afficher l'icône haut-parleur
  AudioButton(...)
}
```

### 2. **Gérer les erreurs**

Toujours gérer le cas 404 (audio non disponible) :

```dart
try {
  // Appel API
} on DioException catch (e) {
  if (e.response?.statusCode == 404) {
    // Aucun audio disponible
  }
}
```

### 3. **Gérer l'état de lecture**

Utiliser `AudioPlayer.onPlayerStateChanged` pour mettre à jour l'UI :

```dart
audioPlayer.onPlayerStateChanged.listen((state) {
  setState(() {
    _isPlaying = state == PlayerState.playing;
  });
});
```

---

## 📡 Endpoints Utilisés

### **GET** `/api/procedures/{id}/audio/base64`

**Réponse** :
```json
{
  "procedureId": 82,
  "procedureNom": "Carte d'identité biométrique",
  "audioBase64": "UklGRiQAAABXQVZFZm10...",
  "format": "aac",
  "filename": "Carte d'identité biométrique .aac",
  "fileSize": 123456
}
```

---

## ✅ Checklist d'Implémentation

- [ ] Ajouter les dépendances (`dio`, `audioplayers`)
- [ ] Créer le service `AudioService`
- [ ] Créer le widget `AudioButton`
- [ ] Vérifier que le modèle `Procedure` a le champ `audioUrl`
- [ ] Vérifier que l'API retourne `audioUrl` dans la réponse
- [ ] Tester avec une procédure qui a un audio
- [ ] Gérer les erreurs (404, timeout, etc.)
- [ ] Gérer l'état de lecture (playing, stopped, etc.)

---

## 🧪 Test

### Test 1 : Vérifier qu'une procédure a un audio

```dart
// Dans votre code
final procedure = Procedure.fromJson(jsonData);
print('Audio URL: ${procedure.audioUrl}');
print('Audio disponible: ${procedure.aAudioDisponible}');
```

### Test 2 : Tester l'appel API

```dart
final dio = Dio();
final response = await dio.get(
  'http://localhost:8080/api/procedures/82/audio/base64',
);
print('Status: ${response.statusCode}');
print('Data: ${response.data}');
```

### Test 3 : Tester la lecture audio

```dart
final audioService = AudioService(...);
final success = await audioService.jouerAudioProcedure(82);
print('Audio joué: $success');
```

---

## ⚠️ Notes Importantes

1. **Token d'authentification** : Si vos endpoints nécessitent une authentification, ajoutez le token dans les headers

2. **URL de base** : Remplacez `http://localhost:8080/api` par votre URL de production

3. **Format audio** : Les fichiers sont en `.aac`, assurez-vous que `audioplayers` supporte ce format

4. **Gestion mémoire** : N'oubliez pas de `dispose()` le `AudioPlayer` quand vous n'en avez plus besoin

5. **Permissions** : Sur Android, ajoutez dans `AndroidManifest.xml` :
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

---

## 🚀 Code Prêt à l'Emploi

Voici le code minimal pour démarrer rapidement :

```dart
// 1. Dans votre widget de procédure
IconButton(
  icon: Icon(Icons.volume_up),
  onPressed: () async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'http://localhost:8080/api/procedures/${procedure.id}/audio/base64',
      );
      
      if (response.statusCode == 200) {
        final audioBase64 = response.data['audioBase64'];
        final audioBytes = base64Decode(audioBase64);
        
        final player = AudioPlayer();
        await player.play(BytesSource(audioBytes));
      }
    } catch (e) {
      print('Erreur: $e');
    }
  },
)
```

---

**Date de création**: 2025-01-14  
**Version**: 1.0

