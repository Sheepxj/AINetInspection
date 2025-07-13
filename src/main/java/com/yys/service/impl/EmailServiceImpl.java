package com.yys.service.impl;

import com.yys.entity.estable.WarningTable;
import com.yys.service.EmailService;
import io.minio.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.mail.MessagingException;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.util.ByteArrayDataSource;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import static com.google.common.io.Files.getFileExtension;

@Service
public class EmailServiceImpl implements EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);

    @Value("${sendmsg.files}")
    private String filespath;

    @Autowired
    private JavaMailSender javaMailSender;

    @Autowired
    private MinioClient minioClient;

    public boolean sendEmail(String to, List<WarningTable> warningTables) {
        // 构建邮件内容
        StringBuilder emailContent = new StringBuilder();

        // 邮件标题
        String title = "紧急告警：" + getCurrentDate() + " 检测到异常活动";

        // 邮件内容构建
        emailContent.append("<html><body>");
        emailContent.append("<h2>您好！</h2>");
        emailContent.append("<p>AI视频监控系统在<strong>").append(getCurrentDateTime()).append("</strong>检测到异常活动，具体信息如下：</p>");

        // 遍历警告列表并展示详细信息
        for (WarningTable warning : warningTables) {
            emailContent.append("<p><strong>事件类型：</strong>").append(warning.getAlertType()).append("</p>");
            emailContent.append("<p><strong>发生地点：</strong>").append(warning.getCameraPosition()).append("</p>");
            emailContent.append("<p><strong>事件时间：</strong>").append(warning.getAlertTime()).append("</p>");
            emailContent.append("<p><strong>风险等级：</strong>").append(warning.getAlertLevel()).append("</p>");

            // 生成 CID 并添加到 HTML 内容中
            String cid = "image-" + warning.getId();
            emailContent.append("<p><strong>事件截图：</strong><br><img src='cid:").append(cid).append("' width='400'></p>");
            emailContent.append("<hr>");
        }

        emailContent.append("<p>为了确保安全，我们建议您尽快登录监控系统，查看事件详情并采取必要的应对措施。</p>");
        emailContent.append("<p>感谢您的使用！</p>");
        emailContent.append("<p>思通数科 AI视频监控团队</p>");
        emailContent.append("</body></html>");

        // 发送 HTML 邮件
        try {
            sendHtmlEmailWithAttachments(to, title, emailContent.toString(), warningTables);
            return true;
        } catch (Exception e) {
            logger.info("邮件发送失败：" + e.getMessage());
            return false;
        }
    }

    private void sendHtmlEmailWithAttachments(String to, String subject, String content, List<WarningTable> warningTables) throws MessagingException, IOException {
        MimeMessage mimeMessage = javaMailSender.createMimeMessage();
        MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage, true, StandardCharsets.UTF_8.name());

        String uniqueId = UUID.randomUUID().toString();

        // 设置邮件参数
        messageHelper.setFrom("chenziran@stonedt.com");
        messageHelper.setTo(to);
        messageHelper.setSubject(subject);
        messageHelper.setText(content, true);

        // 创建 Multipart 对象
        MimeMultipart multipart = new MimeMultipart();

        // 创建文本部分
        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setContent(content, "text/html; charset=UTF-8");
        multipart.addBodyPart(textPart);

        List<File> filesToCleanUp = new ArrayList<>();

        for (WarningTable warning : warningTables) {
            String cid = "image-" + warning.getId();
            String fileLocation = warning.getCapturedImage();
            File imageFile = downloadImageFromMinio(fileLocation,uniqueId);

            DataSource fds = new ByteArrayDataSource(Files.readAllBytes(imageFile.toPath()), "image/jpeg");
            MimeBodyPart imagePart = new MimeBodyPart();
            imagePart.setDataHandler(new DataHandler(fds));
            imagePart.setHeader("Content-ID", "<" + cid + ">");
            imagePart.setHeader("Content-Disposition", "inline; filename=" + imageFile.getName());
            multipart.addBodyPart(imagePart);

            // 记录下载的文件
            filesToCleanUp.add(imageFile);
        }

        // 将 Multipart 对象设置为邮件内容
        mimeMessage.setContent(multipart);

        // 发送邮件
        javaMailSender.send(mimeMessage);

        // 清理下载的文件
        for (File file : filesToCleanUp) {
            if (file.exists()) {
                file.delete();
            }
        }

    }

    private String getCurrentDate() {
        // 获取当前日期
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(new Date());
    }

    private String getCurrentDateTime() {
        // 获取当前日期和时间
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(new Date());
    }


    private File downloadImageFromMinio(String imgPath, String uniqueId) throws IOException {

        // 创建文件夹
        String typeFolder = filespath + File.separator + uniqueId;
        File imagesFolder = new File(typeFolder);

        if (!imagesFolder.exists()) {
            imagesFolder.mkdirs();
        }

        String bucketName = imgPath.split("/")[1];
        String objectName = imgPath.substring(bucketName.length() + 2);
        String imgpath = imgPath.split("/")[5];
        // 处理图片
        try {
            StatObjectResponse stat = minioClient.statObject(
                    StatObjectArgs.builder()
                            .bucket(bucketName)
                            .object(objectName)
                            .build()
            );
            String contentType = stat.contentType();
            String fileExtension = getFileExtension(contentType);

            InputStream imageInputStream = minioClient.getObject(
                    GetObjectArgs.builder()
                            .bucket(bucketName)
                            .object(objectName)
                            .build()
            );

            String fileNameWithExtension = imgpath + fileExtension;
            Path targetImgPath = Paths.get(imagesFolder.getAbsolutePath(), fileNameWithExtension);
            Files.copy(imageInputStream, targetImgPath, StandardCopyOption.REPLACE_EXISTING);
            imageInputStream.close();

        }catch (Exception e) {
            e.printStackTrace();
        }

        return new File(imagesFolder.getAbsolutePath() + File.separator + imgpath);
    }



}
