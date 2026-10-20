CREATE TABLE `stations` (
	`code` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `train_stops` (
	`train_number` text NOT NULL,
	`stop_order` integer NOT NULL,
	`station_code` text NOT NULL,
	`arrival` text,
	`departure` text,
	`arrival_day` integer DEFAULT 0 NOT NULL,
	`departure_day` integer DEFAULT 0 NOT NULL,
	PRIMARY KEY(`train_number`, `stop_order`),
	FOREIGN KEY (`train_number`) REFERENCES `trains`(`number`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`station_code`) REFERENCES `stations`(`code`) ON UPDATE no action ON DELETE no action,
	CONSTRAINT "positive_stop_order" CHECK("train_stops"."stop_order" >= 0),
	CONSTRAINT "nonnegative_days" CHECK("train_stops"."arrival_day" >= 0 AND "train_stops"."departure_day" >= 0)
);
--> statement-breakpoint
CREATE INDEX `train_stops_station_idx` ON `train_stops` (`station_code`,`train_number`);--> statement-breakpoint
CREATE TABLE `trains` (
	`number` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`type` text NOT NULL
);
