# 🔧 Guide de Correction Flutter - Quiz avec Niveaux

## 📋 Problèmes Identifiés

1. **Overflow UI** : `Row` déborde de 31 pixels (ligne 124 dans `selection_niveau_quiz_screen.dart`)
2. **Niveau FACILE verrouillé** : Le frontend affiche que FACILE est verrouillé alors qu'il devrait être accessible

---

## ✅ Solution 1 : Corriger l'Overflow (Ligne 124)

### Problème
```dart
Row(  // ← Ligne 124 - déborde de 31 pixels
  children: [
    // Contenu trop large
  ],
)
```

### Solution A : Utiliser `Flexible` ou `Expanded`
```dart
Row(
  children: [
    Flexible(  // ← Ajouter Flexible pour permettre le redimensionnement
      child: Text(
        "Votre texte qui est trop long...",
        overflow: TextOverflow.ellipsis,  // Optionnel : tronquer avec "..."
      ),
    ),
    // Autres widgets
  ],
)
```

### Solution B : Utiliser `SingleChildScrollView` (si le contenu doit être scrollable)
```dart
SingleChildScrollView(
  scrollDirection: Axis.horizontal,  // Scroll horizontal
  child: Row(
    children: [
      // Votre contenu
    ],
  ),
)
```

### Solution C : Utiliser `Wrap` au lieu de `Row` (si le contenu peut passer à la ligne)
```dart
Wrap(  // ← Remplace Row
  spacing: 8.0,  // Espacement horizontal
  runSpacing: 8.0,  // Espacement vertical entre les lignes
  children: [
    // Votre contenu - passera à la ligne automatiquement si nécessaire
  ],
)
```

---

## ✅ Solution 2 : Corriger l'Accès au Niveau FACILE

### Problème
Le frontend vérifie mal si le niveau FACILE est débloqué.

### Solution : Utiliser l'endpoint `/api/quiz/progression`

#### 1. Créer/Modifier le Service API

```dart
// Dans votre QuizService ou ApiService
class QuizService {
  final String baseUrl = 'http://localhost:8080/api/quiz';
  final String? token;

  // Récupérer la progression (niveaux débloqués)
  Future<Map<String, dynamic>?> obtenirProgression() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/progression'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la récupération de la progression: $e');
      return null;
    }
  }

  // Récupérer tous les quiz avec leurs statuts de déblocage
  Future<Map<String, dynamic>?> obtenirTousQuizAujourdhui() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/aujourdhui'),
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': 'fr',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des quiz: $e');
      return null;
    }
  }

  // Récupérer les quiz d'un niveau spécifique (retourne une LISTE maintenant)
  Future<List<dynamic>?> obtenirQuizParNiveau(String niveau) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/aujourdhui/${niveau.toLowerCase()}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': 'fr',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // IMPORTANT: L'endpoint retourne maintenant une LISTE de quiz
        return json.decode(response.body) as List;
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des quiz $niveau: $e');
      return null;
    }
  }
}
```

#### 2. Modifier l'Écran de Sélection de Niveau

