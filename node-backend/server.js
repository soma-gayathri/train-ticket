
require("dotenv").config();

const express = require("express");
const crypto = require("crypto");
const fs = require("fs");
const path = require("path");
const { DatabaseSync } = require("node:sqlite");
const app = express();
const PORT = Number(process.env.PORT || 3000);
const projectDirectory = path.resolve(__dirname, "..");
const frontendDirectory = path.join(projectDirectory, "frontend");
const seedFile = path.join(projectDirectory, "db/seed.sql");
const railpullScheduleFile = process.env.RAILPULL_SCHEDULE_FILE || path.resolve(__dirname, "../railpull/data/out/schedules.jsonl");
const dataDirectory = path.join(__dirname, "data");
const usersFile = path.join(dataDirectory, "users.json");
fs.mkdirSync(dataDirectory, { recursive: true });
const bookingDatabase = new DatabaseSync(path.join(dataDirectory, "railway-demo.sqlite"));
bookingDatabase.exec(`
  CREATE TABLE IF NOT EXISTS bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pnr TEXT NOT NULL UNIQUE,
    train_number TEXT NOT NULL,
    train_name TEXT NOT NULL,
    travel_class TEXT NOT NULL,
    total_amount INTEGER NOT NULL,
    created_at TEXT NOT NULL
  );
  CREATE TABLE IF NOT EXISTS booking_passengers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    age INTEGER NOT NULL,
    gender TEXT NOT NULL,
    berth_preference TEXT NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
  );
`);
try { bookingDatabase.exec("ALTER TABLE bookings ADD COLUMN viewer_key TEXT"); } catch {}
try { bookingDatabase.exec("ALTER TABLE bookings ADD COLUMN from_station TEXT"); } catch {}
try { bookingDatabase.exec("ALTER TABLE bookings ADD COLUMN to_station TEXT"); } catch {}
try { bookingDatabase.exec("ALTER TABLE bookings ADD COLUMN travel_date TEXT"); } catch {}
bookingDatabase.exec("CREATE INDEX IF NOT EXISTS bookings_viewer_key ON bookings(viewer_key)");
const sessions = new Map();

const allowedOrigins = new Set([
  "https://soma-gayathri.github.io",
  "http://localhost:3000",
  "http://127.0.0.1:3000"
]);
app.use((request, response, next) => {
  const origin = request.headers.origin;
  if (origin && allowedOrigins.has(origin)) {
    response.setHeader("Access-Control-Allow-Origin", origin);
    response.setHeader("Vary", "Origin");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept, ngrok-skip-browser-warning");
  }
  if (request.method === "OPTIONS") return response.sendStatus(204);
  next();
});

function readUsers() { if (!fs.existsSync(usersFile)) return []; return JSON.parse(fs.readFileSync(usersFile, "utf8")); }
function writeUsers(users) { fs.mkdirSync(dataDirectory, { recursive: true }); fs.writeFileSync(usersFile, JSON.stringify(users, null, 2), { mode: 0o600 }); }
function hashPassword(password, salt = crypto.randomBytes(16).toString("hex")) { return new Promise((resolve, reject) => crypto.scrypt(password, salt, 64, (error, key) => error ? reject(error) : resolve({ salt, hash: key.toString("hex") }))); }
function readCookies(request) { return Object.fromEntries((request.headers.cookie || "").split(";").filter(Boolean).map(part => { const index = part.indexOf("="); return [part.slice(0, index).trim(), decodeURIComponent(part.slice(index + 1))]; })); }
function currentUser(request) { const token = readCookies(request).railway_session; const session = token && sessions.get(token); if (!session || session.expiresAt < Date.now()) { if (token) sessions.delete(token); return null; } return readUsers().find(user => user.id === session.userId) || null; }
function publicUser(user) { return { name: user.name, email: user.email }; }
function setSession(response, user) { const token = crypto.randomBytes(32).toString("hex"); sessions.set(token, { userId: user.id, expiresAt: Date.now() + 604800000 }); const secure = process.env.NODE_ENV === "production" ? "; Secure" : ""; response.setHeader("Set-Cookie", `railway_session=${token}; HttpOnly; SameSite=Lax; Path=/; Max-Age=604800${secure}`); }
function clearSession(request, response) { const token = readCookies(request).railway_session; if (token) sessions.delete(token); response.setHeader("Set-Cookie", "railway_session=; HttpOnly; SameSite=Lax; Path=/; Max-Age=0"); }

