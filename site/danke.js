/* Danke-Seite nach dem Download (danke.html und de/danke.html).
   Startet den Download des ZIP sofort und zählt ihn bei GoatCounter.
   Die Download-Knöpfe der Projektseite laufen über diese Seite
   (danke.html?f=zip). Bei jedem Release VERSION anpassen, sobald das ZIP
   am Release hängt. */
(function () {
  var VERSION = '1.3';
  function Url() {
    var name = 'StemTagger-' + VERSION + '.zip';
    return { name: name, url: 'https://github.com/Elospeed/StemTagger/releases/download/v' + VERSION + '/' + name };
  }
  var starten = /[?&]f=zip/.test(location.search);
  /* GoatCounter: nur der echte Download zählt; Zurück oder Neuladen nicht */
  window.goatcounter = {
    path: function (p) { return starten ? p.split('?')[0] + '?f=zip' : null; }
  };
  document.addEventListener('DOMContentLoaded', function () {
    var i, el = document.querySelectorAll('[data-dateiname]');
    for (i = 0; i < el.length; i++) el[i].textContent = Url().name;
    document.getElementById('nochmal').href = Url().url;
    if (!starten) return;
    var titel = document.querySelector('h1[data-laeuft]');
    if (titel) titel.textContent = titel.getAttribute('data-laeuft');
    if (history.replaceState) history.replaceState(null, '', location.pathname);
  });
  /* Download erst nach "load", damit GoatCounter (async) schon gezählt hat;
     spätestens nach 1,5 s, falls count.js blockiert ist. */
  if (!starten) return;
  var los = false;
  function Start() {
    if (los) return;
    los = true;
    location.href = Url().url;
  }
  window.addEventListener('load', function () { setTimeout(Start, 100); });
  setTimeout(Start, 1500);
})();
