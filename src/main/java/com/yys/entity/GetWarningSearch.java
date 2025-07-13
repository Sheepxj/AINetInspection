package com.yys.entity;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;
import java.util.List;

@Data
public class GetWarningSearch {

    List<String> alertTypes;

    String startTime;
    String endTime;
    String searchText;
    String faceData;
    Integer pageNum;
    Integer pageSize;
    List<String> cameraPosition;
}
