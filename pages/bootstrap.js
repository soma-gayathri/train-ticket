import { createDataSource } from './database.js';

globalThis.railwayDataSource = createDataSource({
  initSqlJs: options => {
    if (!globalThis.initSqlJs) throw new Error('The database engine could not load. Refresh the page to retry.');
    return globalThis.initSqlJs(options);
  },
  wasmUrl: new URL('../vendor/sql-wasm.wasm', import.meta.url).href,
  fetchDatabase: async () => {
    const response = await fetch(new URL('../data/railway.sqlite', import.meta.url));
    if (!response.ok) throw new Error('The train database could not load. Please try again.');
    return response.arrayBuffer();
  },
});

await import('../app.js');
