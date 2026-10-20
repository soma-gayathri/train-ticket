import { env } from 'cloudflare:workers';
import seedSql from './seed.sql?raw';

// Schema is owned exclusively by migrations. Data seeding is separate and
// runs atomically on the first request to a newly provisioned, empty database.
// Existing non-empty databases are never reseeded or overwritten.
export async function database() {
  if (!env.DB) throw new Error('Database binding is unavailable');
  const db = env.DB;
  const existing = await db.prepare('SELECT code FROM stations LIMIT 1').first();
  if (!existing) {
    const statements = seedSql.replace(/^--.*$/gm, '').split(';').map(s => s.trim()).filter(Boolean);
    await db.batch(statements.map(statement => db.prepare(statement)));
  }
  return db;
}
