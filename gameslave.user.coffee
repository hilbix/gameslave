`if (GM_evilUpdateHack('https://hydra.geht.net/gm/gameslave/update.html')) return` # # # Development aid

#body = new Path('//body')

routes = { up: @opener or @parent }

send = (data) ->
  log "send", data.src, "to", data.dest, "by", window.location.href
  t = routes[data.dest]
  if !t
    log "unknown route to", data.dest
    return
  if t==window
    log 'route to self:', data.dest
  else if t?.closed
    log 'route closed to', data.dest
    delete routes[data.dest]
  else
    t.postMessage data, "*"

window.addEventListener "message", ((e) -> routes[e.data.src] = e.source; send e.data), false

walkDom = (o) ->
  try
    return { text:o.nodeValue } if o.nodeType == 3
    return { name:'comment', text:o.nodeValue } if o.nodeType == 8
    return { name:'unknown', text:o.innerHTML, _type:o.nodeType } unless o.nodeType == 1

    ret = { name:o.nodeName }
    ret['_'+a.name] = a.value for a in o.attributes
    ret[n] = walkDom(c) for c,n in o.childNodes
    ret.children = n if n
    return ret
  undefined

send { dest:"up", src:window.location.href, html:walkDom document.documentElement }

###
  p.nextIs=function(s)
{
  this.nn();
  return this.is(s);
}
  p.skip=function(s)
{
  if (this.nextIs(s))
    return;
  fatal(s+" is not in "+trim(t.last));
}
  p.find=function(s)
{
  while (this.nn() && !this.is(s));
  return this.last ? true : false;
}
  p.el=function(ignore)
{
  if (!this.node)
    this.next();
  l("el ", this.lastNode);
  return !ignore || this.lastNode ? this.lastNode : {};
}
  p.all=function()
{
  var e;

  a = [];
  while (e=p.nn())
    a.push(e);
//  l(a);
  return a;
}
  return p;
}

// OLD STUFF

