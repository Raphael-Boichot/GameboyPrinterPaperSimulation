# Gameboy Printer Paper Simulation

* Creation Date: 2020-08-23, last update 2021-08-05
* Authors: *Raphaël BOICHOT, Brian KHUU*
* Featured on Hackaday :  https://hackaday.com/2021/06/25/simulating-the-game-boy-printers-actual-paper-output/

This project originates from https://github.com/mofosyne/arduino-gameboy-printer-emulator. This is now a fork of the Arduino Game Boy Printer emulator that increases game compatility to 100% and allows new printing features.

The purpose of this octave/matlab project is to output images from an Arduino Game Boy Printer emulator that have the same soft aspect than images printed on a fresh roll of thermal paper into a Game Boy Printer. The project emerges after a discussion between *Raphaël BOICHOT*, *mofosyne*, *maxs - thatguywithagameboycamera*, *herr_zatacke (@herr_gack)*, *Björn (@gameboycameramaniac)*, *R.A.Helllord* and *crizzlycruz (@23kpixels)* on the Gameboy Camera Club Discord. The motivation ? As Game Boy Printer paper is becoming difficult to find and subjected to definitive deterioration with time, emulating it is more and more appealing from an heritage conservation point of view. Fresh thermal paper used in this study was graciously sent to me by *R.A.Helllord* from the Game Boy Camera Club Discord. 

The Game Boy printer emulator developped by Brian Khuu is able to capture a stream of serial data under text form, but transforming this stream into pleasant images that have the realistic aspect of a roll of paper exiting a thermal printer, with the tone, noise, granularity and aliasing due to the printer head, was challenging compared to a classical pixel perfect rendering. And what is challenging is fun.

My first idea was to do a simulation of printer head by replacing hard square pixels by some sort of bell-shaped spots with lots of noise. A 2D bell-shaped approximation had a sense to me as injecting heat in a point on a 2D surface result in gaussian distribution of temperatures. On thermal paper, tones are due to a chemical reaction of a powder deposited on the surface of paper driven by temperature and phase change. I took inspiration from cashier tickets and Game Boy Printer scans at high resolution. Misalignment of the printer head was also simulated. The result of a pure mathematical approach was interesting for sure.

