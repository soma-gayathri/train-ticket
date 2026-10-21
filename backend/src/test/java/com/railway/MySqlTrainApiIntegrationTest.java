package com.railway;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfEnvironmentVariable;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.dao.DataIntegrityViolationException;
import static org.junit.jupiter.api.Assertions.*;

// Use a separate empty railway_test database. These tests run the real MySQL
// migrations and inherit all HTTP search, schedule, fare, and frontend checks.
@EnabledIfEnvironmentVariable(named="MYSQL_TEST_URL",matches="jdbc:mysql:.*")
@SpringBootTest(webEnvironment=SpringBootTest.WebEnvironment.RANDOM_PORT,properties={
    "spring.datasource.url=${MYSQL_TEST_URL}",
    "spring.datasource.username=${MYSQL_TEST_USERNAME:root}",
    "spring.datasource.password=${MYSQL_TEST_PASSWORD}",
    "spring.flyway.locations=classpath:db/mysql"
})
class MySqlTrainApiIntegrationTest extends TrainApiIntegrationTest {
    @Test void mysqlForeignKeysRejectMissingTrainAndStation() {
        assertEquals(2,jdbc.queryForObject("SELECT COUNT(*) FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=DATABASE() AND TABLE_NAME='train_stops'",Integer.class));
        assertThrows(DataIntegrityViolationException.class,()->jdbc.update(
            "INSERT INTO train_stops (train_number,stop_order,station_code,arrival_day,departure_day) VALUES ('XXXXX',0,'AD',0,0)"));
        assertThrows(DataIntegrityViolationException.class,()->jdbc.update(
            "INSERT INTO train_stops (train_number,stop_order,station_code,arrival_day,departure_day) VALUES ('90001',999,'UNKNOWN',0,0)"));
    }
}
