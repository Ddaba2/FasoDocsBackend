# 📱 Endpoints Flutter - Délégations de Services

**Date**: 2025-01-14  
**Version**: 1.0

---

## 🔐 Authentification

Tous les endpoints nécessitent :
- **Authentification** : Token JWT valide
- **Header** : `Authorization: Bearer {token}`

---

## 📍 Base URL

```
http://localhost:8080/api/delegations
```

---

## 📋 Endpoints Disponibles

### 1. **Obtenir le tarif de délégation**

Récupère le tarif de délégation pour une procédure selon la commune.

**Endpoint** : `GET /delegations/procedures/{procedureId}/tarif`

**Paramètres** :
- `procedureId` (path) : ID de la procédure
- `commune` (query) : Nom de la commune (ex: "Commune I", "Kati")

**Exemple** :
```
GET /delegations/procedures/5/tarif?commune=Commune I
```

**Réponse (200 OK)** :
```json
{
  "procedureId": 5,
  "procedureNom": "Carte d'identité nationale",
  "tarifDelegation": 3000.00,
  "coutLegal": 4000.00,
  "tarifTotal": 7000.00,
  "commune": "Commune I",
  "description": "Service complet incluant la prise en charge de votre procédure, le suivi des démarches et la récupération des documents.",
  "delaiEstime": "2 semaines"
}
```

**Réponse d'erreur (400 Bad Request)** :
```json
{
  "success": false,
  "message": "Erreur lors de la récupération du tarif: Tarif non défini pour la commune: XYZ"
}
```

---

### 2. **Créer une demande de délégation**

Crée une nouvelle demande de délégation. Le statut sera automatiquement `EN_ATTENTE`.

**Endpoint** : `POST /delegations/demandes`

**Body (JSON)** :
```json
{
  "procedureId": 5,
  "commune": "Commune I",
  "quartier": "Hamdallaye",
  "telephoneContact": "+22370123456",
  "dateSouhaitee": "2025-01-20",
  "commentaires": "Besoin urgent",
  "accepteTarif": true
}
```

**Champs** :
- `procedureId` (requis) : ID de la procédure
- `commune` (requis) : Nom de la commune
- `quartier` (optionnel) : Nom du quartier
- `telephoneContact` (optionnel) : Téléphone de contact (utilise celui du profil si non fourni)
- `dateSouhaitee` (optionnel) : Date souhaitée au format `YYYY-MM-DD`
- `commentaires` (optionnel) : Commentaires ou instructions spéciales
- `accepteTarif` (requis) : Doit être `true` pour confirmer l'acceptation du tarif

**Réponse (200 OK)** :
```json
{
  "id": 1,
  "procedure": {
    "id": 5,
    "nom": "Carte d'identité nationale",
    "titre": "Demande de carte d'identité nationale"
  },
  "statut": "EN_ATTENTE",
  "tarif": 7000.00,
  "tarifDelegation": 3000.00,
  "coutLegal": 4000.00,
  "commune": "Commune I",
  "quartier": "Hamdallaye",
  "telephoneContact": "+22370123456",
  "dateSouhaitee": "2025-01-20",
  "commentaires": "Besoin urgent",
  "notesAgent": null,
  "agent": null,
  "dateAcceptation": null,
  "dateDebut": null,
  "dateFin": null,
  "dateCreation": "2025-01-14T10:30:00",
  "dateModification": "2025-01-14T10:30:00"
}
```

**Réponse d'erreur (400 Bad Request)** :
```json
{
  "success": false,
  "message": "Erreur lors de la création de la demande: Vous devez accepter le tarif pour continuer"
}
```

---

### 3. **Lister mes demandes**

Récupère toutes les demandes de délégation de l'utilisateur connecté, triées par date (plus récentes en premier).

**Endpoint** : `GET /delegations/mes-demandes`

**Exemple** :
```
GET /delegations/mes-demandes
```

**Réponse (200 OK)** :
```json
[
  {
    "id": 1,
    "procedure": {
      "id": 5,
      "nom": "Carte d'identité nationale",
      "titre": "Demande de carte d'identité nationale"
    },
    "statut": "EN_ATTENTE",
    "tarif": 7000.00,
    "tarifDelegation": 3000.00,
    "coutLegal": 4000.00,
    "commune": "Commune I",
    "quartier": "Hamdallaye",
    "telephoneContact": "+22370123456",
    "dateSouhaitee": "2025-01-20",
    "commentaires": "Besoin urgent",
    "notesAgent": null,
    "agent": null,
    "dateAcceptation": null,
    "dateDebut": null,
    "dateFin": null,
    "dateCreation": "2025-01-14T10:30:00",
    "dateModification": "2025-01-14T10:30:00"
  },
  {
    "id": 2,
    "procedure": {
      "id": 8,
      "nom": "Passeport",
      "titre": "Demande de passeport"
    },
    "statut": "EN_COURS",
    "tarif": 10000.00,
    "tarifDelegation": 3000.00,
    "coutLegal": 7000.00,
    "commune": "Commune II",
    "quartier": "Badalabougou",
    "telephoneContact": "+22370234567",
    "dateSouhaitee": "2025-01-18",
    "commentaires": null,
    "notesAgent": "Démarches en cours",
    "agent": null,
    "dateAcceptation": null,
    "dateDebut": "2025-01-14T11:00:00",
    "dateFin": null,
    "dateCreation": "2025-01-14T09:15:00",
    "dateModification": "2025-01-14T11:00:00"
  }
]
```

