package com.railway.controller;

import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.server.ResponseStatusException;

@RestControllerAdvice
public class ApiErrors {
    private static final Logger log = LoggerFactory.getLogger(ApiErrors.class);
    @ExceptionHandler(ResponseStatusException.class)
    ResponseEntity<?> status(ResponseStatusException error) {
        return ResponseEntity.status(error.getStatusCode()).body(Map.of("error",error.getReason() == null ? "Request failed." : error.getReason()));
    }
    @ExceptionHandler({MissingServletRequestParameterException.class,MethodArgumentTypeMismatchException.class})
    ResponseEntity<?> invalid(Exception error) {
        return ResponseEntity.badRequest().body(Map.of("error","Provide valid values for all required parameters."));
    }
    @ExceptionHandler(DataAccessException.class)
    ResponseEntity<?> unavailable(DataAccessException error) {
        log.error("Database request failed",error);
        return ResponseEntity.status(503).body(Map.of("error","The database is temporarily unavailable. Please try again."));
    }
}
