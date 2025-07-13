package com.yys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import com.yys.entity.AiCamera;
import com.yys.entity.Result;
import com.yys.mapper.AiCameraMapper;
import com.yys.service.AiCameraService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AiCameraServiceImpl extends ServiceImpl<AiCameraMapper, AiCamera> implements AiCameraService {

    @Autowired
    private AiCameraMapper cameralistMapper;




}
