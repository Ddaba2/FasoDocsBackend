-- Migration V11: Création des tables pour le système de quiz
-- Date: 2025-01-15

-- Table quiz_journaliers (Quiz du jour)
CREATE TABLE IF NOT EXISTS quiz_journaliers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    date_quiz DATE NOT NULL UNIQUE,
    procedure_id BIGINT,
    categorie_id BIGINT,
    est_actif BOOLEAN DEFAULT TRUE,
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (procedure_id) REFERENCES procedures(id) ON DELETE SET NULL,
    FOREIGN KEY (categorie_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_date_quiz (date_quiz),
    INDEX idx_est_actif (est_actif)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table quiz_questions (Questions du quiz)
CREATE TABLE IF NOT EXISTS quiz_questions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    quiz_journalier_id BIGINT NOT NULL,
    question_fr TEXT NOT NULL,
    question_en TEXT NOT NULL,
    type_question VARCHAR(50),
    procedure_id BIGINT,
    reponse_correcte TEXT NOT NULL,
    points INTEGER DEFAULT 10,
    niveau VARCHAR(20) DEFAULT 'FACILE',
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (quiz_journalier_id) REFERENCES quiz_journaliers(id) ON DELETE CASCADE,
    FOREIGN KEY (procedure_id) REFERENCES procedures(id) ON DELETE SET NULL,
    INDEX idx_quiz_journalier (quiz_journalier_id),
    INDEX idx_type_question (type_question)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table quiz_reponses (Réponses possibles)
CREATE TABLE IF NOT EXISTS quiz_reponses (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    question_id BIGINT NOT NULL,
    reponse_fr TEXT NOT NULL,
    reponse_en TEXT NOT NULL,
    est_correcte BOOLEAN DEFAULT FALSE,
    ordre INTEGER,
    FOREIGN KEY (question_id) REFERENCES quiz_questions(id) ON DELETE CASCADE,
    INDEX idx_question (question_id),
    INDEX idx_ordre (ordre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table quiz_participations (Participations des utilisateurs)
CREATE TABLE IF NOT EXISTS quiz_participations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    citoyen_id BIGINT NOT NULL,
    quiz_journalier_id BIGINT NOT NULL,
    score INTEGER DEFAULT 0,
    nombre_bonnes_reponses INTEGER DEFAULT 0,
    nombre_questions INTEGER DEFAULT 0,
    temps_secondes INTEGER,
    date_participation DATETIME DEFAULT CURRENT_TIMESTAMP,
    est_complete BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (citoyen_id) REFERENCES citoyens(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_journalier_id) REFERENCES quiz_journaliers(id) ON DELETE CASCADE,
    UNIQUE KEY unique_participation (citoyen_id, quiz_journalier_id),
    INDEX idx_citoyen (citoyen_id),
    INDEX idx_quiz_journalier (quiz_journalier_id),
    INDEX idx_date_participation (date_participation)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table quiz_reponses_utilisateurs (Réponses données)
CREATE TABLE IF NOT EXISTS quiz_reponses_utilisateurs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    participation_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    reponse_choisie_id BIGINT,
    est_correcte BOOLEAN,
    points_obtenus INTEGER DEFAULT 0,
    date_reponse DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (participation_id) REFERENCES quiz_participations(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES quiz_questions(id) ON DELETE CASCADE,
    FOREIGN KEY (reponse_choisie_id) REFERENCES quiz_reponses(id) ON DELETE SET NULL,
    INDEX idx_participation (participation_id),
    INDEX idx_question (question_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table quiz_statistiques (Stats utilisateur)
CREATE TABLE IF NOT EXISTS quiz_statistiques (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    citoyen_id BIGINT NOT NULL UNIQUE,
    total_points INTEGER DEFAULT 0,
    total_quiz_completes INTEGER DEFAULT 0,
    streak_jours INTEGER DEFAULT 0,
    meilleur_streak INTEGER DEFAULT 0,
    derniere_participation DATE,
    badge_expert BOOLEAN DEFAULT FALSE,
    badge_streak_master BOOLEAN DEFAULT FALSE,
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (citoyen_id) REFERENCES citoyens(id) ON DELETE CASCADE,
    INDEX idx_total_points (total_points),
    INDEX idx_streak_jours (streak_jours)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ajouter colonnes pour les notifications de quiz (si elles n'existent pas déjà)
ALTER TABLE citoyens 
ADD COLUMN IF NOT EXISTS langue_preferee VARCHAR(2) DEFAULT 'fr' 
COMMENT 'Langue préférée: fr, en, bm';

ALTER TABLE citoyens 
ADD COLUMN IF NOT EXISTS notifications_quiz_actives BOOLEAN DEFAULT TRUE 
COMMENT 'Activer les notifications de quiz';

-- Ajouter colonnes pour les notifications multilingues (si elles n'existent pas déjà)
ALTER TABLE notifications 
ADD COLUMN IF NOT EXISTS contenu_en TEXT 
COMMENT 'Contenu de la notification en anglais';

ALTER TABLE notifications 
ADD COLUMN IF NOT EXISTS type_quiz VARCHAR(50) 
COMMENT 'Type de notification quiz: QUIZ_QUOTIDIEN, RAPPEL_STREAK, BADGE_DEBLOQUE';

