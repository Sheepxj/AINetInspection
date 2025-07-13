package com.yys.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yys.entity.face.FaceTask;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface FaceTaskMapper extends BaseMapper<FaceTask> {

    FaceTask selectFaceTask(Integer taskId);
}