# Let's play with noisy gaussian dots
![](https://github.com/Raphael-Boichot/GameboyPrinterPaperSimulation/blob/master/images/2020-08-23/octaveSimPixelDithering.png)

# The pixel perfect test case :
![](https://github.com/Raphael-Boichot/GameboyPrinterPaperSimulation/blob/master/images/2020-08-23/Game_Boy_Pixel_perfect_1.png)

# Example of an early attempt of paper simulation
![](https://github.com/Raphael-Boichot/GameboyPrinterPaperSimulation/blob/master/images/2020-08-23/Game_Boy_Printer_e-paper_1.png)

Even if was not bad at all, pixels were too regularly spaced and paper fibers that deform the dots and create vertical streaks on paper were impossible to simulate with this  approach. We need a more agressive design !

# It MUST be like the real thermal paper !

After considering the differences between early outputs and real prints (scanned at 3600 dpi) obtained with a recently bought Pocket Printer, I was still not satisfied by the result. The difficulty is that the printer head and paper grain add noise to the image at different length scales. Moreover, the needles from thermal printer head do not just create noisy gaussian dots. These dots also have a random shape (typically due to fibers in paper). So my new idea was to sample a collection of representative pixels of the different grayscales on a good quality scan of isolated pixels printed with my Game Boy Printer. 

There is no image available to print in Game Boy library that presents perfectly isolated pixels in huge quantity. So I have created a test case with my brand new SD Game Boy printer code https://github.com/Raphael-Boichot/The-Arduino-SD-Game-Boy-Printer

I first printed this test image with isolated pixels of the three different grayscales (white is just ignored) :

![](./images/2020-09-10/Image_test.png)

Then I scanned a printing of this image at 3600 dpi (sufficient to see the details of pixels, each pixel beeing approx. 20x20 pixels on the scan) :
![](./images/2020-09-10/Image_test_printed.png)

And I sampled manually a collection of 50 pixels of each level of grayscale (very boring task but quite rewarding at the end) : 

![](./images/2020-09-10/Pixel_sample_3600dpi.png)

Then the Octave code just reads a pixel on a pixel perfect image to get its color, picks a random pixel among the 50 of its own "color" and draws it on a new file with some overlapping. 50 pixels of each color is not much, but a pixel is a simple matrix of value. In consequence, to increase randomness each pixel itself is flipped or rotated randomly so that more than 200 different pixels can be generated out of just 50 for each color. Finally, the real printing paper presents fibres that create vertical streaks of "ink" (thermal paper has no ink but you see the idea). So the code randomly decreases the intensity of printing along some streaks of limited length chosen randomly. Of course the code in its present form can be improved, but the result is enough for my poor visual acuity.

I choose to make a test case with a Chip Chip printed from Super Mario Deluxe :
# The pixel perfect test case :
![](./images/2020-09-10/Chip_chip.png)

I then scanned this printing at 3600 dpi (after some contrast enhancement, the printings appear in fact greenish)
# A scan of printed image on a real Game Boy Printer :
![](./images/2020-09-10/Printed.png)

Then I ran Octave with the pixel perfect image and here the result : 
# The e-paper image obtained with Octave :
![](https://github.com/Raphael-Boichot/GameboyPrinterPaperSimulation/blob/master/images/2020-09-10/Direct_e-paper.png)

# Which Game Boy Printer emulator to use with the decoder ?

The Matlab decoder is of course natively backward compatible with https://github.com/mofosyne/arduino-gameboy-printer-emulator. However, I've added some new features to the original Game Boy Printer emulator :

- *The game compatibility have been increased to 100% by applying two simple rules to the error packets sent by the Printer emulator to games: the error packet is always 0x00 before printing (the games clearly do not mind this error byte most of the time) except when an empty data packet is received, where it becomes 0x04 (image data full). This allows triggering the print command for certain rare games that require this. The post-printing commands are still the ones from the original project, except some increase of the number of busy state commands.*

- *A push button have been added to the project to allow an alternative mode of printing that mimicks the use of a real printer with a roll of paper: printings are buffered as long as a the push button is not pressed briefly, wich gives a signal of "paper cutting" to the decoder. This allows printing banners for games that allows this*

The pinout have been modified in consequence. The SOUT pin have been moved to D5 to allow direct pin compatibility with this other project: https://github.com/Raphael-Boichot/The-Arduino-SD-Game-Boy-Printer. It is recommanded to add an LED at pin D13 to allow the Arduino to indicate flashing and acknowledgement of the manual press button action.

![](./images/Arduino_pinout.png)


# How to use the Game Boy Printer paper emulation ?

- Connect your Game Boy to Arduino, open the serial console in 115200 bauds and print as with a real Game Boy Printer
- Copy paste text obtained from the Arduino serial output into Entry_file.txt
- Open Octave/Matlab code "Main_Decoder.m"
- Choose some color palettes (default are OK)
- Run and wait
- Enjoy your images. The code outputs both pixel perfect and paperlike images, can handle compressed protocol, custom palettes and the many variations of the Game Boy printing protocol.

Now let's detail the new features.

**Automatic mode**

Automatic mode is the mode by default : do not touch anything on the Arduino and images will be separeted by the decoder if a margin different from zero is detected. Most of the games are happy with that and in particular the Game Boy Camera. If you do not solder the pushbutton on the Arduino, automatic mode is the only mode available. The Matlab decoder is OK with that.

**Manual mode**

In manual mode, as long as you print in the serial output from Arduino, the decoder will output only one image file. Press the pushbutton after a print and a message is sent to the serial console to indicate to the decoder that "paper have been cut" and that a new output file have to be made. It can be made inbetween each print and will give the same result that automatic mode. It can be made after many printings and you will get a big strand of data or a banner. If the decoder detects that pushbutton have been pressed once, all the printing session will be considered as manual mode (Manual mode has a priority on Automatic mode)

Games that can take advantage from the manual mode are: 
- *All the games from the Nakayoshi Cooking series, Hello Kitty no Magical Museum, Mc Donald's Monogatari and Nintama Rantarou GB: Eawase Challenge Puzzle. They generate splitted image files in Automatic mode due to margin non equal to zero used during the images transmission. Printing in Manual Mode is mandatory with these games.*
- *Mary-Kate and Ashley Pocket Planner and E.T.: Digital Companion print images with no margin by default. Using Manual mode is also advised.*
- *Super Mario Bros Deluxe, The Card Captor Sakura series and Donkey Kong Country offer the possibility to print banners made of multiple images than each contains margin not equal to zero. To benefit from this feature, Manual mode is mandatory.
- *In general, each time you used Automatic mode, if the images decoded are splitted or ill-assembled, use Manual mode*.

# The complete list of games compatible with the Game Boy Printer (and the paper emulator)

See "Game Boy Printer Emulator - Games Support.xlsx" to check the compatibilty list and various hints to print from most of the games, obscure japanese ones included. This list and the hints were never published online before june 2021. There is in total 107 games compatible with the Game Boy Printer. I've tested all of them and can certify the printer support with emulator, even if some printing features are very tricky to reach ! See the Excel spreadsheet for hints and the zip file for 100% or any% saves ready to use with printer features unlocked.

- *1942 (never released in Japan)*
- *Alice in Wonderland (never released in Japan)*
- *Animal Breeder 3 (あにまるぶりーだー3)*
- *Animal Breeder 4 (あにまるぶり〜だ〜4)*
- *Aqualife (アクアライフ)*
- *Asteroids (never released in Japan)*
- *Austin Powers: Oh, Behave! (never released in Japan)*
- *Austin Powers: Welcome to My Underground Lair! (never released in Japan)*
- *Cardcaptor Sakura: Itsumo Sakura-chan to Issho! (カードキャプターさくら 〜いつもさくらちゃんと一緒〜)*
- *Cardcaptor Sakura: Tomoe Shōgakkō Daiundōkai (カードキャプターさくら 〜友枝小学校大運動会〜)*
- *Chee-Chai Alien (ちっちゃいエイリアン)*
- *Cross Hunter - Monster Hunter Version (クロスハンター モンスター・ハンター・バージョン)*
- *Cross Hunter - Treasure Hunter (クロスハンター トレジャー・ハンター・バージョン)*
- *Cross Hunter - X Hunter Version (クロスハンター エックス・ハンター・バージョン)*
- *Daa! Daa! Daa! Totsuzen ★ Card de Battle de Uranai de!? (だぁ!だぁ!だぁ! とつぜん★カードでバトルで占いで!?)*
- *Daikaijuu Monogatari: The Miracle of the Zone II (大貝獣物語 ザ・ミラクル オブ ザ・ゾーンII)*
- *Dejiko no Mahjong Party (でじこの麻雀パーティー)*
- *Densha de GO! 2 (電車でGO!2)*
- *Dino Breeder 3 - Gaia Fukkatsu (ディノブリーダー3 〜ガイア復活〜)*
- *Disney's Dinosaur (never released in Japan)*
- *Disney's Tarzan (ディズニーズ ターザン)*
- *Donkey Kong Country (ドンキーコング2001)*
- *Doraemon Kart 2 (ドラえもんカート2)*
- *Doraemon Memories - Nobita no Omoide Daibouken (ドラえもんメモリーズ のび太の想い出大冒険)*
- *Doraemon no Game Boy de Asobouyo Deluxe 10 (ドラえもんのGBであそぼうよ デラックス10)*
- *Doraemon no Quiz Boy (ドラえもんのクイズボーイ)*
- *Dungeon Savior (ダンジョンセイバー)*
- *E.T.: Digital Companion (never released in Japan)*
- *Fairy Kitty no Kaiun Jiten: Yousei no Kuni no Uranai Shugyou (フェアリーキティの開運辞典 妖精の国の占い修行)*
- *Fisher-Price Rescue Heroes: Fire Frenzy (never released in Japan)*
- *Game Boy Camera or Pocket Camera (ポケットカメラ)*
- *Golf Ou: The King of Golf (ゴルフ王)*
- *Hamster Club (ハムスター倶楽部)*
- *Hamster Paradise (ハムスターパラダイス)*
- *Hamster Paradise 2 (ハムスターパラダイス2)*
- *Harvest Moon 2 (牧場物語GB2)*
- *Hello Kitty no Beads Koubou (ハローキティのビーズ工房)*
- *Hello Kitty no Magical Museum (ハローキティのマジカルミュージアム)*
- *Hello Kitty no Pocket Camera (ハローキティのポケットカメラ)*
- *Jinsei Game Tomodachi takusan Tsukurou Yo! (人生ゲーム 友達たくさんつくろうよ!)*
- *Kakurenbo Battle Monster Tactics (モンスタータクティクス)*
- *Kanji Boy (漢字BOY)*
- *Karamuchou wa Oosawagi!: Porinkiis to Okashina Nakamatachi (カラムー町は大さわぎ! 〜ポリンキーズとおかしな仲間たち〜)*
- *Karamuchou wa Oosawagi!: Okawari! (カラムー町は大さわぎ！おかわりっ！)*
- *Kaseki Sousei Reborn II: Monster Digger (化石創世リボーン2 〜モンスターティガー〜)*
- *Kettou Transformers Beast Wars - Beast Senshi Saikyou Ketteisen (決闘トランスフォーマービーストウォーズ ビースト戦士最強決定戦)*
- *Kidou Senkan Nadesico - Ruri Ruri Mahjong (機動戦艦ナデシコ ルリルリ麻雀)*
- *Kisekae Monogatari (きせかえ物語)*
- *Klax (never released in Japan)*
- *Konchuu Hakase 2 (昆虫博士2)*
- *Little Nicky (never released in Japan)*
- *Logical (never released in Japan)*
- *Love Hina Pocket (ラブ ひな)*
- *Magical Drop (never released in Japan)*
- *Mary-Kate and Ashley Pocket Planner (never released in Japan)*
- *McDonald's Monogatari : Honobono Tenchou Ikusei Game (マクドナルド物語)*
- *Mickey's Racing Adventure (never released in Japan)*
- *Mickey's Speedway USA (never released in Japan)*
- *Mission: Impossible (never released in Japan)*
- *Monster ★ Race 2 (もんすたあ★レース2)*
- *Monster ★ Race Okawari (もんすたあ★レース おかわり)*
- *Nakayoshi Cooking Series 1 - Oishii Cake-ya-san (なかよしクッキングシリーズ1 おいしいケーキ屋さん)*
- *Nakayoshi Cooking Series 2 - Oishii Panya-san (なかよしクッキングシリーズ2 おいしいパン屋さん)*
- *Nakayoshi Cooking Series 3 - Tanoshii Obentou (なかよしクッキングシリーズ3 たのしいお弁当)*
- *Nakayoshi Cooking Series 4 - Tanoshii Dessert (なかよしクッキングシリーズ4 たのしいデザート)*
- *Nakayoshi Cooking Series 5 - Cake Wo Tsukurou (なかよしクッキングシリーズ5 こむぎちゃんのケーキをつくろう!)*
- *Nakayoshi Pet Series 1: Kawaii Hamster (なかよしペットシリーズ1 かわいいハムスタ)*
- *Nakayoshi Pet Series 2: Kawaii Usagi (なかよしペットシリーズ2 かわいいウサギ)*
- *Nakayoshi Pet Series 3: Kawaii koinu (なかよしペットシリーズ3 かわいい仔犬)*
- *NFL Blitz (never released in Japan)*
- *Nintama Rantarou GB: Eawase Challenge Puzzle (忍たま乱太郎GB えあわせチャレンジパズル)*
- *Ojarumaru: Mitsunegai Jinja no Ennichi de Ojaru! (おじゃる丸 〜満願神社は縁日でおじゃる!)*
- *Pachinko Data Card - Chou Ataru-kun (Pachinko Data Card ちょ〜あたる君〜)*
- *Perfect Dark (never released in Japan)*
- *Pocket Family 2 (ポケットファミリーGB2)*
- *Pocket Puyo Puyo-n (ぽけっとぷよぷよ〜ん)*
- *Pokémon Card GB2: Great Rocket-Dan Sanjō! (ポケモンカードGB2 GR団参上!)*
- *Pokémon Crystal (ポケットモンスター クリスタルバージョン)*
- *Pokémon Gold (ポケットモンスター 金)*
- *Pokémon Picross (ポケモンピクロス, unreleased)*
- *Pokémon Pinball (ポケモンピンボール)*
- *Pokémon Silver (ポケットモンスター 銀)*
- *Pokémon Trading Card Game (ポケモンカードGB)*
- *Pokémon Yellow: Special Pikachu Edition (ポケットモンスター ピカチュウ)*
- *Pro Mahjong Tsuwamono GB (プロ麻雀兵 GB)*
- *Purikura Pocket 3 - Talent Debut Daisakusen (プリクラポケット3 〜タレントデビュー大作戦〜)*
- *Puzzled (never released in Japan)*
- *Quest for Camelot (never released in Japan)*
- *Roadsters Trophy (never released in Japan)*
- *Sanrio Timenet: Kako Hen (サンリオタイムネット 過去編)*
- *Sanrio Timenet: Mirai Hen (サンリオタイムネット 未来編)*
- *Shinseiki Evangelion Mahjong Hokan Keikaku (新世紀エヴァンゲリオン 麻雀補完計画)*
- *SMARTCOM (never released in Japan)*
- *Sōko-ban Densetsu: Hikari to Yami no Kuni (倉庫番伝説 光と闇の国)*
- *Super Black Bass Pocket 3 (スーパーブラックバスポケット3)*
- *Super Mario Bros. Deluxe (スーパーマリオブラザーズデラックス)*
- *Sweet Angel (スウィートアンジェ)*
- *Sylvanian Families: Otogi no Kuni no Pendant (シルバニアファミリー 〜おとぎの国のペンダント〜)*
- *Sylvanian Families 2 - Irozuku Mori no Fantasy (シルバニアファミリー2～色づく森のファンタジー)*
- *Sylvanian Families 3 - Hoshi Furu Yoru no Sunadokei (シルバニアファミリー３　星ふる夜のすなどけい)*
- *Tales of Phantasia: Nakiri's Dungeon (テイルズ オブ ファンタジア なりきりダンジョン)*
- *The Legend of Zelda: Link's Awakening DX (ゼルダの伝説 夢をみる島DX)*
- *The Little Mermaid 2: Pinball Frenzy (never released in Japan)*
- *Tony Hawk's Pro Skater 2 (never released in Japan)*
- *Trade & Battle: Card Hero (トレード&バトル カードヒーロー)*
- *Tsuri Sensei 2 (釣り先生2)*
- *VS Lemmings (VS.レミングス)*

# List of games that embed a printer library but without printer support for the player

Code analysis of the Game Boy and Game Boy Color romsets revealed that some games (generally sequels of the preceding list) embed a printer library into the code but no printer support for the player. Some of them where clearly intended to use the printer as their gameplay is about unlocking images. The printer support was probably dismissed during game development as most of them are late published Game Boy Color games. Lazy recycling of non-optimized graphical libraries is also not excluded as memory size was less and less critical at this time.

- *Bouken! Dondoko-tou (冒険!ドンドコ島)*
- *Buffy the Vampire Slayer (never released in Japan)*
- *Doki x Doki Sasete!! (Doki×Dokiさせて)*
- *Gekisou Dangun Racer - Onsoku Buster Dangun Dan (激走!ダンガンレーサー 音速バスター DANGUN弾)*
- *Hamster Club - Awasete Chuu (ハムスター倶楽部 あわせてチュー)*
- *Hamster Club - Oshiema Chuu (ハムスター倶楽部 おしえまチュー)*
- *Hamster Club 2 (ハムスター倶楽部2)*
- *Hamster Paradise 3 (ハムスターパラダイス3)*
- *Hamster Paradise 4 (ハムスターパラダイス4)*
- *Konchuu Hakase 3 (昆虫博士3)*
- *Lemmings (USA version)*
- *Love Hina Party (ラブひなパーティー)*
- *Microsoft - The 6 in 1 Puzzle Collection Entertainment Pack (never released in Japan)*
- *Muteki Ou Tri-Zenon (無敵王トライゼノン)*
- *Nakayoshi Pet Series 4 - Kawaii Koneko (なかよしペットシリーズ 4 かわいい仔猫)*
- *Nakayoshi Pet Series 5 - Kawaii Hamster 2 (なかよしペットシリーズ 5 かわいいハムスター 2)*
- *Watashi no Kitchen (わたしのキッチン)*
- *Watashi no Restaurant (わたしのレストラン)*
- *Xena - Warrior Princess (never released in Japan)*

# Time for statistics !

On the 107 games compatible with the Game Boy Printer

- *97 games works perfectly in Automatic mode, 10 must use Manual mode, 4 can use both*
- *71 games were realeased only in Japan (unlocking printing features being more or less painfull)*
- *50 games are for Game Boy Color only (clear cartridges)*
- *49 games are for Game Boy / Game Boy Color (black cartridge)*
- *8 games are for Game Boy only (no color features)*
- *35 games use custom palettes (not 0xE4)*
- *28 games communicate with serial protocol in double speed mode*
- *5 games use an RLE compression in their serial protocol*
- *4 games use a two colors palette on purpose*
- *3 games use 0x00 as default palette instead of 0xE4 (which is documented is Game Boy programming manual)*
- *2 games belongs to the list of games leaked in september 2020 (Pokémon Picross and Hello Kitty no Pocket Camera)*
- *1 game uses two palettes in the same image (Alice in Wonderland)*
- *1 game uses a three colors palette on purpose (Pokémon Pinball)*

--------------------------------------------------------------------------------
# Telegram Gameboy Camera Chatroom

Got telegram instant messaging and have some questions or need any advice, or just want to share? Invite link below:
https://t.me/gameboycamera

--------------------------------------------------------------------------------


# Some known relaxing scene made with the code to end :
![](./images/2020-09-10/Z1_e-paper.png)

