package com.yys.entity;

import lombok.Data;

@Data
public class CameraDTO {
    private Integer id;
    private String cameraId;
    private String cameraLocation;
    private Integer cameraGroup;
    private String cameraResolution;
    private String cameraProtocol;
    private Integer cameraStatus;
    private String workingTime;
    private String lastTime;
    private String ipAddress;
    private Integer cameraPort;
    private String videoStreaming;
    private String groupName;
    private String cameraTaskid;
    private Integer typeInput;
    private String userName;
    private String passWord;
    private String address;
    private String agreement;
    private Double videoScale; //视频比例
    private Integer videoRate; //视频帧率
    private Integer zlmId;
    private String zlmUrl;
}
