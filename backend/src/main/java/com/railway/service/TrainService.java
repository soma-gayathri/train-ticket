package com.railway.service;

import com.railway.dto.TrainModels.*;
import com.railway.repository.TrainRepository;
import java.time.LocalTime;
import java.util.List;
import java.util.Locale;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class TrainService {
    private final TrainRepository repository;
    public TrainService(TrainRepository repository) { this.repository = repository; }
    public List<Station> stations(String query) {
        String prefix = query == null ? "" : query.trim().toLowerCase(Locale.ROOT);
        return repository.stations().stream().filter(s -> s.name().toLowerCase(Locale.ROOT).startsWith(prefix)
            || s.code().toLowerCase(Locale.ROOT).startsWith(prefix)).toList();
    }
    public TrainDetails details(String number) {
        if (!number.matches("[0-9]{5}")) throw bad("Enter a valid five-digit train number.");
        Train train = repository.train(number).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,"Train not found."));
        return new TrainDetails(train.number(),train.name(),train.type(),true,repository.stops(number,0,Integer.MAX_VALUE));
    }
    public List<Journey> search(String fromText, String toText) {
        String from = stationCode(fromText), to = stationCode(toText);
        if (from.equals(to)) throw bad("Choose two different stations.");
        return repository.routes(from,to).stream().map(route -> {
            List<Stop> stops = repository.stops(route.number(),route.first(),route.last());
            Stop first = stops.get(0), last = stops.get(stops.size()-1);
            return new Journey(route.number(),route.name(),route.type(),stops,first,last,
                minutes(last.arrival(),last.arrivalDay())-minutes(first.departure(),first.departureDay()),
                last.arrivalDay()-first.departureDay());
        }).toList();
    }
    public FareQuote fare(String number, String from, String to, String travelClass, int passengers) {
        details(number);
        if (passengers < 1 || passengers > 6) throw bad("Passengers must be between 1 and 6.");
        String normalizedClass = travelClass.trim().toUpperCase(Locale.ROOT);
        FareRule rule = repository.fareRule(normalizedClass).orElseThrow(() -> bad("Choose SL, 3A, 2A, or CC."));
        Journey journey = search(from,to).stream().filter(t -> t.number().equals(number)).findFirst()
            .orElseThrow(() -> bad("This train does not serve that journey in the selected direction."));
        int legs = journey.segment().size()-1;
        long unitFare = rule.basePaise()+rule.perLegPaise()*legs;
        return new FareQuote(number,journey.departure().code(),journey.arrival().code(),rule.travelClass(),
            passengers,"INR",unitFare,unitFare*passengers,legs,true,
            "Illustrative fare based on scheduled stop-to-stop legs. Not a real railway quote or class-availability guarantee.");
    }
    private String stationCode(String value) {
        String code = value.trim().toUpperCase(Locale.ROOT);
        if (!code.matches("[A-Z0-9]{1,10}") || !repository.stationExists(code)) throw bad("Choose a valid station code.");
        return code;
    }
    private int minutes(String time, int day) { return LocalTime.parse(time).toSecondOfDay()/60+day*1440; }
    private ResponseStatusException bad(String message) { return new ResponseStatusException(HttpStatus.BAD_REQUEST,message); }
}
