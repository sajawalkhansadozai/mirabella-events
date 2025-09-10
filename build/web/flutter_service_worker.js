'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "1933a8d18c3ec0e77a10ba9044a4391e",
"assets/AssetManifest.bin.json": "3f6686cb1013e0feab7c1f8a40c2d5f9",
"assets/AssetManifest.json": "11ba8a82bd4b9d6be0e37592a58a4ca1",
"assets/assets/hero/slide1.jpg": "92cf9cd91d12a469392d06131669a5c6",
"assets/assets/hero/slide2.jpg": "ba2bfcadbd6c2988472da14f9c3203c8",
"assets/assets/hero/slide3.jpg": "3d396c95b02d01e90ac4bbdb0fe3eb04",
"assets/assets/hero/slide4.jpg": "4cace0a66bee233473d44c56407363af",
"assets/assets/images/services/awards.jpg": "cf118f459ddba3486f92e69a778c0c6d",
"assets/assets/images/services/corporate.jpg": "b3c241c06db1bf8af1f15aa6afcb97b7",
"assets/assets/images/services/gala.jpg": "aec945ee8fd1fbd44b1c200473f8e4c1",
"assets/assets/images/services/milestone.jpg": "dc703775622ba2689c6fee7a010f99a8",
"assets/assets/images/services/social.jpg": "978537f609487d9374e04e7a19aaa7dd",
"assets/assets/images/services/wedding.jpg": "f7dc7c9ec3af13243cb2115af402193b",
"assets/assets/images/team/aqib.png": "4d68be500f86a27d221467b106066182",
"assets/assets/images/team/mustafa.png": "a60182b9b4677042a283bde22338f765",
"assets/assets/logo.png": "2a0f7b52d19328ebc637d0365bc57e7e",
"assets/assets/portfolio/ceremony_1.jpg": "055abdc843966002fadfccd37f9676e1",
"assets/assets/portfolio/ceremony_2.jpg": "67c460160512d884841f5b90d1b0852f",
"assets/assets/portfolio/ceremony_3.jpg": "45e64f5392e71872f47047022e469e7a",
"assets/assets/portfolio/ceremony_4.jpg": "dc3d8935bebbeb023ccb722200b6df07",
"assets/assets/portfolio/corp_1.jpg": "8f7f51489689fa66634ed956850bc0cb",
"assets/assets/portfolio/corp_2.jpg": "3b5453b3372a86001d2a6e8571daef04",
"assets/assets/portfolio/corp_3.jpg": "d46a64f485a025350c1af8b933059a48",
"assets/assets/portfolio/corp_4.jpg": "b89af565904610ebc0fc438438f67b59",
"assets/assets/portfolio/corp_5.jpg": "bda78d4eb0f01febf08c1695ceeab7e8",
"assets/assets/portfolio/gala_1.jpg": "52256267fc2cae4855a28dc173b39c09",
"assets/assets/portfolio/gala_2.jpg": "fc1058ae593eafc91c14758502aafa01",
"assets/assets/portfolio/gala_3.jpg": "b507d69731cfc333d2bd785378d53ebc",
"assets/assets/portfolio/gala_4.jpg": "4e54f1111e22809916fb6ba5fd579b50",
"assets/assets/portfolio/social_1.jpg": "f19680e066a1b1175a04317e5f6e5a15",
"assets/assets/portfolio/social_2.jpg": "c524dfc940a91168d88c1322a3938cbd",
"assets/assets/portfolio/social_3.jpg": "2d9c0b0e51797bdad07aea8d15665716",
"assets/assets/portfolio/social_4.jpg": "9571a0423f8126a010d0f7d706ee86dc",
"assets/assets/portfolio/social_5.jpg": "a9284f1efa3ec3105450904575af1976",
"assets/assets/portfolio/wedding_1.jpg": "65913522277503783f46fb4c5ebe4460",
"assets/assets/portfolio/wedding_2.jpg": "b919d52585067873911e23a8bdd00f25",
"assets/assets/portfolio/wedding_3.jpg": "e229cd757c5ef3407628802794e68a5f",
"assets/assets/portfolio/wedding_4.jpg": "ddad937f7c7fd4c96fbc9c585c6a8020",
"assets/assets/portfolio/wedding_5.jpg": "be6a6169ef3cf9eee895f61f12cee7a5",
"assets/assets/portfolio/wedding_6.jpg": "632a9abdad6feb55e92bce19c8039ddc",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "5ecd6b68811bbfa50a16611901ed79f7",
"assets/NOTICES": "7e39a72d80b2417a0639895f30f836b1",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "2a0f7b52d19328ebc637d0365bc57e7e",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "4d38a3f1bbad171c8cadfefa7f8bfea5",
"icons/Icon-192.png": "2a0f7b52d19328ebc637d0365bc57e7e",
"icons/Icon-512.png": "2a0f7b52d19328ebc637d0365bc57e7e",
"icons/Icon-maskable-192.png": "2a0f7b52d19328ebc637d0365bc57e7e",
"icons/Icon-maskable-512.png": "2a0f7b52d19328ebc637d0365bc57e7e",
"index.html": "1f0fb4a7aaedad240cbb5e864d4c7cad",
"/": "1f0fb4a7aaedad240cbb5e864d4c7cad",
"main.dart.js": "2bf043bda2bb20c45f3d47a30279236f",
"manifest.json": "283965bb4a3e093acb9599f9605b50bf",
"version.json": "b70d5508e5686fd74507c3f08d460ce1",
"_redirects.txt": "c62c109df475b368db5e075d5e2f0052"};
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
