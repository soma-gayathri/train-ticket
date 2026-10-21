package com.railway;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.jdbc.core.JdbcTemplate;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(webEnvironment=SpringBootTest.WebEnvironment.RANDOM_PORT,properties={
    "spring.datasource.url=jdbc:h2:mem:railway-test;DB_CLOSE_DELAY=-1", "spring.datasource.username=sa", "spring.datasource.password="
})
class TrainApiIntegrationTest {
    @LocalServerPort int port;
    @Autowired JdbcTemplate jdbc;
    private final HttpClient client = HttpClient.newHttpClient();
    private final JsonMapper json = new JsonMapper();
    private HttpResponse<String> get(String path) throws Exception {
        return client.send(HttpRequest.newBuilder(URI.create("http://127.0.0.1:"+port+path)).GET().build(),HttpResponse.BodyHandlers.ofString());
    }
    private JsonNode body(String path) throws Exception {
        var response = get(path); assertEquals(200,response.statusCode(),response.body()); return json.readTree(response.body());
    }
    @Test void databaseAndFrontendAreReady() throws Exception {
        assertEquals(212,jdbc.queryForObject("SELECT COUNT(*) FROM stations",Integer.class));
        assertEquals(11,jdbc.queryForObject("SELECT COUNT(*) FROM trains",Integer.class));
        assertEquals(69,jdbc.queryForObject("SELECT COUNT(*) FROM train_stops",Integer.class));
        assertEquals(4,jdbc.queryForObject("SELECT COUNT(*) FROM fare_rules",Integer.class));
        assertEquals("ok",body("/api/health").path("status").asText());
        assertEquals("api",body("/config.json").path("dataSource").asText());
        assertTrue(get("/").body().contains("pages/bootstrap.js"));
        assertEquals(212,body("/api/stations").path("stations").size());
    }
    @Test void routeQueriesRespectDirectionAndIntermediateStations() throws Exception {
        assertEquals(3,body("/api/trains?from=ndls&to=jp").path("trains").size());
        JsonNode trains = body("/api/trains?from=GGN&to=AWR").path("trains");
        assertEquals(2,trains.size()); assertEquals(3,trains.get(0).path("segment").size());
        assertEquals("GGN",trains.get(0).path("departure").path("code").asText());
        assertEquals("AWR",trains.get(0).path("arrival").path("code").asText());
        assertEquals(1,body("/api/trains?from=JP&to=NDLS").path("trains").size());
        assertEquals(0,body("/api/trains?from=NDLS&to=HX").path("trains").size());
    }
    @Test void overnightDurationsAndFullSchedulesAreCorrect() throws Exception {
        JsonNode trains = body("/api/trains?from=SBC&to=MAS").path("trains");
        JsonNode overnight = null;
        for (JsonNode train : trains) if (train.path("number").asText().equals("12658")) overnight = train;
        assertNotNull(overnight); assertEquals(360,overnight.path("duration").asInt()); assertEquals(1,overnight.path("dayDifference").asInt());
        JsonNode details = body("/api/trains/12015"); assertTrue(details.path("sample").asBoolean());
        JsonNode stops = body("/api/trains/12015/schedule").path("stops");
        assertEquals(9,stops.size()); assertEquals("NDLS",stops.get(0).path("code").asText()); assertEquals("AII",stops.get(8).path("code").asText());
    }
    @Test void faresUseDatabaseRulesAndIntegerPaise() throws Exception {
        JsonNode quote = body("/api/trains/12015/fare?from=NDLS&to=JP&travelClass=SL&passengers=2");
        assertEquals(19000,quote.path("unitFarePaise").asLong()); assertEquals(38000,quote.path("totalFarePaise").asLong());
        assertEquals("INR",quote.path("currency").asText()); assertTrue(quote.path("sample").asBoolean());
        JsonNode middle = body("/api/trains/12015/fare?from=GGN&to=AWR&travelClass=SL"); assertEquals(9000,middle.path("totalFarePaise").asLong());
    }
    @Test void badInputAndUnknownTrainsReturnClearErrors() throws Exception {
        for (String path : new String[]{"/api/trains?from=NDLS&to=NDLS", "/api/trains?from=unknown&to=JP", "/api/trains?from=NDLS",
            "/api/trains/12015/fare?from=NDLS&to=JP&passengers=0", "/api/trains/12015/fare?from=NDLS&to=JP&passengers=7",
            "/api/trains/12015/fare?from=NDLS&to=JP&travelClass=BAD", "/api/trains/12015/fare?from=JP&to=NDLS"}) {
            var response = get(path); assertEquals(400,response.statusCode(),path); assertTrue(json.readTree(response.body()).has("error"));
        }
        assertEquals(404,get("/api/trains/99999").statusCode());
    }
    @Test void onlyConfiguredFrontendOriginsAreAllowed() throws Exception {
        var allowed = client.send(HttpRequest.newBuilder(URI.create("http://127.0.0.1:"+port+"/api/stations"))
            .header("Origin","https://soma-gayathri.github.io").GET().build(),HttpResponse.BodyHandlers.ofString());
        assertEquals("https://soma-gayathri.github.io",allowed.headers().firstValue("Access-Control-Allow-Origin").orElse(""));
        var denied = client.send(HttpRequest.newBuilder(URI.create("http://127.0.0.1:"+port+"/api/stations"))
            .header("Origin","https://other.example").GET().build(),HttpResponse.BodyHandlers.ofString());
        assertTrue(denied.headers().firstValue("Access-Control-Allow-Origin").isEmpty());
    }
}
