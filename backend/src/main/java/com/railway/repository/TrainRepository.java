package com.railway.repository;

import com.railway.dto.TrainModels.*;
import java.util.List;
import java.util.Optional;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class TrainRepository {
    private final JdbcTemplate jdbc;
    public TrainRepository(JdbcTemplate jdbc) { this.jdbc = jdbc; }

    public List<Station> stations() {
        return jdbc.query("SELECT code, name FROM stations ORDER BY name",
            (rs, row) -> new Station(rs.getString("code"), rs.getString("name")));
    }
    public boolean stationExists(String code) {
        return jdbc.queryForObject("SELECT COUNT(*) FROM stations WHERE code = ?", Integer.class, code) == 1;
    }
    public Optional<Train> train(String number) {
        return jdbc.query("SELECT number, name, type FROM trains WHERE number = ?",
            (rs,row) -> new Train(rs.getString("number"),rs.getString("name"),rs.getString("type")), number).stream().findFirst();
    }
    public List<Stop> stops(String number, int first, int last) {
        return jdbc.query("""
            SELECT s.station_code, p.name, s.arrival, s.departure, s.arrival_day, s.departure_day, s.stop_order
            FROM train_stops s JOIN stations p ON p.code = s.station_code
            WHERE s.train_number = ? AND s.stop_order BETWEEN ? AND ? ORDER BY s.stop_order
            """, (rs,row) -> new Stop(rs.getString("station_code"),rs.getString("name"),
                rs.getString("arrival"),rs.getString("departure"),rs.getInt("arrival_day"),
                rs.getInt("departure_day"),rs.getInt("stop_order")),number,first,last);
    }
    public List<RouteMatch> routes(String from, String to) {
        return jdbc.query("""
            SELECT t.number, t.name, t.type, src.stop_order AS first_stop, dst.stop_order AS last_stop
            FROM trains t JOIN train_stops src ON src.train_number = t.number AND src.station_code = ?
            JOIN train_stops dst ON dst.train_number = t.number AND dst.station_code = ?
            WHERE src.stop_order < dst.stop_order ORDER BY src.departure, t.number
            """, (rs,row) -> new RouteMatch(rs.getString("number"),rs.getString("name"),rs.getString("type"),
                rs.getInt("first_stop"),rs.getInt("last_stop")),from,to);
    }
    public Optional<FareRule> fareRule(String travelClass) {
        return jdbc.query("SELECT travel_class, label, base_paise, per_leg_paise FROM fare_rules WHERE travel_class = ?",
            (rs,row) -> new FareRule(rs.getString("travel_class"),rs.getString("label"),
                rs.getLong("base_paise"),rs.getLong("per_leg_paise")),travelClass).stream().findFirst();
    }
}
