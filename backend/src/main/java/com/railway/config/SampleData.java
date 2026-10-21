package com.railway.config;

import java.nio.charset.StandardCharsets;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
public class SampleData implements ApplicationRunner {
    private final JdbcTemplate jdbc;
    public SampleData(JdbcTemplate jdbc) { this.jdbc = jdbc; }
    @Override @Transactional public void run(ApplicationArguments arguments) throws Exception {
        if (jdbc.queryForObject("SELECT COUNT(*) FROM stations",Integer.class) > 0) return;
        String sql = new String(new ClassPathResource("sample-data/seed.sql").getInputStream().readAllBytes(),StandardCharsets.UTF_8);
        sql = sql.replaceAll("(?m)^--.*$","").replace("INSERT OR IGNORE INTO","INSERT INTO");
        for (String statement : sql.split(";")) if (!statement.isBlank()) jdbc.execute(statement);
    }
}
