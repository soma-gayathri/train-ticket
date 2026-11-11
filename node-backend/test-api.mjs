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

console.log(`PASS: validated ${checked} trains, ${stations.stations.length} major stations, details, schedules, and Sleeper fares.`);
