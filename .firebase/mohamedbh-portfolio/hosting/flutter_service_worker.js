'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"index.html": "9e65beecafa2a1ee991863397ad4dd97",
"/": "9e65beecafa2a1ee991863397ad4dd97",
"main.dart.js": "75e839294f5340f9f651c3cfdbb4ffc6",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"manifest.json": "3eb37294dc10884094b0f5fb82b82769",
"icons/Icon-512.png": "e034fea3750d5d4fa17d0a3a081b23ff",
"icons/Icon-192.png": "733b570d1d4b8b05b97437b33a3107be",
"icons/Icon-maskable-192.png": "733b570d1d4b8b05b97437b33a3107be",
"icons/Icon-maskable-512.png": "e034fea3750d5d4fa17d0a3a081b23ff",
"favicon.png": "f1b6ef139ab0c08268936887c9f0a94e",
"flutter_bootstrap.js": "35125f1864e8d9546efb1d21da261f54",
"version.json": "30078fedd5f91140c8db5a67f72a812f",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "e81f240581a8c70259c1e0aa71939149",
"assets/AssetManifest.json": "2b390a84209773c6a5d787dc9d88e5bd",
"assets/AssetManifest.bin": "a096b6db51095414eda72e2ba9eeb903",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "15d54d142da2f2d6f2e90ed1d55121af",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "269f971cec0d5dc864fe9ae080b19e23",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "262525e2081311609d1fdab966c82bfc",
"assets/AssetManifest.bin.json": "d31c5058f943d01b26eb054d77d66597",
"assets/FontManifest.json": "67a28da3784fc091c2f816d615fbf08a",
"assets/assets/pdf.png": "79847610ae23e07495ecffa408a070ee",
"assets/assets/flutter.png": "4f1eb99a1dab4d4d1cb1c2c6c45df3d1",
"assets/assets/arduino.png": "c6d64daa5833b45b3f702ebdfa988395",
"assets/assets/firebase.png": "9ed79d8d77f3aab27b935896f7258479",
"assets/assets/apple.png": "a22b2e7d8200de522e46126db65bb287",
"assets/assets/MohamedBenHmida_ATS_CV_EN.pdf": "badc49147db8c29cd42aef23a9c1a951",
"assets/assets/python.png": "e127b5f8b6bdedacfaa22930f47e1f7f",
"assets/assets/icon.png": "807ade6d7271deab6def11f6be58f467",
"assets/assets/projects/hlpro_mobile/icon.png": "b1b5a3cd62135d2244550e08608fd378",
"assets/assets/projects/ilef_info_mobile/icon.png": "73b0771d0b29420b334ef73e354b2c7a",
"assets/assets/projects/seekers/screenshots/image2.png": "4a5db7dc7e9cc2f3eb629fa855c97288",
"assets/assets/projects/seekers/screenshots/image4.png": "5f6111e37c25810482a8dc1ed4ef8e56",
"assets/assets/projects/seekers/screenshots/image1.png": "350ffadc665b1fbc33d14d1ad3838c02",
"assets/assets/projects/seekers/screenshots/image3.png": "e307795ee4af974e6ec94ab2c2976963",
"assets/assets/projects/seekers/icon.png": "728b8390f12acfc65ee0ad1a9cc1edce",
"assets/assets/projects/sntat/image5.png": "d56588c48404a52833642ae13baaeeb8",
"assets/assets/projects/sntat/image2.png": "d9b92490a3e4b1c2f93b351673d9de06",
"assets/assets/projects/sntat/image4.png": "d9b92490a3e4b1c2f93b351673d9de06",
"assets/assets/projects/sntat/screenshots/image2.png": "a7faa4e2ce341bce45c5553601b88594",
"assets/assets/projects/sntat/screenshots/image1.png": "fe2af976199513fc779c64fa53097356",
"assets/assets/projects/sntat/screenshots/image3.png": "fe2af976199513fc779c64fa53097356",
"assets/assets/projects/sntat/icon.png": "4e2512a4c6e475be6033951c1ae817a4",
"assets/assets/projects/sntat/image1.png": "833ba3aacbd4df6df69bd1c192d1a593",
"assets/assets/projects/sntat/image3.png": "d56588c48404a52833642ae13baaeeb8",
"assets/assets/projects/kalonet/screenshots/image2.png": "d7a2ace2623b8e701b84f9d64664ef7c",
"assets/assets/projects/kalonet/screenshots/image4.png": "8f7abec5122fd53702f51a2ece5e1a07",
"assets/assets/projects/kalonet/screenshots/image1.png": "cb2009caaeddd5022d6b0d967e14d119",
"assets/assets/projects/kalonet/screenshots/image3.png": "f4fc4a068576a04d76038d7014a3e434",
"assets/assets/projects/kalonet/icon.png": "bf1cd19df0efbae36cf09e99e779e985",
"assets/assets/projects/digital_lib/screenshots/image2.png": "3389287e47a4b72c736e2773b32aa932",
"assets/assets/projects/digital_lib/screenshots/image4.png": "4f3106aa3962499894a925d7b28473c8",
"assets/assets/projects/digital_lib/screenshots/image1.png": "6cfef41e4bf92dc1abd5311224c2c5b2",
"assets/assets/projects/digital_lib/screenshots/image3.png": "b2cd534a8d86f661020494ca48051883",
"assets/assets/projects/digital_lib/icon.png": "abb33f727cba854915712678ea7d8b8f",
"assets/assets/projects/aswan/screenshots/image2.png": "bc04069127de9344b78f4b8c9d78f7c1",
"assets/assets/projects/aswan/screenshots/image1.png": "2c2ae34ba8048396f0f06fb9ebbc5e44",
"assets/assets/projects/aswan/screenshots/image3.png": "c5356b6beef36acb7708e74304cd7ab9",
"assets/assets/projects/aswan/icon.png": "f09a6050ba87917d505e1cccc44c74e6",
"assets/assets/projects/lib_corporate/screenshots/image2.png": "0f5127d99d3ea40353604921bcf65a88",
"assets/assets/projects/lib_corporate/screenshots/image4.png": "9f33b7690c67675b4e3ec59dcb400eb4",
"assets/assets/projects/lib_corporate/screenshots/image1.png": "7494517997d71d0f2d3df13a6a7a8f53",
"assets/assets/projects/lib_corporate/screenshots/image3.png": "6689e5b2ecf51f71ddde423b9ce16fa4",
"assets/assets/projects/lib_corporate/icon.jpg": "abcb5255fb6bcd4b52889b1f19274195",
"assets/assets/playstore.png": "18fab95d924ef304111a8efd2620c0a6",
"assets/assets/backbase.png": "89dc2ce9a3edf0aa772ac69e0b799f73"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
