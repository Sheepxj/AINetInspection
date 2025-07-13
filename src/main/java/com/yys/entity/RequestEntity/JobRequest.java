package com.yys.entity.RequestEntity;

import lombok.Data;

import java.util.List;

@Data
public class JobRequest {
    private String ocrId;
    private String cronExpression;
    private List<Integer> chatIds;
}
