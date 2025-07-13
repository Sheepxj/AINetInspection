package com.yys.service;

import com.yys.entity.estable.WarningTable;

import java.util.List;

public interface EmailService {

    boolean sendEmail(String to, List<WarningTable> warningTables);
}


