package com.railway.dto;

import java.util.List;

public final class TrainModels {
    private TrainModels() {}
    public record Station(String code, String name) {}
    public record Stop(String code, String name, String arrival, String departure,
                       int arrivalDay, int departureDay, int stopOrder) {}
    public record Train(String number, String name, String type) {}
    public record TrainDetails(String number, String name, String type, boolean sample, List<Stop> stops) {}
    public record Journey(String number, String name, String type, List<Stop> segment,
                          Stop departure, Stop arrival, int duration, int dayDifference) {}
    public record RouteMatch(String number, String name, String type, int first, int last) {}
    public record FareRule(String travelClass, String label, long basePaise, long perLegPaise) {}
    public record FareQuote(String trainNumber, String from, String to, String travelClass,
                            int passengers, String currency, long unitFarePaise, long totalFarePaise,
                            int legs, boolean sample, String disclaimer) {}
}
