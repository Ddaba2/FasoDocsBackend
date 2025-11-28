# 📱 Guide d'Intégration Frontend - Système de Quiz

## 🎯 Vue d'Ensemble

Ce guide détaille **exactement** ce que vous devez faire côté frontend pour intégrer le système de quiz :
- **Flutter** (Application utilisateur/citoyen)
- **Angular** (Application admin)

---

## 🔐 Authentification

**IMPORTANT** : Tous les endpoints `/quiz/**` nécessitent une **authentification JWT**.

### Headers requis pour toutes les requêtes :
```http
Authorization: Bearer {JWT_TOKEN}
Accept-Language: fr (ou en)
Content-Type: application/json
```

---

## 📱 FLUTTER - Application Utilisateur

### 1. **Modèles de Données (Models)**

#### QuizJournalierResponse
```dart
class QuizJournalierResponse {
  final int? id;
  final String? dateQuiz; // Format: "2025-01-15"
  final int? procedureId;
  final String? procedureNom;
  final int? categorieId;
  final String? categorieTitre;
  final bool? estActif;
  final List<QuizQuestionResponse>? questions;

  QuizJournalierResponse({
    this.id,
    this.dateQuiz,
    this.procedureId,
    this.procedureNom,
    this.categorieId,
    this.categorieTitre,
    this.estActif,
    this.questions,
  });

  factory QuizJournalierResponse.fromJson(Map<String, dynamic> json) {
    return QuizJournalierResponse(
      id: json['id'],
      dateQuiz: json['dateQuiz'],
      procedureId: json['procedureId'],
      procedureNom: json['procedureNom'],
      categorieId: json['categorieId'],
      categorieTitre: json['categorieTitre'],
      estActif: json['estActif'],
      questions: (json['questions'] as List?)
          ?.map((q) => QuizQuestionResponse.fromJson(q))
          .toList(),
    );
  }
}
```

#### QuizQuestionResponse
```dart
class QuizQuestionResponse {
  final int? id;
  final String? question; // Déjà traduit selon la langue (fr ou en)
  final String? typeQuestion;
  final int? points;
  final String? niveau;
  final List<QuizReponseResponse>? reponses;

  QuizQuestionResponse({
    this.id,
    this.question,
    this.typeQuestion,
    this.points,
    this.niveau,
    this.reponses,
  });

  factory QuizQuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuizQuestionResponse(
      id: json['id'],
      question: json['question'], // Déjà dans la langue demandée
      typeQuestion: json['typeQuestion'],
      points: json['points'],
      niveau: json['niveau'],
      reponses: (json['reponses'] as List?)
          ?.map((r) => QuizReponseResponse.fromJson(r))
          .toList(),
    );
  }
}
```

#### QuizReponseResponse
```dart
class QuizReponseResponse {
  final int? id;
  final String? reponse; // Déjà traduit selon la langue (fr ou en)
  final bool? estCorrecte; // NULL avant soumission (pour ne pas révéler)
  final int? ordre;

  QuizReponseResponse({
    this.id,
    this.reponse,
    this.estCorrecte,
    this.ordre,
  });

  factory QuizReponseResponse.fromJson(Map<String, dynamic> json) {
    return QuizReponseResponse(
      id: json['id'],
      reponse: json['reponse'], // Déjà dans la langue demandée
      estCorrecte: json['estCorrecte'], // null avant soumission
      ordre: json['ordre'],
    );
  }
}
```

#### QuizParticipationRequest
```dart
class QuizParticipationRequest {
  final int quizJournalierId;
  final List<ReponseQuestion> reponses;
  final int? tempsSecondes;

  QuizParticipationRequest({
    required this.quizJournalierId,
    required this.reponses,
    this.tempsSecondes,
  });

  Map<String, dynamic> toJson() {
    return {
      'quizJournalierId': quizJournalierId,
      'reponses': reponses.map((r) => r.toJson()).toList(),
      if (tempsSecondes != null) 'tempsSecondes': tempsSecondes,
    };
  }
}

class ReponseQuestion {
  final int questionId;
  final int reponseChoisieId;

  ReponseQuestion({
    required this.questionId,
    required this.reponseChoisieId,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'reponseChoisieId': reponseChoisieId,
    };
  }
}
```