function oldstuff() {
window.addEventListener("load", function(){load()}, true);

url=""+document.location.href;

function $(e)        { return typeof(e)=="object" ? e : document.getElementById(e); }
function el(e)       { return typeof(e)=="object" ? e : document.getElementsByName(e)[0]; }
function delay(f,ms) { window.setTimeout(f, ms ? ms : 100); }
function toHTML(s)   { return (""+s).replace(/&/,"&amp;").replace(/</,"&lt;").replace(/</,"&gt;"); }

function dummyel(e)  { return el(e) || {}; }

function noneg(x)    { return x<0 ? 0 : x; }

function startsWith(s,v)
{
  return v==s.substr(0,v.length);
}

// Primitive variable dumper
function dump(s)
{
  switch (typeof(s))
    {
      case "string":   return s;
      case "number":   return ""+s;
      case "object":
        var t="";
        for (var i in s)
          t+="["+i+"]=["+s[i]+"]";
        return t;
    }
  return "["+typeof(s)+"]=["+(s && s.toString ? s.toString() : s)+"]";
}
// Primitive logger
var logline=0;
function l()
{
  var s="";
  for (i=0; i<arguments.length; i++)
    s += dump(arguments[i]);
  logline++;
  // For some unknown reason, it does not log same lines again
  GM_log(logline+"["+s+"]");
}
function fatal(what)
{
  l("FATAL: ",what);
  throw what;
}

// Random number from 0 to x (including)
function rnd(x)
{
  var r = Math.floor(Math.random()*(x+1));
//  l("rnd ",r);
  return r;
}
// Run some function later with a random delay (to lessen load hostspots)
function later(f,ms)
{
  if (!ms)
    ms=(rnd(10)>9) ? 10000 : 1500;
  l("later", f);
	ms+=rnd(ms);
	var e=$("content");
	if (ms>300)
	  {
	    e.style.opacity=0.5;
		  e.style.background=ms >4000 ? "black" : "grey";
		}
  delay(f, ms);
}
// Change page to some other URL
function goto(u,ms)
{
  if (ms)
    later(function(){goto(u)},ms);
  else
  	window.location.href = u;
}
// JavaScript hack to get out of the Greasmonkey Sandbox
function exec(s,ms)
{
  goto("javascript:"+s,ms);
}
// Do an artificial click
// The mouse variant is the default as it bubbles through the DOM, so it always works.
// The HTML variant only fires the "onclick" event of the given element.
function click(el,html)
{
  if (!el)
    return;
  if (html)
    {
      var ev = document.createEvent("HTMLEvents");
      ev.initEvent("click", true, true);
    }
  else
    {
      var ev=document.createEvent("MouseEvents");
      ev.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
    }
  l("click ",el.nodeName," named ",el.name);
  $(el).dispatchEvent(ev);
}
// Do a click delayed
function clicklater(el,ms)
{
  l("clicklater ",dump(el));
  later(function() { click(el) }, ms);
}

// Data extraction: Fetch formatted integer
// It must not be a floating point.
function fixInt(s)
{
  return s ? parseInt(s.replace(/[.,]/g,"")) : null;
}
// Data extraction: Fetch an integer somewhere in the text
// There must not be more than one number.
// It must not be a floating point.
function extractInt(s)
{
  return parseInt(s.replace(/[^0-9]/g,""));
}

// Extract 
function getParm(p)
{
  var r=new RegExp("^[^?]*\?.*\\b"+p+"=");
  l(p," at=",url);
  return url.replace(r,"").replace(/&.*$/,"");
}

function trim(s)
{
  if (typeof(s)!="string")
    return s;
  return s.replace(/^[[:space:]]*________/,"").replace(/[[:space:]]*$/,"");
}

function gmSetArray(name,a)
{
  var s = "";
	
	l("set a[",name,"]=",dump(a));
	for (var i in a)
	  if (a[i]!="")
  		s += " "+escape(i)+"="+escape(a[i]);
	GM_setValue("u"+uni+"a"+name,s);
}
function gmGetArray(name)
{
  var s = GM_getValue("u"+uni+"a"+name);
	var a = {};
	if (s)
	  {
			s = s.split(" ");

			for (var i in s)
				{
					var t=s[i];
					if (!t)
						continue;
					t=t.split("=");
					a[unescape(t[0])]=unescape(t[1]);
				}
		  l("get a[",name,"]=",dump(a));
		}
	return a;
}
function gmSet(k,v)
{
  if (!uni || !uniPlanet)
    {
      l("cannot gmSet(",k,")=",v);
      return;
    }
  l("gmSet(",k,")=",v);
  GM_setValue("u"+uni+"l"+uniPlanet+k,v);
}
function gmGet(k)
{
  if (!uni || !uniPlanet)
    return "";
  return GM_getValue("u"+uni+"l"+uniPlanet+k);
}
function planetGetN(p,k)
{
  return gmGet("p"+p+"-"+k);
}
function planetGet(k)
{
  return planetGetN(planet,k);
}
function planetSetN(p,k,v)
{
  gmSet("p"+p+"-"+k, v);
}
function planetSet(k,v)
{
  planetSetN(planet, k, v);
}

function lowPlanet()
{
  for (var i=maxPlanet+1; --i>=0; )
    if (i!=fromPlanet && enabledPlanet(i))
      if (planetGetN(i,"trans")<minTrans)
        return i;
  return -1;
}

// END OF STANDARD LIBRARY
// BEGIN SPECIAL MODULES

// Selections
var sels  = document.getElementsByTagName("select");

function selIdx(x)
{
  return sels[x] ? sels[x].selectedIndex : -1;
}
function selOpt(x,y)
{
  var o;

  o = null;
  if (sels[x] && sels[x].options)
    o = sels[x].options[y];
  return o ? o : {};
}

// END OF SPECIAL MODULES

////////////////////////////////////////////////////////////////////////////////

var uniPlanet=null;

function enabledPlanet(i)
{
  n=planetName(i);
	return n!=KolonieName && !startsWith(n,MondName) && !startsWith(n,"_");
}

function load()
{
	if (sels[0])
	for (var i=0; i<sels[0].length; i++)
	  if (enabledPlanet(i))
		  maxPlanet=i;
	l("maxPlanet=",maxPlanet);

	planet = selIdx(0);
	if (planet>=0)
	  {
	    uniPlanet = planetPos(0);
	    planetSet("pos",planetPos(planet));
	    planetSet("name",planetName(planet));
	  }
	
	var page  = getParm("page");
	l("page=",page," planet=",planet);
	
	var p=path("//table//td[2]/table//tr[3]//td");
	
	metall=fixInt(p.next());
	kristall=fixInt(p.next());
	deuterium=fixInt(p.next());
	dunkle=fixInt(p.next());
	energie=fixInt(p.next());
	
	l("metal=",metall," kristall=",kristall," deuterium=",deuterium);
	planetSet("m",metall);
	planetSet("k",kristall);
	planetSet("d",deuterium);
	planetSet("e",energie);
	
	deuterium -=500;
	if (deuterium<0)
	  deuterium=0;
	
	dopage(page);
}
// Estimate Treibstoffverbrauch
function fuelUse(a,b)
{
  var d;
	
	d = Math.abs(getInt(a[0])-getInt(b[0]));
	if (d>0)
		return 700*d;
		
  d	= Math.abs(getInt(a[1])-getInt(b[1]));
	if (d>0)
		return 100*d;
	
  d	= Math.abs(getInt(a[2])-getInt(b[2]));
	if (d>0)
		return 40;

  return 1;
}
function bestdebris()
{
  var debris = gmGetArray("debris");
	var salvag = gmGetArray("salvage");
	
	if (!debris)
	  return ["",0];

	var d = uniPlanet.split(":");
  var keys	= [];
	var worth	= {};
	for (var a in debris)
	  {
		  var v	= getInt(debris[a]);
			if (v==salvag[a])
			  continue;
			if (v>20000)
			  v	= 20000;
			v /= fuelUse(a.split(","),d);
			if (v<deuteriumToOther)
			  continue;
			l("worth(",a,")=",v);
	    keys.push(a);
			worth[a]	= v;
		}
	if (!keys.length)
	  return ["",0];

	sorted = keys.sort(function (a,b){return worth[b]-worth[a]})

  l(sorted[0],"=",debris[sorted[0]]);

  return [sorted[0],Math.ceil(debris[sorted[0]]/20000)];
}
function setZiel(coord,at)
{
  if (!at)
	  at=1;
	exec("setTarget("+coord.replace(/:/g,",")+","+at+");shortInfo()");
}
function isin(val,arr)
{
  for (var i=arr.length; --i>=0; )
	  if (val.indexOf(arr[i])>=0)
		  return arr[i];
	return "";
}

// The big switch
function dopage(page)
{
var p;

switch (page)
  {
  case "http://ogame.de/":
    // Universum wählen!
    //clicklater("login_button");
    break;

  case "ogamer":
    var k=getParm("pos");
    p=path("//span[@title]");

    // We must fetch all elements in advance,
    // as changing the content invalidates the path.
    var all=p.all();
    for (var i in all)
      {
        var e=all[i];
				var s=GM_getValue(k+e.title);
				if (s=='' || s==null)
				  {
				    s	= GM_getValue(e.title);
						if (s==null)
						  s='';
				    s	= unescape(s);
					}
        e.innerHTML=toHTML(s);
			}
    break;

  case "flotten1":
    p=path("//body/div[4]//form/table//tr");
    p.skip("Neuer Auftrag");
    p.skip("Schiffsname");

		// Fetch interesting ships
    var transporters=0;
		var recyclers=0;
    while (!p.nextIs("Keine Schiffe") && p.last)
      if (p.is("Großer Transporter"))
        transporters  = extractInt(p.last);
		  else if (p.is("Recycler"))
			  recyclers     = extractInt(p.last);
 
    planetSet("trans", transporters);
    planetSet("recycle", recyclers);

		// calculate the number of recyclers of interest
		var rec	= 0;
		var bd	= null;
		if (recyclers)
		  {
				bd = bestdebris();
				rec=bd[1];
			}

		// calculate the number of transporters
    var nr = noneg(Math.floor((metall+kristall+deuterium-3000)/25000));
    l("transporters ",transporters, " need ",nr, ", recyclers ",recyclers," need ",rec);

		// calculate a special transporter target
    i = -1;
    if (planet==fromPlanet)
      {
        var i = gmGet("wantp");
        if (i>0)
          {
            i--;
            nr  =  noneg(gmGet("wantm")-planetGetN(i,"m"));
            nr  += noneg(gmGet("wantk")-planetGetN(i,"k"));
            nr  += noneg(gmGet("wantd")-planetGetN(i,"d"));
            nr  =  Math.floor((nr+24900-1)/24900);  // rule of thumb, must be a little bit more than needed
            gmSet("wantt",nr);
          }
        else if (transporters>=sendTrans && (i=lowPlanet())>=0)
          {
            nr  = sendTrans;
            l("planet ",i," has low transporters");
          }
      }
    gmSet("target",i);

		// Now do what is to do.
		// First, send transporters
    if (nr>transporters)
      nr  = transporters;
    dummyel("ship203").value = nr;
    gmSet("autotransport",nr);
 
		// If we are in autosweep mode, propagate it
    if (gmGet("autosweep")==planet)
      {
        gmSet("autosweep",planet-1);
        gmSet("autonext", 1);
      }
		// As long as we were in autosweep mode on this planet
		// send the transporters
    if (gmGet("autonext"))
      {
			  // Successful send
				// Do not run the bounce on autorun
				// i is the "target" planet, see gmSet above
        if  (nr>0 && (i>=0 || planet!=fromPlanet) && enabledPlanet(planet))
				  {
            clicklater(path("//body/div[4]//form/table//tr//input[@type='submit' and @value='Weiter']").el());
						break;
					}
				// Nothing to send anymore, we are finished with this planet
        gmSet("autonext", 0);

				// Atomatic jump to the next one if there is one.
        if (planet>0)
				  {
            prevPlanet();
						break;
					}
      }
		gmSet("autosweep", -1);

		// As there is nothing to do anymore
		// do all the other things

    // Try to send recyclers
		if (rec>0)
			{
				if (rec>recyclers)
					rec	= recyclers;
				// replace the transporters by recyclers
				dummyel("ship203").value = 0;
				dummyel("ship209").value = rec;
				gmSet("autotransport",rec);
				gmSet("automine",bd[0]);
			}
    break;

  case "flotten2":
	  var inputs = document.getElementsByTagName("input");
    var shp	= 0;
		var inp	= "";
		
	  for (var i=inputs.length; --i>=0; )
		  if (inputs[i].name.substr(0,4)=="ship")
			  {
					inp	= inp + "," + inputs[i].name;
				  shp	= getInt(inputs[i].value);
			  }

		var at=gmGet("autotransport");
		if (shp!=at)
			gmSet("autotransport", 0);

    gmSet("fleetmode","");
		switch (inp)
			{
			case ",ship203":
				var targ=gmGet("target");

				gmSet("fleetmode","stat");
				if (planet!=fromPlanet)
				  {
				    setZiel(planetGetN(fromPlanet,"pos"));
					}
				else if (targ<0 || (gmGet("wantp") ? shp!=gmGet("wantt") : at!=sendTrans))
				  {
					  setZiel(planetGetN(toPlanet,"pos"));
					}
				else
				  {
					  setZiel(planetGetN(targ,"pos"));
						if (gmGet("wantp"))
						  gmSet("fleetmode", "trans");
					}

				if (at==shp && planet==maxPlanet && window.confirm("Autosweep?"))
					gmSet("autosweep",maxPlanet);
					
				break;

			case ",ship209":
			  if (gmGet("automine"))
				  {
  				  setZiel(gmGet("automine"),2);
				    gmSet("fleetmode","mine");
					}
				break;
			}
		if (at>0 && at==shp)
			clicklater(path("//body/div[4]//table//tr//input[@type='submit' and @value='Weiter']").el());
    break;

  case "flotten3":
    p=path("//body/div[4]//table/tbody/tr[2]/th/table//tr");
    var at=gmGet("autotransport");
    var targ=gmGet("target");
    var wantp=gmGet("wantp")-1;
    var from=getGSP("thisgalaxy","thissystem","thisplanet");
    var to=getGSP("galaxy","system","planet");

    // p.nextIn(ARRAY) ???
    while (p.next())
		  {
		    switch (isin(p.last,["Transport","Stationieren","Abbau"]))
			    {
					default:
						continue;
						
					case "Abbau":
						if (gmGet("fleetmode")!="mine" || to.replace(/:/g,",")!=gmGet("automine"))
							continue;
						break;
						
					case "Transport":
						if (gmGet("fleetmode")!="trans" || targ!=wantp || to!=planetGetN(wantp,"pos") || at!=gmGet("wantt"))
							continue;
						gmSet("wantp", 0);
						el("resource1").value = noneg(gmGet("wantm")-planetGetN(targ,"m"));
						el("resource2").value = noneg(gmGet("wantk")-planetGetN(targ,"k"));
						el("resource3").value = noneg(gmGet("wantd")-planetGetN(targ,"d"));
						break;

					case "Stationieren":
						if (gmGet("fleetmode")!="stat")
							{
								at	= 0;
								break;
							}
		        //l("from=",from," to=",to," 1=",planetGetN(fromPlanet,"pos")," 2=",planetGetN(toPlanet,"pos"));
						if ((from==planetGetN(fromPlanet,"pos") && to==planetGetN(toPlanet,"pos") && (lowPlanet()!=toPlanet || at!=sendTrans)) ||
								(  to==planetGetN(fromPlanet,"pos")))
							{
		            //el("resource1").value = noneg(planetGetN(targ,"m")-1000);
		            //el("resource2").value = noneg(planetGetN(targ,"k")-1000);
		            //el("resource3").value = noneg(-planetGetN(targ,"d")-1000);
								exec("maxResources()");
								// reduziere Deuterium um 500?
							}
						else if (targ<0)
							at  = 0;
						break;
				  }
				delay(function(){
					p.sub(".//input").el().checked=true;

					if (at)
						clicklater(path("//body/div[4]//table//tr//input[@type='submit' and @value='Weiter']").el());
					});
				return;
			}
		gmSet("fleetmode","");
    break;

  case "flottenversand":
	  switch (gmGet("fleetmode"))
		  {
			case "mine":
			  // Successful salvage
			  var sal	= gmGetArray("salvage");
				var to  = gmGet("automine");
				sal[to]=gmGetArray("debris")[to];
				gmSetArray("salvage",sal);
				break;
				
			case "stat":
        var targ=gmGet("target");

        if (targ>=0)
					planetSetN(targ,"trans",planetGetN(targ,"trans")+sendTrans);
				break;
			}
		gmSet("target",-1);
    gmSet("autotransport",0);
    break;

  case "messages":
    p=path("//body/div[4]//table//tr/td/table//tr");
    while (p.nn())
      if (p.is("Flottenkommando"))
        if (p.is("Stationierung einer Flotte") ||
            p.is("Rückkehr einer Flotte") ||
            p.is("Erreichen eines Planeten"))
          p.sub(".//input").el().checked=true;
    break;

  case "galaxy":
	  gal = fixInt(path("//form//input[@name='galaxy']").el().value);
	  sys = fixInt(path("//form//input[@name='system']").el().value);
		l("gal=",gal," sys=",sys);
    p=path("//body/div[3]//table//tr/th/a[@title]");
		debris	= gmGetArray("debris");
		salvage	= gmGetArray("salvage");
		have	  = new Array();
		for (;;)
		  {
			  var e=p.nn();
				if (!e)
				  break;
				if (e.title.match(/Tr.mmerfeld/))
					{
					  var s	= e.title;
						res	= fixInt(s.replace(/.*M: /,""))+fixInt(s.replace(/.*K: /,""));
						pl	= fixInt(e.parentNode.textContent);
						l("pl=",pl," res=",res);
						have[pl]=res;
						here=gal+","+sys+","+pl;
						if (salvage[here]!=res)
						  debris[here]=res;
					}
			}
		for (pl=16; --pl>0; )
		  if (!have[pl])
			  {
				  here = gal+","+sys+","+pl;
				  salvage[here]	= "";
				  debris[here]	= "";
		    }
		gmSetArray("debris",debris);
		gmSetArray("salvage",salvage);
    break;

  case "flotten":
  case "buildings":
  case "techtree":
  case "micropayment":
  case "statistics":
  case "suche":
  case "buddy":
  case "options":
  case "allianzen":
  case "overview":
  case "resources":
  case "infos":          // Gebaeudeinfo
  case "notizen":         // Notizen
  case "renameplanet":   // Planet umbenennen
  case "flottenversand":
  case "bericht":
    break;

  case "b_building":    // Gebäude
    BuildingMarker();
		BuildingData();
    break;

  default:
    alert(page);
  }
}

function planetStr(p)
{
  return ""+selOpt(0,p).innerHTML;
}
function planetPos(p)
{
  return planetStr(p).replace(/^.*\[/g,"").replace(/\].*$/,"");
}
function planetName(p)
{
  return trim(planetStr(p).replace(/\[.*$/g,""));
}

// Switch to previous planet
// There's no opposite, as working backwards is just fine.
function prevPlanet()
{
  goto(selOpt(0,planet-1).value, 1500);
}

// Fetch Galaxy, System, Planet from hidden form values
// Form the planet location
function getGSP(g,s,p)
{
  return el(g).value+":"+el(s).value+":"+el(p).value;
}

function getInt(s)
{
  var i  = fixInt(s);
  return i ? i : 0;
}

function extract(str,what)
{
  var i = str.indexOf(what);
  if (i<0)
    return 0;
  var s = str.substr(i).replace(/^[^0-9]*________/,"").replace(/[[:space:]].*________/,"");
//  l(what,s);
  return getInt(s);
}

function BuildingGetMKD(o)
{
  var need=o.innerHTML.replace(/.*<br>Ben.tigt:/,"").replace(/<br>.*________/,"");
//  l("click", need);
// Rundungsprobleme in Ogame.
  return [ extract(need,"Metall:")+0, extract(need,"Kristall:")+0, extract(need,"Deuterium:")+0 ];
}

function BuildingDest()
{
  var mkd=BuildingGetMKD(this.parentNode.previousSibling);

  gmSet("wantp", planet==fromPlanet ? 0 : planet+1);
  gmSet("wantm", mkd[0]+1);
  gmSet("wantk", mkd[1]+1);
  gmSet("wantd", mkd[2]+1);

  this.setAttribute('color', '#0000ff');
}

function BuildingMarker()
{
  if (planet==fromPlanet)
    return;

  var m=planetGetN(fromPlanet,"m")+planetGetN(planet,"m");
  var k=planetGetN(fromPlanet,"k")+planetGetN(planet,"k");
  var d=planetGetN(fromPlanet,"d")+planetGetN(planet,"d");

  var p=path('//body/div[4]//table//tr/td/table//tr/td[3]/font[@color="#ff0000"]');
  var n=p.all();
  for (var x in n)
    {
      var mkd=BuildingGetMKD(n[x].parentNode.previousSibling);
      
//      l("p ",mkd);
      if (m>=mkd[0] && k>=mkd[1] && d>=mkd[2])
        {
          n[x].addEventListener("click",BuildingDest, true);
          n[x].setAttribute('color', '#ffff00');
        }
    }
}

function innerText(o)
{
  var s=""+o.innerHTML;
	return s.replace(/<[^>]*>/g," ").replace(/  *________/g," ").replace(/^ /,"");
}

function BuildingData()
{
  var p=path('//body/div[4]//table//tr/td/table//tr/td[2]');
  var n=p.all();
  for (var x in n)
    {
		  var mkd=BuildingGetMKD(n[x]);
			var s=innerText(n[x]);
			var g=s.replace(/ .*________/,"");
			s=s.replace(/\).*________/g,"").replace(/.*\(/,"(");
			if (startsWith(s,"(Stufe "))
			  s	= s.substr(7);
		  else
			  s	= "0";
			l(mkd," ",g,"#",s);
			planetSet("g"+g,s);
		}
}

###

###
 * FOLLOWING IS PLANNED CURRENTLY AND NOT WORKING AS PLANNED!
 *
 * Getting started:
 * - In a browser with GreaseMonkey open the UI (example: gameslave.html)
 * - Follow instructions shown, in particular:
 *   - Under "Preferences" there is a button to install this script into GreaseMonkey.
 *     - Click on this button
 *     - *Make sure that the "debug" setting is set to "alert"
 *   - In the same browser, open the page you want to remote control
 *     - Copy the shown URL from the address bar into Clipboard.
 *     - Under Greasemonkey (Firefox: Tools - Greasemonkey) choose "Manage User Scripts"
 *       - Choose "Preferences" for the user script "gameslave"
 *         - Under "User Settings" section "Included Pages" click "Add" (it is on the right)
 *           - Paste the URL from the Clipboard
 *           - Modify the URL such, that it includes all pages (it should end in "*")
 *           - Click "OK"
 *         - Click "OK"
 *       - You can close the TAB "about:addons" which shows "User Scripts"
 *     - Reload the page which shall be remote controlled
 *       - Now an alert shall show up which tells you "GameSlave debug: New URL:" and the URL
 *         - Note: This alert only shows up if the "debug" setting is set to "alert" (see above)
 *         - Click: No
 *           - "No" disables further alerts
 *           - "Yes" kees the alert debugging on, so you can add more pages if you like
 *     - Close the game page
 *   - Go back to UI
 *   - Under "Edit" you will now see the page just added
 *     - Select the new page to edit it
 *       - Change "Name" to give it a meaningful name
 *       - Change "URL" to point to the correct URL to start your game
 *       - Change "Prefix" to match all pages (it must not end in a "*")
 *       - Click "Save"
 *   - Under "Open" now a button with the given "Name" shows up.
 *     - Click this button
 *       - Now another window opens.
 *       - As soon as the other window is opened, the UI changes
 *     - Arrange the two windows (UI and controlled) accordingly
 *       - If the UI knows about the controlled page you probably do not need the page,
 *         as the UI takes over everything required from the page and leaves away unneccessary stuff
 * - Note that the UI is very limited if not configured for the pages
 *   - Some pages may need a special module to be handled correctly.
 *   - This is work in progress and not described here.
 *
 * This script
 * - creates a generic gateway to an alternate (generic) UI.
 * - is carefully designed to do no harm.
 * - never does anything on it's own.
 * - uses no timers.
 * - uses no automated reloads.
 * - is explicitely meant to fulfill (but is not limited to)
 *   https://de.wikipedia.org/wiki/Gleichstellung_%28Behinderte_Menschen%29
 * 
 * This script allows to implement a UI which is designed for handicapped people
 * (for example those who cannot use mouses nor touchscreens and are handicapped to use keyboards).
 * This way handicapped people can play web based games much like non-handicapped people,
 * for games not explicitly designed for those handicapped people.
 *
 * Note that, according to German law, there is no permission required to use this script on a page.
 * Also note, that banning this script by the page probably discriminates people.
 * See "Niemand darf wegen seiner Behinderung benachteiligt werden."
 * https://de.wikipedia.org/wiki/Artikel_3_des_Grundgesetzes_f%C3%BCr_die_Bundesrepublik_Deutschland
 * (Reason: This script is designed to allow handicapped people to use a page like the able-bodied.)
 *
 * January 2016 (this is in German as I currently only look in regions I can reach by car):
 *
 * Ich bin auf der Suche nach interessanten Einsatzgebieten um die UI zu entwickeln.
 * Ich mache das zwar in meiner spaerlichen Freizeit,
 * bin aber gerne bereit zu unsterstuetzen so gut es nur geht.
 * Ich kann keine finanzielle Unterstuetzungen leisten.
 * Ich kann keine finanzielle Zuwendung entgegennehmen.
 * Ich bin aber gerne bereit zu vermitteln, also zwischen Leuten,
 * die unterstuetzen wollen und denen, die Unterstuetzung brauchen.
 *
 * Entsprechende Nachrichten bitte auf meinem Pager hinterlassen:
 *	https://hydra.geht.net/pager.php
 *	!! Reine Anfragen zu Installation oder Konfiguration von GameSlave werden ignoriert !!
 * Nachrichten bitte *nicht* als wichtig markieren
 * (Wichtige Nachrichten entsprechen einem an mich gerichteten Notruf).
 * Bugs bitte auf GitHub posten (issue oder pull-request).
 *
 * Ich verwende Englisch, damit ich mehr Menschen, nicht nur Deutsche, erreichen kann.
###

#// ==UserScript==
#// @name        gameslave
#// @description Mouseless UI for HTML sites like browser games
#// @version     1.{{{VERSION}}}
#// @downloadURL https://hydra.geht.net/gm/gameslave/gameslave.user.js
#// @namespace   https://hydra.geht.net/gm/gameslave/
#// @include     https://hydra.geht.net/gm/gameslave/*
#// @grant       GM_info
#// @grant       GM_deleteValue
#// @grant       GM_getValue
#// @grant       GM_listValues
#// @grant       GM_setValue
#// @grant       GM_xmlhttpRequest
#// @require     gmlib/libcoffee.js
#// @require     gmlib/libgm.js
#//
#// Include favorite (supported) games here:
#//
#// @include     /^http://uni[0-9]\.xorbit\.de//
#// ==/UserScript==
#//
#// DO NOT MODIFY!  Instead modify: {{{FILENAME}}}
