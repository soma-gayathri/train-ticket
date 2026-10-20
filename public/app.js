// GitHub Pages supplies a SQLite data source. The server-hosted version uses
// the same interface through its database API.
let stations=[];
const autocompleteReady = import('./station-autocomplete.js' + (globalThis.railwayAssetVersion ? `?v=${encodeURIComponent(globalThis.railwayAssetVersion)}` : ''));
let autocomplete, stationPickers=[];
const stationByCode=code=>stations.find(s=>s.code===code);
const stationLabel=code=>autocomplete.stationLabel(stationByCode(code));
const resolveStation=value=>autocomplete.resolveStation(stations,value);
function validateSearch(a,b){if(!a.trim()||!b.trim())return {error:'Choose both a departure and a destination station.'};const from=resolveStation(a),to=resolveStation(b);if(!from||!to)return {error:'Choose a station from the suggestions, or enter its full name or station code.'};if(from.code===to.code)return {error:'Choose two different stations for your journey.'};return {from,to};}
const formatDuration=value=>`${Math.floor(value/60)}h ${String(value%60).padStart(2,'0')}m`;
const escapeHtml=value=>String(value??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
async function readApi(url,signal){if(globalThis.railwayDataSource)return globalThis.railwayDataSource(url,signal);const response=await fetch(url,{signal,cache:'no-store'});const data=await response.json();if(!response.ok)throw new Error(data.error||'Could not load schedules. Please try again.');return data;}
let searchSequence=0,controller;
const $=id=>document.getElementById(id);
let current=[];
function dayTag(day){return day>0?`<span class="day-label">+${day} day${day>1?'s':''}</span>`:'';}
function stopTime(stop,kind,base){return stop[kind]?`${escapeHtml(stop[kind])}${dayTag(stop[`${kind}Day`]-base)}`:'—';}
function render(){const ordered=[...current].sort((a,b)=>$('sort').value==='duration'?a.duration-b.duration:a.departure.departure.localeCompare(b.departure.departure));
 $('results').innerHTML=ordered.length?ordered.map(t=>{const intermediate=t.segment.length-2;return `<article class="train-card"><div class="train-main"><div><p class="train-number">${escapeHtml(t.number)} · SAMPLE SERVICE</p><h3 class="train-name">${escapeHtml(t.name)}</h3><span class="train-type">${escapeHtml(t.type)}</span></div><div class="journey"><div><div class="time">${escapeHtml(t.departure.departure)}</div><div class="station-code">${escapeHtml(t.departure.code)}</div></div><div class="journey-middle"><span>${formatDuration(t.duration)}</span><div class="route-line"></div><span>${intermediate?`${intermediate} stop${intermediate>1?'s':''}`:'Non-stop'}</span></div><div class="arrival"><div class="time">${escapeHtml(t.arrival.arrival)}${dayTag(t.dayDifference)}</div><div class="station-code">${escapeHtml(t.arrival.code)}</div></div></div><div class="train-right"><strong>Scheduled service</strong>All times in IST</div></div><details><summary aria-label="View route and station stops for ${escapeHtml(t.name)}"><span>View route & station stops</span></summary><div class="stops"><div class="stop-heading"><span>STATION · SELECTED JOURNEY</span><span>ARRIVAL</span><span>DEPARTURE</span></div>${t.segment.map(s=>`<div class="stop-row"><div class="stop-name">${escapeHtml(stationByCode(s.code).name)}<small>${escapeHtml(s.code)}</small></div><div>${stopTime(s,'arrival',t.departure.departureDay)}</div><div>${stopTime(s,'departure',t.departure.departureDay)}</div></div>`).join('')}</div></details></article>`;}).join(''):'<div class="empty"><h3>No sample trains on this route</h3><p>Try a suggested journey above, or swap your stations.</p></div>';
}
async function search(){
 const sequence=++searchSequence;controller?.abort();$('results').removeAttribute('aria-busy');
 stationPickers.forEach(picker=>picker.close());
 if(!stations.length){await initialize();return;}
 const checked=validateSearch($('from').value,$('to').value);$('form-error').hidden=!checked.error;$('from').removeAttribute('aria-invalid');$('to').removeAttribute('aria-invalid');
 if(checked.error){$('form-error').textContent=checked.error;const target=!$('from').value.trim()?'from':'to';$(target).setAttribute('aria-invalid','true');$(target).focus();return;}
 const {from,to}=checked;$('from').value=stationLabel(from.code);$('to').value=stationLabel(to.code);$('results-title').replaceChildren(document.createTextNode(from.name+' '),Object.assign(document.createElement('span'),{textContent:'→'}),document.createTextNode(' '+to.name));
 current=[];$('results').replaceChildren();$('results-count').textContent='Searching train schedules…';$('results').setAttribute('aria-busy','true');controller=new AbortController();
 try {const data=await readApi(`/api/trains?from=${encodeURIComponent(from.code)}&to=${encodeURIComponent(to.code)}`,controller.signal);if(sequence!==searchSequence)return;current=data.trains;$('results-count').textContent=`${current.length} sample train${current.length===1?'':'s'} found · Illustrative schedules · All times IST`;render();}
 catch(error){if(sequence!==searchSequence||error.name==='AbortError')return;$('results-count').textContent='Search could not be completed.';$('form-error').textContent=error.message;$('form-error').hidden=false;}
 finally{if(sequence===searchSequence)$('results').removeAttribute('aria-busy');}
}
$('search-form').addEventListener('submit',event=>{event.preventDefault();search();});
$('swap').addEventListener('click',()=>{const previous=$('from').value;$('from').value=$('to').value;$('to').value=previous;if($('from').value.trim()&&$('to').value.trim())search();});
$('sort').addEventListener('change',render);
document.querySelectorAll('[data-route]').forEach(button=>button.addEventListener('click',()=>{if(!stations.length){initialize();return;}const [from,to]=button.dataset.route.split(',');$('from').value=stationLabel(from);$('to').value=stationLabel(to);search();}));
async function initialize(){
 $('results-count').textContent='Loading stations…';
 try{const [data,module]=await Promise.all([readApi('/api/stations'),autocompleteReady]);stations=data.stations;autocomplete=module;if(!stationPickers.length){stationPickers=['from','to'].map(id=>autocomplete.attachStationAutocomplete($(id),()=>stations,()=>{$('form-error').hidden=true;}));$('stations')?.remove();}await search();}
 catch(error){$('results-count').textContent='Station data could not be loaded.';$('form-error').textContent=error.message+' Use Search trains to retry.';$('form-error').hidden=false;}
}
initialize();
