// ============================================
// CODE ANGULAR COMPLET - Gestion Admin des Procédures
// ============================================
// Copiez ce code dans vos fichiers Angular
// ============================================

// ============================================
// 1. MODÈLE PROCEDURE
// ============================================
// src/app/models/procedure.model.ts

export interface Procedure {
  id?: number;
  nom: string;
  nomEn?: string;
  nomBm?: string;
  titre: string;
  titreEn?: string;
  titreBm?: string;
  description: string;
  descriptionEn?: string;
  descriptionBm?: string;
  delai: string;
  delaiEn?: string;
  delaiBm?: string;
  urlVersFormulaire?: string;
  audioUrl?: string;
  peutEtreDelegatee?: boolean; // ⚠️ IMPORTANT pour la délégation
  categorieId: number;
  sousCategorieId?: number;
  coutId?: number;
  centreId?: number;
  dateCreation?: Date;
  dateModification?: Date;
}

export interface Categorie {
  id: number;
  titre: string;
  description?: string;
}

export interface SousCategorie {
  id: number;
  titre: string;
  categorieId: number;
}

export interface ProcedureResponse {
  success: boolean;
  message?: string;
  data?: Procedure;
}

// ============================================
// 2. SERVICE PROCEDURE
// ============================================
// src/app/services/procedure.service.ts

import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Procedure, ProcedureResponse } from '../models/procedure.model';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ProcedureService {
  private apiUrl = `${environment.apiUrl}/procedures`;

  constructor(private http: HttpClient) {}

  obtenirToutesLesProcedures(): Observable<Procedure[]> {
    return this.http.get<Procedure[]>(this.apiUrl);
  }

  obtenirProcedureParId(id: number): Observable<Procedure> {
    return this.http.get<Procedure>(`${this.apiUrl}/${id}`);
  }

  creerProcedure(procedure: Procedure): Observable<ProcedureResponse> {
    return this.http.post<ProcedureResponse>(this.apiUrl, procedure);
  }

  mettreAJourProcedure(id: number, procedure: Procedure): Observable<ProcedureResponse> {
    return this.http.put<ProcedureResponse>(`${this.apiUrl}/${id}`, procedure);
  }

  supprimerProcedure(id: number): Observable<ProcedureResponse> {
    return this.http.delete<ProcedureResponse>(`${this.apiUrl}/${id}`);
  }

  activerDelegation(id: number, peutEtreDelegatee: boolean): Observable<ProcedureResponse> {
    return this.http.patch<ProcedureResponse>(
      `${this.apiUrl}/${id}/delegation`,
      { peutEtreDelegatee }
    );
  }

  rechercherProcedures(terme: string): Observable<Procedure[]> {
    const params = new HttpParams().set('recherche', terme);
    return this.http.get<Procedure[]>(`${this.apiUrl}/recherche`, { params });
  }
}

// ============================================
// 3. SERVICE CATÉGORIE
// ============================================
// src/app/services/category.service.ts

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Categorie, SousCategorie } from '../models/procedure.model';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class CategoryService {
  private apiUrl = `${environment.apiUrl}/categories`;

  constructor(private http: HttpClient) {}

  obtenirToutesLesCategories(): Observable<Categorie[]> {
    return this.http.get<Categorie[]>(this.apiUrl);
  }

  obtenirSousCategories(categorieId: number): Observable<SousCategorie[]> {
    return this.http.get<SousCategorie[]>(`${this.apiUrl}/${categorieId}/sous-categories`);
  }
}

// ============================================
// 4. COMPOSANT LISTE DES PROCÉDURES
// ============================================
// src/app/admin/procedures/procedures-list/procedures-list.component.ts

import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Procedure } from '../../../models/procedure.model';
import { ProcedureService } from '../../../services/procedure.service';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ConfirmationDialogComponent } from '../../../shared/confirmation-dialog/confirmation-dialog.component';

@Component({
  selector: 'app-procedures-list',
  templateUrl: './procedures-list.component.html',
  styleUrls: ['./procedures-list.component.scss']
})
export class ProceduresListComponent implements OnInit {
  procedures: Procedure[] = [];
  proceduresFiltrees: Procedure[] = [];
  isLoading = false;
  rechercheTerme = '';

  constructor(
    private procedureService: ProcedureService,
    private router: Router,
    private dialog: MatDialog,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.chargerProcedures();
  }

  chargerProcedures(): void {
    this.isLoading = true;
    this.procedureService.obtenirToutesLesProcedures().subscribe({
      next: (procedures) => {
        this.procedures = procedures;
        this.proceduresFiltrees = procedures;
        this.isLoading = false;
      },
      error: (error) => {
        console.error('Erreur:', error);
        this.snackBar.open('Erreur lors du chargement', 'Fermer', { duration: 3000 });
        this.isLoading = false;
      }
    });
  }

