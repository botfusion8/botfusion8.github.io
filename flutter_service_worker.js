'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "c93c6de85fe04239ad8b9a0e38670cd1",
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
".git/index": "83252a057a157edcd9bf0cb76ca1405e",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "4adb19bfddbc044f69762787e357a0e6",
".git/logs/refs/heads/master": "4adb19bfddbc044f69762787e357a0e6",
".git/logs/refs/remotes/origin/main": "6d59d6f3230fcb699cbacd8a54f9b00b",
".git/logs/refs/remotes/origin/master": "54253d2c4940bf702ef4ccba26bac13b",
".git/objects/03/5ac40f862e6298199b3e624375bdffac10fbb6": "677037823c845fb473d2fb38353ab6e7",
".git/objects/03/a54cca4ef0c30d3f953d1672e4e13b07058c25": "b0136a307ec2a531768098f645b24945",
".git/objects/06/70856ec2d82525ccdba140ec1192107d49ec02": "4cd7f389c82ca9f707b3aabe1fa18092",
".git/objects/06/a3523bd20d6d76a5c9b5371e2fcd7ab58b4f33": "b73835b02bb51b531bf2f371acad4330",
".git/objects/0a/e1742a8ef9533a0d1b725fed81b3f005996f24": "2d09ffa71e0cd64f257315e7200d5c17",
".git/objects/0c/60ecadfd0a59413c7c5f05d410175140f2bcf0": "e77ec13aa743a16d157b55564c177908",
".git/objects/0d/10cc1eff7915a53e0429cbeb60087b70e959de": "6bc18658e484c91af9f45fc02886dab2",
".git/objects/0d/c964be676011acd419b04e6e3999b00c0fdc79": "af35e9a0bf8e678cf214a704bddc846f",
".git/objects/0e/936d45ef601511a54c5ebc8561caf4e83cf5e5": "88dcf6ccdd9701a895d2ccd9badfa4b2",
".git/objects/0e/e514dc0e17e1b0feadb1524822b285014e71a6": "36fcb8b8c2241c6f3d18034c562f848a",
".git/objects/0e/fbcaae2bc5b58009904080cae6e95683c0e6e3": "9b4a83940069bea7e23df2ccddd55906",
".git/objects/0f/c344c7e8b9e32ea1ad91f30ded22556352d7bf": "a8a30f28869f7378465338066f34d80d",
".git/objects/12/4d6e4d7e23fc292e2e7d837ac8c028c6388e54": "11d7e41384a04cd9edfe4985147943ea",
".git/objects/13/52c0937ee02ca58428f86bc7e44ae547396d3f": "c29e3a0050804cec9783227efd8276f8",
".git/objects/14/20c83b9d4a909d4f0aac9f89943a80d46daca1": "a1d8594ffa17a34743b4f3d0d66e05cb",
".git/objects/14/4c6c96ba42ce1218d67214f6defb3199124284": "670297a6560b6db71e1b5c4dc0031515",
".git/objects/16/0001a8b2c73edcf79ab88ca121ee0944de258e": "ce3e67eaf58958245d57c09e73d54cad",
".git/objects/17/ffaa201551946c5ca9d8d493600569eac3258c": "25012a981c6562091d770d0d6dcd0bb2",
".git/objects/18/eb401097242a0ec205d5f8abd29a4c5e09c5a3": "4e08af90d04a082aab5eee741258a1dc",
".git/objects/1a/19e03b9a0076e77c4b2c637ff27a03ebc2d7ba": "692efecd9238304dc0befec39155924e",
".git/objects/1e/7d3de87a50ff4e9290c7c10d301c3c2c286684": "a981a0928a4a1542d46585e97037b763",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/1f/a17484a0a8702cdab8aa01862d8d35cd32744c": "09826fd3e2285c91b405301af94bd3c4",
".git/objects/20/1afe538261bd7f9a38bed0524669398070d046": "82a4d6c731c1d8cdc48bce3ab3c11172",
".git/objects/20/815149135c837a5aa1ef1ebe74daf0689c085b": "d8eab53df5f475738675e7c42687c1b1",
".git/objects/20/cb2f80169bf29d673844d2bb6a73bc04f3bfb8": "b807949265987310dc442dc3f9f492a2",
".git/objects/24/55625fe2fcfb5fc408dd84c0227218a87f1616": "855cb1924bdbe7dff80f8f9b15070b28",
".git/objects/24/9f4875f1f496a188ea512d646df8455563282a": "7fbed3995a168c0835a26ed02a8e52a2",
".git/objects/25/8b3eee70f98b2ece403869d9fe41ff8d32b7e1": "05e38b9242f2ece7b4208c191bc7b258",
".git/objects/27/bbf05093775bddfe9f37465e8796059c12f96e": "8eb57f59bffb0775ab8367607f533977",
".git/objects/27/cf8c103d45137150e55ec96f6b1da86b5f68ef": "0694db79ba3197169c6d334b522f270d",
".git/objects/28/65cdf4a2771abcf05965cee4972335ffc52179": "1a9b76cca1d20610808f12d829479c9a",
".git/objects/28/7325dfc250d9a0ff89f887cb6cfea39c3bae9b": "f8e1d855d33116aae374cad9c911e03c",
".git/objects/28/7fa9f7671704ada16485769a05f3b6e8fc5573": "95f48dc090543cab1f347dc4547bf715",
".git/objects/2a/64c4fc3c0104f615ec78c0985418adf9dd5216": "e09a8ba86a2def2e88d112d084f7b2b8",
".git/objects/2c/148fb7471b7990aa5d0e22c72ef3aa0eb88df3": "46b71f6901184863b51422c20e57c098",
".git/objects/2d/2b696a318e4a14219dd1580c05584a8757785c": "aeb055fdc8ed2a2a80fb7866e97f01cd",
".git/objects/2e/b06953b6fdd7842713842b17f85e36e7a550a4": "0e16326592fd612dae5f58528161edfb",
".git/objects/2e/e295ac4c545063047135099bc20f8753d9ad6e": "28bd424c852c0b7e6c848c72be84305f",
".git/objects/31/776b43a16b0e4f943dbc8d90840890b8a5c572": "c909f59ed3c50c55beec9c854e682828",
".git/objects/31/79f65a8dda2cbb34337dc32131e31031907eaa": "a298f5e63b7b6dcd820276fa87a00333",
".git/objects/33/3948be3a950aa17f35c72f0f55632b62d11dc9": "058d0bf3c3acf9e067446a647abcac0c",
".git/objects/33/8e48dcef659ccecea87f24e422fce3da3d348b": "5748caf078aa75715d4a2d799e3e5950",
".git/objects/33/b6727c07bca19a7b28c21a01d3e0f487d0a4d6": "2a075abee6c0a9e863e0cb4e0234e93d",
".git/objects/37/eda5f68203f41061bd70d465d4169d38537456": "f4765fcdc77e974af5985c1e12224d62",
".git/objects/3b/c2a9f4b8ba33f338e2c93ccc41ae34e7bc8034": "6566f0181ad164861ee966bd150e27e0",
".git/objects/3d/eeb716d7674fa3ef1ae1041874f06129ba397c": "aca8a1166caf55c16e245f19ddc79779",
".git/objects/3e/c628717c513a6c1e0a12eee4cfb3981c3e5178": "fe676dc8dd4cc904211e53c4fe14a08b",
".git/objects/3f/b8ce7bb1a987a04917c2aa596c09937316b752": "250f471e5d1f4a6d53a4fddc4a0e2eb2",
".git/objects/40/fe06f817f17e9cb028d410cd2ac42f61f66dea": "1ebb7c7edb3357cfb48d80b3dc516cb8",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/46/bc1f124fb064bb8c5e8eb1991175cd6314d810": "ba0abb192fc53ef0cdee25d2f462a3fc",
".git/objects/47/d367f30e45a9e40dc9c437bb0c99d6f7b2ac2d": "99da7e00657c50c44b2a8b6837c67d39",
".git/objects/49/4acede0c520f847f75982ca1f671fc6eaa889e": "c4a42624eaa20c8a64455bab6edd0908",
".git/objects/49/adebdb511c8c293b28db3f6792e5bac28cdc32": "ba6a3971e7f06834fd6ec3844372ce17",
".git/objects/4a/8a31773c02ac311c8e41bbbac316404424479b": "f06ae79660ac00bbc25f33b27b73f9e8",
".git/objects/4c/2cb8ab3967bab5c3efe848f7b55d3b078a9592": "2eddd71117291f762802a54d4dc8034b",
".git/objects/4d/6ce6374b362acf96b1662b7393eee4fa64590a": "a0227429b23112962e4eb246b15ae942",
".git/objects/50/67f72854f86f24142bb049b1b9cb45ddb1c750": "761c2c074bf0f156bd0b580b9a87b20d",
".git/objects/51/d74bbe772ec2a3bec06e695ea7f1fab8ca0484": "962f607da201e449fd7741b6f6bfb085",
".git/objects/53/63be6309720632127be15b55c3ed5d9972396a": "507e16440af9189f0aa1038239612d32",
".git/objects/57/ae13b79ece60753d9c83728a35dff33276214e": "3fbf2a0883c9e3996371705d4b078471",
".git/objects/58/356635d1dc89f2ed71c73cf27d5eaf97d956cd": "f61f92e39b9805320d2895056208c1b7",
".git/objects/58/b007afeab6938f7283db26299ce2de9475d842": "6c6cbea527763bb3cdff2cecfee91721",
".git/objects/5b/a3e4abf66192659dcf249bf0bd39fe8699d828": "55b447deb91fda3a85e26b75eecdb2ba",
".git/objects/5c/a02720b5e29f042a1485d3320411acddc530c1": "7c31f695c290e09620ba0cd09431b6ab",
".git/objects/62/375619f9eaaeca5539c66529f2000dbd864b43": "b5abc588cedad07ba32f1ac05d0a1da1",
".git/objects/62/c89ee094658c7a9465824fdb42793a64ea557b": "133cd5da638f245b079d9e9cdc29ae38",
".git/objects/62/cecfdb9440e79370b6a62f28501500c66e9fe3": "e113b02185eb10f352ad84adfb1beed8",
".git/objects/62/d04b9fb8419dd59d6ce4b0163fa991c14933ed": "b8c4914dda59690436cb715576bc0888",
".git/objects/62/ecd09cb6e2cdd47d6baac6d2069457012e2d0a": "984e3b5f17eb089233dcc9ea69de055c",
".git/objects/64/b483855507c5e2b2d2d4d82ddb511fc221b86f": "8fee9983c0d08eb92aba8ace9ebf9287",
".git/objects/66/9082e6f45fbaa1aeb4911c2205f7f33a0fb962": "2a0aed4d658835d2563be8cfe8d9a8b1",
".git/objects/67/e853e5cf6115ea00953a588ff5f4696bad8600": "8d1787a8e59b7ffaf4de2415b4448292",
".git/objects/6f/8517bbfa8b375fc9e486fecf636d50e94cbf57": "e21b4ff5d8aaa735095cdbb4b4d7aaf1",
".git/objects/70/50860ff5730b4ad6cf813117f5b6a00fd5fa6d": "8684a78338f1bbaa3a3cd2241280d02d",
".git/objects/71/3f932c591e8f661aa4a8e54c32c196262fd574": "66c6c54fbdf71902cb7321617d5fa33c",
".git/objects/72/6577c597286b8f2eba20927cc060eccd416323": "d0393503b2a53d163d7dc8e75d78af67",
".git/objects/74/78139fcaa3d509ec2ebd118ef1511e87310705": "3bc0bff67fdccd19699c39ace84753c8",
".git/objects/74/b6e6c9936fbe753008314fd6ac718c312689ea": "9d7821a3f5516e43853d8c635785677d",
".git/objects/75/426673fc2c36f64c03cd0d6ca541de174f1d41": "dcf5fba48ba8a6587e2d5caf996e0d7f",
".git/objects/75/de2e3b7074141f36812d3193000f919f4f1539": "8d259851bf770f2f7bfcb13d28153e1f",
".git/objects/77/1f88ab93af0f9d042e4362c40a49efe60e755c": "48be13a1ab49640aa0d6ffd743b38914",
".git/objects/78/3367ecac0dbaeaa45366ca66dec97a86e3f243": "c3e4e36f72744a83a6cc2258f080e6ab",
".git/objects/7a/74d17fc79f9f6e9f4be0e93bd3ac5142c9c23c": "ae33749de77ff1a7eac6c02c72ffc613",
".git/objects/7b/20e59d5db0592e17ab22799673cedfe42f0c2e": "5472e3aa15ebcbc5ebfcbf07d7e9faf0",
".git/objects/7b/f82068451ab23039cbd06c68ad04cfbf302358": "439332ff4cc4dffa6fe5bb617746c903",
".git/objects/7d/35e015aeff39a8ad715c702d68ddd1db9f7b28": "f56baf7959f30dc9b550f9b9d6f2b447",
".git/objects/7d/4c3af644b95396890e914605c9036bbd559efe": "050304bffd12279c8f5c29358d279bec",
".git/objects/81/8ee8a1ba7bb1cd07eac86fea7a63e661d11bdf": "f1b7bb2a2eacb82f315518d60c73c68e",
".git/objects/82/5081dc0339399ef450121fc74660121b82c7b1": "b0fe12d3ba02237b8ab6f8279d8e7b18",
".git/objects/83/bd22fe6b1aa9f34744a4f6ba9dcc851293ca70": "a825fd92805cae418ec9f473a45d516d",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/85/7702d20909310928d864c46afc0c17342e927e": "f4744a1b1caf031a9ae7741dc798d8cb",
".git/objects/86/c8bd0e66eab4e536adefa4e24be312b968e3bb": "791409aa4e4b5dc06287a5ee88e5036b",
".git/objects/87/37bcebfe220e724bc3cf58e2c25b4d5e0cdc7c": "0dac42e229fdb15905199b435eb45db9",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/90e0e1dfb7a6c6e000ecde2782866be1f337e6": "bf14376ec309d592fc1307f25ea7bad5",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8d/7134338fbcdd318cacfc50df757970aa75619b": "0c20da1a2719e9bf2cf607a839534d72",
".git/objects/8e/470c834d61b098f7af42927f0de11170cb60d5": "1316288ccf20636339b0817213bf9496",
".git/objects/8e/a5118cfc0c1a04efa50a4cec44e26ace16803d": "9ff21288a4f38c0a42646420fb4c4d98",
".git/objects/8f/4909ce82be9c574e8c18ad5a92bcf7f6afd930": "9a94b13dc4f24fdf54fedabf74eb085d",
".git/objects/93/d6eaaff43211eacb03d62985a6df2e0bc3f2c9": "3211edb4b25b395769e0e146f9751a04",
".git/objects/94/e31853bb379da5a874ce8226f479042cd4254d": "77ef21498bc5faffaa520cdc0fcdd6e4",
".git/objects/94/f7d06e926d627b554eb130e3c3522a941d670a": "77a772baf4c39f0a3a9e45f3e4b285bb",
".git/objects/96/f66df76bb08468ac63766dd3abf2e97f935e04": "813740c38946e56f293b12e116d1728b",
".git/objects/97/55a668c05a082429176d6596b6eef06fd80f62": "442cbd204e6b83c88fe034544fa28200",
".git/objects/9a/7e60ec7b92728ceec2fd277d94901957174de9": "73aac3dcf2c54ab0ab6e6a4b69a832a3",
".git/objects/9c/62f94a54d8bc0a24f2054ca7a7fe6a391dc42d": "d94dc11c436562054391a39ac7f7f129",
".git/objects/9c/cf6883e1bf214825db6ae08d5a5166e832b57b": "0c67e359ea14125861621f5a2f8b102a",
".git/objects/9f/e61616640732805b9fd2666ad88078c78ebac5": "5eab72b19fead5517f743f6f674c3842",
".git/objects/a0/e8e950fb093121ae2d8afa81ad6314868a126a": "574731f09d0aa3d14518a4b8e34dcf61",
".git/objects/a1/1c85933e8b03904f2f7b7bf91844ad09c45807": "0190731ba54d52a101151fed1de543af",
".git/objects/a1/7669f6647941f7615002d4965e3c1f7b47d504": "44c03e409d2b229c74442e6e005b2184",
".git/objects/a2/54bfe73d25dd75057321e5952d843243f0e887": "479e7861637faa98da2be9e2fa1917a5",
".git/objects/a3/c5616ceff3c40821aa00ffb5833a279d5e58a4": "9ec8dcb99fbaecf276a22878a82c6bd9",
".git/objects/aa/8e3b0c1463dd51f4ddb09aaecb1fc2e27f90e7": "577bec3dce991fa589127d35f10adc79",
".git/objects/ab/82315f30da959fab5157430d7a60d2c41e7065": "87f9896f31126fef4e7da5ee3933e8f4",
".git/objects/b1/969ec93d0863cf65f809284c567dcb371ff19e": "4c941381f2e0a51036b985fb26fff666",
".git/objects/b2/b4581d6e1620e436a8dd7eaaaa18acb51a88e3": "5d592c624fe4c07a25b33021c23c27c6",
".git/objects/b3/8dfd26d07135f3abf7ca875018403d3a7bc9cd": "d453d6d54dd976d62c664240a3284940",
".git/objects/b3/ebbd38f666d4ffa1a394c5de15582f9d7ca6c0": "23010709b2d5951ca2b3be3dd49f09df",
".git/objects/b5/9c15601c81a23ec5572994fdd75ebff227c020": "d73bfc67585f62574369bf46687fea57",
".git/objects/b6/a89b56980f694e42f1c5e7eded284bcf1ba3f9": "e324b50118f64f9327ca0e22036ff1b0",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/bd/0c249998cf400c88ce4b16665b2c65031631dc": "9f3a2b08323fa5e5936ac5b25484ad3e",
".git/objects/bd/401561131acb4665fe0862d4b6b604bb40ee0b": "e830a1ad3fb81eddd6f1c1e37fc40afc",
".git/objects/be/02cd3d3e3ccf30a724ccd4b07a3688140d0748": "46ff09f4a63f6e87e6f53e32c01cfed1",
".git/objects/bf/298c15e90d29e3821037b9ea5e7807d858effa": "89d4a69ce37cf2acbd6a828d04a062ff",
".git/objects/c5/c3f79ad3cd6c8077124a31ac14b8bba6cf25b7": "4c72412d8df20e0c8840519c88a9eaa5",
".git/objects/c6/688892f679d686ba4561cf5a4265b021d610ea": "d3ab4a2735a1edce77749b43320095b1",
".git/objects/c7/46018d4cdabec4d0312f2592367c37a9b67608": "f0db476504eae5561a70a47488ea1179",
".git/objects/c7/ffeded30256f97dee6ae812a11726a656513b4": "35e85d80d759818b565100bbeeb56f15",
".git/objects/c9/bf8af1b92c723b589cc9afadff1013fa0a0213": "632f11e7fee6909d99ecfd9eeab30973",
".git/objects/cf/5dd895ca7cd56a0491cf1d7fb7b5f829a16283": "176736f5ca6a9e0b0451892bf1367cb2",
".git/objects/d1/098e7588881061719e47766c43f49be0c3e38e": "f17e6af17b09b0874aa518914cfe9d8c",
".git/objects/d2/b2a78cfa2956fed39890c0386271a52e780ccf": "aff6da074fd825daf8593464c341dc42",
".git/objects/d3/de0619c858c5e7d575f9c7c1e0e45624d8b0a8": "18b97455f80b2d7550d5d42088acdea9",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d4/a58771b6eb3390b098cd619662b45f55a7b865": "4b7cdd3978efa1c5d4736d3d9ab06e91",
".git/objects/d4/f900bb1af56be3e7de10b4a2e5e8f174b5f307": "0a2724d4f05d6c82df29662100989247",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d8/4172eb3d9f3413666cc3c5cebbe57092d75da3": "2e86dc9511606af1647dbdb59f716a65",
".git/objects/d8/6a4177c09a4221948c8a38e58c404b34509444": "28a12e3d603e130f67ca2960141f3d03",
".git/objects/d8/7abb06805f2850672348e18c913a571be5656e": "fae7b9ffde372e225254a25d17961ec5",
".git/objects/d9/270138ba85a60daf4214d0614400fbd392233b": "29813331ac23f61ebd7f4ae624866f3a",
".git/objects/da/ae3da21edc1b318507c802f4c54b67519ffc16": "ef00b0697980cab6c7d2d886564a3acc",
".git/objects/db/c3ea65062c27b6e1f9f33611c67f627362aef0": "264b2f2247ef4b519fa5174599f5a823",
".git/objects/dc/4ae71145fda656dbde29927e2b1e69780b9659": "45044755c7814c6f03b5867640f215c5",
".git/objects/dc/79ca6273c03a64a3f07e669e9cae2d8e06f5ed": "54c3797a04a49b24968502c69ee26533",
".git/objects/dd/2dc7d2f7e067b696a5194256691f65ad46ce70": "517e04cb168c3d4e8ab1b192f6d63765",
".git/objects/e0/1a7b7763f7ea1cb0e85f0b97f7854b7875eac9": "cc68935dd01d596744f92b59dbdfc9c0",
".git/objects/e0/b83030e76297b0fc9cd20f74bfd9592b665483": "5d6308984f3127ecc6be39a553821158",
".git/objects/e1/3b3424f49c26757ee5bb7aac3e60570e92a650": "7a56485532d43828f1f432904aa24b77",
".git/objects/e9/1f392c821148234666c226d6296530cc7f696f": "402113e146ab950b80e45dfa1ece54f2",
".git/objects/e9/22a707a5fc5b3ece8348e64a178731fc1336ec": "42a93c6e67dea28fed06609c0d87e35e",
".git/objects/ea/47095526b4d22663534e8ee9f8c0e4a421c8ff": "6e24fb9d48d66e289276ddd0270ffe3f",
".git/objects/ea/77fe54e2ad117929f4069cb70a7f722e8224f8": "afc649e0704771093523509328718bd0",
".git/objects/ea/8a047dc330372d816a7237ea59ef578de14e59": "cad9e1fc776c7ef069b0776020701274",
".git/objects/ea/8a11f907272aabbea32c5211cb907ec97ab4f3": "1f6cd97f77b2fadb536adec27d0fc99f",
".git/objects/eb/1bfa20197907053351208abb2d26277c174f1f": "61c3431b1f084ac1fa4e8fb9793cd8c9",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f2/1aad9e4e47528575c575e86cae06baa907ba74": "5f5cbf349918b7aac164c004c3ebae91",
".git/objects/f3/1bb92fc499ac2e31a88003fca4286e32609ba3": "62532adf06bb7e5e19434758d5400cc8",
".git/objects/f5/4ba255180cec64b6d0d54f67baa190722a4cdd": "94f66d3b98aa5c723718fd4743024b6f",
".git/objects/f9/1bbc2faa9c7f6443b74b72f6bea30ca14309ae": "d446b0a80c4d169593b9e5714b656603",
".git/objects/fb/d77da06f1959de18f09a5fe32b0a9e4c57ee1d": "cab46a29b67bda849096b607036414c9",
".git/objects/fd/406cf27800a7ce68517fabb1e60961d6d5b4a2": "8772390e1a3ab1f45697219ce53eed1b",
".git/objects/fd/e5e83aba19c93a24961017a49ce8212d3489db": "c075eb5954b53964c2c3985ef949a500",
".git/objects/fd/f23cfb0fddd669e4454a365629122d28570a7a": "06810a70d64593f572fb0692033d6f2e",
".git/ORIG_HEAD": "b0224ea4637e1c524bc65a848daa8e7e",
".git/refs/heads/master": "b091044bca830fd8085acaa842d1a452",
".git/refs/remotes/origin/main": "b039df88c1469036033c98e30e5d6e74",
".git/refs/remotes/origin/master": "b091044bca830fd8085acaa842d1a452",
"404.html": "e84e858aca7abba29f114961976c1f7c",
"assets/AssetManifest.bin": "6d049b3718d7d3a1eec1872f9da5aa28",
"assets/AssetManifest.bin.json": "e11f8ef93cae6623507d9b4470a72c17",
"assets/AssetManifest.json": "c53182f83780f29882c3e72b06a9501f",
"assets/assets/images/iv_add_user.png": "346f8a7f9d199ab60de50ff40a655202",
"assets/assets/images/iv_google.png": "ca2f7db280e9c773e341589a81c15082",
"assets/assets/images/iv_share_chats.png": "2869d3b9e9dde7d5c294f1da1909763f",
"assets/assets/images/maslow_icon.png": "8ca592955dc690bb97a79e0d894fa8a5",
"assets/assets/images/nothing_to_show.jpg": "e8cd3c62123ddcc96c7c4becb97acd20",
"assets/assets/images/user_placeholder.jpg": "35975c8078fbc7111ae9b9252293d710",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "86a8753820fbd3e585f8f56dd820e306",
"assets/NOTICES": "d1defa98b1d99e914b1d3cf174268338",
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
"flutter_bootstrap.js": "0a5c9bd3e28420dfce9ae7cf9955c774",
"icons/android-chrome-192x192.png": "c2699d8b4baf59c26556230ff830ba60",
"icons/android-chrome-512x512.png": "b3bb38972d49e42be96bce0729d9e6f0",
"icons/apple-touch-icon.png": "42af912d519173019b568515b1aff059",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "0baf8f63fc116ae06be40fd964dff957",
"/": "0baf8f63fc116ae06be40fd964dff957",
"logo.png": "8ca592955dc690bb97a79e0d894fa8a5",
"main.dart.js": "a99bfb59ac73c8f43da5b4f19d3b1b24",
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