app.use(express.json({ limit: "10kb" }));

function blockFor(table) {
  const source = fs.readFileSync(seedFile, "utf8");
  const match = source.match(new RegExp(`INSERT OR IGNORE INTO ${table}[\\s\\S]*?;`));
  return match ? match[0] : "";
}
function unquote(value) { return value === "NULL" ? null : value.slice(1, -1); }
function cleanRailpullTime(value) {
  const time = String(value || "").trim();
  return /^\d{2}:\d{2}$/.test(time) ? time : null;
}
function loadRailpullSchedules() {
  if (!fs.existsSync(railpullScheduleFile)) return null;
  try {
    const rows = fs.readFileSync(railpullScheduleFile, "utf8").split(/\r?\n/).filter(Boolean).map(line => JSON.parse(line));
    const stations = new Map();
    const trains = rows.map(record => ({
      number: String(record.number), name: record.name || `Train ${record.number}`,
      type: record.type_label || record.type || "Railway service",
      stops: (record.stops || []).map((stop, index) => {
        const code = String(stop.code || "").trim().toUpperCase();
        const name = String(stop.name || code).trim();
        if (code) stations.set(code, { code, name });
        return { order: Number(stop.seq) || index + 1, code, arrival: cleanRailpullTime(stop.arr), departure: cleanRailpullTime(stop.dep), arrivalDay: Math.max(0, Number(stop.day || 1) - 1), departureDay: Math.max(0, Number(stop.day || 1) - 1) };
      }).filter(stop => stop.code)
    })).filter(train => train.stops.length >= 2);
    if (!trains.length) return null;
    const directory = [...stations.values()].sort((a, b) => a.name.localeCompare(b.name));
    return { stations: directory, trains, stationByCode: new Map(directory.map(station => [station.code, station])), source: "railpull" };
  } catch (error) {
    console.warn("Railpull timetable file could not be read; using sample schedules.", error.message);
    return null;
  }
}
function loadSchedules() {
  const railpull = loadRailpullSchedules();
  if (railpull) return railpull;
  const stations = [...blockFor("stations").matchAll(/\('([^']+)', '([^']+)'\)/g)].map(([, code, name]) => ({ code, name }));
  const trains = [...blockFor("trains").matchAll(/\('([^']+)', '([^']+)', '([^']+)'\)/g)].map(([, number, name, type]) => ({ number, name, type, stops: [] }));
  const byNumber = new Map(trains.map(train => [train.number, train]));
  const pattern = /\('([^']+)', (\d+), '([^']+)', (NULL|'[^']+'), (NULL|'[^']+'), (\d+), (\d+)\)/g;
  for (const [, number, order, code, arrival, departure, arrivalDay, departureDay] of blockFor("train_stops").matchAll(pattern)) {
    byNumber.get(number)?.stops.push({ order: Number(order), code, arrival: unquote(arrival), departure: unquote(departure), arrivalDay: Number(arrivalDay), departureDay: Number(departureDay) });
  }
  for (const train of trains) train.stops.sort((a, b) => a.order - b.order);
  return { stations, trains, stationByCode: new Map(stations.map(station => [station.code, station])), source: "sample" };
}
function shiftTime(time, day, offsetMinutes) {
  if (!time) return { time: null, day };
  const [hours, minutes] = time.split(":").map(Number);
  const absolute = ((day * 24 + hours) * 60) + minutes + offsetMinutes;
  const shiftedDay = Math.floor(absolute / 1440);
  const withinDay = ((absolute % 1440) + 1440) % 1440;
  return { time: `${String(Math.floor(withinDay / 60)).padStart(2, "0")}:${String(withinDay % 60).padStart(2, "0")}`, day: shiftedDay };
}
function createDemoServices(base, targetCount = 552) {
  if (base.trains.length >= targetCount) return base;
  const trains = [...base.trains];
  const categories = ["Superfast Express", "Mail/Express", "Intercity Express", "AC Express", "Passenger Express"];
  let generated = 0;
  while (trains.length < targetCount) {
    const template = base.trains[generated % base.trains.length];
    const offsetMinutes = 35 + ((generated * 79) % 1080);
    const number = String(70001 + generated);
    const stops = template.stops.map(stop => {
      const arrival = shiftTime(stop.arrival, stop.arrivalDay, offsetMinutes);
      const departure = shiftTime(stop.departure, stop.departureDay, offsetMinutes);
      return { ...stop, arrival: arrival.time, arrivalDay: arrival.day, departure: departure.time, departureDay: departure.day };
    });
    trains.push({ number, name: `${template.name} Demo Service ${generated + 1}`, type: categories[generated % categories.length], stops });
    generated += 1;
  }
  return { ...base, trains, source: `${base.source}-demo-${targetCount}` };
}
const schedules = createDemoServices(loadSchedules());
const majorStationNames = new Map([
  ["NDLS", "New Delhi"], ["MMCT", "Mumbai Central"], ["CSMT", "Mumbai CSMT"],
  ["MAS", "Chennai Central"], ["SBC", "Bengaluru"], ["HYB", "Hyderabad"],
  ["SC", "Secunderabad"], ["HWH", "Kolkata Howrah"], ["PUNE", "Pune"],
  ["JP", "Jaipur"], ["ADI", "Ahmedabad"], ["BZA", "Vijayawada"],
  ["VSKP", "Visakhapatnam"], ["BPL", "Bhopal"], ["NGP", "Nagpur"],
  ["CNB", "Kanpur Central"], ["BBS", "Bhubaneswar"], ["TVC", "Thiruvananthapuram"],
  ["MYS", "Mysuru"], ["ASR", "Amritsar"], ["BRC", "Vadodara"],
  ["BSP", "Bilaspur"], ["CBE", "Coimbatore"], ["GAYA", "Gaya"],
  ["GHY", "Guwahati"], ["GTL", "Guntakal"], ["JAT", "Jammu Tawi"],
  ["KOTA", "Kota"], ["MTJ", "Mathura"], ["NJP", "New Jalpaiguri"],
  ["ST", "Surat"], ["TATA", "Tatanagar"], ["UBL", "Hubballi"],
  ["UJN", "Ujjain"], ["YPR", "Yesvantpur"]
]);
const majorStations = [...majorStationNames].map(([code, name]) => schedules.stationByCode.has(code) ? { code, name } : null).filter(Boolean);
const fareRules = {
  SL: { base: 9000, perKm: 32 },
  "3A": { base: 30000, perKm: 70 },
  "2A": { base: 45000, perKm: 105 },
  CC: { base: 18000, perKm: 45 }
};
const railRadarApiKey = process.env.USE_RAILRADAR === "true" ? process.env.RAILRADAR_API_KEY : "";
let railRadarStations;

async function railRadar(path) {
  const response = await fetch(`https://api.railradar.in/v1${path}`, { headers: { Authorization: `Bearer ${railRadarApiKey}`, Accept: "application/json" } });
  const body = await response.json();
  if (!response.ok || body.success === false) throw new Error(body.error?.message || "RailRadar could not return live train data.");
  return body.data;
}
async function liveStations() {
  if (railRadarStations) return railRadarStations;
  const directory = await railRadar("/lookup/stations");
  railRadarStations = Array.isArray(directory) ? directory.map(item => ({ code: item.code, name: item.name })) : Object.entries(directory).map(([code, name]) => ({ code, name }));
  return railRadarStations;
}
function liveStop(code, name, arrival, departure, arrivalDay, departureDay) { return { code, name, arrival: arrival || null, departure: departure || null, arrivalDay: Number(arrivalDay || 1) - 1, departureDay: Number(departureDay || 1) - 1 }; }
function minutesAt(time, day) { const [hours, minutes] = time.split(":").map(Number); return day * 1440 + hours * 60 + minutes; }
function fullStop(stop) { return { ...stop, name: schedules.stationByCode.get(stop.code)?.name || stop.code }; }
const cityTerminals = [
  ["NDLS", "NZM", "DEE", "DLI", "DEC", "ANVT"],
  ["MMCT", "BCT", "CSMT", "LTT", "BDTS"],
  ["MAS", "MS", "TBM", "PER"],
  ["SBC", "YPR", "BNC", "KJM"],
  ["HYB", "SC", "KCG", "LPI", "CHZ"],
  ["HWH", "KOAA", "SDAH"],
  ["PUNE"], ["JP"], ["ADI"], ["BZA"]
];
function matchingTerminals(code) { return cityTerminals.find(group => group.includes(code)) || [code]; }
function journey(train, from, to) {
  const fromCodes = matchingTerminals(from); const toCodes = matchingTerminals(to);
  const start = train.stops.findIndex(stop => fromCodes.includes(stop.code));
  const end = train.stops.findIndex((stop, index) => index > start && toCodes.includes(stop.code));
  if (start < 0 || end < 0) return null;
  const departure = train.stops[start]; const arrival = train.stops[end];
  if (!departure.departure || !arrival.arrival) return null;
  return { number: train.number, name: train.name, type: train.type, departure: fullStop(departure), arrival: fullStop(arrival), segment: train.stops.slice(start, end + 1).map(fullStop), duration: minutesAt(arrival.arrival, arrival.arrivalDay) - minutesAt(departure.departure, departure.departureDay), dayDifference: arrival.arrivalDay - departure.departureDay };
}

app.get("/api/health", (req, res) => res.json({ ok: true, backend: "Express", dataSource: schedules.source }));
app.get("/api/auth/me", (req, res) => { const user = currentUser(req); if (!user) return res.status(401).json({ error: "You are not signed in." }); res.json({ user: publicUser(user) }); });
app.post("/api/auth/register", async (req, res) => {
  const name = String(req.body?.name || "").trim(); const email = String(req.body?.email || "").trim().toLowerCase(); const password = String(req.body?.password || "");
  if (name.length < 2 || name.length > 60 || !/^\S+@\S+\.\S+$/.test(email) || password.length < 8) return res.status(400).json({ error: "Enter your name, a valid email, and a password with at least 8 characters." });
  const users = readUsers(); if (users.some(user => user.email === email)) return res.status(409).json({ error: "An account already exists for this email." });
  const user = { id: crypto.randomUUID(), name, email, ...(await hashPassword(password)), createdAt: new Date().toISOString() }; users.push(user); writeUsers(users); setSession(res, user); res.status(201).json({ user: publicUser(user) });
});
app.post("/api/auth/login", async (req, res) => {
  const email = String(req.body?.email || "").trim().toLowerCase(); const password = String(req.body?.password || ""); const user = readUsers().find(item => item.email === email);
  if (!user) return res.status(401).json({ error: "Email or password is incorrect." }); const passwordData = await hashPassword(password, user.salt);
  if (!crypto.timingSafeEqual(Buffer.from(passwordData.hash, "hex"), Buffer.from(user.hash, "hex"))) return res.status(401).json({ error: "Email or password is incorrect." });
  setSession(res, user); res.json({ user: publicUser(user) });
});
app.post("/api/auth/logout", (req, res) => { clearSession(req, res); res.status(204).end(); });
app.get("/api/stations", async (req, res) => {
  const query = String(req.query.query || "").trim().toLowerCase();
  try {
    const useRailRadar = railRadarApiKey && !schedules.source.startsWith("railpull");
    const directory = useRailRadar ? await liveStations() : (req.query.all === "true" ? schedules.stations : majorStations);
    const stations = !query ? directory : directory.filter(station => station.code.toLowerCase().includes(query) || station.name.toLowerCase().includes(query));
    res.json({ stations, source: useRailRadar ? "railradar" : schedules.source });
  } catch (error) { res.status(502).json({ error: error.message }); }
});
app.get("/api/trains", async (req, res) => {
  const from = String(req.query.from || "").trim().toUpperCase(); const to = String(req.query.to || "").trim().toUpperCase();
  if (!from || !to || from === to) return res.status(400).json({ error: "Choose two different valid stations." });
  try {
    if (railRadarApiKey && !schedules.source.startsWith("railpull")) {
      const data = await railRadar(`/trains/between/${encodeURIComponent(from)}/${encodeURIComponent(to)}?byCity=true`);
      const trains = (data.trains || []).map(item => {
        const train = item.train || {}; const departure = liveStop(from, data.from?.name || from, null, item.from?.departure, item.from?.day, item.from?.day); const arrival = liveStop(to, data.to?.name || to, item.to?.arrival, null, item.to?.day, item.to?.day);
        return { number: String(train.number), name: train.name, type: train.type || train.category || "Railway service", departure, arrival, segment: [departure, arrival], duration: Number(item.duration || 0), dayDifference: Math.max(0, Number(item.to?.day || 1) - Number(item.from?.day || 1)) };
      });
      return res.json({ trains, source: "railradar" });
    }
    if (!schedules.stationByCode.has(from) || !schedules.stationByCode.has(to)) return res.status(400).json({ error: "Choose two different valid stations." });
    res.json({ trains: schedules.trains.map(train => journey(train, from, to)).filter(Boolean), source: schedules.source });
  } catch (error) { res.status(502).json({ error: error.message }); }
});
app.get("/api/trains/:number", async (req, res) => {
  if (railRadarApiKey && !schedules.source.startsWith("railpull")) {
    try { const data = await railRadar(`/trains/${encodeURIComponent(req.params.number)}?haltsOnly=true`); const train = data.train || {}; const stops = (data.route || []).map(stop => liveStop(stop.station?.code, stop.station?.name, stop.arrival, stop.departure, stop.arrivalDay, stop.departureDay)); return res.json({ number: String(train.number), name: train.name, type: train.type || train.category, stops, source: "railradar" }); } catch (error) { return res.status(502).json({ error: error.message }); }
  }
  const train = schedules.trains.find(item => item.number === req.params.number);
  if (!train) return res.status(404).json({ error: "Sample train not found." });
  res.json({ number: train.number, name: train.name, type: train.type, stops: train.stops.map(fullStop) });
});
app.get("/api/trains/:number/schedule", async (req, res) => {
  if (railRadarApiKey && !schedules.source.startsWith("railpull")) {
    try { const data = await railRadar(`/trains/${encodeURIComponent(req.params.number)}?haltsOnly=true`); const train = data.train || {}; const stops = (data.route || []).map(stop => liveStop(stop.station?.code, stop.station?.name, stop.arrival, stop.departure, stop.arrivalDay, stop.departureDay)); return res.json({ number: String(train.number), name: train.name, type: train.type || train.category, stops, source: "railradar" }); } catch (error) { return res.status(502).json({ error: error.message }); }
  }
  const train = schedules.trains.find(item => item.number === req.params.number);
  if (!train) return res.status(404).json({ error: "Sample train not found." });
  res.json({ number: train.number, name: train.name, type: train.type, stops: train.stops.map(fullStop) });
});
app.get("/api/trains/:number/fare", (req, res) => {
  const train = schedules.trains.find(item => item.number === req.params.number); const from = String(req.query.from || "").toUpperCase(); const to = String(req.query.to || "").toUpperCase(); const rule = fareRules[req.query.travelClass]; const passengers = Number(req.query.passengers); const trip = train && journey(train, from, to);
  if (!trip || !rule || !Number.isInteger(passengers) || passengers < 1 || passengers > 6) return res.status(400).json({ error: "Choose a valid journey, class, and 1 to 6 passengers." });
  const estimatedDistanceKm = Math.min(2500, Math.max(110, (trip.segment.length - 1) * 65));
  const unitFarePaise = Math.round(rule.base + rule.perKm * estimatedDistanceKm);
  res.json({ currency: "INR", passengers, estimatedDistanceKm, unitFarePaise, totalFarePaise: unitFarePaise * passengers, disclaimer: "Reasonable illustrative demo fare only; this is not an official railway fare." });
});
app.get("/api/catalog", (req, res) => res.json({ trains: schedules.trains.length, stations: schedules.stations.length, dataSource: schedules.source, note: "Generated demo timetable data with illustrative fares; not live IRCTC information." }));
app.post("/api/bookings", (req, res) => {
  const trainNumber = String(req.body?.trainNumber || "").trim();
  const trainName = String(req.body?.trainName || "").trim();
  const travelClass = String(req.body?.travelClass || "").trim();
  const pnr = String(req.body?.pnr || "").trim();
  const viewerKey = String(req.body?.viewerKey || "").trim();
  const fromStation = String(req.body?.fromStation || "").trim();
  const toStation = String(req.body?.toStation || "").trim();
  const travelDate = String(req.body?.travelDate || "").trim();
  const totalAmount = Number(req.body?.totalAmount);
  const passengers = Array.isArray(req.body?.passengers) ? req.body.passengers : [];
  if (!trainNumber || !trainName || !travelClass || !fromStation || !toStation || !/^\d{4}-\d{2}-\d{2}$/.test(travelDate) || !/^D\d{8}$/.test(pnr) || !/^[a-z0-9-]{32,80}$/i.test(viewerKey) || !Number.isInteger(totalAmount) || totalAmount < 0 || passengers.length < 1 || passengers.length > 6) {
    return res.status(400).json({ error: "Enter valid demo booking details." });
  }
  const cleanPassengers = passengers.map(passenger => ({
    name: String(passenger?.name || "").trim(),
    age: Number(passenger?.age),
    gender: String(passenger?.gender || "").trim(),
    berthPreference: String(passenger?.berthPreference || "No preference").trim()
  }));
  if (cleanPassengers.some(passenger => passenger.name.length < 1 || passenger.name.length > 60 || !Number.isInteger(passenger.age) || passenger.age < 1 || passenger.age > 120 || !['Female', 'Male', 'Other'].includes(passenger.gender) || passenger.berthPreference.length > 30)) {
    return res.status(400).json({ error: "Enter valid passenger details." });
  }
  try {
    const createdAt = new Date().toISOString();
    const result = bookingDatabase.prepare("INSERT INTO bookings (pnr, train_number, train_name, travel_class, total_amount, created_at, viewer_key, from_station, to_station, travel_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)").run(pnr, trainNumber, trainName, travelClass, totalAmount, createdAt, viewerKey, fromStation, toStation, travelDate);
    const bookingId = Number(result.lastInsertRowid);
    const insertPassenger = bookingDatabase.prepare("INSERT INTO booking_passengers (booking_id, name, age, gender, berth_preference) VALUES (?, ?, ?, ?, ?)");
    for (const passenger of cleanPassengers) insertPassenger.run(bookingId, passenger.name, passenger.age, passenger.gender, passenger.berthPreference);
    res.status(201).json({ id: bookingId, pnr, passengers: cleanPassengers.length, createdAt });
  } catch (error) {
    if (String(error.message).includes("UNIQUE")) return res.status(409).json({ error: "Please retry demo booking." });
    console.error("Booking storage error:", error.message);
    res.status(500).json({ error: "Could not store the demo booking." });
  }
});
app.post("/api/bookings/list", (req, res) => {
  const viewerKey = String(req.body?.viewerKey || "").trim();
  if (!/^[a-z0-9-]{32,80}$/i.test(viewerKey)) return res.status(401).json({ error: "This browser cannot view saved bookings." });
  const bookings = bookingDatabase.prepare("SELECT id, pnr, train_number AS trainNumber, train_name AS trainName, travel_class AS travelClass, total_amount AS totalAmount, created_at AS createdAt, from_station AS fromStation, to_station AS toStation, travel_date AS travelDate FROM bookings WHERE viewer_key = ? ORDER BY id DESC").all(viewerKey);
  const passengersForBooking = bookingDatabase.prepare("SELECT name, age, gender, berth_preference AS berthPreference FROM booking_passengers WHERE booking_id = ? ORDER BY id");
  res.json({ bookings: bookings.map(booking => ({ ...booking, passengers: passengersForBooking.all(booking.id) })) });
});
// Your learning endpoint: add RAILRADAR_API_KEY to .env before using it.
app.get("/api/provider/stations", async (req, res) => {
  const query = String(req.query.query || "").trim(); const apiKey = process.env.RAILRADAR_API_KEY;
  if (!query) return res.status(400).json({ error: "Please provide a station search query." });
  if (!apiKey || apiKey === "your_actual_api_key") return res.status(503).json({ error: "Add your RailRadar API key to .env." });
  try {
    const url = new URL("https://api.railradar.in/v1/lookup/search/stations"); url.searchParams.set("q", query); url.searchParams.set("limit", "10");
    const response = await fetch(url, { headers: { Authorization: `Bearer ${apiKey}`, Accept: "application/json" } });
    if (!response.ok) return res.status(502).json({ error: "The station provider request failed.", status: response.status });
    const data = await response.json(); const stations = (Array.isArray(data.data) ? data.data : []).map(station => ({ code: String(station.code || station.station_code || ""), name: String(station.name || station.station_name || ""), city: String(station.city || "") })).filter(station => station.code && station.name);
    res.json({ stations });
  } catch (error) { console.error("Station provider error:", error.message); res.status(502).json({ error: "Unable to fetch station data." }); }
});
app.use(express.static(frontendDirectory));
app.get("*splat", (req, res) => res.sendFile(path.join(frontendDirectory, "index.html")));
app.listen(PORT, () => console.log(`Railway site: http://localhost:${PORT}`));


