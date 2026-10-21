CREATE TABLE `fare_rules` (
	`travel_class` text PRIMARY KEY NOT NULL,
	`label` text NOT NULL,
	`base_paise` integer NOT NULL,
	`per_leg_paise` integer NOT NULL,
	CONSTRAINT "nonnegative_fares" CHECK("fare_rules"."base_paise" >= 0 AND "fare_rules"."per_leg_paise" >= 0)
);
