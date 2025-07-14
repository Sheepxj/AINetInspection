package com.yys.service;

import com.yys.entity.AiZlm;

public interface ZlmediakitService {

    //预览视频
    String getVideo(AiZlm aiZlm);

    //添加摄像头流
    AiZlm addVideo(AiZlm aiZlm);

    //删除摄像头流
    boolean deleteVideo(AiZlm aiZlm);

    //获取播放流信息
    String getPlayUrl(AiZlm aiZlm);

    //判断流是否在线
    boolean getZlmkey(AiZlm aiZlm);

    String getImg(String videoStream);

}
