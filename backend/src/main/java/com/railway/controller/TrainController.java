package com.railway.controller;

import com.railway.service.TrainService;
import java.util.Map;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class TrainController {
    private final TrainService service;
    public TrainController(TrainService service) { this.service = service; }
    @GetMapping("/health") public Map<String,Object> health() { return Map.of("status","ok","sample",true); }
    @GetMapping("/stations") public Object stations(@RequestParam(defaultValue="") String q) {
        return Map.of("stations",service.stations(q));
    }
    @GetMapping("/trains") public Object trains(@RequestParam String from,@RequestParam String to) {
        return Map.of("trains",service.search(from,to));
    }
    @GetMapping("/trains/{number}") public Object details(@PathVariable String number) { return service.details(number); }
    @GetMapping("/trains/{number}/schedule") public Object schedule(@PathVariable String number) { return service.details(number); }
    @GetMapping("/trains/{number}/fare") public Object fare(@PathVariable String number,@RequestParam String from,
        @RequestParam String to,@RequestParam(defaultValue="SL") String travelClass,@RequestParam(defaultValue="1") int passengers) {
        return service.fare(number,from,to,travelClass,passengers);
    }
}
