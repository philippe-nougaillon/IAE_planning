var CACHE_NAME = "iae-cache-v1.0";
var CACHED_URLS = [
  // Bootstrap
  "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css",
  // Images
  "/logo_iae.png",
  // Offline page
  "/offline.html"
];

self.addEventListener("install", function(event) {
  event.waitUntil(
      caches.open(CACHE_NAME).then(function(cache) {
        return cache.addAll(CACHED_URLS);
      })
    ); 
});

// Intercepte les demandes, retourne l'objet s'il existe dans le cache, 
// sinon, et si c'est une page html, on retourne la page d'index-offline
 
self.addEventListener("fetch", function(event) {
  event.respondWith(
    fetch(event.request).catch(function() {
      return caches.match(event.request).then(function(response) {
        //console.log(response);
        if (response)
          return response;
        else if (event.request.headers.get("accept").includes("text/html")) {
          return caches.match("offline.html");
        }
      });
    })
  );
});
