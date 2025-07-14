package com.yys.config;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.transport.ElasticsearchTransport;
import co.elastic.clients.transport.rest_client.RestClientTransport;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ElasticsearchConfig {

    @Value("${spring.elasticsearch.uris}")
    private String uris;

    @Bean
    public ElasticsearchClient elasticsearchClient() {
        // 创建低级 RestClient
        RestClient restClient = RestClient.builder(
                new HttpHost(uris, 9222, "http")
        ).build();

        // 创建传输层
        ElasticsearchTransport transport = new RestClientTransport(
                restClient,
                new co.elastic.clients.json.jackson.JacksonJsonpMapper()
        );

        // 返回 ElasticsearchClient
        return new ElasticsearchClient(transport);
    }

}


