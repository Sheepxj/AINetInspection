package com.yys.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.BinaryWebSocketHandler;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.*;
import java.net.URI;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.locks.ReentrantLock;

@Component
public class WebSocketStreamHandler extends BinaryWebSocketHandler {

    @Autowired
    private StringRedisTemplate redisTemplate;

    private static final Logger logger = LoggerFactory.getLogger(WebSocketStreamHandler.class);
    private static ExecutorService executorService = Executors.newCachedThreadPool();

    private final Map<WebSocketSession, String> sessionStreamMap = new ConcurrentHashMap<>();
    private final Map<String, Process> activeStreams = new HashMap<>();  // 存储流和对应的进程
    private final Map<String, WebSocketSession> sessions = new HashMap<>();
    private final ReentrantLock lock = new ReentrantLock();

    /**
     * 当WebSocket连接建立后调用此方法
     */
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        URI uri = session.getUri();
        Map<String, String> queryParams = UriComponentsBuilder.fromUri(uri).build().getQueryParams().toSingleValueMap();
        String token = queryParams.get("Authorization");
        String sessionId = session.getId();

        sessions.put(sessionId, session);
        logger.info("WebSocket 连接已建立，sessionId: " + sessionId + ", token: " + token);

        redisTemplate.opsForValue().set(token, sessionId);
        session.sendMessage(new TextMessage("{\"type\":\"sessionId\",\"sessionId\":\"" + sessionId + "\"}"));
    }

    /**
     * 当WebSocket连接关闭后调用此方法
     */
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        closeSession(session);
    }

    /**
     * 启动RTSP流
     */
    public void startStream(String rtspUrl, String sessionId) {
        if (sessions.containsKey(sessionId)) {
            WebSocketSession session = sessions.get(sessionId);
            sessionStreamMap.put(session, rtspUrl);
        } else {
            logger.info("sessionId不存在: " + sessionId);
            return;
        }

        logger.info("开始启动流: " + rtspUrl);

        // 如果流已经启动，直接返回
        if (activeStreams.containsKey(rtspUrl)) {
            logger.info("该流已在运行: " + rtspUrl);
            return;
        }

        executorService.submit(() -> {
            try {
                // 启动RTSP到H.264的转码进程
                ProcessBuilder processBuilder = new ProcessBuilder(
                        "ffmpeg",
                        "-i", rtspUrl,
                        "-vcodec", "libx264",  // 使用 H.264 编码
                        "-f", "mpegts",        // 使用 MPEG-TS 容器格式
                        "-an",                 // 不传输音频
                        "-r","10",             // 指定15帧播放
                        "-mpegts_flags", "resend_headers", // 重新发送头部
                        "-"
                );

                Process ffmpegProcess = processBuilder.start();
                activeStreams.put(rtspUrl, ffmpegProcess);  // 存储 Process 对象
                InputStream inputStream = ffmpegProcess.getInputStream();
                byte[] buffer = new byte[1024 * 1024];  // 使用 1MB 缓冲区
                int bytesRead;

                // 实时读取FFmpeg输出流并通过WebSocket发送
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    sendStreamToSessions(rtspUrl, buffer, bytesRead);
                }

                inputStream.close();
                ffmpegProcess.waitFor();  // 确保进程终止
            } catch (IOException | InterruptedException e) {
                logger.error("启动流失败: " + rtspUrl, e);
            } finally {
                // 清理已停止的流
                activeStreams.remove(rtspUrl);
                logger.info("流已停止: " + rtspUrl);
            }
        });

        logger.info("已启动 H.264 流: " + rtspUrl);
    }

    public boolean closeSessionById(String sessionId) {
        WebSocketSession session = sessions.get(sessionId);
        if (session == null) {
            logger.warn("无法找到指定的 sessionId: " + sessionId);
            return false;
        }
        return closeSession(session);
    }

    private boolean closeSession(WebSocketSession session) {
        lock.lock();
        try {
            String rtspUrl = sessionStreamMap.remove(session);

            if (rtspUrl != null && !sessionStreamMap.containsValue(rtspUrl) && activeStreams.containsKey(rtspUrl)) {
                Process ffmpegProcess = activeStreams.remove(rtspUrl);
                if (ffmpegProcess != null) {
                    ffmpegProcess.destroy();  // 停止FFmpeg进程
                    ffmpegProcess.waitFor();   // 确保进程完全停止
                    logger.info("FFmpeg 流已停止: " + rtspUrl);
                }
            }

            sessions.remove(session.getId());

            if (session.isOpen()) {
                session.close();
            }
            logger.info("已关闭 WebSocket 会话，sessionId: " + session.getId());
            return true;
        } catch (Exception e) {
            logger.error("关闭 sessionId 失败: " + session.getId(), e);
            return false;
        } finally {
            lock.unlock();
        }
    }

    /**
     * 发送流数据到对应的WebSocket会话
     */
    private void sendStreamToSessions(String rtspUrl, byte[] buffer, int bytesRead) {
        synchronized (sessionStreamMap) {
            for (Map.Entry<WebSocketSession, String> entry : sessionStreamMap.entrySet()) {
                WebSocketSession session = entry.getKey();
                String streamUrl = entry.getValue();
                if (session.isOpen() && streamUrl.equals(rtspUrl)) {
                    try {
                        session.sendMessage(new BinaryMessage(Arrays.copyOf(buffer, bytesRead)));
                    } catch (IOException e) {
                        logger.error("发送数据到 WebSocket 会话失败", e);
                    }
                }
            }
        }
    }

    /**
     * 处理WebSocket接收到的二进制消息
     */
    @Override
    protected void handleBinaryMessage(WebSocketSession session, BinaryMessage message) throws Exception {
        // 这里可以处理 WebSocket 收到的二进制消息
    }

}