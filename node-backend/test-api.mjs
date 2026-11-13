import assert from "node:assert/strict";

const baseUrl = (process.env.API_BASE_URL || "http://127.0.0.1:3000").replace(/\/$/, "");
const api = async path => {
  const response = await fetch(`${baseUrl}${path}`);
  const body = await response.json();
  assert.equal(response.status, 200, `${path}: ${body.error || "request failed"}`);
  return body;
};
const concurrent = async (items, limit, work) => {
  let next = 0;
  const workers = Array.from({ length: limit }, async () => {
    while (next < items.length) {
      const index = next++;
      await work(items[index]);
    }
  });
  await Promise.all(workers);
};

const catalog = await api("/api/catalog?includeTrains=true");
assert.equal(catalog.trains, 552, "Expected 552 generated demo train services.");
assert.equal(catalog.services.length, 552, "Catalog must include every service.");
const stations = await api("/api/stations");
assert.ok(stations.stations.length >= 30, "Expected major stations in selector.");
assert.ok(stations.stations.every(station => station.code && station.name), "Every major station needs a code and name.");

const routePairs = stations.stations.flatMap(from => stations.stations
  .filter(to => to.code !== from.code)
  .map(to => ({ from, to })));
let checkedRoutes = 0;
await concurrent(routePairs, 12, async ({ from, to }) => {
  const result = await api(`/api/trains?from=${encodeURIComponent(from.code)}&to=${encodeURIComponent(to.code)}`);
  assert.ok(Array.isArray(result.trains), `${from.code} to ${to.code} must return a trains array.`);
  assert.ok(result.trains.every(train => train && train.number && train.name && train.departure && train.arrival && Array.isArray(train.segment)), `${from.code} to ${to.code} returned incomplete train data.`);
  assert.ok(result.trains.every(train => train.departure.code === from.code && train.arrival.code === to.code), `${from.code} to ${to.code} returned a city-area train that does not stop at the selected stations.`);
  checkedRoutes += 1;
});

let checked = 0;
await concurrent(catalog.services, 12, async service => {
  const details = await api(`/api/trains/${encodeURIComponent(service.number)}`);
  assert.equal(details.number, service.number, "Train detail number must match catalog.");
  assert.ok(details.name, "Train name is required.");
  assert.ok(details.stops.length >= 2, "A train needs at least two stops.");
  assert.ok(details.stops.every(stop => stop.code && stop.name), "Every stop needs a code and name.");

  const schedule = await api(`/api/trains/${encodeURIComponent(service.number)}/schedule`);
  assert.ok(schedule.stops.length >= 2, "Schedule needs at least two stops.");
  const from = schedule.stops[0].code;
  const to = schedule.stops.at(-1).code;
  const fare = await api(`/api/trains/${encodeURIComponent(service.number)}/fare?from=${encodeURIComponent(from)}&to=${encodeURIComponent(to)}&travelClass=SL&passengers=1`);
  assert.ok(Number.isInteger(fare.estimatedDistanceKm) && fare.estimatedDistanceKm > 0, "Fare needs a positive route distance.");
  assert.ok(Number.isInteger(fare.totalFarePaise) && fare.totalFarePaise > 0, "Fare must be a positive paise amount.");
  checked += 1;
});

console.log(`PASS: validated ${checked} trains, ${stations.stations.length} major stations, ${checkedRoutes} From/To searches, details, schedules, and Sleeper fares.`);
