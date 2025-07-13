package com.yys.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.yys.entity.AiModel;


import java.util.List;

public interface AiModelService extends IService<AiModel> {

    List<AiModel> selectModel(String ids);

    AiModel getModelByModel(String model);
}