#### QuizParticipationResponse
```dart
class QuizParticipationResponse {
  final int? id;
  final int? quizJournalierId;
  final String? dateQuiz;
  final int? score;
  final int? nombreBonnesReponses;
  final int? nombreQuestions;
  final int? tempsSecondes;
  final bool? estComplete;
  final String? dateParticipation;
  final List<QuizReponseUtilisateurResponse>? reponses;

  QuizParticipationResponse({
    this.id,
    this.quizJournalierId,
    this.dateQuiz,
    this.score,
    this.nombreBonnesReponses,
    this.nombreQuestions,
    this.tempsSecondes,
    this.estComplete,
    this.dateParticipation,
    this.reponses,
  });

  factory QuizParticipationResponse.fromJson(Map<String, dynamic> json) {
    return QuizParticipationResponse(
      id: json['id'],
      quizJournalierId: json['quizJournalierId'],
      dateQuiz: json['dateQuiz'],
      score: json['score'],
      nombreBonnesReponses: json['nombreBonnesReponses'],
      nombreQuestions: json['nombreQuestions'],
      tempsSecondes: json['tempsSecondes'],
      estComplete: json['estComplete'],
      dateParticipation: json['dateParticipation'],
      reponses: (json['reponses'] as List?)
          ?.map((r) => QuizReponseUtilisateurResponse.fromJson(r))
          .toList(),
    );
  }
}
```

#### QuizStatistiqueResponse
```dart
class QuizStatistiqueResponse {
  final int? citoyenId;
  final String? citoyenNom;
  final String? citoyenPrenom;
  final int? totalPoints;
  final int? totalQuizCompletes;
  final int? streakJours;
  final int? meilleurStreak;
  final String? derniereParticipation;
  final bool? badgeExpert;
  final bool? badgeStreakMaster;
  final int? positionClassement;

  QuizStatistiqueResponse({
    this.citoyenId,
    this.citoyenNom,
    this.citoyenPrenom,
    this.totalPoints,
    this.totalQuizCompletes,
    this.streakJours,
    this.meilleurStreak,
    this.derniereParticipation,
    this.badgeExpert,
    this.badgeStreakMaster,
    this.positionClassement,
  });

  factory QuizStatistiqueResponse.fromJson(Map<String, dynamic> json) {
    return QuizStatistiqueResponse(
      citoyenId: json['citoyenId'],
      citoyenNom: json['citoyenNom'],
      citoyenPrenom: json['citoyenPrenom'],
      totalPoints: json['totalPoints'],
      totalQuizCompletes: json['totalQuizCompletes'],
      streakJours: json['streakJours'],
      meilleurStreak: json['meilleurStreak'],
      derniereParticipation: json['derniereParticipation'],
      badgeExpert: json['badgeExpert'],
      badgeStreakMaster: json['badgeStreakMaster'],
      positionClassement: json['positionClassement'],
    );
  }
}
```

#### ClassementResponse
```dart
class ClassementResponse {
  final String? periode; // "HEBDOMADAIRE" ou "MENSUEL"
  final List<QuizStatistiqueResponse>? classement;
  final int? positionUtilisateur;

  ClassementResponse({
    this.periode,
    this.classement,
    this.positionUtilisateur,
  });

  factory ClassementResponse.fromJson(Map<String, dynamic> json) {
    return ClassementResponse(
      periode: json['periode'],
      classement: (json['classement'] as List?)
          ?.map((s) => QuizStatistiqueResponse.fromJson(s))
          .toList(),
      positionUtilisateur: json['positionUtilisateur'],
    );
  }
}
```

