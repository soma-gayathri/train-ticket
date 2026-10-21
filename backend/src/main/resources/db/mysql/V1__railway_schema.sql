-- MySQL 8.0.16+ / 8.4. InnoDB enforces the explicit foreign keys.
CREATE TABLE stations (
  code VARCHAR(10) PRIMARY KEY,
  name VARCHAR(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE trains (
  number VARCHAR(10) PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  type VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE train_stops (
  train_number VARCHAR(10) NOT NULL,
  stop_order INTEGER NOT NULL CHECK (stop_order >= 0),
  station_code VARCHAR(10) NOT NULL,
  arrival VARCHAR(5),
  departure VARCHAR(5),
  arrival_day INTEGER NOT NULL DEFAULT 0 CHECK (arrival_day >= 0),
  departure_day INTEGER NOT NULL DEFAULT 0 CHECK (departure_day >= 0),
  PRIMARY KEY (train_number, stop_order),
  CONSTRAINT fk_stops_train FOREIGN KEY (train_number) REFERENCES trains(number),
  CONSTRAINT fk_stops_station FOREIGN KEY (station_code) REFERENCES stations(code),
  INDEX train_stops_station_idx (station_code, train_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE fare_rules (
  travel_class VARCHAR(10) PRIMARY KEY,
  label VARCHAR(60) NOT NULL,
  base_paise BIGINT NOT NULL CHECK (base_paise >= 0),
  per_leg_paise BIGINT NOT NULL CHECK (per_leg_paise >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
