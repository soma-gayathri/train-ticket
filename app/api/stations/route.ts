import { database } from '../../../db/runtime';
import { listStations } from '../../../db/repository.js';
export const dynamic = 'force-dynamic';
export async function GET() {
  try {
    return Response.json({stations: await listStations(await database())}, {headers:{'Cache-Control':'no-store'}});
  } catch (error) {
    console.error('Station lookup failed', error);
    return Response.json({error:'Station data is temporarily unavailable. Please try again.'}, {status:503});
  }
}
