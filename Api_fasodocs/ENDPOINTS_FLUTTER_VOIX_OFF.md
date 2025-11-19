# 🔊 Endpoints Flutter - Accès Direct à la Voix Off

**Date**: 2025-01-14  
**Version**: 1.0

---

## ⚙️ Configuration

**Djelia AI est désactivé** dans `application.properties` :
```properties
djelia.ai.enabled=false
```

Le système utilise maintenant **uniquement les fichiers audio préenregistrés** (voix off).

---

## 📍 Base URL

```
http://localhost:8080/api/procedures
```

---

## 📡 Endpoints Disponibles

### 1. **Récupérer l'audio en Base64 (Recommandé pour Flutter)**

**Endpoint** : `GET /api/procedures/{id}/audio/base64`

**Description** : Récupère l'audio d'une procédure encodé en Base64. **Idéal pour Flutter**.

**Paramètres** :
- `id` (path) : ID de la procédure

**Exemple** :
```
GET /api/procedures/1/audio/base64
```

**Réponse (200 OK)** :
```json
{
  "procedureId": 1,
  "procedureNom": "Carte d'identité nationale",
  "audioBase64": "UklGRiQAAABXQVZFZm10...",
  "format": "wav",
  "filename": "carte_identite_nationale.wav",
  "fileSize": 123456
}
```

**Réponse (404 Not Found)** :
```json
{
  "success": false,
  "message": "Aucun fichier audio disponible pour cette procédure"
}
```

---

### 2. **Récupérer l'audio en fichier binaire**

**Endpoint** : `GET /api/procedures/{id}/audio`

**Description** : Récupère directement le fichier audio (binaire). Peut être utilisé pour téléchargement ou lecture directe.

**Paramètres** :
- `id` (path) : ID de la procédure

**Exemple** :
```
GET /api/procedures/1/audio
```

**Réponse (200 OK)** :
- **Content-Type** : `audio/wav`, `audio/mpeg`, ou `audio/ogg` (selon le fichier)
- **Body** : Fichier audio binaire

**Réponse (404 Not Found)** : Aucun contenu

---

## 💻 Utilisation dans Flutter

### Option 1 : Avec Base64 (Recommandé)

```dart
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';

class AudioService {
  final Dio dio;
  final String baseUrl;
  final AudioPlayer audioPlayer = AudioPlayer();

  AudioService({required this.dio, required this.baseUrl});

  /// Récupère et joue l'audio d'une procédure
  Future<void> jouerAudioProcedure(int procedureId) async {
    try {
      // Récupérer l'audio en Base64
      final response = await dio.get(
        '$baseUrl/procedures/$procedureId/audio/base64',
      );

      if (response.statusCode == 200) {
        final audioData = response.data;
        final audioBase64 = audioData['audioBase64'] as String;
        final format = audioData['format'] as String;

        // Décoder Base64 en bytes
        final audioBytes = base64Decode(audioBase64);

        // Créer un fichier temporaire ou jouer directement
        // Option 1 : Jouer depuis les bytes (si supporté)
        await audioPlayer.play(BytesSource(audioBytes));
        
        // Option 2 : Sauvegarder temporairement puis jouer
        // final tempFile = await _saveTempFile(audioBytes, format);
        // await audioPlayer.play(DeviceFileSource(tempFile.path));
        
        print('✅ Audio joué avec succès');
      } else {
        throw Exception('Aucun audio disponible');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Aucun fichier audio disponible pour cette procédure');
      } else {
        throw Exception('Erreur lors de la récupération de l\'audio: ${e.message}');
      }
    }
  }
}
```

---

### Option 2 : Avec Fichier Binaire

```dart
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class AudioService {
  final Dio dio;
  final String baseUrl;
  final AudioPlayer audioPlayer = AudioPlayer();

  AudioService({required this.dio, required this.baseUrl});

  /// Récupère et joue l'audio d'une procédure (fichier binaire)
  Future<void> jouerAudioProcedure(int procedureId) async {
    try {
      // Récupérer l'audio en fichier binaire
      final response = await dio.get(
        '$baseUrl/procedures/$procedureId/audio',
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        final audioBytes = response.data as List<int>;
        
        // Sauvegarder temporairement
        final tempDir = await Directory.systemTemp.createTemp();
        final tempFile = File('${tempDir.path}/audio_$procedureId.wav');
        await tempFile.writeAsBytes(audioBytes);
        
        // Jouer l'audio
        await audioPlayer.play(DeviceFileSource(tempFile.path));
        
        print('✅ Audio joué avec succès');
      } else {
        throw Exception('Aucun audio disponible');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Aucun fichier audio disponible pour cette procédure');
      } else {
        throw Exception('Erreur lors de la récupération de l\'audio: ${e.message}');
      }
    }
  }
}
```

