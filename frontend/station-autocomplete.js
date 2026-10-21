// Common city names and older spellings help people find the right station.
const CITY_NAMES = {
  SBC:['Bengaluru','Bangalore'], BNC:['Bengaluru','Bangalore'], YPR:['Bengaluru','Bangalore','Yesvantpur'],
  BCT:['Mumbai','Bombay'], CSMT:['Mumbai','Bombay','Chhatrapati Shivaji Maharaj Terminus'],
  BDTS:['Mumbai','Bombay','Bandra'], LTT:['Mumbai','Bombay','Lokmanya Tilak'], BVI:['Mumbai','Borivali'],
  NDLS:['Delhi','New Delhi'], DEC:['Delhi','Delhi Cantt'], DLI:['Delhi','Old Delhi'],
  MAS:['Chennai','Madras'], KOAA:['Kolkata','Calcutta'], HWH:['Howrah','Kolkata','Calcutta'],
  BSB:['Varanasi','Banaras','Kashi'], BRC:['Vadodara','Baroda'],
  HX:['Kadapa','Cuddapah'], KRMR:['Karimnagar','Karomnagar'],
  VGLJ:['Jhansi','Virangana Lakshmibai Jhansi'], GGN:['Gurugram','Gurgaon'],
  MYS:['Mysuru','Mysore'], BGM:['Belagavi','Belgaum'], BJP:['Vijayapura','Bijapur'],
  UBL:['Hubballi','Hubli'], HPT:['Hosapete','Hospet'], CLT:['Kozhikode','Calicut'],
  MAJN:['Mangaluru','Mangalore'], NED:['Nanded','Hazur Sahib Nanded'],
  HYB:['Hyderabad','Hyderabad Deccan'], SC:['Secunderabad','Hyderabad'],
  MAO:['Goa','Madgaon','Margao'], ERS:['Kochi','Cochin','Ernakulam'],
  TVC:['Thiruvananthapuram','Trivandrum'], TCR:['Thrissur','Trichur'],
  QLN:['Kollam','Quilon'], UAM:['Ooty','Udhagamandalam'], PDY:['Puducherry','Pondicherry'],
  MAQ:['Mangaluru','Mangalore'], KOP:['Kolhapur'], ZB:['Zaheerabad','Zahirabad'],
  R:['Raipur'], RMM:['Rameswaram','Rameshwaram'], QLD:['Quilandi','Koyilandy'],
};
const normalize = value => String(value).trim().toLowerCase().replace(/\s+/g,' ');
const generic = new Set(['junction','jn','jn.','central','cantt','cantonment','road','station','terminus','terminal','ksr']);
export const cityNames = station => CITY_NAMES[station.code] ?? [];
export const stationLabel = station => `${station.name} (${station.code})`;
const terms = station => [station.name, ...cityNames(station)];

export function resolveStation(stations, value) {
  const query = normalize(value);
  const exact = stations.find(station => normalize(station.code) === query || normalize(stationLabel(station)) === query || normalize(station.name) === query);
  if (exact) return exact;
  const preferred = {bangalore:'SBC',bengaluru:'SBC',bombay:'BCT',mumbai:'BCT',delhi:'NDLS',calcutta:'KOAA',hyderabad:'HYB',goa:'MAO',kochi:'ERS'};
  return stations.find(station => station.code === preferred[query]) ?? stations.find(station => cityNames(station).some(name => normalize(name) === query));
}

export function matchingStations(stations, value) {
  const query = normalize(value);
  const rank = station => {
    const names = terms(station).map(normalize);
    if (!query || normalize(station.name).startsWith(query)) return 0;
    if (cityNames(station).some(name => normalize(name).startsWith(query))) return 1;
    if (names.some(name => name.split(/[\s-]+/).some(word => !generic.has(word) && word.startsWith(query)))) return 2;
    if (normalize(station.code).startsWith(query)) return 3;
    if (normalize(stationLabel(station)).startsWith(query)) return 0;
    return -1;
  };
  return stations.map(station => ({station,rank:rank(station)})).filter(item => item.rank >= 0)
    .sort((a,b) => a.rank-b.rank || a.station.name.localeCompare(b.station.name))
    .map(item => item.station);
}

