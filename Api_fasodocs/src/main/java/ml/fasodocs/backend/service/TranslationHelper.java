package ml.fasodocs.backend.service;

import ml.fasodocs.backend.entity.*;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * Helper pour récupérer les traductions selon la langue courante
 * Utilise le contexte HTTP pour déterminer la langue via Accept-Language
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
                
                if (acceptLanguage != null) {
                    // Nettoyer et prendre seulement les 2 premiers caractères
                    String lang = acceptLanguage.trim().toLowerCase();
                    if (lang.startsWith("en")) return "en";
                    if (lang.startsWith("bm")) return "bm";
                }
            }
        } catch (Exception e) {
            // En cas d'erreur, retourner la langue par défaut
        }
        
        return "fr"; // Langue par défaut
    }

    /**
     * Récupère le titre traduit d'une catégorie
     */
    public String getTitre(Categorie categorie) {
        if (categorie == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return categorie.getTitreEn() != null ? categorie.getTitreEn() : categorie.getTitre();
            case "bm":
                return categorie.getTitreBm() != null ? categorie.getTitreBm() : categorie.getTitre();
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
        switch (lang) {
            case "en":
                return procedure.getNomEn() != null ? procedure.getNomEn() : procedure.getNom();
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

    /**
     * Récupère le nom traduit d'un centre
     */
    public String getNom(Centre centre) {
        if (centre == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return centre.getNomEn() != null ? centre.getNomEn() : centre.getNom();
            case "bm":
                return centre.getNomBm() != null ? centre.getNomBm() : centre.getNom();
            default:
                return centre.getNom();
        }
    }

    /**
     * Récupère l'adresse traduite d'un centre
     */
    public String getAdresse(Centre centre) {
        if (centre == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return centre.getAdresseEn() != null ? centre.getAdresseEn() : centre.getAdresse();
            case "bm":
                return centre.getAdresseBm() != null ? centre.getAdresseBm() : centre.getAdresse();
            default:
                return centre.getAdresse();
        }
    }

    /**
     * Récupère les horaires traduits d'un centre
     */
    public String getHoraires(Centre centre) {
        if (centre == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return centre.getHorairesEn() != null ? centre.getHorairesEn() : centre.getHoraires();
            case "bm":
                return centre.getHorairesBm() != null ? centre.getHorairesBm() : centre.getHoraires();
            default:
                return centre.getHoraires();
        }
    }

    /**
     * Récupère la description traduite d'un coût
     */
    public String getDescription(Cout cout) {
        if (cout == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return cout.getDescriptionEn() != null ? cout.getDescriptionEn() : cout.getDescription();
            case "bm":
                return cout.getDescriptionBm() != null ? cout.getDescriptionBm() : cout.getDescription();
            default:
                return cout.getDescription();
        }
    }

    /**
     * Récupère la description traduite d'une loi/article
     */
    public String getDescription(LoiArticle loiArticle) {
        if (loiArticle == null) return null;
        
        String lang = getCurrentLanguage();
        switch (lang) {
            case "en":
                return loiArticle.getDescriptionEn() != null ? loiArticle.getDescriptionEn() : loiArticle.getDescription();
            case "bm":
                return loiArticle.getDescriptionBm() != null ? loiArticle.getDescriptionBm() : loiArticle.getDescription();
            default:
                return loiArticle.getDescription();
        }
    }
}



