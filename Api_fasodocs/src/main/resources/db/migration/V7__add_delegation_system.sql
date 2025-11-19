-- Migration pour ajouter le système de délégation de procédures

-- Ajouter champ peut_etre_delegatee dans procedures
ALTER TABLE procedures 
ADD COLUMN peut_etre_delegatee BOOLEAN DEFAULT FALSE 
COMMENT 'Indique si la procédure peut être déléguée à un agent FasoDocs';

-- Créer table demandes_delegation
CREATE TABLE demandes_delegation (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    citoyen_id BIGINT NOT NULL,
    procedure_id BIGINT NOT NULL,
    statut VARCHAR(20) NOT NULL DEFAULT 'EN_ATTENTE',
    tarif DECIMAL(10,2) NOT NULL COMMENT 'Tarif total (délégation + coût légal)',
    tarif_delegation DECIMAL(10,2) NOT NULL COMMENT 'Frais de délégation selon commune',
    cout_legal DECIMAL(10,2) COMMENT 'Coût légal de la procédure',
    commune VARCHAR(100) NOT NULL,
    quartier VARCHAR(100),
    telephone_contact VARCHAR(20),
    date_souhaitee DATE,
    commentaires TEXT,
    notes_agent TEXT,
    agent_id BIGINT COMMENT 'Agent assigné (ADMIN)',
    date_acceptation DATETIME,
    date_debut DATETIME,
    date_fin DATETIME,
    date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (citoyen_id) REFERENCES citoyens(id) ON DELETE CASCADE,
    FOREIGN KEY (procedure_id) REFERENCES procedures(id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES citoyens(id) ON DELETE SET NULL,
    INDEX idx_citoyen (citoyen_id),
    INDEX idx_procedure (procedure_id),
    INDEX idx_statut (statut),
    INDEX idx_date_creation (date_creation)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Demandes de délégation de procédures administratives';

