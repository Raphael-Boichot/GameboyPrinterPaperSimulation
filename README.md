# Gameboy Printer Paper Simulation V1

* Creation Date: 2020-08-23
* Author: *Raphaël BOICHOT*
* Curator: Brian Khuu

Author of this script is *Raphaël BOICHOT* and was posted here with his permission.

Game boy printer emulator with e-paper feature (CrapPrinter)
Code runs very fast with Matlab, slowly with Octave.

This is a companion project with https://github.com/mofosyne/arduino-gameboy-printer-emulator

The purpose of this octave/matlab script is to do an accurate simulation of an
 output of a gameboy printer and the effect of the thermal printer head on the
 gameboy printer roll. This is not the same as a typical receipt printer as you
 will see in the historical writeup below.

## Simulation of the e-paper output:

<img src="./images/2020-08-23/Game_Boy_Printer_e-paper_1.png" width="40%" height="40%" alt="epaper examples">
<img src="./images/2020-08-23/Game_Boy_Printer_e-paper_2.png" width="40%" height="40%" alt="epaper examples">

## Comparison to pixel perfect output:

![](./images/2020-08-23/Game_Boy_Pixel_perfect_1.png)
![](./images/2020-08-23/Game_Boy_Pixel_perfect_2.png)


--------------------------------------------------------------------------------

# Telegram Gameboy Camera Chatroom

Got telegram instant messaging and have some questions or need any advice, or just want to share? Invite link below:

https://t.me/gameboycamera


--------------------------------------------------------------------------------

# Two ways of using the emulator V1 :

- Copy paste game boy serial data obtained from https://github.com/mofosyne/arduino-gameboy-printer-emulator into Entry_file.txt
- Open Octave/Matlab code "Main_Decoder.m"
- Choose some options
- Run and wait
- Enjoy your images


--------------------------------------------------------------------------------

# Octave Screenshots (As of 2020-08-23)

These are the latest as of 2020-08-23 screen shot

<img src="./images/2020-08-23/octaveBurntPixelPlot.png" width="50%" height="50%" alt="Octave Burnt Pixel Plot">

<img src="./images/2020-08-23/octaveSimPixelDithering.png" width="50%" height="50%" alt="Octave Pixel Dithering">

<img src="./images/2020-08-23/octaveSimVsReal.png" width="50%" height="50%" alt="Octave Simulated Vs Real">

<img src="./images/2020-08-23/octaveSimVsRealZoomed.png" width="50%" height="50%" alt="Octave Simulated Vs Real Zoomed">


--------------------------------------------------------------------------------

# Historical background (As of 2020-08-16)

This conversation occurred in Gameboy Camera Club in discord, contact us for an invite link.

During discussion between *Raphaël BOICHOT* and *maxs - thatguywithagameboycamera*
Raphaël BOICHOT got an idea to simulate the paper output of the gameboy printer.

*herr_zatacke (@herr_gack)* and *Björn (@gameboycameramaniac)* and *crizzlycruz (@23kpixels)* was also in the
chatroom contributing to the discussion of this effort.

> Raphaël BOICHOT
> It gives me an idea : it should be possible to make an "after converter" that outputs images having the same soft aspect that printed paper, I mean the tone, noise, granularity and aliasing due to the printer head. Could somebody send me when possible a very high resolution scan of a printed image from GB camera with a real Game Boy printer, so that I can see what to do ? The idea is to make a real fake printed image.

> R.A.Helllord
> If anyone wants it: https://drive.google.com/file/d/1JRHAElErzPu5oDeHRIkm9hTtXbVukhd9/view?usp=sharing 276MB after compressing it as png, I'll be seeing if I can't get a sharper scan, though

> Raphaël BOICHOT
> It's enough information to try something now, Thanks.

With R.A.Helllord high resolution scan of a real gameboy printer output on good quality paper,
Raphaël BOICHOT obtained a zoomed in sample of the output as ground reference.

![](./images/2020-08-17/RAHelllord_real1.png)

![](./images/2020-08-17/RAHelllord_real2.png)

