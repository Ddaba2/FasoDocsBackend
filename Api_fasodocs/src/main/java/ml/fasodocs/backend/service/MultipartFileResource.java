package ml.fasodocs.backend.service;

import org.springframework.core.io.AbstractResource;
import org.springframework.lang.Nullable;
import org.springframework.util.Assert;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;

/**
 * Resource implementation for MultipartFile
 */
public class MultipartFileResource extends AbstractResource {
    
    private final MultipartFile multipartFile;
    
    private final String filename;
    
    public MultipartFileResource(MultipartFile multipartFile) {
        Assert.notNull(multipartFile, "MultipartFile must not be null");
        this.multipartFile = multipartFile;
        this.filename = multipartFile.getOriginalFilename() != null ? multipartFile.getOriginalFilename() : "";
    }
    
    @Override
    public InputStream getInputStream() throws IOException {
        return this.multipartFile.getInputStream();
    }
    
    @Override
    public boolean exists() {
        return true;
    }
    
    @Override
    public boolean isReadable() {
        return true;
    }
    
    @Override
    public long contentLength() throws IOException {
        return this.multipartFile.getSize();
    }
    
    @Override
    @Nullable
    public String getFilename() {
        return this.filename;
    }
    
    @Override
    public String getDescription() {
        return "MultipartFile resource [" + this.filename + "]";
    }
}