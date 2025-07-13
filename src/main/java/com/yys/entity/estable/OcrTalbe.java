package com.yys.entity.estable;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.data.annotation.Id;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class OcrTalbe {

    @Id
    private String Id;

    private String ocrTask;

    private String cameraPosition;

    private String textContent;

    private String ocrLevel;

    private String alertTime;

    private String capturedImage;

}
