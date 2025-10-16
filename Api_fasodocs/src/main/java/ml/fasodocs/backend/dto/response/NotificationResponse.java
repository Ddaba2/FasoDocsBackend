package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotificationResponse {
    private Long id;
    private String contenu;
    private LocalDateTime dateEnvoi;
    private Boolean estLue;
    private String type;
    private Long procedureId;
    private String procedureNom;
}