export function attachStationAutocomplete(input, getStations, onSelect = () => {}) {
  const field = input.closest('.station-field');
  const list = document.createElement('div');
  list.className = 'station-suggestions'; list.id = `${input.id}-suggestions`;
  list.setAttribute('role','listbox'); list.setAttribute('aria-label',`${input.id === 'from' ? 'Departure' : 'Destination'} stations`);
  list.hidden = true; field.append(list);
  const status = document.createElement('div');
  status.className = 'visually-hidden'; status.setAttribute('role','status'); status.setAttribute('aria-live','polite'); field.append(status);
  input.removeAttribute('list'); input.setAttribute('role','combobox'); input.setAttribute('aria-autocomplete','list');
  input.setAttribute('aria-controls',list.id); input.setAttribute('aria-expanded','false'); input.setAttribute('aria-haspopup','listbox'); input.spellcheck = false;
  let matches = [], active = -1;
  function close() { list.hidden = true; input.setAttribute('aria-expanded','false'); input.removeAttribute('aria-activedescendant'); active = -1; }
  function choose(station) { input.value = stationLabel(station); input.removeAttribute('aria-invalid'); close(); onSelect(station); }
  function highlight(index) {
    active = index;
    const options = list.querySelectorAll('[role="option"]');
    options.forEach((option,i) => option.setAttribute('aria-selected',String(i === active)));
    if (options[active]) { input.setAttribute('aria-activedescendant',options[active].id); options[active].scrollIntoView({block:'nearest'}); }
  }
  function show() {
    matches = matchingStations(getStations(), input.value); active = -1; list.replaceChildren(); input.removeAttribute('aria-activedescendant');
    if (!getStations().length) { close(); return; }
    const count = document.createElement('div'); count.className = 'suggestion-count';
    count.textContent = matches.length ? `${matches.length} matching station${matches.length === 1 ? '' : 's'}` : 'No matching stations. Try another name or code.'; list.append(count);
    for (const [index,station] of matches.entries()) {
      const option = document.createElement('div'); option.className = 'station-option'; option.id = `${list.id}-${index}`;
      option.setAttribute('role','option'); option.setAttribute('aria-selected','false');
      const text = document.createElement('span'); const name = document.createElement('strong'); name.textContent = station.name; text.append(name);
      const aliases = cityNames(station).filter(city => !normalize(station.name).includes(normalize(city)));
      if (aliases.length) { const hint = document.createElement('small'); hint.textContent = aliases.join(' · '); text.append(hint); }
      const code = document.createElement('span'); code.className = 'suggestion-code'; code.textContent = station.code; option.append(text,code);
      option.addEventListener('mousedown',event => event.preventDefault());
      option.addEventListener('click',() => choose(station)); list.append(option);
    }
    list.hidden = false; input.setAttribute('aria-expanded','true'); status.textContent = count.textContent;
  }
  input.addEventListener('input',show); input.addEventListener('focus',show);
  input.addEventListener('keydown',event => {
    if (event.key === 'Escape') { if (!list.hidden) event.preventDefault(); close(); return; }
    if (event.key === 'Tab') { close(); return; }
    if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
      event.preventDefault(); if (list.hidden) show();
      if (matches.length) highlight(event.key === 'ArrowDown' ? (active + 1) % matches.length : (active <= 0 ? matches.length - 1 : active - 1));
    } else if (event.key === 'Enter' && !list.hidden && active >= 0) { event.preventDefault(); choose(matches[active]); }
  });
  document.addEventListener('pointerdown',event => { if (!field.contains(event.target)) close(); });
  document.addEventListener('focusin',event => { if (!field.contains(event.target)) close(); });
  return { close };
}
