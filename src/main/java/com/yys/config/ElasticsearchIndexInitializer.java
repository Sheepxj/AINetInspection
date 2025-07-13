package com.yys.config;

import co.elastic.clients.elasticsearch.ElasticsearchClient;

import co.elastic.clients.elasticsearch.indices.CreateIndexRequest;
import co.elastic.clients.elasticsearch.indices.CreateIndexResponse;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.io.IOException;


@Component
public class ElasticsearchIndexInitializer {

    private static final Logger logger = LoggerFactory.getLogger(ElasticsearchIndexInitializer.class);

    private final ElasticsearchClient elasticsearchClient;

    public ElasticsearchIndexInitializer(ElasticsearchClient elasticsearchClient) {
        this.elasticsearchClient = elasticsearchClient;
    }

    @EventListener(ApplicationReadyEvent.class)
    public void init() {
        logger.info("✅ 准备初始化索引 warning_table");

        String indexName = "warning_table";
        try {
            boolean exists = elasticsearchClient.indices()
                    .exists(e -> e.index(indexName))
                    .value();

            if (exists) {
                logger.info("索引 [{}] 已存在，无需创建", indexName);
                return;
            }

            // 创建索引
            CreateIndexResponse response = elasticsearchClient.indices().create(CreateIndexRequest.of(c -> c
                    .index(indexName)
                    .mappings(m -> m
                            .properties("Id", p -> p.keyword(k -> k))
                            .properties("alertId", p -> p.keyword(k -> k))
                            .properties("userId", p -> p.keyword(k -> k))
                            .properties("cameraPosition", p -> p.text(t -> t
                                    .fields("keyword", f -> f.keyword(k -> k))
                            ))
                            .properties("monitoringTask", p -> p.text(t -> t))
                            .properties("videoTags", p -> p.text(t -> t))
                            .properties("alertType", p -> p.text(t -> t
                                    .fields("keyword", f -> f.keyword(k -> k))
                            ))
                            .properties("alertLevel", p -> p.keyword(k -> k))
                            .properties("alertTime", p -> p.date(d -> d.format("yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis")))
                            .properties("capturedImage", p -> p.keyword(k -> k))
                            .properties("capturedVideo", p -> p.keyword(k -> k))
                    )
            ));

            if (response.acknowledged()) {
                logger.info("索引 [{}] 创建成功", indexName);
            } else {
                logger.warn("索引 [{}] 创建未被完全确认", indexName);
            }

        } catch (IOException e) {
            logger.error("索引 [{}] 初始化异常: {}", indexName, e.getMessage(), e);
        }
    }

}