---

## 🎨 Exemple d'Utilisation dans un Widget

```dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';

class ProcedureCard extends StatefulWidget {
  final Procedure procedure;

  const ProcedureCard({required this.procedure});

  @override
  _ProcedureCardState createState() => _ProcedureCardState();
}

class _ProcedureCardState extends State<ProcedureCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _jouerAudio() async {
    // Vérifier si la procédure a un audio
    if (widget.procedure.audioUrl == null || widget.procedure.audioUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aucun audio disponible pour cette procédure')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _isPlaying = false;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'http://localhost:8080/api/procedures/${widget.procedure.id}/audio/base64',
      );

      if (response.statusCode == 200) {
        final audioData = response.data;
        final audioBase64 = audioData['audioBase64'] as String;
        final audioBytes = base64Decode(audioBase64);

        // Jouer l'audio
        await _audioPlayer.play(BytesSource(audioBytes));
        
        setState(() {
          _isPlaying = true;
          _isLoading = false;
        });

        // Écouter la fin de la lecture
        _audioPlayer.onPlayerComplete.listen((_) {
          setState(() {
            _isPlaying = false;
          });
        });
      } else {
        throw Exception('Aucun audio disponible');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isPlaying = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Future<void> _arreterAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.procedure.titre),
        subtitle: Text(widget.procedure.description),
        trailing: widget.procedure.audioUrl != null && widget.procedure.audioUrl!.isNotEmpty
            ? IconButton(
                icon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_isPlaying ? Icons.stop : Icons.volume_up),
                onPressed: _isPlaying ? _arreterAudio : _jouerAudio,
                tooltip: _isPlaying ? 'Arrêter' : 'Écouter',
              )
            : null,
      ),
    );
  }
}
```

---

## 📦 Modèle Dart

```dart
class Procedure {
  final int id;
  final String nom;
  final String titre;
  final String description;
  final String? audioUrl; // Chemin du fichier audio

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
      audioUrl: json['audioUrl'],
    );
  }

  // Vérifier si l'audio est disponible
  bool get aAudioDisponible => audioUrl != null && audioUrl!.isNotEmpty;
}

class AudioResponse {
  final int procedureId;
  final String procedureNom;
  final String audioBase64;
  final String format;
  final String? filename;
  final int? fileSize;

  AudioResponse({
    required this.procedureId,
    required this.procedureNom,
    required this.audioBase64,
    required this.format,
    this.filename,
    this.fileSize,
  });

  factory AudioResponse.fromJson(Map<String, dynamic> json) {
    return AudioResponse(
      procedureId: json['procedureId'],
      procedureNom: json['procedureNom'],
      audioBase64: json['audioBase64'],
      format: json['format'],
      filename: json['filename'],
      fileSize: json['fileSize'],
    );
  }
}
```

---

## 🔧 Configuration des Fichiers Audio

### 1. **Placer les fichiers audio**

Les fichiers doivent être dans :
```
src/main/resources/static/audio/procedures/
```

**Exemples** :
```
src/main/resources/static/audio/procedures/
├── carte_identite_nationale.wav
├── passeport.wav
├── acte_naissance.wav
└── permis_conduire.wav
```

### 2. **Enregistrer en base de données**

```sql
-- Ajouter un fichier audio à une procédure
UPDATE procedures 
SET audio_url = 'carte_identite_nationale.wav' 
WHERE id = 1;

-- Vérifier les procédures avec audio
SELECT id, nom, audio_url 
FROM procedures 
WHERE audio_url IS NOT NULL;
```

---

## 📝 Formats Supportés

- ✅ **WAV** (recommandé) : `audio/wav`
- ✅ **MP3** : `audio/mpeg`
- ✅ **OGG** : `audio/ogg`