  filtrerProcedures(): void {
    if (!this.rechercheTerme.trim()) {
      this.proceduresFiltrees = this.procedures;
      return;
    }

    const terme = this.rechercheTerme.toLowerCase();
    this.proceduresFiltrees = this.procedures.filter(p =>
      p.nom.toLowerCase().includes(terme) ||
      p.titre.toLowerCase().includes(terme) ||
      p.description?.toLowerCase().includes(terme)
    );
  }

  ajouterProcedure(): void {
    this.router.navigate(['/admin/procedures/nouveau']);
  }

  modifierProcedure(id: number): void {
    this.router.navigate(['/admin/procedures/modifier', id]);
  }

  voirDetails(id: number): void {
    this.router.navigate(['/admin/procedures', id]);
  }

  supprimerProcedure(procedure: Procedure): void {
    const dialogRef = this.dialog.open(ConfirmationDialogComponent, {
      width: '400px',
      data: {
        titre: 'Confirmer la suppression',
        message: `Êtes-vous sûr de vouloir supprimer "${procedure.nom}" ?`,
        boutonConfirmer: 'Supprimer',
        boutonAnnuler: 'Annuler'
      }
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result && procedure.id) {
        this.procedureService.supprimerProcedure(procedure.id).subscribe({
          next: () => {
            this.snackBar.open('Procédure supprimée avec succès', 'Fermer', { duration: 3000 });
            this.chargerProcedures();
          },
          error: (error) => {
            console.error('Erreur:', error);
            this.snackBar.open('Erreur lors de la suppression', 'Fermer', { duration: 3000 });
          }
        });
      }
    });
  }

  toggleDelegation(procedure: Procedure): void {
    if (!procedure.id) return;

    const nouvelleValeur = !procedure.peutEtreDelegatee;
    const message = nouvelleValeur
      ? 'Activer la délégation pour cette procédure ?'
      : 'Désactiver la délégation pour cette procédure ?';

    const dialogRef = this.dialog.open(ConfirmationDialogComponent, {
      width: '400px',
      data: {
        titre: 'Confirmer',
        message: message,
        boutonConfirmer: 'Confirmer',
        boutonAnnuler: 'Annuler'
      }
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.procedureService.activerDelegation(procedure.id!, nouvelleValeur).subscribe({
          next: () => {
            procedure.peutEtreDelegatee = nouvelleValeur;
            this.snackBar.open(
              nouvelleValeur ? 'Délégation activée' : 'Délégation désactivée',
              'Fermer',
              { duration: 3000 }
            );
          },
          error: (error) => {
            console.error('Erreur:', error);
            this.snackBar.open('Erreur lors de la modification', 'Fermer', { duration: 3000 });
          }
        });
      }
    });
  }
}

// ============================================
// 5. COMPOSANT FORMULAIRE
// ============================================
// src/app/admin/procedures/procedure-form/procedure-form.component.ts

