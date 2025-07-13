package com.yys.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import com.yys.entity.AiModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface AiModelMapper extends BaseMapper<AiModel> {

    @Select("SELECT id,model_name,model FROM ai_model WHERE id in (#{ids})")
    List<AiModel> selectModel(@Param("ids") String ids);

}
