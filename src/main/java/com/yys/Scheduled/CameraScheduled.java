package com.yys.Scheduled;

import com.yys.entity.AiCamera;
import com.yys.service.CameralistService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;


import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

@Component
public class CameraScheduled implements AutoCloseable {

    private final ExecutorService executorService = Executors.newFixedThreadPool(5);


    /**
     * 定期同步每日数据到数据库
     * 通过使用定时任务注解 @Scheduled，确保该方法每两小时执行一次
     * 该方法的目的是从摄像头列表服务中获取所有AI摄像头信息，并为每个摄像头启动一个检查和同步任务
     */
    @Scheduled(cron = "0 0 1 * * ?")
    public void syncDailyDataToDatabase() {

    }

    private void checkAndSyncCamera(AiCamera aiCamera) {

    }
    @Override
    public void close() throws Exception {
        executorService.shutdown();
        while (!executorService.awaitTermination(1, TimeUnit.SECONDS)) ;
    }

}

