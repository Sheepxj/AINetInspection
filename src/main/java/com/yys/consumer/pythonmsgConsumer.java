package com.yys.consumer;

import com.alibaba.fastjson2.JSON;
import com.yys.config.RabbitMQconfig;
import com.yys.entity.DetectionTask;
import com.yys.entity.RabbitMsg;
import com.yys.entity.estable.WarningTable;
import com.yys.service.DetectionTaskService;
import com.yys.service.RadisService;
import com.yys.service.WarningTableService;
import org.springframework.amqp.rabbit.annotation.RabbitHandler;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.time.Instant;

@Component
@RabbitListener(queues = {RabbitMQconfig.QUEUE_NAME})
public class pythonmsgConsumer {

    @Autowired
    private WarningTableService warningTableService;

    @Autowired
    private DetectionTaskService detectionTaskService;

    @Autowired
    private RadisService radisCounterService;

    @RabbitHandler
    public void process(byte[] message) throws InterruptedException {

        try {
            // 将字节数组转换为字符串
            String jsonString = new String(message, StandardCharsets.UTF_8);
            // 将JSON字符串转换为对象
            RabbitMsg rabbitMsg = JSON.parseObject(jsonString, RabbitMsg.class);

            // 获取模型名称
            String model = detectionTaskService.modelName(rabbitMsg.getModel().get(0));

            // 获取任务信息
            DetectionTask detectionTask = detectionTaskService.selectDetectionType(rabbitMsg.getTaskId());
            // 创建警告表
            WarningTable warningTable = new WarningTable();
            warningTable.setId(getCurrentTimestampUsingInstant());
            warningTable.setCameraPosition(detectionTask.getCameraPosition());
            warningTable.setMonitoringTask(rabbitMsg.getTaskId());
            warningTable.setAlertType(model);
            warningTable.setAlertLevel(detectionTask.getAlertLevel());
            warningTable.setAlertTime(rabbitMsg.getTimestamp());

            String uuid = rabbitMsg.getUniqueId();

            if (rabbitMsg.getVideoPath()==null){
                //保存图片
                warningTable.setCapturedImage(rabbitMsg.getImgPath());
                WarningTable savewarningTable= warningTableService.saveWarningTable(warningTable);
                String Id=savewarningTable.getId();
                radisCounterService.setWarningTableId(uuid,Id);
                //Radis计数器
                radisCounterService.incrementCounter();
            } else if (rabbitMsg.getImgPath()==null) {
                String guid = radisCounterService.getWarningTableId(uuid);
                WarningTable warningTablevideo = warningTableService.getWarningTable(guid);
                warningTablevideo.setCapturedVideo(rabbitMsg.getVideoPath());
                warningTableService.saveWarningTable(warningTablevideo);
            }else {
                warningTable.setCapturedImage(rabbitMsg.getImgPath());
                warningTable.setCapturedVideo(rabbitMsg.getVideoPath());
                warningTableService.saveWarningTable(warningTable);
                //Radis计数器zui
                radisCounterService.incrementCounter();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String getCurrentTimestampUsingInstant() {
        return String.valueOf(Instant.now().toEpochMilli());
    }

}
