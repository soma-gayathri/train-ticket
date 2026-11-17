# Railway developer API (v1)

This project includes a small, versioned API for other applications. It uses the project’s **illustrative demo timetable**. It does not return live Indian Railways, IRCTC availability, or official fares.

## Start securely

Generate a private key and its SHA-256 hash. Save the key somewhere safe; only put the hash in `.env`.

```powershell
node -e "const c=require('crypto'); const k='railway_live_'+c.randomBytes(24).toString('hex'); console.log('API key: '+k); console.log('SHA-256: '+c.createHash('sha256').update(k).digest('hex'))"
```

Create `node-backend/.env`:

```env
DEVELOPER_API_KEY_HASH=paste-the-sha-256-hash-here
DEVELOPER_API_RATE_LIMIT=60
```

Then start the backend:

```powershell
cd node-backend
npm start
```

The local base URL is `http://localhost:3000`. All `/v1` requests need this header:

```http
Authorization: Bearer railway_live_your-private-key
```

The API accepts a maximum of 60 requests per minute per key by default. It returns `401` for an invalid key, `429` when the limit is exceeded, and `503` until a key hash is configured.

## Endpoints

### Search stations

```http
GET /v1/stations?q=delhi&limit=20
```

### Search exact station-to-station trains

```http
GET /v1/trains?from=NDLS&to=MMCT&date=2026-11-17
```

`from` and `to` are station codes. Results only include trains containing those exact codes in that travel order.

### Get a train schedule

```http
GET /v1/trains/12952
```

## Example request

```powershell
$headers = @{ Authorization = 'Bearer railway_live_your-private-key' }
Invoke-RestMethod 'http://localhost:3000/v1/trains?from=NDLS&to=MMCT&date=2026-11-17' -Headers $headers
```

## Before publishing publicly

Do not commit `.env`, API keys, user data, or database credentials. A permanent URL requires hosting the backend (for example Cloudflare Workers, Render, or Railway) and a managed database. Use HTTPS, rotate compromised keys, and check the licence of any live railway-data provider before redistributing its data.
