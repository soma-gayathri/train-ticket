import { sqliteTable, text, integer, primaryKey, index, check } from 'drizzle-orm/sqlite-core';
import { sql } from 'drizzle-orm';
export const stations = sqliteTable('stations', {
  code: text('code').primaryKey(), name: text('name').notNull(),
});
export const trains = sqliteTable('trains', {
  number: text('number').primaryKey(), name: text('name').notNull(), type: text('type').notNull(),
});
export const trainStops = sqliteTable('train_stops', {
  trainNumber: text('train_number').notNull().references(() => trains.number),
  stopOrder: integer('stop_order').notNull(),
  stationCode: text('station_code').notNull().references(() => stations.code),
  arrival: text('arrival'), departure: text('departure'),
  arrivalDay: integer('arrival_day').notNull().default(0),
  departureDay: integer('departure_day').notNull().default(0),
}, table => [
  primaryKey({ columns: [table.trainNumber, table.stopOrder] }),
  index('train_stops_station_idx').on(table.stationCode, table.trainNumber),
  check('positive_stop_order', sql`${table.stopOrder} >= 0`),
  check('nonnegative_days', sql`${table.arrivalDay} >= 0 AND ${table.departureDay} >= 0`),
]);
