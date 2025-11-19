// ============================================
// CODE FLUTTER COMPLET - Délégation de Procédures
// ============================================
// Copiez ce code dans vos fichiers Flutter
// ============================================

// ============================================
// 1. MODÈLE PROCEDURE (mettre à jour)
// ============================================
// lib/models/procedure.dart

class Procedure {
  final int id;
  final String nom;
  final String titre;
  final String description;
  final bool peutEtreDelegatee; // ⚠️ NOUVEAU CHAMP

  Procedure({
    required this.id,
    required this.nom,
    required this.titre,
    required this.description,
    this.peutEtreDelegatee = false, // ⚠️ Par défaut false
  });

  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure(
      id: json['id'],
      nom: json['nom'],
      titre: json['titre'],
      description: json['description'] ?? '',
      peutEtreDelegatee: json['peutEtreDelegatee'] ?? false, // ⚠️ IMPORTANT
    );
  }
}

// ============================================
// 2. MODÈLES DE DÉLÉGATION
// ============================================
// lib/models/delegation_models.dart

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
      tarifDelegation: (json['tarifDelegation'] as num).toDouble(),
      coutLegal: json['coutLegal'] != null 
          ? (json['coutLegal'] as num).toDouble() 
          : null,
      tarifTotal: (json['tarifTotal'] as num).toDouble(),
      commune: json['commune'],
      description: json['description'] ?? '',
      delaiEstime: json['delaiEstime'] ?? '',
    );
  }
}

class DemandeDelegation {
  final int id;
  final ProcedureSimple procedure;
  final String statut;
  final double tarif;
  final String commune;
  final DateTime dateCreation;

  DemandeDelegation({
    required this.id,
    required this.procedure,
    required this.statut,
    required this.tarif,
    required this.commune,
    required this.dateCreation,
  });

  factory DemandeDelegation.fromJson(Map<String, dynamic> json) {
    return DemandeDelegation(
      id: json['id'],
      procedure: ProcedureSimple.fromJson(json['procedure']),
      statut: json['statut'],
      tarif: (json['tarif'] as num).toDouble(),
      commune: json['commune'],
      dateCreation: DateTime.parse(json['dateCreation']),
    );
  }
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

// ============================================
// 3. SERVICE DE DÉLÉGATION
// ============================================
// lib/services/delegation_service.dart

import 'package:dio/dio.dart';
import '../models/delegation_models.dart';

class DelegationService {
  final Dio dio;
  final String baseUrl;

  DelegationService({required this.dio, required this.baseUrl});

