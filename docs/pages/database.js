import { listStations, searchJourneys, trainDetails, calculateSampleFare } from '../db/repository.js?v=73053e354209';

export function sqliteAdapter(database) {
  return {
    prepare(sql) {
      let parameters = [];
      return {
        bind(...values) { parameters = values; return this; },
        async all() {
          const statement = database.prepare(sql);
          try {
            statement.bind(parameters);
            const results = [];
            while (statement.step()) results.push(statement.getAsObject());
            return { results };
          } finally { statement.free(); }
        },
      };
    },
  };
}

// The SQLite file and engine are both served by this GitHub Pages site.
// Requests here are local SQL queries; no remote API or database server is used.
export function createDataSource({ initSqlJs, fetchDatabase, wasmUrl }) {
  let pending;
  async function connect() {
    if (!pending) {
      pending = (async () => {
        const [SQL, bytes] = await Promise.all([
          initSqlJs(wasmUrl ? { locateFile: () => wasmUrl } : {}), fetchDatabase(),
        ]);
        const database = new SQL.Database(new Uint8Array(bytes));
        database.run('PRAGMA query_only = ON');
        return sqliteAdapter(database);
      })().catch(error => { pending = undefined; throw error; });
    }
    return pending;
  }
  return async function readData(path, signal) {
    const checkAborted = () => { if (signal?.aborted) throw new DOMException('Search cancelled', 'AbortError'); };
    checkAborted();
    const database = await connect();
    checkAborted();
    const url = new URL(path, 'https://railway.invalid');
    if (url.pathname === '/api/stations') return { stations: await listStations(database) };
    if (url.pathname === '/api/trains') {
      return { trains: await searchJourneys(database,
        (url.searchParams.get('from') ?? '').trim().toUpperCase(),
        (url.searchParams.get('to') ?? '').trim().toUpperCase()) };
    }
    const trainRoute = url.pathname.match(/^\/api\/trains\/([0-9]{5})(?:\/(schedule|fare))?$/);
    if (trainRoute) {
      const [,number,action] = trainRoute;
      if (action === 'fare') return calculateSampleFare(database,number,
        (url.searchParams.get('from') ?? '').trim().toUpperCase(),
        (url.searchParams.get('to') ?? '').trim().toUpperCase(),
        url.searchParams.get('travelClass') ?? 'SL',Number(url.searchParams.get('passengers') ?? '1'));
      return trainDetails(database,number);
    }
    throw new Error('Unknown data request');
  };
}
