package ml.fasodocs.backend.entity.converters;

import ml.fasodocs.backend.entity.Signalement;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class TypeSignalementConverter implements AttributeConverter<Signalement.TypeSignalement, String> {

    @Override
    public String convertToDatabaseColumn(Signalement.TypeSignalement typeSignalement) {
        if (typeSignalement == null) {
            return null;
        }
        return typeSignalement.name();
    }

    @Override
    public Signalement.TypeSignalement convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.trim().isEmpty()) {
            return null;
        }
        
        try {
            return Signalement.TypeSignalement.fromString(dbData);
        } catch (Exception e) {
            // En cas d'erreur, on retourne AUTRE par défaut
            return Signalement.TypeSignalement.AUTRE;
        }
    }
}