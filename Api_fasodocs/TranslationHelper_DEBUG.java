package ml.fasodocs.backend.service;

import ml.fasodocs.backend.entity.*;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * VERSION DEBUG - Helper pour récupérer les traductions selon la langue courante
 * Cette version inclut des logs pour déboguer les problèmes de traduction
 * 
 * INSTRUCTIONS :
 * 1. Remplacez le contenu de TranslationHelper.java par ce fichier
 * 2. Redémarrez Spring Boot
 * 3. Testez avec Postman en utilisant Accept-Language: en
 * 4. Regardez les logs dans la console
 */
@Component
public class TranslationHelper {

    /**
     * Récupère la langue courante depuis le contexte HTTP
     * @return Code de langue (fr, en, bm) - par défaut 'fr'
     */
    public String getCurrentLanguage() {
        try {
            ServletRequestAttributes attributes = 
                (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            
            if (attributes != null && attributes.getRequest() != null) {
                String acceptLanguage = attributes.getRequest().getHeader("Accept-Language");
                
                // ✅ LOG DEBUG
                System.out.println("🌐 [TranslationHelper] Accept-Language reçu: " + acceptLanguage);
                
                if (acceptLanguage != null) {
                    // Nettoyer et prendre seulement les 2 premiers caractères
                    String lang = acceptLanguage.trim().toLowerCase();
                    
                    // ✅ LOG DEBUG
                    System.out.println("🌐 [TranslationHelper] Langue nettoyée: " + lang);
                    
                    if (lang.startsWith("en")) {
                        System.out.println("✅ [TranslationHelper] Retourne: EN");
                        return "en";
                    }
                    if (lang.startsWith("bm")) {
                        System.out.println("✅ [TranslationHelper] Retourne: BM");
                        return "bm";
                    }
                }
            } else {
                System.out.println("⚠️ [TranslationHelper] Pas de contexte HTTP (attributes est null)");
            }
        } catch (Exception e) {
            // En cas d'erreur, retourner la langue par défaut
            System.err.println("❌ [TranslationHelper] Erreur: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("⚠️ [TranslationHelper] Retourne langue par défaut: FR");
        return "fr"; // Langue par défaut
    }

    /**
     * Récupère le titre traduit d'une catégorie
     */
    public String getTitre(Categorie categorie) {
        if (categorie == null) {
            System.out.println("⚠️ [getTitre] Catégorie est NULL");
            return null;
        }
        
        String lang = getCurrentLanguage();
        System.out.println("📝 [getTitre] Catégorie ID=" + categorie.getId() + " | Langue=" + lang);
        
        switch (lang) {
            case "en":
                String titreEn = categorie.getTitreEn();
                String titreFr = categorie.getTitre();
                System.out.println("📝 [getTitre] titreEn=" + titreEn + " | titreFr=" + titreFr);
                return titreEn != null ? titreEn : titreFr;
            case "bm":
                String titreBm = categorie.getTitreBm();
                System.out.println("📝 [getTitre] titreBm=" + titreBm);
                return titreBm != null ? titreBm : categorie.getTitre();
            default:
                return categorie.getTitre();
        }
    }

    /**
     * Récupère la description traduite d'une catégorie
     */
    public String getDescription(Categorie categorie) {
        if (categorie == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return categorie.getDescriptionEn() != null ? categorie.getDescriptionEn() : categorie.getDescription();
            case "bm":
                return categorie.getDescriptionBm() != null ? categorie.getDescriptionBm() : categorie.getDescription();
            default:
                return categorie.getDescription();
        }
    }

    /**
     * Récupère le titre traduit d'une sous-catégorie
     */
    public String getTitre(SousCategorie sousCategorie) {
        if (sousCategorie == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return sousCategorie.getTitreEn() != null ? sousCategorie.getTitreEn() : sousCategorie.getTitre();
            case "bm":
                return sousCategorie.getTitreBm() != null ? sousCategorie.getTitreBm() : sousCategorie.getTitre();
            default:
                return sousCategorie.getTitre();
        }
    }

    /**
     * Récupère la description traduite d'une sous-catégorie
     */
    public String getDescription(SousCategorie sousCategorie) {
        if (sousCategorie == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return sousCategorie.getDescriptionEn() != null ? sousCategorie.getDescriptionEn() : sousCategorie.getDescription();
            case "bm":
                return sousCategorie.getDescriptionBm() != null ? sousCategorie.getDescriptionBm() : sousCategorie.getDescription();
            default:
                return sousCategorie.getDescription();
        }
    }

    /**
     * Récupère le nom traduit d'une procédure
     */
    public String getNom(Procedure procedure) {
        if (procedure == null) return null;
        
        String lang = getCurrentLanguage();
        System.out.println("📝 [getNom] Procedure ID=" + procedure.getId() + " | Langue=" + lang);
        
        switch (lang) {
            case "en":
                String nomEn = procedure.getNomEn();
                System.out.println("📝 [getNom] nomEn=" + nomEn + " | nomFr=" + procedure.getNom());
                return nomEn != null ? nomEn : procedure.getNom();
            case "bm":
                return procedure.getNomBm() != null ? procedure.getNomBm() : procedure.getNom();
            default:
                return procedure.getNom();
        }
    }

    /**
     * Récupère le titre traduit d'une procédure
     */
    public String getTitre(Procedure procedure) {
        if (procedure == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return procedure.getTitreEn() != null ? procedure.getTitreEn() : procedure.getTitre();
            case "bm":
                return procedure.getTitreBm() != null ? procedure.getTitreBm() : procedure.getTitre();
            default:
                return procedure.getTitre();
        }
    }

    /**
     * Récupère la description traduite d'une procédure
     */
    public String getDescription(Procedure procedure) {
        if (procedure == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return procedure.getDescriptionEn() != null ? procedure.getDescriptionEn() : procedure.getDescription();
            case "bm":
                return procedure.getDescriptionBm() != null ? procedure.getDescriptionBm() : procedure.getDescription();
            default:
                return procedure.getDescription();
        }
    }

    /**
     * Récupère le délai traduit d'une procédure
     */
    public String getDelai(Procedure procedure) {
        if (procedure == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return procedure.getDelaiEn() != null ? procedure.getDelaiEn() : procedure.getDelai();
            case "bm":
                return procedure.getDelaiBm() != null ? procedure.getDelaiBm() : procedure.getDelai();
            default:
                return procedure.getDelai();
        }
    }

    /**
     * Récupère la description traduite d'une étape
     */
    public String getDescription(Etape etape) {
        if (etape == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return etape.getDescriptionEn() != null ? etape.getDescriptionEn() : etape.getDescription();
            case "bm":
                return etape.getDescriptionBm() != null ? etape.getDescriptionBm() : etape.getDescription();
            default:
                return etape.getDescription();
        }
    }

    /**
     * Récupère la description traduite d'un document requis
     */
    public String getDescription(DocumentRequis document) {
        if (document == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return document.getDescriptionEn() != null ? document.getDescriptionEn() : document.getDescription();
            case "bm":
                return document.getDescriptionBm() != null ? document.getDescriptionBm() : document.getDescription();
            default:
                return document.getDescription();
        }
    }
}




















