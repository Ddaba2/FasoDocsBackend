package ml.fasodocs.backend.dto.response;

import lombok.Data;
import java.time.LocalDate;

@Data
public class QuizStatistiqueResponse {
    private Long citoyenId;
    private String citoyenNom;
    private String citoyenPrenom;
    private Integer totalPoints;
    private Integer totalQuizCompletes;
    private Integer streakJours;
    private Integer meilleurStreak;
    private LocalDate derniereParticipation;
    private Boolean badgeExpert;
    private Boolean badgeStreakMaster;
    private Integer positionClassement;
}

