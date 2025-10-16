package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class JwtResponse {
    private String token;
    private Long id;
    private String nom;
    private String prenom;
    private String email;
    private String telephone;
    private String languePreferee;
}
