'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "13cd2975cc9976cecf49cd307df11ea4",
".git/config": "422975543ffbdde8f47328de3b76c787",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "2e7a5095b896783d269865dacc3f43fb",
".git/HEAD": "4cf2d64e44205fe628ddd534e1151b58",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "4f520c035575533c71d44c18b2b5a157",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "bdbe274779e693b7870310c01121c1c6",
".git/logs/refs/heads/master": "bdbe274779e693b7870310c01121c1c6",
".git/logs/refs/remotes/origin/main": "6d59d6f3230fcb699cbacd8a54f9b00b",
".git/logs/refs/remotes/origin/master": "6b54f4238dc8b7592b2bc78372e3ff23",
".git/objects/0a/e1742a8ef9533a0d1b725fed81b3f005996f24": "2d09ffa71e0cd64f257315e7200d5c17",
".git/objects/0d/10cc1eff7915a53e0429cbeb60087b70e959de": "6bc18658e484c91af9f45fc02886dab2",
".git/objects/0e/e514dc0e17e1b0feadb1524822b285014e71a6": "36fcb8b8c2241c6f3d18034c562f848a",
".git/objects/0f/c344c7e8b9e32ea1ad91f30ded22556352d7bf": "a8a30f28869f7378465338066f34d80d",
".git/objects/12/4d6e4d7e23fc292e2e7d837ac8c028c6388e54": "11d7e41384a04cd9edfe4985147943ea",
".git/objects/16/0001a8b2c73edcf79ab88ca121ee0944de258e": "ce3e67eaf58958245d57c09e73d54cad",
".git/objects/17/ffaa201551946c5ca9d8d493600569eac3258c": "25012a981c6562091d770d0d6dcd0bb2",
".git/objects/18/eb401097242a0ec205d5f8abd29a4c5e09c5a3": "4e08af90d04a082aab5eee741258a1dc",
".git/objects/1a/19e03b9a0076e77c4b2c637ff27a03ebc2d7ba": "692efecd9238304dc0befec39155924e",
".git/objects/1e/7d3de87a50ff4e9290c7c10d301c3c2c286684": "a981a0928a4a1542d46585e97037b763",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/20/1afe538261bd7f9a38bed0524669398070d046": "82a4d6c731c1d8cdc48bce3ab3c11172",
".git/objects/20/815149135c837a5aa1ef1ebe74daf0689c085b": "d8eab53df5f475738675e7c42687c1b1",
".git/objects/20/cb2f80169bf29d673844d2bb6a73bc04f3bfb8": "b807949265987310dc442dc3f9f492a2",
".git/objects/24/9f4875f1f496a188ea512d646df8455563282a": "7fbed3995a168c0835a26ed02a8e52a2",
".git/objects/25/8b3eee70f98b2ece403869d9fe41ff8d32b7e1": "05e38b9242f2ece7b4208c191bc7b258",
".git/objects/28/65cdf4a2771abcf05965cee4972335ffc52179": "1a9b76cca1d20610808f12d829479c9a",
".git/objects/28/7325dfc250d9a0ff89f887cb6cfea39c3bae9b": "f8e1d855d33116aae374cad9c911e03c",
".git/objects/2e/e295ac4c545063047135099bc20f8753d9ad6e": "28bd424c852c0b7e6c848c72be84305f",
".git/objects/31/776b43a16b0e4f943dbc8d90840890b8a5c572": "c909f59ed3c50c55beec9c854e682828",
".git/objects/33/8e48dcef659ccecea87f24e422fce3da3d348b": "5748caf078aa75715d4a2d799e3e5950",
".git/objects/37/eda5f68203f41061bd70d465d4169d38537456": "f4765fcdc77e974af5985c1e12224d62",
".git/objects/3d/eeb716d7674fa3ef1ae1041874f06129ba397c": "aca8a1166caf55c16e245f19ddc79779",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/49/4acede0c520f847f75982ca1f671fc6eaa889e": "c4a42624eaa20c8a64455bab6edd0908",
".git/objects/49/adebdb511c8c293b28db3f6792e5bac28cdc32": "ba6a3971e7f06834fd6ec3844372ce17",
".git/objects/58/356635d1dc89f2ed71c73cf27d5eaf97d956cd": "f61f92e39b9805320d2895056208c1b7",
".git/objects/58/b007afeab6938f7283db26299ce2de9475d842": "6c6cbea527763bb3cdff2cecfee91721",
".git/objects/62/c89ee094658c7a9465824fdb42793a64ea557b": "133cd5da638f245b079d9e9cdc29ae38",
".git/objects/62/cecfdb9440e79370b6a62f28501500c66e9fe3": "e113b02185eb10f352ad84adfb1beed8",
".git/objects/66/9082e6f45fbaa1aeb4911c2205f7f33a0fb962": "2a0aed4d658835d2563be8cfe8d9a8b1",
".git/objects/67/e853e5cf6115ea00953a588ff5f4696bad8600": "8d1787a8e59b7ffaf4de2415b4448292",
".git/objects/71/3f932c591e8f661aa4a8e54c32c196262fd574": "66c6c54fbdf71902cb7321617d5fa33c",
".git/objects/72/6577c597286b8f2eba20927cc060eccd416323": "d0393503b2a53d163d7dc8e75d78af67",
".git/objects/75/426673fc2c36f64c03cd0d6ca541de174f1d41": "dcf5fba48ba8a6587e2d5caf996e0d7f",
".git/objects/77/1f88ab93af0f9d042e4362c40a49efe60e755c": "48be13a1ab49640aa0d6ffd743b38914",
".git/objects/7a/74d17fc79f9f6e9f4be0e93bd3ac5142c9c23c": "ae33749de77ff1a7eac6c02c72ffc613",
".git/objects/7b/20e59d5db0592e17ab22799673cedfe42f0c2e": "5472e3aa15ebcbc5ebfcbf07d7e9faf0",
".git/objects/7b/f82068451ab23039cbd06c68ad04cfbf302358": "439332ff4cc4dffa6fe5bb617746c903",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/86/c8bd0e66eab4e536adefa4e24be312b968e3bb": "791409aa4e4b5dc06287a5ee88e5036b",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8e/a5118cfc0c1a04efa50a4cec44e26ace16803d": "9ff21288a4f38c0a42646420fb4c4d98",
".git/objects/8f/4909ce82be9c574e8c18ad5a92bcf7f6afd930": "9a94b13dc4f24fdf54fedabf74eb085d",
".git/objects/93/d6eaaff43211eacb03d62985a6df2e0bc3f2c9": "3211edb4b25b395769e0e146f9751a04",
".git/objects/94/f7d06e926d627b554eb130e3c3522a941d670a": "77a772baf4c39f0a3a9e45f3e4b285bb",
".git/objects/9f/e61616640732805b9fd2666ad88078c78ebac5": "5eab72b19fead5517f743f6f674c3842",
".git/objects/a0/e8e950fb093121ae2d8afa81ad6314868a126a": "574731f09d0aa3d14518a4b8e34dcf61",
".git/objects/a1/7669f6647941f7615002d4965e3c1f7b47d504": "44c03e409d2b229c74442e6e005b2184",
".git/objects/aa/8e3b0c1463dd51f4ddb09aaecb1fc2e27f90e7": "577bec3dce991fa589127d35f10adc79",
".git/objects/ab/82315f30da959fab5157430d7a60d2c41e7065": "87f9896f31126fef4e7da5ee3933e8f4",
".git/objects/b3/ebbd38f666d4ffa1a394c5de15582f9d7ca6c0": "23010709b2d5951ca2b3be3dd49f09df",
".git/objects/b5/9c15601c81a23ec5572994fdd75ebff227c020": "d73bfc67585f62574369bf46687fea57",
".git/objects/b6/a89b56980f694e42f1c5e7eded284bcf1ba3f9": "e324b50118f64f9327ca0e22036ff1b0",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/bd/401561131acb4665fe0862d4b6b604bb40ee0b": "e830a1ad3fb81eddd6f1c1e37fc40afc",
".git/objects/be/02cd3d3e3ccf30a724ccd4b07a3688140d0748": "46ff09f4a63f6e87e6f53e32c01cfed1",
".git/objects/c5/c3f79ad3cd6c8077124a31ac14b8bba6cf25b7": "4c72412d8df20e0c8840519c88a9eaa5",
".git/objects/c6/688892f679d686ba4561cf5a4265b021d610ea": "d3ab4a2735a1edce77749b43320095b1",
".git/objects/c7/46018d4cdabec4d0312f2592367c37a9b67608": "f0db476504eae5561a70a47488ea1179",
".git/objects/c9/bf8af1b92c723b589cc9afadff1013fa0a0213": "632f11e7fee6909d99ecfd9eeab30973",
".git/objects/cf/5dd895ca7cd56a0491cf1d7fb7b5f829a16283": "176736f5ca6a9e0b0451892bf1367cb2",
".git/objects/d1/098e7588881061719e47766c43f49be0c3e38e": "f17e6af17b09b0874aa518914cfe9d8c",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d4/a58771b6eb3390b098cd619662b45f55a7b865": "4b7cdd3978efa1c5d4736d3d9ab06e91",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d8/6a4177c09a4221948c8a38e58c404b34509444": "28a12e3d603e130f67ca2960141f3d03",
".git/objects/db/c3ea65062c27b6e1f9f33611c67f627362aef0": "264b2f2247ef4b519fa5174599f5a823",
".git/objects/e9/1f392c821148234666c226d6296530cc7f696f": "402113e146ab950b80e45dfa1ece54f2",
".git/objects/e9/22a707a5fc5b3ece8348e64a178731fc1336ec": "42a93c6e67dea28fed06609c0d87e35e",
".git/objects/ea/47095526b4d22663534e8ee9f8c0e4a421c8ff": "6e24fb9d48d66e289276ddd0270ffe3f",
".git/objects/ea/8a047dc330372d816a7237ea59ef578de14e59": "cad9e1fc776c7ef069b0776020701274",
".git/objects/eb/1bfa20197907053351208abb2d26277c174f1f": "61c3431b1f084ac1fa4e8fb9793cd8c9",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f9/1bbc2faa9c7f6443b74b72f6bea30ca14309ae": "d446b0a80c4d169593b9e5714b656603",
".git/objects/fb/d77da06f1959de18f09a5fe32b0a9e4c57ee1d": "cab46a29b67bda849096b607036414c9",
".git/objects/fd/e5e83aba19c93a24961017a49ce8212d3489db": "c075eb5954b53964c2c3985ef949a500",
".git/ORIG_HEAD": "b0224ea4637e1c524bc65a848daa8e7e",
".git/refs/heads/master": "b0224ea4637e1c524bc65a848daa8e7e",
".git/refs/remotes/origin/main": "b039df88c1469036033c98e30e5d6e74",
".git/refs/remotes/origin/master": "b0224ea4637e1c524bc65a848daa8e7e",
"404.html": "e84e858aca7abba29f114961976c1f7c",
"assets/AssetManifest.bin": "5bfd79b4150a4fd3e141e02af6522260",
"assets/AssetManifest.bin.json": "d04353cb3cefdd5f119a634c4d209448",
"assets/AssetManifest.json": "cdb70c9fab4b479ea36203aa8c5df3a2",
"assets/assets/images/iv_google.png": "ca2f7db280e9c773e341589a81c15082",
"assets/assets/images/nothing_to_show.jpg": "e8cd3c62123ddcc96c7c4becb97acd20",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "bfde32590d2cc1abd211d33baba66cf3",
"assets/NOTICES": "10d37d2c62bff3f94e7925993564b6ad",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "1907a002a3671c1d2bacb54d3bedd8f8",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "2a2ee57ececcf01f1527a507caba1f2e",
"/": "2a2ee57ececcf01f1527a507caba1f2e",
"main.dart.js": "c3023cbd4ec60c97be65799d7a1d94f9",
"manifest.json": "be2c4704e1ebe58f66db9bf172152ade",
"version.json": "2336c00eaedab0f69dd517c99a813844"};
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
