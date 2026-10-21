package com.railway;

import java.nio.charset.StandardCharsets;
import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import static org.junit.jupiter.api.Assertions.*;

class SampleRouteUpgradeTest {
    @Test void migrationUpgradesExistingDataWithoutResetOrDuplicates() throws Exception {
        var source = new DriverManagerDataSource("jdbc:h2:mem:upgrade-test;DB_CLOSE_DELAY=-1","sa","");
        Flyway.configure().dataSource(source).target("1").load().migrate();
        var jdbc = new JdbcTemplate(source);
        try (var input = new ClassPathResource("sample-data/seed.sql").getInputStream()) {
            String original = new String(input.readAllBytes(),StandardCharsets.UTF_8)
                .split("-- Additional fictional regional demo services\\.")[0]
                .replaceAll("(?m)^--.*$", "").replace("INSERT OR IGNORE INTO", "INSERT INTO");
            for (String sql : original.split(";")) if (!sql.isBlank()) jdbc.execute(sql);
        }
        jdbc.update("UPDATE trains SET name='My edited train' WHERE number='12015'");
        Flyway.configure().dataSource(source).load().migrate();
        assertEquals("My edited train",jdbc.queryForObject("SELECT name FROM trains WHERE number='12015'",String.class));
        assertEquals(97,jdbc.queryForObject("SELECT COUNT(*) FROM trains",Integer.class));
        assertEquals(673,jdbc.queryForObject("SELECT COUNT(*) FROM train_stops",Integer.class));
        assertEquals(0,Flyway.configure().dataSource(source).load().migrate().migrationsExecuted);
    }
}
