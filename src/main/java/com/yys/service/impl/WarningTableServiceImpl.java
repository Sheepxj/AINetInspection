package com.yys.service.impl;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.elasticsearch._types.FieldValue;
import co.elastic.clients.elasticsearch._types.Result;
import co.elastic.clients.elasticsearch._types.SortOrder;
import co.elastic.clients.elasticsearch._types.aggregations.StringTermsAggregate;
import co.elastic.clients.elasticsearch._types.query_dsl.*;
import co.elastic.clients.elasticsearch.core.*;
import co.elastic.clients.elasticsearch.core.search.Hit;
import co.elastic.clients.json.JsonData;
import com.yys.entity.GetWarningSearch;
import com.yys.entity.estable.WarningTable;

import com.yys.service.WarningTableService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;


@Service
public class WarningTableServiceImpl implements WarningTableService {

    private static final Logger logger = LoggerFactory.getLogger(WarningTableService.class);

    @Value("${stream.warningindex}")
    private String esIndex;

    @Autowired
    private ElasticsearchClient esClient;

    /**
     * 保存警告信息到数据库
     *
     * @param warningTable 要保存的警告信息表对象
     * @return 保存后的警告信息表对象，如果保存失败则返回null
     *
     * 此方法首先检查传入的警告信息表对象是否为null，如果为null，则记录错误日志并抛出非法参数异常
     * 接着，为警告信息表对象生成一个相机ID，并尝试将其保存到数据库中
     * 如果保存过程中出现异常，则记录错误日志并返回null
     */
    @Override
    public WarningTable saveWarningTable(WarningTable warningTable) {
        // 参数校验
        if (warningTable == null) {
            logger.error("参数为空");
            throw new IllegalArgumentException("参数为空");
        }
        try {
            warningTable.setAlertId(generateCameraId());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try {
            // 构建 IndexRequest
            IndexRequest<WarningTable> request = IndexRequest.of(builder -> builder
                    .index(esIndex) // 设置索引名称
                    .id(warningTable.getId())
                    .document(warningTable) // 设置文档数据
            );

            IndexResponse response = esClient.index(request);
            if (response.result() == Result.Created) {
                logger.info("保存成功，新创建记录");
                return warningTable;
            } else if (response.result() == Result.Updated) {
                logger.info("保存成功，更新记录");
                return warningTable;
            } else {
                logger.warn("保存失败");
                return null;
            }


        } catch (Exception e) {
            logger.error("保存es索引出错", e);
            return null;
        }
    }

    @Override
    public WarningTable getWarningTable(String Id) throws IOException {
        GetRequest request = GetRequest.of(req -> req
                .index(esIndex)
                .id(Id)
        );

        // 执行 Get 请求
        GetResponse<WarningTable> response = esClient.get(request, WarningTable.class);

        // 检查文档是否存在
        if (response.found()) {
            WarningTable warningTable = response.source();
            return warningTable;
        } else {
            logger.warn("未找到匹配的警告信息");
            return null;
        }
    }

    /**
     * 根据警告ID查询警告信息
     *
     * @param alertId 警告ID
     * @return 匹配警告ID的警告信息表对象，如果找不到则返回null
     *
     * 此方法首先检查传入的警告ID是否为null，如果为null，则记录错误日志并抛出非法参数异常
     * 接着，尝试根据警告ID查询数据库中的警告信息
     * 如果查询过程中出现异常，则记录错误日志并返回null
     */
    @Override
    public WarningTable searchByAlertId(String alertId) {
        // 创建搜索请求
        SearchRequest request = SearchRequest.of(req -> req
                .index(esIndex)
                .query(q -> q.match(m -> m.field("alertId").query(alertId)))
        );

        // 执行搜索请求
        SearchResponse<WarningTable> response = null;
        try {
            response = esClient.search(request, WarningTable.class);
        } catch (IOException e) {
            logger.error("查询es索引出错", e);
        }

        // 获取搜索结果
        List<Hit<WarningTable>> hits = response.hits().hits();
        if (!hits.isEmpty()) {
            Hit<WarningTable> hit = hits.get(0);
            WarningTable warningTable = hit.source();
            return warningTable;
        } else {
            logger.warn("未找到匹配的警告信息");
            return null;
        }
    }

    /**
     * 查询所有警告信息，并按照警告时间降序排序
     *
     * @return 排序后的警告信息列表，如果列表为空则返回null
     *
     * 此方法首先定义一个分页请求，用于获取最多5条记录
     * 然后，尝试查询数据库中所有警告信息，并按照警告时间降序排序
     * 如果查询结果为空，则返回null；否则，返回查询结果
     */
    @Override
    public List<WarningTable> searchWithSort() {
        // 创建搜索请求
        SearchRequest request = SearchRequest.of(req -> req
                .index(esIndex)
                .size(5)
                .sort(s -> s.field(f -> f.field("alertTime").order(SortOrder.Desc)))
        );

        try {
            // 执行搜索请求
            SearchResponse<WarningTable> response = esClient.search(request, WarningTable.class);

            // 获取搜索结果
            List<Hit<WarningTable>> hits = response.hits().hits();
            if (!hits.isEmpty()) {
                return hits.stream()
                        .map(Hit::source)
                        .collect(Collectors.toList());
            } else {
                logger.warn("未找到匹配的警告信息");
                return Collections.emptyList();
            }
        } catch (IOException e) {
            logger.error("查询es索引出错", e);
            return Collections.emptyList();
        }
    }

    @Override
    public Map<String, Integer> getalertTypes() {
        // 创建聚合查询请求
        SearchRequest request = SearchRequest.of(req -> req
                .index(esIndex)
                .size(0)  // 不返回文档内容，只返回聚合结果
                .aggregations("unique_alert_types", agg -> agg
                        .terms(t -> t
                                .field("alertType.keyword")  // 使用 keyword 子字段进行聚合
                                .size(10000)  // 设置返回的唯一值数量上限

                        )
                ).sort(s -> s.field(f -> f.field("alertTime").order(SortOrder.Desc)))
        );

        // 执行搜索请求
        SearchResponse<Object> response = null;
        try {
            response = esClient.search(request, Object.class);
        } catch (IOException e) {
            logger.error("查询es索引出错", e);
            return Collections.emptyMap();
        }

        Map<String, Integer> alertTypeCountMap = new LinkedHashMap<>();
        if (response != null && response.aggregations() != null) {
            // 获取字符串类型的 terms 聚合结果
            StringTermsAggregate termsAggregate = response.aggregations()
                    .get("unique_alert_types")
                    .sterms();

            // 遍历 buckets
            termsAggregate.buckets().array().forEach(bucket -> {
                String key = bucket.key().stringValue();
                long docCount = bucket.docCount();
                alertTypeCountMap.put(key, (int) docCount);
            });
        }

        return alertTypeCountMap;
    }

    @Override
    public Map<String, Integer> getcameraPosition() {
        // 创建聚合查询请求
        SearchRequest request = SearchRequest.of(req -> req
                .index(esIndex)
                .size(0)  // 不返回文档内容，只返回聚合结果
                .aggregations("unique_alert_types", agg -> agg
                        .terms(t -> t
                                .field("cameraPosition.keyword")
                                .size(10000)

                        )
                ).sort(s -> s.field(f -> f.field("alertTime").order(SortOrder.Desc)))
        );

        // 执行搜索请求
        SearchResponse<Object> response = null;
        try {
            response = esClient.search(request, Object.class);
        } catch (IOException e) {
            logger.error("查询es索引出错", e);
            return Collections.emptyMap();
        }

        Map<String, Integer> alertTypeCountMap = new LinkedHashMap<>();
        if (response != null && response.aggregations() != null) {
            // 获取字符串类型的 terms 聚合结果
            StringTermsAggregate termsAggregate = response.aggregations()
                    .get("unique_alert_types")
                    .sterms();

            // 遍历 buckets
            termsAggregate.buckets().array().forEach(bucket -> {
                String key = bucket.key().stringValue();
                long docCount = bucket.docCount();
                alertTypeCountMap.put(key, (int) docCount);
            });
        }

        return alertTypeCountMap;
    }

    @Override
    public Page<WarningTable> searchByAlertTypes(GetWarningSearch getWarningSearch) {
        try {
            // 初始化 BoolQuery
            BoolQuery.Builder boolQueryBuilder = new BoolQuery.Builder();

            // 提取搜索条件参数
            String startTime = getWarningSearch.getStartTime();
            String endTime = getWarningSearch.getEndTime();
            String searchText = getWarningSearch.getSearchText();
            List<String> alertTypes = getWarningSearch.getAlertTypes();
            List<String> cameraPosition = getWarningSearch.getCameraPosition();

            int pageNum = getWarningSearch.getPageNum();
            int pageSize = getWarningSearch.getPageSize();

            // 时间范围查询
            if (startTime != null && !startTime.isEmpty() && endTime != null && !endTime.isEmpty()) {
                RangeQuery rangeQuery = QueryBuilders.range()
                        .field("alertTime")
                        .gte(JsonData.of(startTime))
                        .lte(JsonData.of(endTime))
                        .build();
                boolQueryBuilder.must(rangeQuery._toQuery());
            }

            // 多字段匹配查询
            if (searchText != null && !searchText.isEmpty()) {
                MultiMatchQuery multiMatchQuery = QueryBuilders.multiMatch()
                        .query(searchText)
                        .fields("cameraPosition", "monitoringTask", "alertType", "videoTags")
                        .build();
                boolQueryBuilder.must(multiMatchQuery._toQuery());
            }

            // 告警类型查询
            if (alertTypes != null && !alertTypes.isEmpty()) {
                TermsQuery termsQuery = QueryBuilders.terms()
                        .field("alertType.keyword")
                        .terms(t -> t.value(alertTypes.stream().map(FieldValue::of).collect(Collectors.toList())))
                        .build();
                boolQueryBuilder.must(termsQuery._toQuery());
            }

            // 摄像机点位查询
            if (cameraPosition != null && !cameraPosition.isEmpty()) {
                TermsQuery termsQuery = QueryBuilders.terms()
                        .field("cameraPosition.keyword")
                        .terms(t -> t.value(cameraPosition.stream().map(FieldValue::of).collect(Collectors.toList())))
                        .build();
                boolQueryBuilder.must(termsQuery._toQuery());
            }

            // 构建查询请求
            SearchRequest searchRequest = SearchRequest.of(s -> s
                    .index(esIndex)
                    .query(boolQueryBuilder.build()._toQuery())
                    .from(pageNum * pageSize)
                    .size(pageSize)
                    .sort(so -> so
                            .field(f -> f
                                    .field("alertTime")
                                    .order(SortOrder.Desc)
                            )
                    )
            );



            // 执行查询
            SearchResponse<WarningTable> response = esClient.search(searchRequest, WarningTable.class);

            // 处理查询结果
            List<WarningTable> warningList = new ArrayList<>();
            for (Hit<WarningTable> hit : response.hits().hits()) {
                warningList.add(hit.source());
            }

            // 构建分页结果
            long totalHits = response.hits().total() != null ? response.hits().total().value() : 0;
            return new PageImpl<>(warningList, PageRequest.of(pageNum, pageSize), totalHits);

        } catch (Exception e) {
            e.printStackTrace();
            return Page.empty();
        }
    }

    @Override
    public List<WarningTable> searchByTime(String startTime, String endTime) {

        // 初始化 BoolQuery
        BoolQuery.Builder boolQueryBuilder = new BoolQuery.Builder();

        // 时间范围查询
        if (startTime != null && !startTime.isEmpty() && endTime != null && !endTime.isEmpty()) {
            RangeQuery rangeQuery = QueryBuilders.range()
                    .field("alertTime")
                    .gte(JsonData.of(startTime))
                    .lte(JsonData.of(endTime))
                    .build();
            boolQueryBuilder.must(rangeQuery._toQuery());
        }


        // 构建查询请求
        SearchRequest searchRequest = SearchRequest.of(s -> s
                .index(esIndex)
                .query(boolQueryBuilder.build()._toQuery())
                .sort(so -> so
                        .field(f -> f
                                .field("alertTime")
                                .order(SortOrder.Desc)
                        )
                )
        );

        // 执行查询
        SearchResponse<WarningTable> response = null;
        try {
            response = esClient.search(searchRequest, WarningTable.class);
        } catch (IOException e) {
            logger.error("查询告警信息失败", e);
            return Collections.emptyList();
        }

        // 处理查询结果
        List<WarningTable> warningList = response.hits().hits().stream()
                .map(Hit::source)
                .collect(Collectors.toList());

        return warningList;
    }


    @Override
    public Map<String, Map<String, Long>> getSevenTopAlertTypes() {
        // 获取当前时间
        LocalDateTime now = LocalDateTime.now();
        // 计算七天前的时间
        LocalDateTime sevenDaysAgo = now.minusDays(7);
        // 格式化时间
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String startTime = sevenDaysAgo.atZone(ZoneId.systemDefault()).format(formatter);
        String endTime = now.atZone(ZoneId.systemDefault()).format(formatter);

        // 构建查询请求
        SearchRequest request = SearchRequest.of(s -> s
                .index(esIndex)
                .query(q -> q.range(r -> r.field("alertTime")
                        .gte(JsonData.of(startTime))
                        .lt(JsonData.of(endTime))))
        );

        // 执行查询
        SearchResponse<WarningTable> response = null;
        try {
            response = esClient.search(request, WarningTable.class);
        } catch (IOException e) {
            logger.error("查询失败", e);
            return new HashMap<>();
        }

        // 处理查询结果
        List<WarningTable> warningTables = new ArrayList<>();
        for (Hit<WarningTable> hit : response.hits().hits()) {
            warningTables.add(hit.source());
        }


        // 创建一个Map来存储统计结果
        Map<String, Long> warningsCountByDate = new HashMap<>();

        // 遍历查询结果，统计每个日期的预警数量
        for (WarningTable warningTable : warningTables) {
            LocalDate alertDate = LocalDate.parse(warningTable.getAlertTime(), formatter);
            String dateKey = alertDate.toString();
            warningsCountByDate.put(dateKey, warningsCountByDate.getOrDefault(dateKey, 0L) + 1);
        }

        // 获取过去七天的日期列表
        LocalDate today = LocalDate.now();
        List<String> lastSevenDays = Stream.iterate(today.minusDays(6), date -> date.plusDays(1))
                .limit(7)
                .map(LocalDate::toString)
                .collect(Collectors.toList());

        // 将统计结果与日期列表合并，确保没有预警的日期补0
        Map<String, Long> finalResult = lastSevenDays.stream()
                .collect(Collectors.toMap(
                        date -> date,
                        date -> warningsCountByDate.getOrDefault(date, 0L)
                ));

        // 创建一个Map来存储最终结果
        Map<String, Map<String, Long>> result = new HashMap<>();
        result.put("预警数量", finalResult);

        return result;
    }


    @Override
    public Map<String, Map<String, Long>> getThreeDayTopAlertTypes() {
        // 获取当前时间
        LocalDateTime now = LocalDateTime.now();
        // 计算30天前的时间
        LocalDateTime thirtyDaysAgo = now.minusDays(30);
        // 格式化时间
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String startTime = thirtyDaysAgo.atZone(ZoneId.systemDefault()).format(formatter);
        String endTime = now.atZone(ZoneId.systemDefault()).format(formatter);

        // 构建查询请求
        SearchRequest request = SearchRequest.of(s -> s
                .index(esIndex)
                .query(q -> q.range(r -> r.field("alertTime")
                        .gte(JsonData.of(startTime))
                        .lt(JsonData.of(endTime))))
        );

        // 执行查询
        SearchResponse<WarningTable> response = null;
        try {
            response = esClient.search(request, WarningTable.class);
        } catch (IOException e) {
            logger.error("查询失败", e);
            return new HashMap<>();
        }

        if (response == null || response.hits() == null || response.hits().hits() == null) {
            return new HashMap<>();
        }

        // 处理查询结果
        List<WarningTable> warningTables = new ArrayList<>();
        for (Hit<WarningTable> hit : response.hits().hits()) {
            warningTables.add(hit.source());
        }

        // 创建一个Map来存储统计结果
        Map<String, Long> warningsCountByInterval = new TreeMap<>();

        // 遍历查询结果，统计每个时间间隔的预警数量
        for (WarningTable warningTable : warningTables) {
            LocalDate alertDate = LocalDate.parse(warningTable.getAlertTime(), formatter);
            String intervalKey = getIntervalKey(thirtyDaysAgo, alertDate, 3);
            warningsCountByInterval.put(intervalKey, warningsCountByInterval.getOrDefault(intervalKey, 0L) + 1);
        }

        // 获取过去30天的日期列表，按每三天为一个间隔
        List<String> intervals = generateIntervals(thirtyDaysAgo, now, 3);

        // 将统计结果与日期列表合并，确保没有预警的时间间隔补0
        Map<String, Long> finalResult = intervals.stream()
                .collect(Collectors.toMap(
                        interval -> interval,
                        interval -> warningsCountByInterval.getOrDefault(interval, 0L)
                ));

        // 创建一个Map来存储最终结果
        Map<String, Map<String, Long>> result = new HashMap<>();
        result.put("预警数量", finalResult);

        return result;
    }

    @Override
    public Map<String, Map<String, Long>> getTodayTopAlertTypes() {
        // 获取当前时间
        LocalDateTime now = LocalDateTime.now();
        // 获取当天的开始时间
        LocalDateTime todayStart = now.toLocalDate().atStartOfDay();
        // 获取当天的结束时间
        LocalDateTime todayEnd = todayStart.plusDays(1).minusSeconds(1);
        // 格式化时间
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String startTime = todayStart.atZone(ZoneId.systemDefault()).format(formatter);
        String endTime = todayEnd.atZone(ZoneId.systemDefault()).format(formatter);

        // 构建查询请求
        SearchRequest request = SearchRequest.of(s -> s
                .index(esIndex)
                .query(q -> q.range(r -> r.field("alertTime")
                        .gte(JsonData.of(startTime))
                        .lt(JsonData.of(endTime))))
        );

        // 执行查询
        SearchResponse<WarningTable> response = null;
        try {
            response = esClient.search(request, WarningTable.class);
        } catch (Exception e) {
            logger.error("查询失败", e);
            return new HashMap<>();
        }

        if (response == null || response.hits() == null || response.hits().hits() == null) {
            return new HashMap<>();
        }

        // 处理查询结果
        List<WarningTable> warningTables = new ArrayList<>();
        for (Hit<WarningTable> hit : response.hits().hits()) {
            warningTables.add(hit.source());
        }

        // 创建一个Map来存储统计结果，使用TreeMap来确保按时间排序
        Map<LocalDateTime, Long> warningsCountByHour = new TreeMap<>();

        // 遍历查询结果，统计每两个小时的预警数量
        for (WarningTable warningTable : warningTables) {
            LocalDateTime alertTime = LocalDateTime.parse(warningTable.getAlertTime(), formatter);
            LocalDateTime intervalKey = getTwoHourIntervalKey(alertTime);
            warningsCountByHour.put(intervalKey, warningsCountByHour.getOrDefault(intervalKey, 0L) + 1);
        }

        // 获取当天的每两个小时的时间列表
        List<LocalDateTime> twoHourIntervals = generateTwoHourIntervals(todayStart, todayEnd);

        // 将统计结果与时间列表合并，确保没有预警的时间段补0
        Map<String, Long> finalResult = twoHourIntervals.stream()
                .collect(Collectors.toMap(
                        interval -> interval.format(DateTimeFormatter.ofPattern("HH:mm")),  // 格式化时间为字符串
                        interval -> warningsCountByHour.getOrDefault(interval, 0L)
                ));

        // 创建一个Map来存储最终结果
        Map<String, Map<String, Long>> result = new HashMap<>();
        result.put("预警信息", finalResult);

        return result;
    }




    private WarningTable searchLatest() throws IOException {
        // 创建搜索请求
        SearchRequest request = SearchRequest.of(req -> req
                .index(esIndex)
                .size(1)
                .sort(s -> s.field(f -> f.field("alertTime").order(SortOrder.Desc)))
        );

        // 执行搜索请求
        SearchResponse<WarningTable> response = esClient.search(request, WarningTable.class);

        // 获取搜索结果
        List<Hit<WarningTable>> hits = response.hits().hits();
        if (!hits.isEmpty()) {
            Hit<WarningTable> hit = hits.get(0);
            WarningTable warningTable = hit.source();
            return warningTable;
        } else {
            return null;
        }
    }
    public String generateCameraId() throws IOException {
        WarningTable warningTable = searchLatest();
        SimpleDateFormat sdf = new SimpleDateFormat("MMdd");
        String datePart = sdf.format(new Date());
        String oldId="";
        if (warningTable == null){
            oldId=null;
        }else {
            oldId = warningTable.getAlertId();
        }

        if (oldId == null || oldId.isEmpty()) {
            return "JWD-"+datePart+"-000001";
        }
        int numericPart = Integer.parseInt(oldId.substring(9)) + 1;
        return String.format("JWD-%s-%06d", datePart, numericPart);
    }


    // 辅助方法：生成时间间隔的键
    private String getIntervalKey(LocalDateTime start, LocalDate date, int days) {
        long daysBetween = ChronoUnit.DAYS.between(start.toLocalDate(), date);
        int intervalIndex = (int) (daysBetween / days);
        LocalDateTime intervalStart = start.plusDays(intervalIndex * days);
        LocalDateTime intervalEnd = intervalStart.plusDays(days).minusSeconds(1);
        return intervalStart.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + " to " + intervalEnd.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    // 辅助方法：生成时间间隔列表
    private List<String> generateIntervals(LocalDateTime start, LocalDateTime end, int days) {
        List<String> intervals = new ArrayList<>();
        LocalDateTime current = start;
        while (current.isBefore(end)) {
            LocalDateTime intervalStart = current;
            LocalDateTime intervalEnd = current.plusDays(days).minusSeconds(1);
            intervals.add(intervalStart.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + " to " + intervalEnd.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
            current = current.plusDays(days);
        }
        return intervals;
    }


    // 辅助方法：生成每两个小时的时间段键（使用LocalDateTime）
    private LocalDateTime getTwoHourIntervalKey(LocalDateTime alertTime) {
        int hour = alertTime.getHour();
        int intervalStartHour = (hour / 2) * 2;
        return alertTime.withHour(intervalStartHour).withMinute(0).withSecond(0).withNano(0);
    }

    // 辅助方法：生成当天的每两个小时的时间段列表（返回LocalDateTime）
    private List<LocalDateTime> generateTwoHourIntervals(LocalDateTime start, LocalDateTime end) {
        List<LocalDateTime> intervals = new ArrayList<>();
        LocalDateTime current = start;
        while (current.isBefore(end)) {
            intervals.add(current);
            current = current.plusHours(2);
        }
        return intervals;
    }

}