---

### 4. **Récupérer une demande spécifique**

Récupère les détails complets d'une demande de délégation par son ID.

**Endpoint** : `GET /delegations/demandes/{id}`

**Paramètres** :
- `id` (path) : ID de la demande de délégation

**Exemple** :
```
GET /delegations/demandes/1
```

**Réponse (200 OK)** :
```json
{
  "id": 1,
  "procedure": {
    "id": 5,
    "nom": "Carte d'identité nationale",
    "titre": "Demande de carte d'identité nationale"
  },
  "statut": "EN_ATTENTE",
  "tarif": 7000.00,
  "tarifDelegation": 3000.00,
  "coutLegal": 4000.00,
  "commune": "Commune I",
  "quartier": "Hamdallaye",
  "telephoneContact": "+22370123456",
  "dateSouhaitee": "2025-01-20",
  "commentaires": "Besoin urgent",
  "notesAgent": null,
  "agent": null,
  "dateAcceptation": null,
  "dateDebut": null,
  "dateFin": null,
  "dateCreation": "2025-01-14T10:30:00",
  "dateModification": "2025-01-14T10:30:00"
}
```

**Réponse d'erreur (400 Bad Request)** :
```json
{
  "success": false,
  "message": "Erreur lors de la récupération de la demande: Vous n'avez pas accès à cette demande"
}
```

---

### 5. **Annuler une demande**

Annule une demande de délégation. Uniquement possible si le statut est `EN_ATTENTE`.

**Endpoint** : `PUT /delegations/demandes/{id}/annuler`

**Paramètres** :
- `id` (path) : ID de la demande de délégation
- `raison` (query, optionnel) : Raison de l'annulation

**Exemples** :
```
PUT /delegations/demandes/1/annuler
PUT /delegations/demandes/1/annuler?raison=Changement de plan
```

**Réponse (200 OK)** :
```json
{
  "success": true,
  "message": "Demande annulée avec succès. L'admin sera informé."
}
```

**Réponse d'erreur (400 Bad Request)** :
```json
{
  "success": false,
  "message": "Erreur lors de l'annulation: Seules les demandes en attente peuvent être annulées"
}
```

---

## 📊 Statuts des Demandes

| Statut | Description | Actions possibles |
|--------|-------------|-------------------|
| `EN_ATTENTE` | Demande créée, en attente de traitement | ✅ Annuler |
| `EN_COURS` | Demande en cours de traitement | ❌ Aucune (suivi uniquement) |
| `TERMINEE` | Demande terminée | ❌ Aucune (suivi uniquement) |

---

## 💻 Exemples d'Implémentation Flutter/Dart

### Configuration du Service

```dart
import 'package:dio/dio.dart';

class DelegationService {
  final Dio dio;
  final String baseUrl;

  DelegationService({required this.dio, required this.baseUrl});

  // Méthode helper pour ajouter le token
  Options _getOptions() {
    return Options(
      headers: {
        'Authorization': 'Bearer ${_getToken()}', // Récupérer depuis votre storage
        'Content-Type': 'application/json',
      },
    );
  }

  String _getToken() {
    // Implémenter la récupération du token depuis votre storage
    // Exemple: return SharedPreferences.getInstance().then((prefs) => prefs.getString('token'));
    return 'YOUR_TOKEN';
  }
}
```

---

### 1. Obtenir le tarif de délégation

