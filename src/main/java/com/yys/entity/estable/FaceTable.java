package com.yys.entity.estable;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.data.annotation.Id;


@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class FaceTable {

    @Id
    private String Id;

    private String faceData;

    private String cameraPosition;

    private String faceLevel;

    private String alertTime;

    private String capturedImage;

    private String capturedVideo;

}

