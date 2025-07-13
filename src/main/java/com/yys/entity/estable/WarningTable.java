package com.yys.entity.estable;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import org.springframework.data.annotation.Id;


@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class WarningTable {

    @Id
    private String Id;

    private String alertId;

    private String cameraPosition;

    private String monitoringTask;

    private String alertType;

    private String videoTags;

    private String alertLevel;

    private String alertTime;

    private String capturedImage;

    private String capturedVideo;

}

