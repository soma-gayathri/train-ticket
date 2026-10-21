export const STATIONS_SQL = 'SELECT code, name FROM stations ORDER BY name';
export const JOURNEY_SQL = `
SELECT t.number, t.name, t.type,
 s.station_code AS code, s.stop_order AS stopOrder, s.arrival, s.departure,
 s.arrival_day AS arrivalDay, s.departure_day AS departureDay
FROM trains t
JOIN train_stops origin ON origin.train_number = t.number AND origin.station_code = ?
JOIN train_stops destination ON destination.train_number = t.number AND destination.station_code = ?
JOIN train_stops s ON s.train_number = t.number
WHERE origin.stop_order < destination.stop_order
 AND s.stop_order BETWEEN origin.stop_order AND destination.stop_order
ORDER BY t.number, s.stop_order`;

export const toMinutes = (time, day = 0) => {
  const [hours, minutes] = time.split(':').map(Number);
  return day * 1440 + hours * 60 + minutes;
};

export async function listStations(db) {
  return (await db.prepare(STATIONS_SQL).all()).results;
}

export async function searchJourneys(db, from, to) {
  if (!/^[A-Z0-9]{1,10}$/.test(from) || !/^[A-Z0-9]{1,10}$/.test(to)) {
    throw new Error('INVALID_STATIONS');
  }
  if (from === to) throw new Error('SAME_STATION');
  const existing = await db.prepare('SELECT code FROM stations WHERE code IN (?, ?)').bind(from, to).all();
  if (existing.results.length !== 2) throw new Error('UNKNOWN_STATION');
  const rows = (await db.prepare(JOURNEY_SQL).bind(from, to).all()).results;
  const grouped = new Map();
  for (const row of rows) {
    if (!grouped.has(row.number)) grouped.set(row.number, {number:row.number, name:row.name, type:row.type, segment:[]});
    grouped.get(row.number).segment.push({code:row.code, arrival:row.arrival, departure:row.departure, arrivalDay:row.arrivalDay, departureDay:row.departureDay});
  }
  return [...grouped.values()].map(train => {
    const departure = train.segment[0], arrival = train.segment.at(-1);
    return {...train, departure, arrival,
      duration: toMinutes(arrival.arrival, arrival.arrivalDay) - toMinutes(departure.departure, departure.departureDay),
      dayDifference: arrival.arrivalDay - departure.departureDay};
  });
}

export async function trainDetails(db, number) {
  if (!/^[0-9]{5}$/.test(number)) throw new Error('Enter a valid five-digit train number.');
  const train = (await db.prepare('SELECT number, name, type FROM trains WHERE number = ?').bind(number).all()).results[0];
  if (!train) throw new Error('Train not found.');
  const stops = (await db.prepare(`SELECT s.station_code AS code, p.name, s.arrival, s.departure,
    s.arrival_day AS arrivalDay, s.departure_day AS departureDay, s.stop_order AS stopOrder
    FROM train_stops s JOIN stations p ON p.code = s.station_code WHERE s.train_number = ? ORDER BY s.stop_order`).bind(number).all()).results;
  return {...train, sample:true, stops};
}

export async function calculateSampleFare(db, number, from, to, travelClass='SL', passengers=1) {
  await trainDetails(db,number);
  if (!Number.isInteger(passengers) || passengers < 1 || passengers > 6) throw new Error('Passengers must be between 1 and 6.');
  const rule = (await db.prepare('SELECT travel_class, base_paise, per_leg_paise FROM fare_rules WHERE travel_class = ?').bind(travelClass.trim().toUpperCase()).all()).results[0];
  if (!rule) throw new Error('Choose SL, 3A, 2A, or CC.');
  const journey = (await searchJourneys(db,from,to)).find(train => train.number === number);
  if (!journey) throw new Error('This train does not serve that journey in the selected direction.');
  const legs = journey.segment.length-1;
  const unitFarePaise = rule.base_paise+rule.per_leg_paise*legs;
  return {trainNumber:number,from,to,travelClass:rule.travel_class,passengers,currency:'INR',
    unitFarePaise,totalFarePaise:unitFarePaise*passengers,legs,sample:true,
    disclaimer:'Illustrative fare based on scheduled stop-to-stop legs. Not a real railway quote or class-availability guarantee.'};
}
