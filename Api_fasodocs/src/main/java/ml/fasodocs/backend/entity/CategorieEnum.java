package ml.fasodocs.backend.entity;

/**
 * Enumération des catégories prédéfinies selon le diagramme UML
 */
public enum CategorieEnum {
    IDENTITE_ET_CITOYENNETE("Identité et citoyenneté"),
    CREATION_D_ENTREPRISE("Création d'entreprise"),
    DOCUMENTS("Documents"),
    SERVICE_FONCIER("Service foncier"),
    EAU_ET_ELECTRICITE("Eau et électricité"),
    JUSTICE("Justice"),
    AUTRES_DOMAINES("Autres domaines");

    private final String libelle;

    CategorieEnum(String libelle) {
        this.libelle = libelle;
    }

    public String getLibelle() {
        return libelle;
    }

    @Override
    public String toString() {
        return libelle;
    }
}