---

## ⚠️ Notes Importantes

1. **Djelia AI est désactivé** : Le système utilise uniquement les fichiers audio préenregistrés

2. **Vérifier l'audio avant d'afficher l'icône** :
   ```dart
   if (procedure.audioUrl != null && procedure.audioUrl!.isNotEmpty) {
     // Afficher l'icône haut-parleur
   }
   ```

3. **Gestion des erreurs** : Toujours gérer le cas où l'audio n'est pas disponible (404)

4. **Performance** : L'endpoint Base64 est plus pratique pour Flutter car il évite la gestion des fichiers temporaires

5. **Cache** : Considérez mettre en cache les fichiers audio en Base64 pour améliorer les performances

---

## 🧪 Tests

### Test 1 : Vérifier qu'un audio existe

```bash
# Vérifier en base de données
SELECT id, nom, audio_url 
FROM procedures 
WHERE audio_url IS NOT NULL;

# Tester l'endpoint Base64
curl http://localhost:8080/api/procedures/1/audio/base64

# Tester l'endpoint fichier binaire
curl http://localhost:8080/api/procedures/1/audio -o test.wav
```

---

## 📊 Comparaison des Endpoints

| Endpoint | Format | Utilisation | Avantages |
|----------|--------|-------------|-----------|
| `/audio/base64` | JSON + Base64 | Flutter (recommandé) | ✅ Facile à utiliser<br>✅ Pas de gestion de fichiers<br>✅ Informations supplémentaires |
| `/audio` | Fichier binaire | Téléchargement direct | ✅ Plus léger<br>✅ Streaming possible |

---

## 🚀 Exemple Complet avec Gestion d'État

```dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

enum AudioState {
  idle,
  loading,
  playing,
  error,
}

class ProcedureAudioPlayer extends StatefulWidget {
  final int procedureId;
  final String? audioUrl;

  const ProcedureAudioPlayer({
    required this.procedureId,
    this.audioUrl,
  });

  @override
  _ProcedureAudioPlayerState createState() => _ProcedureAudioPlayerState();
}

class _ProcedureAudioPlayerState extends State<ProcedureAudioPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioState _state = AudioState.idle;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _jouerAudio() async {
    if (widget.audioUrl == null || widget.audioUrl!.isEmpty) {
      setState(() => _state = AudioState.error);
      return;
    }

    setState(() => _state = AudioState.loading);

    try {
      final dio = Dio();
      final response = await dio.get(
        'http://localhost:8080/api/procedures/${widget.procedureId}/audio/base64',
      );

      if (response.statusCode == 200) {
        final audioData = response.data;
        final audioBase64 = audioData['audioBase64'] as String;
        final audioBytes = base64Decode(audioBase64);

        await _audioPlayer.play(BytesSource(audioBytes));
        
        setState(() => _state = AudioState.playing);

        _audioPlayer.onPlayerComplete.listen((_) {
          setState(() => _state = AudioState.idle);
        });
      } else {
        setState(() => _state = AudioState.error);
      }
    } catch (e) {
      setState(() => _state = AudioState.error);
    }
  }

  Future<void> _arreterAudio() async {
    await _audioPlayer.stop();
    setState(() => _state = AudioState.idle);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audioUrl == null || widget.audioUrl!.isEmpty) {
      return SizedBox.shrink();
    }

    return IconButton(
      icon: _buildIcon(),
      onPressed: _state == AudioState.playing ? _arreterAudio : _jouerAudio,
      tooltip: _getTooltip(),
    );
  }

  Widget _buildIcon() {
    switch (_state) {
      case AudioState.loading:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case AudioState.playing:
        return Icon(Icons.stop);
      case AudioState.error:
        return Icon(Icons.error_outline, color: Colors.red);
      default:
        return Icon(Icons.volume_up);
    }
  }

  String _getTooltip() {
    switch (_state) {
      case AudioState.loading:
        return 'Chargement...';
      case AudioState.playing:
        return 'Arrêter';
      case AudioState.error:
        return 'Erreur de lecture';
      default:
        return 'Écouter';
    }
  }
}
```

---

**Date de création**: 2025-01-14  
**Version**: 1.0

