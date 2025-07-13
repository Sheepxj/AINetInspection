package com.yys.repository;
import com.yys.entity.JobRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface JobRecordRepository extends JpaRepository<JobRecord, Long> {

    JobRecord findByJobNameAndJobGroup(String jobName, String jobGroup);


}
