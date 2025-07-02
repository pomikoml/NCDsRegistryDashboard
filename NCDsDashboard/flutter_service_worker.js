'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "c34ac8472017741a70d003802c936ddf",
"assets/AssetManifest.bin.json": "958742e4fbbc164ea95aa10899c279ac",
"assets/AssetManifest.json": "b60844e31ae57549b2ae0e5a73719630",
"assets/assets/audios/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/fonts/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/images/App_BG.png": "1fef683de7cfc465a04db9f5c263aa7e",
"assets/assets/images/app_logo.png": "f059b12a402e23a2d52dfd87f73ba42b",
"assets/assets/images/banner-bg.png": "f0c7401d464643e9414b0184423790ea",
"assets/assets/images/bg22.png": "9cdf0003319596fc0377a634094b437e",
"assets/assets/images/bg_provider_load.png": "00693662f3ab21e7e001c9363fc16613",
"assets/assets/images/blood-pressure.png": "93d7e8cdac00606dd7eabe6ef364e356",
"assets/assets/images/body.png": "485a81a1982d940fcd95137d063a45f5",
"assets/assets/images/brain.png": "338e298d57a748c8a6316b33975f49e8",
"assets/assets/images/clinic_(1).png": "06162edf5b534526e6af1f9a9f6eff43",
"assets/assets/images/copd.png": "8b9c4b6407122707616f3fe442ab3d92",
"assets/assets/images/decorate_login1.png": "eb53729031d3a99c344247c51a7cb17c",
"assets/assets/images/decorate_login2.png": "356b9aa1b7a9082f988718656e705f55",
"assets/assets/images/Delete.png": "bf05133dfa5e6919d5b5c2cf803453c3",
"assets/assets/images/diabete.png": "fe8dd8aad343be0c1670c89bb3180e12",
"assets/assets/images/doctor-avatar.png": "bea5498d65e50aab1fafb804d101cfcb",
"assets/assets/images/doctor_dashboard.png": "6025ff770e5dcb079e9e81922a700842",
"assets/assets/images/e-cig.png": "627630070f55db58260dc9e2afcb84a6",
"assets/assets/images/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/images/heart.png": "20bcd11c93e2b69ea34e5216c1522db7",
"assets/assets/images/highFat.png": "2f7927aa74ed678fa7dbe4205107f33a",
"assets/assets/images/highlight_login.png": "fed20d6035b5d5d90a7e8ed5d06685c4",
"assets/assets/images/hospital.png": "87a5c860ed11c726f8fdafbb858cef1e",
"assets/assets/images/image_33.png": "9562230a2cd7a6e71a3e2c9896579c3e",
"assets/assets/images/image_34.png": "51ddd45cf966ae793bf73f40f2da9610",
"assets/assets/images/image_35.png": "78daffea0e9bbb09d3174a77699b50ad",
"assets/assets/images/kidney.png": "92f8339632ee700967af9147ec832f4c",
"assets/assets/images/logout.png": "0d3a379a5e6115395b562b1b6b55bce7",
"assets/assets/images/ncds-logo.png": "1dfb16969cfc614cb7a99d3551410f1d",
"assets/assets/images/ncd_logo.svg": "2097e953150f3d8df9c167fecef27f78",
"assets/assets/images/obesity.png": "1d13e2acaddf259a9801602d3d313dc0",
"assets/assets/images/obesity_menu.png": "dc2c0c1a2c0876f4979177e696c88a42",
"assets/assets/images/providerid.png": "9a5228028af7f88dae553a1ebf98faad",
"assets/assets/images/provider_id.png": "16c04e8425b0a4d7dcc3541774387b71",
"assets/assets/images/Social_Share.png": "efd3634a09e416e595f40b850009f94f",
"assets/assets/images/workplace-with-laptop_1746647342.svg": "a7550fadc0bf3750774b518ca8aa0d1b",
"assets/assets/jsons/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/pdfs/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/rive_animations/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/videos/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "d8b9a7c5cc06c2f0412cdfcc70ff273d",
"assets/NOTICES": "07679205346d568ee266f56a2e3148c4",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "17ee8e30dde24e349e70ffcdc0073fb0",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "f3307f62ddff94d2cd8b103daf8d1b0f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "1b6748a3bf02f5cd4fc578c515b03a81",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "d7bc63e9893e41834377d7c7baa3fbd9",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "e13d72a8615f91a333aa7bf26d47130b",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "b37d19942e0f0bb61e5ca2c3691bdec5",
"/": "b37d19942e0f0bb61e5ca2c3691bdec5",
"main.dart.js": "30d500b4e0ce89718d67e54920c0ac1c",
"ncds-logo.png": "1dfb16969cfc614cb7a99d3551410f1d",
"ncd_logo.svg": "2097e953150f3d8df9c167fecef27f78",
"version.json": "e4d9dc14cd808ce0dc7ac0e543c50392"};
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
