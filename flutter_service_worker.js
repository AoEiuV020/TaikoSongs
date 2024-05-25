'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"README.md": "80bb5ef8cc71e6b621b8eecb3025bfd5",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"icons/Icon-maskable-192.png": "3d09f715e505512315061a00ee13dc43",
"icons/Icon-maskable-512.png": "278abae0a11954c7a9d1cbc7bd4a409e",
"icons/Icon-512.png": "278abae0a11954c7a9d1cbc7bd4a409e",
"icons/Icon-192.png": "3d09f715e505512315061a00ee13dc43",
"manifest.json": "25e75c83f8824e2ac492a37b9d56461c",
"favicon.png": "bd9094370184eb2556fc2a21cdc7e7b8",
"flutter_bootstrap.js": "55bacfd2216d6afcddb5f06baedecaae",
"imageMergeTransform.js": "429e5a1f1caae51966f5015f9057445b",
"version.json": "baf538e51518538ef71947bb5916ed58",
"imageMergeTransform.dart": "9a1000fee08256f0518c63e3d07085c6",
"index.html": "1a7876160fb08e50d874fc597fec29d5",
"/": "1a7876160fb08e50d874fc597fec29d5",
"main.dart.js": "c39dacf7fa24da30b331e5a8858f7dcf",
"assets/AssetManifest.json": "3f5e0d53c90715b80f073bf0ae3c4c8c",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "e0b709b3e67c2f930723095c51f8a8f4",
"assets/fonts/MaterialIcons-Regular.otf": "f005411919d98cfdf67069900a2bef3c",
"assets/assets/images/2.0x/flutter_logo.png": "4efb9624185aff46ca4bf5ab96496736",
"assets/assets/images/3.0x/flutter_logo.png": "b8ead818b15b6518ac627b53376b42f2",
"assets/assets/images/flutter_logo.png": "478970b138ad955405d4efda115125bf",
"assets/assets/line/taiko_release_DS2": "e957c1bab2fa4584149eb188c7119cee",
"assets/assets/line/taiko_release_ce2ab26c597c0884097e404e3bdce30d": "d02f0249cf6d02eaf2d54bd6dde0d3be",
"assets/assets/line/taiko_release_Wii%252520U3": "debd8ebb490f923ca6f5d3eefb28cdc8",
"assets/assets/line/taiko_release_AC10": "e404180a7195765817c2d84725b7d3e7",
"assets/assets/line/taiko_release_0ff3b24ced5a634f9629df033ffda496": "3c4208652868be31d4c7b34f277de2d3",
"assets/assets/line/taiko_release_AC11": "3e650002d6aa2fc876b57193d2f9a614",
"assets/assets/line/taiko_release_AC12": "3fb569b2e09cbb85e775b816d11d35cc",
"assets/assets/line/taiko_release_AC3": "0b8d16749d22472ae01e62457fdd8e69",
"assets/assets/line/taiko_release_5dd2af10a2f501a5cca08504aaea46b8": "e1d6c999feaacf72d86e4953e2f84f9b",
"assets/assets/line/taiko_release_PS%252520Vita%252520MS": "d9873c1ffcffbab8389d85a25f19f77b",
"assets/assets/line/taiko_release_CS7": "23486b7fe2c4cdbbeb2660eb3973a2e4",
"assets/assets/line/taiko_release_Beena": "80fc2bfbade9d2410d1730e593229350",
"assets/assets/line/taiko_release_PTB": "6b65ee0da7ef9a338babd9fadf85c37a",
"assets/assets/line/taiko_release_AC8": "7675d1adc9905c9084237fe013df6eac",
"assets/assets/line/taiko_release_CS3": "a9287ff993e2b3e672e7ea965ff1a58f",
"assets/assets/line/taiko_release_Wii3": "f2dcaefd858cf72b084776c18334cdac",
"assets/assets/line/taiko_release_NS%252520RPG": "c8e889f16350e557c7c98bcd02a3dd30",
"assets/assets/line/taiko_release_RC": "832ad675ea8447f0a58f30e8b2578564",
"assets/assets/line/taiko_release_Wii2": "c5720f3c38be443deb0f40e8eba7a196",
"assets/assets/line/taiko_release_Wii4": "9b9cd206dd394f606a6c43fb7790fe0f",
"assets/assets/line/taiko_release_AC7": "1d984de54cda77b170aeaf7024416c2a",
"assets/assets/line/taiko_release_c3aa02936a8fa4f18632937e11e562be": "8288aa7be4ecf0b629965dcc72510dd4",
"assets/assets/line/taiko_release_AC4": "a37ae8128e016ff1414be0add146ec82",
"assets/assets/line/taiko_release_ce7010a67619ea6459df1bdb263eb9b4": "25a603e0f6de8bf05f0d9df263b9a193",
"assets/assets/line/taiko_release_Wii1": "344a138ec154e00985448e1c286c18f8",
"assets/assets/line/taiko_release_AC13": "338cdb771ca2d4c06615b5dd640c098c",
"assets/assets/line/taiko_release_65287e484ec748ea93ce910c9303dfee": "a53024f6c6c1a8744d1d6c8a46d68b02",
"assets/assets/line/taiko_release_CS4": "72dd67fdc97f439305c356d85ca20ed8",
"assets/assets/line/taiko_release_TDM": "9d4f0ba12eb2bb716d8fb9fa597a9efe",
"assets/assets/line/taiko_release_AC12%2525E4%2525BA%25259C%2525E6%2525B4%2525B2%2525E7%252589%252588": "eb014bf646dc6d0865b739ecc771e69c",
"assets/assets/line/taiko_release_DS3": "02ee7c41e1c14bae0eebaf2fc4b79148",
"assets/assets/line/taiko_release_3DS1": "3a33dd8e910de0989fcbb0b4413a89ef",
"assets/assets/line/taiko_release_2152842f6ec422eb3e030ee4dda8f663": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/line/taiko_release_Xbox1": "54191d4e8ce63461f7c0afc5dc9d175e",
"assets/assets/line/taiko_release_CS1": "69f76377a6efecbf6612397c8bdaaa94",
"assets/assets/line/taiko_release_PS4%2525201": "a415da60326ef3a393785dbdf1bb820b",
"assets/assets/line/taiko_release_bbafd25204516b53e91134021b2b4b99": "f0ebba5930ab191cf94e256c9504c5fd",
"assets/assets/line/taiko_release_AC11%2525E4%2525BA%25259C%2525E6%2525B4%2525B2%2525E7%252589%252588": "0398af680974591a0bf8bda7ceae8555",
"assets/assets/line/taiko_release_3b477c91d656e488387b28026cddb6a0": "8e233cd3b7945e20fe769266e00a7257",
"assets/assets/line/taiko_release_%2525E5%25258C%252597%2525E7%2525B1%2525B3%2525E7%252589%252588TDM": "ef15e985a46c9af3adb21d312dc9c187",
"assets/assets/line/taiko_release_PSPDX": "7c4daea349824765679a477ecbcb61c4",
"assets/assets/line/taiko_release_8ba53c8d6e5af65d36500fa25c01c4b6": "687dc9befff3717cc8ab7b440f3d9b17",
"assets/assets/line/taiko_release_46f571399ae880b43235d9fab8ee82a1": "23553267f260316f8d4acfab69e69943",
"assets/assets/line/taiko_release_e47381c6a54e768ff2682a32bcae034b": "57177ec2c5811e920727e45afd7e4033",
"assets/assets/line/taiko_release_5630fad18ec8844f61beddd01183c934": "3e173478b95a582a5232648a9b4e5af5",
"assets/assets/line/taiko_release_PSP1": "8ca574fa821f635111df04ca5541f106",
"assets/assets/line/taiko_release_3DS3": "eda99cb68ca09c44b5155cf400a097df",
"assets/assets/line/taiko_release_AC1": "9af6caa7ae3aba6544f4c8e18acadb36",
"assets/assets/line/taiko_release_AC9": "19fb90e17eb00c9147b89f5eadfad8c0",
"assets/assets/line/taiko_release_CS2": "7781c18e9b0122217f4c51300d8bc115",
"assets/assets/line/taiko_release_99d5c6121d66a75596ebaa8a0be59868": "31b65d64c7df7e9ff90fedd70fb66838",
"assets/assets/line/taiko_release_Wii5": "a0a1f14b4d474749748e4fdffd5cc7c8",
"assets/assets/line/taiko_release_e421f8893e78f2f4c3811bd3bf3c953d": "29b7bbcef2b86353e770d81fe99e0148",
"assets/assets/line/taiko_release_3DS2%2525E9%25259F%252593%2525E5%25259B%2525BD%2525E7%252589%252588": "44acde1dd12378a0d52084a3d49baa5f",
"assets/assets/line/taiko_release_7a86e04bddeae46356d92c0e738f6326": "cb1cf40c6e180da90a20881e4d1d052f",
"assets/assets/line/taiko_release_AC5": "cc4813a6f65192dc371b936329b37dda",
"assets/assets/line/taiko_release_RT": "0d80eb0a53bb417284ab398d39793568",
"assets/assets/line/taiko_release_Wii%252520U2": "561d474f7f6ebbc33f4cb87d83e38c6d",
"assets/assets/line/taiko_release_95f22c0199bf850f8d9d86a8456242e2": "ddfdb9e6010e58cfe4bec502e9455d04",
"assets/assets/line/taiko_release_AC6": "783ba911e0cd7af8cf3f93cd0f90989a",
"assets/assets/line/taiko_release_45ca259f23ed371b4ec8bfaa3d2c5b7e": "87cb12a6949ab94f4af6eda49fe2b227",
"assets/assets/line/taiko_release_DS1": "0388402a5e4d7ce5b40617fa1cfb96a4",
"assets/assets/line/taiko_release_2e74e644569d8adc485e8b2eddd9b267": "eb3862e0c0d71ae64d73d5a7cf3d8e23",
"assets/assets/line/taiko_release_CS6": "c6a90813f7bd3d5e75c0f6ab82bed7b7",
"assets/assets/line/taiko_release_PSP2": "f59103b517793b7361c6d2d3e3b81efa",
"assets/assets/line/taiko_release_47b16b9e0143cc0b84320b8aeb137374": "789f6e7799fc9b7f292080e7fec06d9e",
"assets/assets/line/taiko_release_NS1": "774da52eadfcf48809e9909eae2f232e",
"assets/assets/line/taiko_release_AC12%2525E5%2525A2%252597%2525E9%252587%25258F%2525E7%252589%252588": "8d26a88acc063c31bbba89291878d10e",
"assets/assets/line/taiko_collection_%2525E4%2525BD%25259C%2525E5%252593%252581": "2b8f535b0e98ab44c38b2b331c78ae54",
"assets/assets/line/taiko_release_560319d426e05cadf4103a9ebcfee3e6": "ec9996850abc221f0f6dc747878983e7",
"assets/assets/line/taiko_release_51ed4f2d9f7ed132147d39b7ee29919f": "1bbde268793cea4c513e117f29e7967a",
"assets/assets/line/taiko_release_CS5": "045f91d427a7c2a44daa3a1db46db0cc",
"assets/assets/line/taiko_release_iOS": "affbe1ae774f44ccda2421c831b2a566",
"assets/assets/line/taiko_release_NS2": "3e03a9aa1346f53c3ceab9579cfcb0d8",
"assets/assets/line/taiko_release_PS%252520Vita1": "ff4a310ed7f872504c35a89663fdc634",
"assets/assets/line/taiko_release_%2525E6%252596%2525B0AC": "116ca8738cf3850843058508ef279506",
"assets/assets/line/taiko_release_AC2": "10654a872d9e66a090b20bf0b11330e8",
"assets/assets/line/taiko_release_Wii%252520U1": "9b356098efea3b04a5f9bb0dffe70045",
"assets/assets/line/taiko_release_a338df1c3dcd481ee10ba4a281ab3a1a": "7a8002107158dd524b90f37be1658806",
"assets/assets/line/taiko_release_3DS2": "0ec6aaf1e6ff200462b5f8d028423ab4",
"assets/assets/line/taiko_release_AC14": "44c53d601cb0ea95c0038b1a18f51467",
"assets/assets/translate/other.txt": "85b1e725838b9e1e278a9093c1ad2b76",
"assets/assets/translate/song_name_slash.txt": "534a926bb1af50f0faf5b2eff51701ca",
"assets/assets/translate/song_name_ps4.txt": "70c503bcd437a12cf7505a952249e977",
"assets/assets/translate/song_name_ns2.txt": "49e7c73d77534e4c241e4b5a2a0d1e61",
"assets/assets/translate/release_name.txt": "95ef56f7aa5ec0c78e492cdf381c7683",
"assets/NOTICES": "4b4b0af054931eb06ecf36a7857f379d",
"assets/AssetManifest.bin": "1d80e792a8f78f99f079e4ae0c3a0c57",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c"};
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