```dart
// Dans selection_niveau_quiz_screen.dart

class SelectionNiveauQuizScreen extends StatefulWidget {
  @override
  _SelectionNiveauQuizScreenState createState() => _SelectionNiveauQuizScreenState();
}

class _SelectionNiveauQuizScreenState extends State<SelectionNiveauQuizScreen> {
  final QuizService quizService = QuizService(token: yourToken);
  Map<String, dynamic>? progression;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    chargerProgression();
  }

  Future<void> chargerProgression() async {
    setState(() => isLoading = true);
    
    // Utiliser l'endpoint /progression pour obtenir les niveaux débloqués
    final data = await quizService.obtenirProgression();
    
    setState(() {
      progression = data;
      isLoading = false;
    });
  }

  bool estNiveauDebloque(String niveau) {
    if (progression == null) return false;
    
    // FACILE est toujours débloqué
    if (niveau.toUpperCase() == 'FACILE') {
      return true;
    }
    
    // Vérifier dans la liste des progressions
    final progressions = progression!['progressions'] as List?;
    if (progressions == null) return false;
    
    for (var p in progressions) {
      if (p['niveau'] == niveau.toUpperCase() && p['estDebloque'] == true) {
        return true;
      }
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Sélectionner un Niveau')),
      body: Column(
        children: [
          // Niveau FACILE - TOUJOURS DÉBLOQUÉ
          _buildNiveauCard(
            niveau: 'FACILE',
            estDebloque: true,  // ← Toujours true
            couleur: Colors.green,
          ),
          
          // Niveau MOYEN
          _buildNiveauCard(
            niveau: 'MOYEN',
            estDebloque: estNiveauDebloque('MOYEN'),
            couleur: Colors.orange,
          ),
          
          // Niveau DIFFICILE
          _buildNiveauCard(
            niveau: 'DIFFICILE',
            estDebloque: estNiveauDebloque('DIFFICILE'),
            couleur: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildNiveauCard({
    required String niveau,
    required bool estDebloque,
    required Color couleur,
  }) {
    return Card(
      margin: EdgeInsets.all(16),
      child: ListTile(
        leading: Icon(
          estDebloque ? Icons.lock_open : Icons.lock,
          color: estDebloque ? couleur : Colors.grey,
        ),
        title: Text('Niveau $niveau'),
        subtitle: Text(
          estDebloque 
            ? 'Débloqué - Cliquez pour commencer'
            : 'Verrouillé - Complétez le niveau précédent',
        ),
        trailing: estDebloque 
          ? Icon(Icons.arrow_forward, color: couleur)
          : Icon(Icons.lock, color: Colors.grey),
        onTap: estDebloque 
          ? () => _naviguerVersQuiz(niveau)
          : null,
      ),
    );
  }

  void _naviguerVersQuiz(String niveau) async {
    // Récupérer la LISTE de quiz pour ce niveau
    final quizList = await quizService.obtenirQuizParNiveau(niveau);
    
    if (quizList != null && quizList.isNotEmpty) {
      // Naviguer vers l'écran de quiz avec la liste
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            quizList: quizList,
            niveau: niveau,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aucun quiz disponible pour ce niveau')),
      );
    }
  }
}
```

#### 3. Alternative : Utiliser l'endpoint `/api/quiz/aujourdhui`

```dart
// Cette méthode retourne tous les quiz avec leurs statuts de déblocage
Future<void> chargerQuizAvecStatuts() async {
  final data = await quizService.obtenirTousQuizAujourdhui();
  
  if (data != null) {
    bool facileDebloque = data['facile_debloque'] ?? true;  // ← Toujours true
    bool moyenDebloque = data['moyen_debloque'] ?? false;
    bool difficileDebloque = data['difficile_debloque'] ?? false;
    
    List<String> niveauxDebloques = List<String>.from(data['niveaux_debloques'] ?? ['FACILE']);
    
    // FACILE est toujours dans la liste, même si progression n'existe pas
    // Le backend garantit que FACILE est toujours débloqué
  }
}
```

---

## ✅ Solution 3 : Endpoint de Diagnostic (Optionnel)

Pour déboguer, vous pouvez appeler :

```dart
// Endpoint de diagnostic
Future<Map<String, dynamic>?> diagnosticDeblocage() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/diagnostic/deblocage'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  } catch (e) {
    print('Erreur diagnostic: $e');
  }
  return null;
}
```

**Réponse attendue** :
```json
{
  "citoyenId": 1,
  "citoyenNom": "Diallo",
  "citoyenPrenom": "Amadou",
  "niveaux": {
    "FACILE": {
      "estDebloque": true,
      "raison": "FACILE est toujours débloqué par défaut",
      "progressionExiste": true,
      "quizCompletes": 0
    },
    "MOYEN": {
      "estDebloque": false,
      "progressionExiste": false,
      "raison": "Niveau non débloqué - complétez le niveau précédent"
    }
  },
  "niveauxDebloques": ["FACILE"]
}
```