He also compared with a typical cash receipt

![](./images/2020-08-17/cashTicketExample.png)

From here, Raphaël BOICHOT started work on this project. From the sample of a real printer output, he did a simulation of a single speckle.

![](./images/2020-08-17/octaveSpeckleSim.png)

This allowed him to generate this dot ![](./images/2020-08-17/dot_small.png) and then starting with an original perfect rendering of a gameboy printer output... he carefully crappified it to match the original output in reality.

### Original Image

![](./images/2020-08-17/originalImage.png)

### Attempt 1: First Attempt

![](./images/2020-08-17/attempt1.png)

### Attempt 2: Less Error

![](./images/2020-08-17/attempt2_lesserror.png)

### Attempt 3: Less Pixel Masking

![](./images/2020-08-17/attempt3_lesspixelmask.png)

### Attempt 4: Hard To Be Crap Like Reality

> It hard to be crap like reality ~ Raphaël BOICHOT

![](./images/2020-08-17/attempt4_hardToBeCrapLikeReality.png)

### Attempt 5: Link

![](./images/2020-08-17/attempt5_link.png)

### Attempt 6: Squid

![](./images/2020-08-17/attempt6_squid.png)

# Gameboy Printer Paper Simulation V2

* Creation Date: 2020-09-10
* Author: *Raphaël BOICHOT*

After considering many comparisons between the code V1 and real prints obtained with a recently bought Pocket Printer, I was still not satisfied by the result. The difficulty is that the printer adds noise to the image at different length scales, what is particularly difficult to render with a fast code. So my new idea was to sample a collection of representative pixels of the different grayscales on a good quality scan of isolated pixels printed with my printer.

Typically, there is no image available to print in Game Boy library that presents perfectly isolated pixels. My idea was to create a test case with my brand new SD Game Boy printer code :

https://github.com/Raphael-Boichot/The-Arduino-SD-Game-Boy-Printer

So I created this test image with isolated pixels of the three different grayscales (white is just ignored) :
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
![](./images/2020-09-10/Direct_e-paper.png)

# Two ways of using the emulator V2 :

- Copy paste game boy serial data obtained from https://github.com/mofosyne/arduino-gameboy-printer-emulator into Entry_file.txt
- Open Octave/Matlab code "Main_Decoder.m"
- Choose some options
- Run and wait
- Enjoy your images

OR

- Choose a pixel perfect image 4 shades of gray from any Game Boy Game using the printer (or any other source)
- Open Octave/Matlab code "Game_Boy_crap_me_directly.m"
- Change the name of the image file to convert
- Run and wait
- Enjoy your 16 millions color 2564x2308 new image

# The e-paper squid test :
![](./images/2020-09-10/Squid_e-paper.png)

# Some known relaxing scene in all it's pixel glory to end :
![](./images/2020-09-10/Z1_e-paper.png)

# Gameboy Printer Paper Simulation V3

* Creation Date: 2021-06-09
* Author: *Raphaël BOICHOT*

V3 is just a reboot made fron scratch to follow V3 of the Game Boy Printer emulator, nothing change compared to V2 for user, enjoy it !
I have removed the possibility to directly transform an image into e-paper as it was source of bugs. Now everything passes through entry text file.

# The complete list of game compatible with the Game Boy Printer

