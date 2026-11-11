# Node/Express Demo Railway API

This is the active local backend used by the Train Ticket website. It is separate from the existing Java Spring Boot backend in `backend/`.

## Run

```powershell
cd node-backend
npm install
npm start
```

The API runs at `http://localhost:3000`.

## Demo API endpoints

- `GET /api/catalog` — catalog count and data source
- `GET /api/stations` — major stations for the selector
- `GET /api/trains?from=NDLS&to=JP` — train search
- `GET /api/trains/:number` — train details
- `GET /api/trains/:number/schedule` — ordered stop list
- `GET /api/trains/:number/fare?from=NDLS&to=JP&travelClass=SL&passengers=1` — illustrative fare
- `POST /api/bookings` — save a demo booking
- `POST /api/bookings/list` — show the current browser's saved demo bookings

The server creates 552 demo services from the local timetable structure. Train timings, fares, availability and bookings are demonstrations only, not official Indian Railways or IRCTC data.

`data/`, `.env`, and `node_modules/` are deliberately excluded from Git.
