package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Statistiques du cache Djelia AI
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DjeliaCacheStatsResponse {
    
    private int cacheSize;
    
    private long totalRequests;
    
    private long cacheHits;
    
    private long cacheMisses;
    
    private double hitRate;
}

