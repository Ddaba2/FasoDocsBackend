package ml.fasodocs.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MessageResponse {
    private String message;
    private boolean success;
    private Object data;

    public MessageResponse(String message, boolean success) {
        this.message = message;
        this.success = success;
        this.data = null;
    }

    public static MessageResponse success(String message) {
        return new MessageResponse(message, true);
    }

    public static MessageResponse success(String message, Object data) {
        MessageResponse response = new MessageResponse(message, true);
        response.setData(data);
        return response;
    }

    public static MessageResponse error(String message) {
        return new MessageResponse(message, false);
    }
}
