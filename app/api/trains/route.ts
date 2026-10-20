import { database } from '../../../db/runtime';
import { searchJourneys } from '../../../db/repository.js';
export const dynamic = 'force-dynamic';
export async function GET(request: Request) {
  const params = new URL(request.url).searchParams;
  const from = (params.get('from') ?? '').trim().toUpperCase();
  const to = (params.get('to') ?? '').trim().toUpperCase();
  try {
    const trains = await searchJourneys(await database(), from, to);
    return Response.json({trains}, {headers:{'Cache-Control':'no-store'}});
  } catch (error) {
    const message = error instanceof Error ? error.message : '';
    if (['INVALID_STATIONS','SAME_STATION','UNKNOWN_STATION'].includes(message)) {
      return Response.json({error:'Choose two different, valid station codes.'}, {status:400});
    }
    console.error('Train search failed', error);
    return Response.json({error:'Train data is temporarily unavailable. Please try again.'}, {status:503});
  }
}
