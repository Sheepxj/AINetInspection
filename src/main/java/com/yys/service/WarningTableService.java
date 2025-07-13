package com.yys.service;

import com.yys.entity.GetWarningSearch;
import com.yys.entity.estable.WarningTable;
import org.springframework.data.domain.Page;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface WarningTableService {

    WarningTable saveWarningTable(WarningTable warningTable);

    WarningTable getWarningTable(String Id) throws IOException;

    WarningTable searchByAlertId(String alertId);

    List<WarningTable> searchWithSort();

    Page<WarningTable> searchByAlertTypes(GetWarningSearch getWarningSearch);

    List<WarningTable> searchByTime(String startTime, String endTime);

    Map<String, Map<String, Long>> getSevenTopAlertTypes();
    Map<String, Map<String, Long>> getThreeDayTopAlertTypes();
    Map<String, Map<String, Long>> getTodayTopAlertTypes();

    Map<String, Integer> getalertTypes();

    Map<String, Integer> getcameraPosition();

}