```dart
Future<TarifDelegation> obtenirTarif({
  required int procedureId,
  required String commune,
}) async {
  try {
    final response = await dio.get(
      '$baseUrl/delegations/procedures/$procedureId/tarif',
      queryParameters: {'commune': commune},
      options: _getOptions(),
    );

    if (response.statusCode == 200) {
      return TarifDelegation.fromJson(response.data);
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      final errorMessage = e.response?.data['message'] ?? 'Erreur inconnue';
      throw Exception(errorMessage);
    } else {
      throw Exception('Erreur de connexion: ${e.message}');
    }
  }
}

// Modèle
class TarifDelegation {
  final int procedureId;
  final String procedureNom;
  final double tarifDelegation;
  final double? coutLegal;
  final double tarifTotal;
  final String commune;
  final String description;
  final String delaiEstime;

  TarifDelegation({
    required this.procedureId,
    required this.procedureNom,
    required this.tarifDelegation,
    this.coutLegal,
    required this.tarifTotal,
    required this.commune,
    required this.description,
    required this.delaiEstime,
  });

  factory TarifDelegation.fromJson(Map<String, dynamic> json) {
    return TarifDelegation(
      procedureId: json['procedureId'],
      procedureNom: json['procedureNom'],
      tarifDelegation: json['tarifDelegation']?.toDouble() ?? 0.0,
      coutLegal: json['coutLegal']?.toDouble(),
      tarifTotal: json['tarifTotal']?.toDouble() ?? 0.0,
      commune: json['commune'],
      description: json['description'],
      delaiEstime: json['delaiEstime'],
    );
  }
}
```

---

### 2. Créer une demande de délégation

```dart
Future<DemandeDelegation> creerDemande({
  required int procedureId,
  required String commune,
  String? quartier,
  String? telephoneContact,
  DateTime? dateSouhaitee,
  String? commentaires,
}) async {
  try {
    final response = await dio.post(
      '$baseUrl/delegations/demandes',
      data: {
        'procedureId': procedureId,
        'commune': commune,
        'quartier': quartier,
        'telephoneContact': telephoneContact,
        'dateSouhaitee': dateSouhaitee?.toIso8601String().split('T')[0],
        'commentaires': commentaires,
        'accepteTarif': true,
      },
      options: _getOptions(),
    );

    if (response.statusCode == 200) {
      return DemandeDelegation.fromJson(response.data);
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      final errorMessage = e.response?.data['message'] ?? 'Erreur inconnue';
      throw Exception(errorMessage);
    } else {
      throw Exception('Erreur de connexion: ${e.message}');
    }
  }
}
```

---

### 3. Lister mes demandes

```dart
Future<List<DemandeDelegation>> obtenirMesDemandes() async {
  try {
    final response = await dio.get(
      '$baseUrl/delegations/mes-demandes',
      options: _getOptions(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => DemandeDelegation.fromJson(json)).toList();
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      final errorMessage = e.response?.data['message'] ?? 'Erreur inconnue';
      throw Exception(errorMessage);
    } else {
      throw Exception('Erreur de connexion: ${e.message}');
    }
  }
}
```

---

### 4. Récupérer une demande spécifique

```dart
Future<DemandeDelegation> obtenirDemandeParId(int id) async {
  try {
    final response = await dio.get(
      '$baseUrl/delegations/demandes/$id',
      options: _getOptions(),
    );

    if (response.statusCode == 200) {
      return DemandeDelegation.fromJson(response.data);
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      final errorMessage = e.response?.data['message'] ?? 'Erreur inconnue';
      throw Exception(errorMessage);
    } else {
      throw Exception('Erreur de connexion: ${e.message}');
    }
  }
}
```

---

### 5. Annuler une demande

```dart
Future<void> annulerDemande(int id, {String? raison}) async {
  try {
    final response = await dio.put(
      '$baseUrl/delegations/demandes/$id/annuler',
      queryParameters: raison != null ? {'raison': raison} : null,
      options: _getOptions(),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      final errorMessage = e.response?.data['message'] ?? 'Erreur inconnue';
      throw Exception(errorMessage);
    } else {
      throw Exception('Erreur de connexion: ${e.message}');
    }
  }
}
```

---

## 📦 Modèles Dart Complets

### Modèle DemandeDelegation