- *1942 (never released in Japan)*
- *Alice in Wonderland (never released in Japan)*
- *Animal Breeder 3 (あにまるぶりーだー3)*
-*Animal Breeder 4 (あにまるぶり〜だ〜4)*
-*Aqualife (アクアライフ)*
-*Asteroids (never released in Japan)*
-*Austin Powers: Oh, Behave! (never released in Japan)*
-*Austin Powers: Welcome to My Underground Lair! (never released in Japan)*
-*Cardcaptor Sakura: Itsumo Sakura-chan to Issho! (カードキャプターさくら 〜いつもさくらちゃんと一緒〜)*
-*Cardcaptor Sakura: Tomoe Shōgakkō Daiundōkai (カードキャプターさくら 〜友枝小学校大運動会〜)*
-*Chee-Chai Alien (ちっちゃいエイリアン)*
-*Cross Hunter - Monster Hunter Version (クロスハンター モンスター・ハンター・バージョン)*
-*Cross Hunter - Treasure Hunter (クロスハンター トレジャー・ハンター・バージョン)*
-*Cross Hunter - X Hunter Version (クロスハンター エックス・ハンター・バージョン)*
-*Daa! Daa! Daa! - Totsuzen Card de Battle de Uranai de! (だぁ!だぁ!だぁ! とつぜん★カードでバトルで占いで!?)*
-*Daikaijuu Monogatari: The Miracle of the Zone II (大貝獣物語 ザ・ミラクル オブ ザ・ゾーンII)*
-*Dejiko no Mahjong Party (でじこの麻雀パーティー)*
-*Densha de GO! 2 (電車でGO!2)*
-*Dino Breeder 3 - Gaia Fukkatsu (ディノブリーダー3 〜ガイア復活〜)*
-*Disney's Dinosaur (never released in Japan)*
-*Disney's Tarzan (ディズニーズ ターザン)*
-*Donkey Kong Country (ドンキーコング2001)*
-*Doraemon Kart 2 (ドラえもんカート2)*
-*Doraemon Memories - Nobita no Omoide Daibouken (ドラえもんメモリーズ のび太の想い出大冒険)*
-*Doraemon no Quiz Boy (ドラえもんのクイズボーイ)*
-*E.T.: Digital Companion (never released in Japan)*
-*Fairy Kitty no Kaiun Jiten: Yousei no Kuni no Uranai Shugyou (フェアリーキティの開運辞典 妖精の国の占い修行)*
-*Fisher-Price Rescue Heroes: Fire Frenzy (never released in Japan)*
-*Game Boy Camera (ポケットカメラ)*
-*Golf Ou: The King of Golf (ゴルフ王)*
-*Hamster Club (ハムスター倶楽部)*
-*Hamster Paradise (ハムスターパラダイス)*
-*Hamster Paradise 2 (ハムスターパラダイス2)*
-*Harvest Moon 2 (牧場物語GB2)*
-*Hello Kitty no Beads Koubou (ハローキティのビーズ工房)*
-*Hello Kitty no magical museum (ハローキティのマジカルミュージアム)*
-*Hello Kitty Pocket Camera (Japan, unreleased)*
-*Jinsei Game Tomodachi takusan Tsukurou Yo! (人生ゲーム 友達たくさんつくろうよ!)*
-*Kakurenbo Battle Monster Tactics (モンスタータクティクス)*
-*Kanji Boy (漢字BOY)*
-*Karamuchou wa Oosawagi!: Porinkiis to Okashina Nakamatachi (カラムー町は大さわぎ! 〜ポリンキーズとおかしな仲間たち〜)*
-*Kaseki Sousei Reborn II: Monster Digger (化石創世リボーン2 〜モンスターティガー〜)*
-*Kidou Senkan Nadesico - Ruri Ruri Mahjong (機動戦艦ナデシコ ルリルリ麻雀)*
-*Kisekae Monogatari (きせかえ物語)*
-*Klax (never released in Japan)*
-*Little Nicky (never released in Japan)*
-*Logical (never released in Japan)*
-*Love Hina Pocket (ラブ ひな)*
-*Magical Drop (never released in Japan)*
-*Mary-Kate and Ashley Pocket Planner (never released in Japan)*
-*McDonald's Monogatari : Honobono Tenchou Ikusei Game (マクドナルド物語)*
-*Mickey's Racing Adventure (never released in Japan)*
-*Mickey's Speedway USA (never released in Japan)*
-*Mission: Impossible (never released in Japan)*
-*Monster ★ Race 2 (もんすたあ★レース2)*
-*Monster ★ Race Okawari (もんすたあ★レース おかわり)*
-*Nakayoshi Cooking Series 1 - Oishii Cake-ya-san (なかよしクッキングシリーズ1 おいしいケーキ屋さん)*
-*Nakayoshi Cooking Series 2 - Oishii Panya-san (なかよしクッキングシリーズ2 おいしいパン屋さん)*
-*Nakayoshi Cooking Series 3 - Tanoshii Obentou (なかよしクッキングシリーズ3 たのしいお弁当)*
-*Nakayoshi Cooking Series 4 - Tanoshii Dessert (なかよしクッキングシリーズ4 たのしいデザート)*
-*Nakayoshi Cooking Series 5 - Cake Wo Tsukurou (なかよしクッキングシリーズ5 こむぎちゃんのケーキをつくろう!)*
-*Nakayoshi Pet Series 1: Kawaii Hamster (なかよしペットシリーズ1 かわいいハムスター)*
-*Nakayoshi Pet Series 2: Kawaii Usagi (なかよしペットシリーズ2 かわいいウサギ)*
-*Nakayoshi Pet Series 3: Kawaii koinu (なかよしペットシリーズ3 かわいい仔犬)*
-*NFL Blitz (never released in Japan)*
-*Nintama Rantarou GB: Eawase Challenge Puzzle (忍たま乱太郎GB えあわせチャレンジパズル)*
-*Ojarumaru: Mitsunegai Jinja no Ennichi de Ojaru! (おじゃる丸 〜満願神社は縁日でおじゃる!〜)*
-*Pachinko Data Card - Chou Ataru-kun (Pachinko Data Card ちょ〜あたる君)*
-*Perfect Dark (never released in Japan)*
-*Pocket Family 2 (ポケットファミリーGB2)*
-*Pocket Puyo Puyo-n (ぽけっとぷよぷよ〜ん)*
-*Pokémon Card GB2: Great Rocket-Dan Sanjō! (ポケモンカードGB2 GR団参上!)*
-*Pokémon Crystal (ポケットモンスター クリスタルバージョン)*
-*Pokémon Gold (ポケットモンスター 金)*
-*Pokémon Picross (Japan, unreleased)*
-*Pokémon Pinball (ポケモンピンボール)*
-*Pokémon Silver (ポケットモンスター 銀)*
-*Pokémon Trading Card Game (ポケモンカードGB)*
-*Pokémon Yellow: Special Pikachu Edition (ポケットモンスター ピカチュウ)*
-*Purikura Pocket 3 - Talent Debut Daisakusen (プリクラポケット3 〜タレントデビュー大作戦〜)*
-*Puzzled (never released in Japan)*
-*Quest for Camelot (never released in Japan)*
-*Roadsters Trophy (never released in Japan)*
-*Sanrio Timenet: Kako Hen (サンリオタイムネット 過去編)*
-*Sanrio Timenet: Mirai Hen (サンリオタイムネット 未来編)*
-*Shinseiki Evangelion Mahjong Hokan Keikaku (新世紀エヴァンゲリオン 麻雀補完計画)*
-*Sōko-ban Densetsu: Hikari to Yami no Kuni (倉庫番伝説 光と闇の国)*
-*Super Black Bass Pocket 3 (スーパーブラックバスポケット3)*
-*Super Mario Bros. Deluxe (スーパーマリオブラザーズデラックス)*
-*Sweet Angel (スウィートアンジェ)*
-*Sylvanian Families 3 - Hoshi Furu Yoru no Sunadokei (シルバニアファミリー３　星ふる夜のすなどけい)*
-*Sylvanian Families: Otogi no Kuni no Pendant (シルバニアファミリー 〜おとぎの国のペンダント〜)*
-*Tales of Phantasia: Nakiri's Dungeon (テイルズ オブ ファンタジア なりきりダンジョン)*
-*The Legend of Zelda: Link's Awakening DX (ゼルダの伝説 夢をみる島DX)*
-*The Little Mermaid 2: Pinball Frenzy (never released in Japan)*
-*Tony Hawk's Pro Skater 2 (never released in Japan)*
-*Trade & Battle: Card Hero (トレード&バトル カードヒーロー)*
-*Tsuri Sensei 2 (釣り先生2)*
