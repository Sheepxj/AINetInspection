package com.yys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import com.yys.entity.AiModel;
import com.yys.mapper.AiModelMapper;
import com.yys.service.AiModelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AiModelServiceImpl extends ServiceImpl<AiModelMapper, AiModel> implements AiModelService {

    @Autowired
    private AiModelMapper aiModelMapper;

    @Override
    public List<AiModel> selectModel(String ids) {
        return aiModelMapper.selectModel(ids);
    }

    @Override
    public AiModel getModelByModel(String model) {
        QueryWrapper<AiModel> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("model",model);
        return this.getOne(queryWrapper);
    }


}