```dart
class DemandeDelegation {
  final int id;
  final ProcedureSimple procedure;
  final String statut; // EN_ATTENTE, EN_COURS, TERMINEE
  final double tarif;
  final double tarifDelegation;
  final double? coutLegal;
  final String commune;
  final String? quartier;
  final String? telephoneContact;
  final DateTime? dateSouhaitee;
  final String? commentaires;
  final String? notesAgent;
  final CitoyenSimple? agent;
  final DateTime? dateAcceptation;
  final DateTime? dateDebut;
  final DateTime? dateFin;
  final DateTime dateCreation;
  final DateTime dateModification;

  DemandeDelegation({
    required this.id,
    required this.procedure,
    required this.statut,
    required this.tarif,
    required this.tarifDelegation,
    this.coutLegal,
    required this.commune,
    this.quartier,
    this.telephoneContact,
    this.dateSouhaitee,
    this.commentaires,
    this.notesAgent,
    this.agent,
    this.dateAcceptation,
    this.dateDebut,
    this.dateFin,
    required this.dateCreation,
    required this.dateModification,
  });

  factory DemandeDelegation.fromJson(Map<String, dynamic> json) {
    return DemandeDelegation(
      id: json['id'],
      procedure: ProcedureSimple.fromJson(json['procedure']),
      statut: json['statut'],
      tarif: json['tarif']?.toDouble() ?? 0.0,
      tarifDelegation: json['tarifDelegation']?.toDouble() ?? 0.0,
      coutLegal: json['coutLegal']?.toDouble(),
      commune: json['commune'],
      quartier: json['quartier'],
      telephoneContact: json['telephoneContact'],
      dateSouhaitee: json['dateSouhaitee'] != null
          ? DateTime.parse(json['dateSouhaitee'])
          : null,
      commentaires: json['commentaires'],
      notesAgent: json['notesAgent'],
      agent: json['agent'] != null
          ? CitoyenSimple.fromJson(json['agent'])
          : null,
      dateAcceptation: json['dateAcceptation'] != null
          ? DateTime.parse(json['dateAcceptation'])
          : null,
      dateDebut: json['dateDebut'] != null
          ? DateTime.parse(json['dateDebut'])
          : null,
      dateFin: json['dateFin'] != null
          ? DateTime.parse(json['dateFin'])
          : null,
      dateCreation: DateTime.parse(json['dateCreation']),
      dateModification: DateTime.parse(json['dateModification']),
    );
  }

  // Helpers
  bool get estEnAttente => statut == 'EN_ATTENTE';
  bool get estEnCours => statut == 'EN_COURS';
  bool get estTerminee => statut == 'TERMINEE';
  bool get peutEtreAnnulee => estEnAttente;
}

class ProcedureSimple {
  final int id;
  final String nom;
  final String titre;

  ProcedureSimple({
    required this.id,
    required this.nom,
    required this.titre,
  });

  factory ProcedureSimple.fromJson(Map<String, dynamic> json) {
    return ProcedureSimple(
      id: json['id'],
      nom: json['nom'],
      titre: json['titre'],
    );
  }
}

class CitoyenSimple {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;

  CitoyenSimple({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
  });

  factory CitoyenSimple.fromJson(Map<String, dynamic> json) {
    return CitoyenSimple(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
    );
  }
}
```

---

## 🎨 Exemple d'Utilisation dans un Widget Flutter

```dart
import 'package:flutter/material.dart';

class DelegationListScreen extends StatefulWidget {
  @override
  _DelegationListScreenState createState() => _DelegationListScreenState();
}

class _DelegationListScreenState extends State<DelegationListScreen> {
  final DelegationService _delegationService = DelegationService(
    dio: Dio(),
    baseUrl: 'http://localhost:8080/api',
  );

  List<DemandeDelegation> _demandes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _chargerDemandes();
  }

  Future<void> _chargerDemandes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final demandes = await _delegationService.obtenirMesDemandes();
      setState(() {
        _demandes = demandes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _annulerDemande(int id) async {
    try {
      await _delegationService.annulerDemande(id, raison: 'Annulation par l\'utilisateur');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande annulée avec succès')),
      );
      _chargerDemandes(); // Recharger la liste
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Demandes')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Demandes')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erreur: $_error'),
              ElevatedButton(
                onPressed: _chargerDemandes,
                child: Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Mes Demandes')),
      body: RefreshIndicator(
        onRefresh: _chargerDemandes,
        child: _demandes.isEmpty
            ? Center(child: Text('Aucune demande de délégation'))
            : ListView.builder(
                itemCount: _demandes.length,
                itemBuilder: (context, index) {
                  final demande = _demandes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(demande.procedure.titre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Statut: ${demande.statut}'),
                          Text('Tarif: ${demande.tarif} FCFA'),
                          if (demande.dateSouhaitee != null)
                            Text('Date souhaitée: ${demande.dateSouhaitee!.toString().split(' ')[0]}'),
                        ],
                      ),
                      trailing: demande.peutEtreAnnulee
                          ? IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () => _annulerDemande(demande.id),
                            )
                          : null,
                      onTap: () {
                        // Naviguer vers la page de détails
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DelegationDetailScreen(demande.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
```

---

## ⚠️ Notes Importantes

1. **Authentification** : Tous les endpoints nécessitent un token JWT valide dans le header `Authorization`

2. **Gestion des erreurs** : Toujours gérer les erreurs `DioException` pour afficher des messages clairs à l'utilisateur

3. **Statuts** : Les statuts sont en majuscules : `EN_ATTENTE`, `EN_COURS`, `TERMINEE`

4. **Dates** : Les dates sont au format ISO 8601 (`YYYY-MM-DD` ou `YYYY-MM-DDTHH:mm:ss`)

5. **Notifications** : Le client reçoit automatiquement une notification dans l'application à chaque changement de statut

6. **Annulation** : Seules les demandes avec le statut `EN_ATTENTE` peuvent être annulées

---

**Date de création**: 2025-01-14  
**Version**: 1.0