---

## 📝 Checklist de Correction Flutter

### 1. Corriger l'Overflow
- [ ] Ouvrir `selection_niveau_quiz_screen.dart`
- [ ] Trouver le `Row` à la ligne 124
- [ ] Envelopper les enfants dans `Flexible` ou `Expanded`
- [ ] Ou utiliser `SingleChildScrollView` si scrollable
- [ ] Ou remplacer par `Wrap` si le contenu peut passer à la ligne

### 2. Corriger l'Accès au Niveau FACILE
- [ ] Vérifier que le service API utilise `/api/quiz/progression` ou `/api/quiz/aujourdhui`
- [ ] S'assurer que `FACILE` est toujours considéré comme débloqué (hardcoder `true` si nécessaire)
- [ ] Modifier la logique de vérification pour utiliser les données du backend
- [ ] Tester avec l'endpoint de diagnostic si le problème persiste

### 3. Mettre à Jour les Appels API
- [ ] `GET /api/quiz/aujourdhui/{niveau}` retourne maintenant une **LISTE** (pas un seul objet)
- [ ] Adapter le code Flutter pour gérer une liste de quiz
- [ ] Permettre à l'utilisateur de choisir quel quiz faire parmi les 30 disponibles

---

## 🎯 Code Flutter Recommandé

### Modèle de Données
```dart
class QuizProgression {
  final String niveau;
  final bool estDebloque;
  final int quizCompletes;
  final int meilleurScore;
  final DateTime? dateDeblocage;

  QuizProgression({
    required this.niveau,
    required this.estDebloque,
    required this.quizCompletes,
    required this.meilleurScore,
    this.dateDeblocage,
  });

  factory QuizProgression.fromJson(Map<String, dynamic> json) {
    return QuizProgression(
      niveau: json['niveau'] ?? '',
      estDebloque: json['estDebloque'] ?? false,
      quizCompletes: json['quizCompletes'] ?? 0,
      meilleurScore: json['meilleurScore'] ?? 0,
      dateDeblocage: json['dateDeblocage'] != null 
        ? DateTime.parse(json['dateDeblocage']) 
        : null,
    );
  }
}
```

### Vérification Simple
```dart
// Dans votre écran
bool estNiveauDebloque(String niveau) {
  // FACILE est TOUJOURS débloqué
  if (niveau.toUpperCase() == 'FACILE') {
    return true;  // ← Hardcoder true pour FACILE
  }
  
  // Pour les autres niveaux, vérifier dans la progression
  // ... votre logique existante
}
```

---

## 🚨 Points Importants

1. **FACILE est toujours débloqué** : Le backend garantit que `estNiveauDebloque(userId, "FACILE")` retourne toujours `true`
2. **L'endpoint retourne une LISTE** : `GET /api/quiz/aujourdhui/{niveau}` retourne maintenant `List<QuizJournalierResponse>` (30 quiz)
3. **Création automatique** : Si la progression FACILE n'existe pas, elle sera créée automatiquement lors de la première requête
4. **Overflow UI** : C'est un problème de layout Flutter uniquement, pas lié au backend

---

## ✅ Résumé

**Côté Flutter, vous devez :**

1. ✅ **Corriger l'overflow** : Utiliser `Flexible`, `Expanded`, `SingleChildScrollView` ou `Wrap`
2. ✅ **Hardcoder FACILE comme débloqué** : `if (niveau == 'FACILE') return true;`
3. ✅ **Utiliser l'endpoint `/api/quiz/progression`** pour vérifier les autres niveaux
4. ✅ **Adapter pour gérer une LISTE de quiz** au lieu d'un seul quiz

**Le backend est déjà corrigé** - FACILE sera toujours accessible ! 🎉