### 2. **Service API (QuizService)**

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizService {
  final String baseUrl = 'http://localhost:8080/api/quiz'; // Ajustez selon votre config
  final String? token; // JWT token de l'utilisateur connecté
  final String? langue; // 'fr' ou 'en'

  QuizService({this.token, this.langue = 'fr'});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept-Language': langue ?? 'fr',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // 1. Récupérer le quiz du jour
  Future<QuizJournalierResponse?> obtenirQuizAujourdhui() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/aujourdhui'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return QuizJournalierResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la récupération du quiz: $e');
      return null;
    }
  }

  // 2. Participer à un quiz
  Future<QuizParticipationResponse?> participerAuQuiz(
    QuizParticipationRequest request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/participer'),
        headers: _headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return QuizParticipationResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la participation: $e');
      return null;
    }
  }

  // 3. Récupérer les statistiques
  Future<QuizStatistiqueResponse?> obtenirStatistiques() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/statistiques'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return QuizStatistiqueResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des stats: $e');
      return null;
    }
  }

  // 4. Classement hebdomadaire
  Future<ClassementResponse?> obtenirClassementHebdomadaire() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/classement/hebdomadaire'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return ClassementResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la récupération du classement: $e');
      return null;
    }
  }

  // 5. Classement mensuel
  Future<ClassementResponse?> obtenirClassementMensuel() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/classement/mensuel'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return ClassementResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la récupération du classement: $e');
      return null;
    }
  }
}
```

### 3. **Écrans à Créer**

#### A. Écran Principal du Quiz (`quiz_screen.dart`)

```dart
import 'package:flutter/material.dart';
import 'models/quiz_models.dart';
import 'services/quiz_service.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _quizService = QuizService(
    token: 'VOTRE_JWT_TOKEN', // Récupérer depuis le storage
    langue: 'fr', // Récupérer depuis les préférences
  );

  QuizJournalierResponse? _quiz;
  bool _loading = true;
  int _currentQuestionIndex = 0;
  Map<int, int> _reponsesChoisies = {}; // questionId -> reponseId
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _chargerQuiz();
  }

  Future<void> _chargerQuiz() async {
    setState(() => _loading = true);
    final quiz = await _quizService.obtenirQuizAujourdhui();
    setState(() {
      _quiz = quiz;
      _loading = false;
      _startTime = DateTime.now();
    });
  }

  void _selectionnerReponse(int questionId, int reponseId) {
    setState(() {
      _reponsesChoisies[questionId] = reponseId;
    });
  }

  Future<void> _soumettreQuiz() async {
    if (_quiz == null || _reponsesChoisies.length != _quiz!.questions!.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez répondre à toutes les questions')),
      );
      return;
    }

    final tempsSecondes = DateTime.now().difference(_startTime!).inSeconds;

    final request = QuizParticipationRequest(
      quizJournalierId: _quiz!.id!,
      reponses: _reponsesChoisies.entries.map((e) => ReponseQuestion(
        questionId: e.key,
        reponseChoisieId: e.value,
      )).toList(),
      tempsSecondes: tempsSecondes,
    );

    final resultat = await _quizService.participerAuQuiz(request);

    if (resultat != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultatQuizScreen(resultat: resultat),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz du Jour')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_quiz == null || _quiz!.questions == null || _quiz!.questions!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz du Jour')),
        body: Center(
          child: Text('Aucun quiz disponible aujourd\'hui'),
        ),
      );
    }

    final question = _quiz!.questions![_currentQuestionIndex];
    final langue = 'fr'; // Récupérer depuis les préférences

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz du Jour'),
        actions: [
          Text('${_currentQuestionIndex + 1}/${_quiz!.questions!.length}'),
        ],
      ),
      body: Column(
        children: [
          // Barre de progression
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _quiz!.questions!.length,
          ),
          
          // Question
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.question ?? '',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  
                  // Réponses
                  Expanded(
                    child: ListView.builder(
                      itemCount: question.reponses?.length ?? 0,
                      itemBuilder: (context, index) {
                        final reponse = question.reponses![index];
                        final isSelected = _reponsesChoisies[question.id] == reponse.id;
                        
                        return Card(
                          color: isSelected ? Colors.blue[100] : null,
                          child: ListTile(
                            title: Text(
                              reponse.reponse ?? '',
                            ),
                            onTap: () => _selectionnerReponse(
                              question.id!,
                              reponse.id!,
                            ),
                            trailing: isSelected 
                              ? Icon(Icons.check_circle, color: Colors.blue)
                              : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Boutons navigation
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _currentQuestionIndex--);
                    },
                    child: Text('Précédent'),
                  ),
                if (_currentQuestionIndex < _quiz!.questions!.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _currentQuestionIndex++);
                    },
                    child: Text('Suivant'),
                  )
                else
                  ElevatedButton(
                    onPressed: _soumettreQuiz,
                    child: Text('Terminer'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

#### B. Écran de Résultat (`resultat_quiz_screen.dart`)

```dart
class ResultatQuizScreen extends StatelessWidget {
  final QuizParticipationResponse resultat;

  ResultatQuizScreen({required this.resultat});

  @override
  Widget build(BuildContext context) {
    final pourcentage = (resultat.nombreBonnesReponses! / 
                         resultat.nombreQuestions! * 100).round();

    return Scaffold(
      appBar: AppBar(title: Text('Résultats')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: ${resultat.score} points',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '${resultat.nombreBonnesReponses}/${resultat.nombreQuestions} bonnes réponses',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Temps: ${resultat.tempsSecondes} secondes',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### C. Écran de Statistiques (`statistiques_quiz_screen.dart`)

```dart
class StatistiquesQuizScreen extends StatefulWidget {
  @override
  _StatistiquesQuizScreenState createState() => _StatistiquesQuizScreenState();
}

class _StatistiquesQuizScreenState extends State<StatistiquesQuizScreen> {
  final QuizService _quizService = QuizService(
    token: 'VOTRE_JWT_TOKEN',
    langue: 'fr',
  );

  QuizStatistiqueResponse? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _chargerStatistiques();
  }

  Future<void> _chargerStatistiques() async {
    final stats = await _quizService.obtenirStatistiques();
    setState(() {
      _stats = stats;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Statistiques')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_stats == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Statistiques')),
        body: Center(child: Text('Aucune statistique disponible')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Mes Statistiques')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildStatCard('Points totaux', '${_stats!.totalPoints}'),
          _buildStatCard('Quiz complétés', '${_stats!.totalQuizCompletes}'),
          _buildStatCard('Streak actuel', '${_stats!.streakJours} jours'),
          _buildStatCard('Meilleur streak', '${_stats!.meilleurStreak} jours'),
          if (_stats!.badgeExpert!)
            _buildBadgeCard('🏆 Expert', 'Vous avez débloqué le badge Expert!'),
          if (_stats!.badgeStreakMaster!)
            _buildBadgeCard('🔥 Streak Master', 'Vous avez débloqué le badge Streak Master!'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBadgeCard(String titre, String description) {
    return Card(
      color: Colors.amber[100],
      child: ListTile(
        title: Text(titre, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
```

#### D. Écran de Classement (`classement_quiz_screen.dart`)

```dart
class ClassementQuizScreen extends StatefulWidget {
  @override
  _ClassementQuizScreenState createState() => _ClassementQuizScreenState();
}

class _ClassementQuizScreenState extends State<ClassementQuizScreen> {
  final QuizService _quizService = QuizService(
    token: 'VOTRE_JWT_TOKEN',
    langue: 'fr',
  );

  ClassementResponse? _classementHebdo;
  ClassementResponse? _classementMensuel;
  bool _loading = true;
  bool _showHebdo = true;

  @override
  void initState() {
    super.initState();
    _chargerClassements();
  }

  Future<void> _chargerClassements() async {
    final hebdo = await _quizService.obtenirClassementHebdomadaire();
    final mensuel = await _quizService.obtenirClassementMensuel();
    setState(() {
      _classementHebdo = hebdo;
      _classementMensuel = mensuel;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Classement')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final classement = _showHebdo ? _classementHebdo : _classementMensuel;

    return Scaffold(
      appBar: AppBar(title: Text('Classement')),
      body: Column(
        children: [
          // Toggle hebdo/mensuel
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _showHebdo = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showHebdo ? Colors.blue : null,
                  ),
                  child: Text('Hebdomadaire'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _showHebdo = false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_showHebdo ? Colors.blue : null,
                  ),
                  child: Text('Mensuel'),
                ),
              ),
            ],
          ),
          
          // Liste du classement
          Expanded(
            child: ListView.builder(
              itemCount: classement?.classement?.length ?? 0,
              itemBuilder: (context, index) {
                final stat = classement!.classement![index];
                final position = index + 1;
                
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('$position'),
                    backgroundColor: position <= 3 ? Colors.amber : Colors.grey,
                  ),
                  title: Text('${stat.citoyenNom} ${stat.citoyenPrenom}'),
                  subtitle: Text('${stat.totalPoints} points'),
                  trailing: Text('Streak: ${stat.streakJours}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 🖥️ ANGULAR - Application Admin

**IMPORTANT** : Les endpoints admin sont protégés par `@PreAuthorize("hasRole('ADMIN')")`. Assurez-vous que votre token JWT contient le rôle ADMIN.

### 1. **Modèles TypeScript**

Créez `src/app/models/quiz.models.ts` :

```typescript
export interface QuizJournalierResponse {
  id?: number;
  dateQuiz?: string;
  procedureId?: number;
  procedureNom?: string;
  categorieId?: number;
  categorieTitre?: string;
  estActif?: boolean;
  questions?: QuizQuestionResponse[];
}

export interface QuizQuestionResponse {
  id?: number;
  questionFr?: string;
  questionEn?: string;
  typeQuestion?: string;
  procedureId?: number;
  reponseCorrecte?: string;
  points?: number;
  niveau?: string;
  reponses?: QuizReponseResponse[];
}

export interface QuizReponseResponse {
  id?: number;
  reponseFr?: string;
  reponseEn?: string;
  estCorrecte?: boolean;
  ordre?: number;
}

export interface QuizStatistiqueResponse {
  citoyenId?: number;
  citoyenNom?: string;
  citoyenPrenom?: string;
  totalPoints?: number;
  totalQuizCompletes?: number;
  streakJours?: number;
  meilleurStreak?: number;
  derniereParticipation?: string;
  badgeExpert?: boolean;
  badgeStreakMaster?: boolean;
  positionClassement?: number;
}

export interface ClassementResponse {
  periode?: string;
  classement?: QuizStatistiqueResponse[];
  positionUtilisateur?: number;
}
```

### 2. **Service Angular Admin**

Créez `src/app/services/admin-quiz.service.ts` :

```typescript
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { QuizJournalierResponse } from '../models/quiz.models';

@Injectable({
  providedIn: 'root'
})
export class AdminQuizService {
  private apiUrl = `${environment.apiUrl}/admin/quiz/journaliers`;

  constructor(private http: HttpClient) {}

  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('token');
    const langue = localStorage.getItem('langue') || 'fr';
    return new HttpHeaders({
      'Content-Type': 'application/json',
      'Accept-Language': langue,
      'Authorization': `Bearer ${token}`
    });
  }

  // 1. Créer un quiz ✅ NOUVEAU
  creerQuiz(dateQuiz?: string): Observable<QuizJournalierResponse> {
    const body = dateQuiz ? { dateQuiz } : {};
    return this.http.post<QuizJournalierResponse>(
      this.apiUrl,
      body,
      { headers: this.getHeaders() }
    );
  }

  // 2. Lister tous les quiz
  listerTousLesQuiz(): Observable<QuizJournalierResponse[]> {
    return this.http.get<QuizJournalierResponse[]>(
      this.apiUrl,
      { headers: this.getHeaders() }
    );
  }

  // 3. Récupérer un quiz par ID
  obtenirQuizParId(id: number): Observable<QuizJournalierResponse> {
    return this.http.get<QuizJournalierResponse>(
      `${this.apiUrl}/${id}`,
      { headers: this.getHeaders() }
    );
  }

  // 4. Modifier un quiz ✅ NOUVEAU
  modifierQuiz(id: number, quiz: Partial<QuizJournalierResponse>): Observable<QuizJournalierResponse> {
    return this.http.put<QuizJournalierResponse>(
      `${this.apiUrl}/${id}`,
      quiz,
      { headers: this.getHeaders() }
    );
  }

  // 5. Activer/Désactiver un quiz
  toggleStatutQuiz(id: number, actif: boolean = true): Observable<any> {
    return this.http.put(
      `${this.apiUrl}/${id}/actif?actif=${actif}`,
      {},
      { headers: this.getHeaders() }
    );
  }

  // 6. Supprimer un quiz ✅ NOUVEAU
  supprimerQuiz(id: number): Observable<any> {
    return this.http.delete(
      `${this.apiUrl}/${id}`,
      { headers: this.getHeaders() }
    );
  }
}
```

### 3. **Composant de Gestion des Quiz (Admin)**

Créez `src/app/components/quiz-management/quiz-management.component.ts` :

```typescript
import { Component, OnInit } from '@angular/core';
import { AdminQuizService } from '../../services/admin-quiz.service';
import { QuizJournalierResponse } from '../../models/quiz.models';

@Component({
  selector: 'app-quiz-management',
  templateUrl: './quiz-management.component.html',
  styleUrls: ['./quiz-management.component.css']
})
export class QuizManagementComponent implements OnInit {
  quizList: QuizJournalierResponse[] = [];
  selectedQuiz?: QuizJournalierResponse;
  loading = false;
  showCreateModal = false;
  showEditModal = false;
  showDeleteModal = false;

  constructor(private adminQuizService: AdminQuizService) {}

  ngOnInit(): void {
    this.chargerQuizList();
  }

  chargerQuizList(): void {
    this.loading = true;
    this.adminQuizService.listerTousLesQuiz().subscribe({
      next: (quiz) => {
        this.quizList = quiz;
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur:', err);
        this.loading = false;
      }
    });
  }

  creerQuiz(dateQuiz?: string): void {
    this.loading = true;
    this.adminQuizService.creerQuiz(dateQuiz).subscribe({
      next: () => {
        this.showCreateModal = false;
        this.chargerQuizList();
      },
      error: (err) => {
        console.error('Erreur création:', err);
        this.loading = false;
      }
    });
  }

  ouvrirModalModification(quiz: QuizJournalierResponse): void {
    this.selectedQuiz = quiz;
    this.showEditModal = true;
  }

  modifierQuiz(quiz: Partial<QuizJournalierResponse>): void {
    if (!this.selectedQuiz?.id) return;
    
    this.loading = true;
    this.adminQuizService.modifierQuiz(this.selectedQuiz.id, quiz).subscribe({
      next: () => {
        this.showEditModal = false;
        this.chargerQuizList();
      },
      error: (err) => {
        console.error('Erreur modification:', err);
        this.loading = false;
      }
    });
  }

  ouvrirModalSuppression(quiz: QuizJournalierResponse): void {
    this.selectedQuiz = quiz;
    this.showDeleteModal = true;
  }

  supprimerQuiz(): void {
    if (!this.selectedQuiz?.id) return;
    
    this.loading = true;
    this.adminQuizService.supprimerQuiz(this.selectedQuiz.id).subscribe({
      next: () => {
        this.showDeleteModal = false;
        this.chargerQuizList();
      },
      error: (err) => {
        console.error('Erreur suppression:', err);
        this.loading = false;
      }
    });
  }

  toggleActif(quiz: QuizJournalierResponse): void {
    if (!quiz.id) return;
    
    this.adminQuizService.toggleStatutQuiz(quiz.id, !quiz.estActif).subscribe({
      next: () => {
        quiz.estActif = !quiz.estActif;
      },
      error: (err) => {
        console.error('Erreur toggle statut:', err);
      }
    });
  }
}
```

#### Template HTML (`quiz-management.component.html`) :

```html
<div class="container mt-4">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Gestion des Quiz</h2>
    <button class="btn btn-primary" (click)="showCreateModal = true">
      + Créer un Quiz
    </button>
  </div>

  <div *ngIf="loading" class="text-center">
    <div class="spinner-border" role="status"></div>
  </div>

  <table class="table table-striped" *ngIf="!loading">
    <thead>
      <tr>
        <th>ID</th>
        <th>Date Quiz</th>
        <th>Procédure</th>
        <th>Catégorie</th>
        <th>Statut</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <tr *ngFor="let quiz of quizList">
        <td>{{ quiz.id }}</td>
        <td>{{ quiz.dateQuiz }}</td>
        <td>{{ quiz.procedureNom }}</td>
        <td>{{ quiz.categorieTitre }}</td>
        <td>
          <span class="badge" [class.bg-success]="quiz.estActif" [class.bg-danger]="!quiz.estActif">
            {{ quiz.estActif ? 'Actif' : 'Inactif' }}
          </span>
        </td>
        <td>
          <button class="btn btn-sm btn-info me-2" (click)="ouvrirModalModification(quiz)">
            Modifier
          </button>
          <button class="btn btn-sm btn-warning me-2" (click)="toggleActif(quiz)">
            {{ quiz.estActif ? 'Désactiver' : 'Activer' }}
          </button>
          <button class="btn btn-sm btn-danger" (click)="ouvrirModalSuppression(quiz)">
            Supprimer
          </button>
        </td>
      </tr>
    </tbody>
  </table>
</div>

<!-- Modal Création -->
<div class="modal" [class.show]="showCreateModal">
  <!-- Implémentez le modal de création -->
</div>

<!-- Modal Modification -->
<div class="modal" [class.show]="showEditModal">
  <!-- Implémentez le modal de modification -->
</div>

<!-- Modal Suppression -->
<div class="modal" [class.show]="showDeleteModal">
  <!-- Implémentez le modal de confirmation de suppression -->
</div>
```

### 4. **Composants Angular à Créer**

#### A. Dashboard Quiz (`quiz-dashboard.component.ts`)

```typescript
import { Component, OnInit } from '@angular/core';
import { QuizService } from '../services/quiz.service';
import { ClassementResponse, QuizStatistiqueResponse } from '../models/quiz.models';

@Component({
  selector: 'app-quiz-dashboard',
  templateUrl: './quiz-dashboard.component.html',
  styleUrls: ['./quiz-dashboard.component.css']
})
export class QuizDashboardComponent implements OnInit {
  classementHebdo?: ClassementResponse;
  classementMensuel?: ClassementResponse;
  loading = true;

  constructor(private quizService: QuizService) {}

  ngOnInit(): void {
    this.chargerClassements();
  }

  chargerClassements(): void {
    this.loading = true;
    
    this.quizService.obtenirClassementHebdomadaire().subscribe({
      next: (data) => {
        this.classementHebdo = data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur:', err);
        this.loading = false;
      }
    });

    this.quizService.obtenirClassementMensuel().subscribe({
      next: (data) => {
        this.classementMensuel = data;
      },
      error: (err) => {
        console.error('Erreur:', err);
      }
    });
  }
}
```

#### B. Template HTML (`quiz-dashboard.component.html`)

```html
<div class="container mt-4">
  <h2>Dashboard Quiz</h2>

  <div *ngIf="loading" class="text-center">
    <div class="spinner-border" role="status">
      <span class="visually-hidden">Chargement...</span>
    </div>
  </div>

  <div *ngIf="!loading" class="row">
    <!-- Classement Hebdomadaire -->
    <div class="col-md-6">
      <div class="card">
        <div class="card-header">
          <h5>Classement Hebdomadaire</h5>
        </div>
        <div class="card-body">
          <table class="table">
            <thead>
              <tr>
                <th>Position</th>
                <th>Nom</th>
                <th>Points</th>
                <th>Streak</th>
              </tr>
            </thead>
            <tbody>
              <tr *ngFor="let stat of classementHebdo?.classement; let i = index">
                <td>{{ i + 1 }}</td>
                <td>{{ stat.citoyenNom }} {{ stat.citoyenPrenom }}</td>
                <td>{{ stat.totalPoints }}</td>
                <td>{{ stat.streakJours }} jours</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Classement Mensuel -->
    <div class="col-md-6">
      <div class="card">
        <div class="card-header">
          <h5>Classement Mensuel</h5>
        </div>
        <div class="card-body">
          <table class="table">
            <thead>
              <tr>
                <th>Position</th>
                <th>Nom</th>
                <th>Points</th>
                <th>Streak</th>
              </tr>
            </thead>
            <tbody>
              <tr *ngFor="let stat of classementMensuel?.classement; let i = index">
                <td>{{ i + 1 }}</td>
                <td>{{ stat.citoyenNom }} {{ stat.citoyenPrenom }}</td>
                <td>{{ stat.totalPoints }}</td>
                <td>{{ stat.streakJours }} jours</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
```

### 4. **Routes Angular**

Ajoutez dans `app-routing.module.ts` :

```typescript
import { QuizDashboardComponent } from './components/quiz-dashboard/quiz-dashboard.component';

const routes: Routes = [
  // ... autres routes
  {
    path: 'admin/quiz',
    component: QuizDashboardComponent,
    canActivate: [AuthGuard] // Si vous avez un guard d'authentification
  }
];
```

---

## 📋 Checklist d'Intégration

### Flutter (Utilisateur)
- [ ] Créer les modèles de données (Models)
- [ ] Créer le service API (QuizService)
- [ ] Créer l'écran principal du quiz
- [ ] Créer l'écran de résultat
- [ ] Créer l'écran de statistiques
- [ ] Créer l'écran de classement
- [ ] Ajouter la navigation vers les écrans quiz
- [ ] Gérer l'authentification JWT
- [ ] Gérer la langue (FR/EN)
- [ ] Tester tous les endpoints

### Angular (Admin)
- [ ] Créer les modèles TypeScript
- [ ] Créer le service QuizService (admin)
- [ ] Créer le composant dashboard
- [ ] Créer le composant de gestion des quiz (liste, créer, modifier, supprimer)
- [ ] Créer le template HTML
- [ ] Ajouter les routes
- [ ] Gérer l'authentification JWT
- [ ] Tester tous les endpoints admin (créer, modifier, supprimer)

---

## 🎯 Points Importants

1. **Authentification** : Tous les endpoints nécessitent un JWT token
2. **Langue** : Utilisez le header `Accept-Language: fr` ou `en`
3. **Base URL** : Ajustez selon votre configuration (`http://localhost:8080/api` ou votre URL de production)
4. **Gestion d'erreurs** : Implémentez une gestion d'erreurs appropriée
5. **Loading states** : Affichez des indicateurs de chargement
6. **Validation** : Validez les réponses avant soumission

---

## 🚀 Prochaines Étapes

1. **Tester les endpoints** avec Postman/Swagger
2. **Implémenter les modèles** dans Flutter et Angular
3. **Créer les écrans/composants**
4. **Intégrer avec l'authentification existante**
5. **Tester l'ensemble du flux**

Le système est prêt côté backend ! 🎉