  /// Récupère le tarif de délégation
  Future<TarifDelegation> obtenirTarif({
    required int procedureId,
    required String commune,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/delegations/procedures/$procedureId/tarif',
        queryParameters: {'commune': commune},
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

  /// Crée une demande de délégation
  Future<DemandeDelegation> creerDemande({
    required int procedureId,
    required String commune,
    String? quartier,
    String? adresseComplete,
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
          'adresseComplete': adresseComplete,
          'telephoneContact': telephoneContact,
          'dateSouhaitee': dateSouhaitee?.toIso8601String().split('T')[0],
          'commentaires': commentaires,
          'accepteTarif': true,
        },
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

  /// Récupère les demandes de l'utilisateur
  Future<List<DemandeDelegation>> obtenirMesDemandes() async {
    try {
      final response = await dio.get('$baseUrl/delegations/mes-demandes');
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => DemandeDelegation.fromJson(json))
            .toList();
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
}

// ============================================
// 4. CARTE PROCÉDURE AVEC ICÔNE
// ============================================
// lib/widgets/procedure_card.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/procedure.dart';

class ProcedureCard extends StatelessWidget {
  final Procedure procedure;
  final VoidCallback? onTap;
  final VoidCallback? onDelegationTap;

  const ProcedureCard({
    Key? key,
    required this.procedure,
    this.onTap,
    this.onDelegationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec icône de délégation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      procedure.titre,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // ⚠️ ICÔNE DE DÉLÉGATION (seulement si peutEtreDelegatee = true)
                  if (procedure.peutEtreDelegatee)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.motorcycle, // 🏍️ Icône livreur sur moto
                          color: Colors.orange[700],
                          size: 24,
                        ),
                        tooltip: "Faire à ma place",
                        onPressed: onDelegationTap,
                      ),
                    ),
                ],
              ),
              
              SizedBox(height: 8),
              
              Text(
                procedure.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// 5. MODAL DE TARIF
// ============================================
// lib/widgets/tarif_delegation_modal.dart

import 'package:flutter/material.dart';
import '../models/delegation_models.dart';

class TarifDelegationModal extends StatelessWidget {
  final TarifDelegation tarif;
  final VoidCallback onContinuer;
  final VoidCallback onAnnuler;

  const TarifDelegationModal({
    Key? key,
    required this.tarif,
    required this.onContinuer,
    required this.onAnnuler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '💰 Tarif de Délégation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: onAnnuler,
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Nom de la procédure
              Text(
                tarif.procedureNom,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Détails du tarif
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildTarifLigne('Service de délégation', tarif.tarifDelegation),
                    if (tarif.coutLegal != null)
                      _buildTarifLigne('Coût légal', tarif.coutLegal!),
                    Divider(height: 24),
                    _buildTarifLigne('TOTAL', tarif.tarifTotal, isTotal: true),
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              
              // Délai estimé
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    'Délai estimé: ${tarif.delaiEstime}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Services inclus
              Text('✅ Services inclus:', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(
                '• Prise en charge complète\n'
                '• Suivi des démarches\n'
                '• Récupération des documents',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              
              SizedBox(height: 24),
              
              // Boutons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onAnnuler,
                      child: Text('Annuler'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onContinuer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text('Continuer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTarifLigne(String label, double montant, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${montant.toStringAsFixed(0)} FCFA',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.orange[700] : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// 6. FORMULAIRE DE DEMANDE
// ============================================
// lib/widgets/formulaire_delegation.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/delegation_models.dart';
import '../services/delegation_service.dart';

class FormulaireDelegation extends StatefulWidget {
  final int procedureId;
  final String procedureNom;
  final double tarifTotal;
  final String communeInitiale;
  final DelegationService delegationService;

  const FormulaireDelegation({
    Key? key,
    required this.procedureId,
    required this.procedureNom,
    required this.tarifTotal,
    this.communeInitiale = '',
    required this.delegationService,
  }) : super(key: key);

  @override
  State<FormulaireDelegation> createState() => _FormulaireDelegationState();
}

class _FormulaireDelegationState extends State<FormulaireDelegation> {
  final _formKey = GlobalKey<FormState>();
  
  final _communeController = TextEditingController();
  final _quartierController = TextEditingController();
  final _adresseController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _commentairesController = TextEditingController();
  
  DateTime? _dateSouhaitee;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _communeController.text = widget.communeInitiale;
  }

  @override
  void dispose() {
    _communeController.dispose();
    _quartierController.dispose();
    _adresseController.dispose();
    _telephoneController.dispose();
    _commentairesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _dateSouhaitee = picked;
      });
    }
  }

  Future<void> _soumettreDemande() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final demande = await widget.delegationService.creerDemande(
        procedureId: widget.procedureId,
        commune: _communeController.text.trim(),
        quartier: _quartierController.text.trim().isEmpty 
            ? null 
            : _quartierController.text.trim(),
        adresseComplete: _adresseController.text.trim().isEmpty 
            ? null 
            : _adresseController.text.trim(),
        telephoneContact: _telephoneController.text.trim().isEmpty 
            ? null 
            : _telephoneController.text.trim(),
        dateSouhaitee: _dateSouhaitee,
        commentaires: _commentairesController.text.trim().isEmpty 
            ? null 
            : _commentairesController.text.trim(),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Demande créée avec succès! Numéro: #${demande.id}'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demande de Délégation'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // En-tête avec tarif
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.procedureNom,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tarif: ${widget.tarifTotal.toStringAsFixed(0)} FCFA',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Commune (obligatoire)
            TextFormField(
              controller: _communeController,
              decoration: InputDecoration(
                labelText: 'Commune *',
                hintText: 'Ex: Commune I, Kati, Katibougou, etc.',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La commune est obligatoire';
                }
                return null;
              },
            ),
            
            SizedBox(height: 16),
            
            // Quartier
            TextFormField(
              controller: _quartierController,
              decoration: InputDecoration(
                labelText: 'Quartier',
                hintText: 'Ex: Hamdallaye',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Adresse complète
            TextFormField(
              controller: _adresseController,
              decoration: InputDecoration(
                labelText: 'Adresse complète',
                hintText: 'Ex: Rue 123, Porte 456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.place),
              ),
              maxLines: 2,
            ),
            
            SizedBox(height: 16),
            
            // Téléphone de contact
            TextFormField(
              controller: _telephoneController,
              decoration: InputDecoration(
                labelText: 'Téléphone de contact',
                hintText: '+22370123456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            
            SizedBox(height: 16),
            
            // Date souhaitée
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date souhaitée',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _dateSouhaitee != null
                      ? DateFormat('dd/MM/yyyy').format(_dateSouhaitee!)
                      : 'Sélectionner une date (optionnel)',
                  style: TextStyle(
                    color: _dateSouhaitee != null 
                        ? Colors.black 
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Commentaires
            TextFormField(
              controller: _commentairesController,
              decoration: InputDecoration(
                labelText: 'Commentaires / Instructions spéciales',
                hintText: 'Ex: Besoin urgent pour voyage...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 4,
            ),
            
            SizedBox(height: 32),
            
            // Bouton de soumission
            ElevatedButton(
              onPressed: _isLoading ? null : _soumettreDemande,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Soumettre la demande',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 7. UTILISATION DANS LA PAGE DE LISTE
// ============================================
// lib/pages/procedures_list_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/procedure.dart';
import '../widgets/procedure_card.dart';
import '../widgets/tarif_delegation_modal.dart';
import '../widgets/formulaire_delegation.dart';
import '../services/delegation_service.dart';
import '../services/api_service.dart'; // Votre service API existant

class ProceduresListPage extends StatefulWidget {
  @override
  State<ProceduresListPage> createState() => _ProceduresListPageState();
}

class _ProceduresListPageState extends State<ProceduresListPage> {
  final DelegationService _delegationService = DelegationService(
    dio: ApiService().dio, // Utiliser votre instance Dio configurée
    baseUrl: ApiService().baseUrl,
  );

  List<Procedure> _procedures = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerProcedures();
  }

  Future<void> _chargerProcedures() async {
    try {
      // Charger les procédures depuis votre API
      // final procedures = await apiService.obtenirProcedures();
      // setState(() {
      //   _procedures = procedures;
      //   _isLoading = false;
      // });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _afficherModalTarif(Procedure procedure) async {
    // 1. Demander la commune
    final commune = await _demanderCommune();
    if (commune == null) return;

    try {
      // 2. Récupérer le tarif
      final tarif = await _delegationService.obtenirTarif(
        procedureId: procedure.id,
        commune: commune,
      );

      // 3. Afficher le modal
      if (!mounted) return;
      
      final continuer = await showDialog<bool>(
        context: context,
        builder: (context) => TarifDelegationModal(
          tarif: tarif,
          onContinuer: () => Navigator.of(context).pop(true),
          onAnnuler: () => Navigator.of(context).pop(false),
        ),
      );

      // 4. Si l'utilisateur continue, ouvrir le formulaire
      if (continuer == true && mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FormulaireDelegation(
              procedureId: procedure.id,
              procedureNom: procedure.nom,
              tarifTotal: tarif.tarifTotal,
              communeInitiale: commune,
              delegationService: _delegationService,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erreur: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<String?> _demanderCommune() async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        String commune = '';
        return AlertDialog(
          title: Text('Votre commune'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Commune',
              hintText: 'Ex: Commune I, Kati, Katibougou, etc.',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => commune = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (commune.trim().isNotEmpty) {
                  Navigator.of(context).pop(commune.trim());
                }
              },
              child: Text('Continuer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Procédures')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Procédures Administratives'),
      ),
      body: ListView.builder(
        itemCount: _procedures.length,
        itemBuilder: (context, index) {
          final procedure = _procedures[index];
          
          return ProcedureCard(
            procedure: procedure,
            onTap: () {
              // Naviguer vers la page de détails
              // Navigator.push(...);
            },
            onDelegationTap: procedure.peutEtreDelegatee
                ? () => _afficherModalTarif(procedure)
                : null,
          );
        },
      ),
    );
  }
}

// ============================================
// 8. UTILISATION DANS LA PAGE DE DÉTAILS
// ============================================
// lib/pages/procedure_detail_page.dart

class ProcedureDetailPage extends StatefulWidget {
  final Procedure procedure;

  const ProcedureDetailPage({Key? key, required this.procedure}) 
      : super(key: key);

  @override
  State<ProcedureDetailPage> createState() => _ProcedureDetailPageState();
}

class _ProcedureDetailPageState extends State<ProcedureDetailPage> {
  final DelegationService _delegationService = DelegationService(
    dio: ApiService().dio,
    baseUrl: ApiService().baseUrl,
  );

  Future<void> _afficherModalTarif() async {
    final commune = await _demanderCommune();
    if (commune == null) return;

    try {
      final tarif = await _delegationService.obtenirTarif(
        procedureId: widget.procedure.id,
        commune: commune,
      );

      if (!mounted) return;
      
      final continuer = await showDialog<bool>(
        context: context,
        builder: (context) => TarifDelegationModal(
          tarif: tarif,
          onContinuer: () => Navigator.of(context).pop(true),
          onAnnuler: () => Navigator.of(context).pop(false),
        ),
      );

      if (continuer == true && mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FormulaireDelegation(
              procedureId: widget.procedure.id,
              procedureNom: widget.procedure.nom,
              tarifTotal: tarif.tarifTotal,
              communeInitiale: commune,
              delegationService: _delegationService,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _demanderCommune() async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        String commune = '';
        return AlertDialog(
          title: Text('Votre commune'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Commune',
              hintText: 'Ex: Commune I, Kati, etc.',
            ),
            onChanged: (value) => commune = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (commune.trim().isNotEmpty) {
                  Navigator.of(context).pop(commune.trim());
                }
              },
              child: Text('Continuer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.procedure.titre),
        actions: [
          // ⚠️ ICÔNE DE DÉLÉGATION dans l'AppBar
          if (widget.procedure.peutEtreDelegatee)
            IconButton(
              icon: Icon(
                FontAwesomeIcons.motorcycle,
                color: Colors.orange,
              ),
              tooltip: "Faire à ma place",
              onPressed: _afficherModalTarif,
            ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Contenu de la procédure...
          Text(
            widget.procedure.description,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// ============================================
// FIN DU CODE
// ============================================