import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Procedure, Categorie, SousCategorie } from '../../../models/procedure.model';
import { ProcedureService } from '../../../services/procedure.service';
import { CategoryService } from '../../../services/category.service';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-procedure-form',
  templateUrl: './procedure-form.component.html',
  styleUrls: ['./procedure-form.component.scss']
})
export class ProcedureFormComponent implements OnInit {
  procedureForm: FormGroup;
  isEditMode = false;
  procedureId?: number;
  categories: Categorie[] = [];
  sousCategories: SousCategorie[] = [];
  isLoading = false;

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private procedureService: ProcedureService,
    private categoryService: CategoryService,
    private snackBar: MatSnackBar
  ) {
    this.procedureForm = this.creerFormulaire();
  }

  ngOnInit(): void {
    this.chargerCategories();

    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEditMode = true;
      this.procedureId = +id;
      this.chargerProcedure(this.procedureId);
    }
  }

  creerFormulaire(): FormGroup {
    return this.fb.group({
      nom: ['', [Validators.required, Validators.maxLength(200)]],
      nomEn: [''],
      nomBm: [''],
      titre: ['', [Validators.required, Validators.maxLength(100)]],
      titreEn: [''],
      titreBm: [''],
      description: ['', [Validators.required]],
      descriptionEn: [''],
      descriptionBm: [''],
      delai: ['', [Validators.required, Validators.maxLength(500)]],
      delaiEn: [''],
      delaiBm: [''],
      urlVersFormulaire: [''],
      audioUrl: [''],
      peutEtreDelegatee: [false], // ⚠️ Checkbox délégation
      categorieId: ['', [Validators.required]],
      sousCategorieId: [''],
      coutId: [''],
      centreId: ['']
    });
  }

  chargerCategories(): void {
    this.categoryService.obtenirToutesLesCategories().subscribe({
      next: (categories) => {
        this.categories = categories;
      },
      error: (error) => {
        console.error('Erreur:', error);
      }
    });
  }

  onCategorieChange(): void {
    const categorieId = this.procedureForm.get('categorieId')?.value;
    if (categorieId) {
      this.categoryService.obtenirSousCategories(categorieId).subscribe({
        next: (sousCategories) => {
          this.sousCategories = sousCategories;
          this.procedureForm.patchValue({ sousCategorieId: '' });
        },
        error: (error) => {
          console.error('Erreur:', error);
        }
      });
    } else {
      this.sousCategories = [];
    }
  }

  chargerProcedure(id: number): void {
    this.isLoading = true;
    this.procedureService.obtenirProcedureParId(id).subscribe({
      next: (procedure) => {
        this.procedureForm.patchValue(procedure);
        if (procedure.categorieId) {
          this.onCategorieChange();
        }
        this.isLoading = false;
      },
      error: (error) => {
        console.error('Erreur:', error);
        this.snackBar.open('Erreur lors du chargement', 'Fermer', { duration: 3000 });
        this.isLoading = false;
      }
    });
  }

  soumettreFormulaire(): void {
    if (this.procedureForm.invalid) {
      this.snackBar.open('Veuillez remplir tous les champs obligatoires', 'Fermer', {
        duration: 3000
      });
      return;
    }

    this.isLoading = true;
    const procedureData = this.procedureForm.value;

    if (this.isEditMode && this.procedureId) {
      this.procedureService.mettreAJourProcedure(this.procedureId, procedureData).subscribe({
        next: () => {
          this.snackBar.open('Procédure modifiée avec succès', 'Fermer', { duration: 3000 });
          this.router.navigate(['/admin/procedures']);
        },
        error: (error) => {
          console.error('Erreur:', error);
          this.snackBar.open('Erreur lors de la modification', 'Fermer', { duration: 3000 });
          this.isLoading = false;
        }
      });
    } else {
      this.procedureService.creerProcedure(procedureData).subscribe({
        next: () => {
          this.snackBar.open('Procédure créée avec succès', 'Fermer', { duration: 3000 });
          this.router.navigate(['/admin/procedures']);
        },
        error: (error) => {
          console.error('Erreur:', error);
          this.snackBar.open('Erreur lors de la création', 'Fermer', { duration: 3000 });
          this.isLoading = false;
        }
      });
    }
  }

  annuler(): void {
    this.router.navigate(['/admin/procedures']);
  }
}

// ============================================
// 6. COMPOSANT DE CONFIRMATION
// ============================================
// src/app/shared/confirmation-dialog/confirmation-dialog.component.ts

import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

export interface ConfirmationDialogData {
  titre: string;
  message: string;
  boutonConfirmer?: string;
  boutonAnnuler?: string;
}

@Component({
  selector: 'app-confirmation-dialog',
  templateUrl: './confirmation-dialog.component.html'
})
export class ConfirmationDialogComponent {
  constructor(
    public dialogRef: MatDialogRef<ConfirmationDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: ConfirmationDialogData
  ) {}

  onAnnuler(): void {
    this.dialogRef.close(false);
  }

  onConfirmer(): void {
    this.dialogRef.close(true);
  }
}

// ============================================
// 7. GUARD ADMIN
// ============================================
// src/app/guards/admin.guard.ts

import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

@Injectable({
  providedIn: 'root'
})
export class AdminGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  canActivate(): boolean {
    if (this.authService.estAdmin()) {
      return true;
    } else {
      this.router.navigate(['/']);
      return false;
    }
  }
}

// ============================================
// 8. ROUTES
// ============================================
// src/app/app-routing.module.ts

import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from './guards/auth.guard';
import { AdminGuard } from './guards/admin.guard';
import { ProceduresListComponent } from './admin/procedures/procedures-list/procedures-list.component';
import { ProcedureFormComponent } from './admin/procedures/procedure-form/procedure-form.component';

const routes: Routes = [
  {
    path: 'admin/procedures',
    canActivate: [AuthGuard, AdminGuard],
    children: [
      { path: '', component: ProceduresListComponent },
      { path: 'nouveau', component: ProcedureFormComponent },
      { path: 'modifier/:id', component: ProcedureFormComponent }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }

// ============================================
// FIN DU CODE
// ============================================

