// ignore_for_file: avoid_print

import 'package:collection/collection.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/db/data.dart';

Future<void> translateSongName(DataSource data) async {
  /* https://tak-wls-prod.wahlap.net/file/dist/#/songs
  使用vue框架，这里不好解析 ，直接在浏览器用js解析出列表，
Array.from(document.querySelectorAll('.song_item')).map(function(item, index, array) {
    var sep = '||';
    var name = item.querySelector('.main_text').innerText;
    var subtitle = item.querySelector('.singer').innerText;
    var diffi = Array.from(item.querySelectorAll('.scope')).map((it) => it.innerText).join(sep);
    return name+sep+subtitle+sep+diffi;
}).join('\n');
   */
  const jpUrl =
      'https://wikiwiki.jp/taiko-fumen/%E4%BD%9C%E5%93%81/%E6%96%B0AC%E3%82%A2%E3%82%B8%E3%82%A2%E7%89%88%28%E4%B8%AD%E5%9B%BD%E8%AA%9E%29';
  const cnItemListString = """
#流行音乐
爱你||||1||4||4||6||
逆战||||3||4||4||7||
被比较的孩子||TUYU||2||2||5||7||
Just Awake||Fear, and Loathing in Las Vegas 出自"HUNTER×HUNTER"||3||4||5||8||
DANCE MONKEY||||2||2||5||7||
修炼爱情||||2||3||5||7||
Savage Love||||2||3||4||6||
新时代||Ado "UTA 出自 航海王剧场版：红发歌姬"||2||4||5||7||
Mixed nuts||电视动画"SPY×FAMILY"第一期片头曲||2||4||5||7||
CITRUS||出自"极主夫道"||2||3||5||7||
Nothing's Working Out||meiyo||3||4||5||8||
Shining Star||魔王魂||3||3||5||6||
怪物||YOASOBI「怪物 /優しい彗星」より||3||5||6||7||
群青||YOASOBI||2||4||6||8||
向夜晚奔去||YOASOBI||1||2||4||8||
Ichizu||King Gnu||3||4||5||8||
白日||||2||2||2||8||
Ashura-chan||Ado||2||3||4||7||
踊||Ado||2||3||5||8||
Usseewa||Ado||2||2||3||8||
Dried Flower||||1||3||5||7||
来自天堂的魔鬼||||2||4||4||6||
Streamer||草莓王子 / TwitCasting “Furu Furu Fruit Campaign“ Campaign Song||2||3||5||7||
Strawberry☆Planet!||草莓王子 / Nayutan星人||3||3||3||6||
LOVE LOVE ALIEN||Strawberry Prince / NayutalieN||3||3||5||6||
promise the star||BiSH||3||3||4||6||8
Sugar||||1||3||4||7||
以后别做朋友||电视剧"16个夏天"片尾曲||2||2||4||6||
AKEBOSHI||||1||2||5||6||
炎||||1||2||1||4||
红莲华||出自"鬼灭之刃"||2||2||3||6||8
廻廻奇譚||Eve 电视动画"咒术回战"第一期片头曲||4||5||6||8||
YONA YONA DANCE||Akiko Wada||2||5||5||8||
如果我成为大统领||P丸样・||3||4||5||7||
再见宣言||Chinozo feat. flower||3||5||6||8||
怪兽少女不喷火||粗品 feat. 初音未来||3||5||6||8||9
第六感||Reol||3||5||5||7||
Walking with you||||2||4||5||8||
DDU-DU DDU-DU||||2||2||4||7||
bad guy||||3||5||6||7||
Colorful Party||HIMAWARI Channel||1||2||4||5||
HIMAWARI HAPPY||HIMAWARI Channel||1||1||2||2||
Natsumatsuri / Jitterin' Jinn||||4||4||6||7||10
睡莲花||||3||3||5||7||
乱数调整的反转灰姑娘||粗品 feat. Su Ayamiya(CV: Ayana Taketatsu)||3||5||6||8||10
Turing Love feat.Sou / Nanawo Akari||NayutalieN From / " RIKEI GA KOI NI OCHITA NO DE SHOUMEI SHITE MITA. "||2||5||6||8||
裸の心||TBS系 火曜ドラマ「私の家政夫ナギサさん」主題歌||1||2||5||7||
猫||||2||3||3||8||
宿命||Official髭男dism||2||2||5||7||
Theme of 半泽直树 ~Main Title~||||1||2||2||8||
最重要的事||||3||4||6||7||
香水||||1||2||3||6||
月光||YORUSHIKA||1||2||4||6||8
仅予以你的晴天||YORUSHIKA||2||2||3||5||
Byoushinwo Kamu||ZUTOMAYO||2||4||5||8||
ROKI||mikito P feat. 镜音铃||3||3||4||7||
前前前世||出自电影"你的名字。"||3||4||6||8||
Is There Still Anything That Love Can Do?||出自"天气之子"||2||2||4||5||8
Natsumatsuri||||3||2||6||6||
Ao to Natsu||||2||2||3||6||
甜蜜歌声与苦涩舞步||出自"血界战线"||3||4||5||8||
轟!!!||水溜りボンド||2||2||3||6||
イイコ進化論（feat. O-LuHA）||えっちゃん||3||6||7||9||
RESTART||TOSHIMITSU||2||3||4||8||
ミュートすればいいじゃん。||ぁぃぁぃ||3||4||4||7||
アバみ||アバンティーズ||2||3||4||8||
8月の坂||んだほ＆ぺけたん from Fischer’s||2||3||5||7||
虹||Fischer’s‐フィッシャーズ‐||3||4||5||6||
GODSONG||BAND JA NAIMON! MAXX NAKAYOSHI||3||5||6||8||10
神様の言うとおりに||ラトゥラトゥ（タケヤキ翔×マイキ）||3||4||4||8||9
猫サンキュー||夕闇に誘いし漆黒の天使達||4||5||7||9||
今||||2||3||3||5||
YouTube主题曲||HIKAKIN & SEIKIN||3||4||5||7||
雑草||HIKAKIN ＆ SEIKIN||3||3||5||6||
恋||||2||3||3||6||
告別輓歌||||3||4||5||8||
Anata To Tu Lat Tat Ta♪||DREAMS COME TRUE||1||1||1||1||10
Sekai Wa Anata Ni Waraikakete Iru||||3||4||5||8||
天体観測||||3||5||4||6||
红||||3||4||7||8||
Silent Jealousy||||4||6||7||8||10
Literary Nonsense||Eve||2||2||4||7||
Dramaturgy||Eve||2||2||3||5||8
向日葵的约定||||3||4||5||7||
奇迹||||3||2||3||2||
JOIN US||UUUM Collaboration Unit||2||3||3||7||
樱桃||||4||4||4||8||
SYNCHRONICITY||||2||3||5||7||
LINDA LINDA||||4||6||5||5||
刀剣乱舞||刀剣男士 team三条 with加州清光||1||2||3||5||
女人气||Golden Bomber||3||4||5||8||
零 ‐ZERO‐||福山雅治　「名探偵コナン ゼロの執行人」より||2||3||5||7||
Count Down||出自"名侦探柯南"||2||4||5||8||
RPG||||3||3||4||6||
Dragon Night||SEKAI NO OWARI||3||4||5||8||
Ashita mo||||1||2||3||2||
私以外私じゃないの||||4||6||6||8||
忍者棒棒||||3||5||6||8||
インベーダーインベーダー||||3||4||6||6||
PON PON PON||kyary pamyu pamyu||3||4||4||6||
Rain||||3||4||5||7||
Haruuta||出自"名侦探柯南 第11位前锋"||3||4||5||6||
Heavy Rotation||||2||3||3||6||
马尾和发圈||||3||5||6||7||
命短し恋せよ乙女||MOSHIMO||3||3||5||7||
Love song 永不停息||||3||4||4||6||
さちさちにしてあげる♪||小林幸子||3||6||7||7||10
I my moko||桃井はるこ||3||5||6||8||
#儿童音乐
两只老虎||||2||2||3||6||
HaneMari体操||HANEMARI Channel||2||2||3||5||
新时代||Ado "UTA 出自 航海王剧场版：红发歌姬"||2||4||5||7||
１・２・３||出自 动画"宝可梦（2019）"||1||1||4||6||
Mezase Pokémon Master -20th Anniversary-||出自"宝可梦 就决定是你了！"||2||4||6||8||8
Colorful Party||HIMAWARI Channel||1||2||4||5||
HIMAWARI HAPPY||HIMAWARI Channel||1||1||2||2||
Ore Koso Only One||出自"暴太郎战队DON BROTHERS"||1||2||3||6||
ZENRYOKUZENKAI! ZENKAIGER||出自"KIKAI SENTAI ZENKAIGER"||2||2||4||6||
AKEBOSHI||||1||2||5||6||
炎||||1||2||1||4||
红莲华||出自"鬼灭之刃"||2||2||3||6||8
liveDevil||出自"假面骑士 REVICE"||2||3||5||6||
Fun!Fun!Fun! ～梦∞～||出自"挚友×战士 闪耀能量！"||2||3||5||6||
Baby Shark||||1||1||3||4||
We Are!||出自"航海王"||3||4||5||6||10
闪亮亮银河||出自"妖怪学园Y ～第N类接触～"||2||3||4||6||
Let It Go||出自"冰雪奇缘"||2||2||2||4||
实现梦想的哆啦Ａ梦||||1||1||2||4||
面包超人进行曲||||2||1||5||1||
名侦探柯南 主题音乐||||3||1||5||6||
星之卡比 组曲||出自"Kirby's Return to Dream Land"||2||4||5||8||
隔壁的龙猫||||2||3||1||5||
散步||出自"隔壁的龙猫"||1||1||4||5||9
永远同在||出自"千与千寻"||2||1||2||1||
崖上的波妞||||1||2||1||2||
伴随着你||出自"天空之城"||2||3||4||6||
稍息立正站好||出自"樱桃小丸子"||1||2||3||4||
8月の坂||んだほ＆ぺけたん from Fischer’s||2||3||5||7||
虹||Fischer’s‐フィッシャーズ‐||3||4||5||6||
今||||2||3||3||5||
YouTube主题曲||HIKAKIN & SEIKIN||3||4||5||7||
雑草||HIKAKIN ＆ SEIKIN||3||3||5||6||
RPG||||3||3||4||6||
轟!!!||水溜りボンド||2||2||3||6||
KA! KA! KA! KAMIZMODE!||From “ SAIKYO KAMIZMODE! ”||2||2||3||7||
Chuwapane!||出自"秘密X战士 幻影甜心！"||1||1||3||5||
Smile! Smile! Smile!||出自"少年阿贝 GO!GO!小芝麻"||2||2||4||5||9
咯咯咯鬼太郎||||1||1||1||2||10
UKIUKI OTOPPE||||1||1||4||9||
ぐでたまテーマソング||||1||1||1||3||
ぐでたまぷちょへんざ||||1||1||3||4||
XY&Z||出自"宝可梦 XY & Z"||1||2||5||9||
メタナイトの逆襲メドレー||「星のカービィ ウルトラスーパーデラックス」より||3||4||7||7||10
零 ‐ZERO‐||福山雅治　「名探偵コナン ゼロの執行人」より||2||3||5||7||
Count Down||出自"名侦探柯南"||2||4||5||8||
Haruuta||出自"名侦探柯南 第11位前锋"||3||4||5||6||
エビカニクス||ケロポンズ||2||2||3||6||
向日葵的约定||||3||4||5||7||
限界突破×Survivor||出自"七龙珠超"||3||3||3||3||8
卡门第一组曲 斗牛士之歌||比才||3||5||5||7||
天堂与地狱序曲||奥芬巴赫||4||4||5||6||
威廉泰尔序曲||罗西尼||3||5||7||7||
第九号交响曲||贝多芬||3||3||3||6||
GEEDの証||『ウルトラマンジード』より||3||3||4||7||
オーブの祈り||「ウルトラマンオーブ」より||3||5||6||10||
ウルトラマンX||||1||3||5||7||10
银河奥特曼之歌||||3||3||6||9||
おさかな毎日！さかなクン||さかなクン||2||4||4||7||
グレート！アニマルカイザー!!||「百獣大戦グレートアニマルカイザー」より||3||4||6||8||
RAINMAKER||新日本プロレス オカダ・カズチカ入場テーマ||3||4||5||8||
くらえ！ブットバースト!!||「友情装着！ブットバースト」より||2||2||4||6||
#动漫音乐
Just Awake||Fear, and Loathing in Las Vegas 出自"HUNTER×HUNTER"||3||4||5||8||
新时代||Ado "UTA 出自 航海王剧场版：红发歌姬"||2||4||5||7||
Mixed nuts||电视动画"SPY×FAMILY"第一期片头曲||2||4||5||7||
怪物||YOASOBI「怪物 /優しい彗星」より||3||5||6||7||
１・２・３||出自 动画"宝可梦（2019）"||1||1||4||6||
Mezase Pokémon Master -20th Anniversary-||出自"宝可梦 就决定是你了！"||2||4||6||8||8
Ichizu||King Gnu||3||4||5||8||
廻廻奇譚||Eve 电视动画"咒术回战"第一期片头曲||4||5||6||8||
AKEBOSHI||||1||2||5||6||
炎||||1||2||1||4||
红莲华||出自"鬼灭之刃"||2||2||3||6||8
僕の戦争||「進撃の巨人 The Final Season」より||3||4||5||8||
We Are!||出自"航海王"||3||4||5||6||10
Turing Love feat.Sou / Nanawo Akari||NayutalieN From / " RIKEI GA KOI NI OCHITA NO DE SHOUMEI SHITE MITA. "||2||5||6||8||
Realize||出自"Re:从零开始的异世界生活"||3||5||6||7||
Paradisus-Paradoxum||出自"Re:从零开始的异世界生活"||3||5||6||8||
前前前世||出自电影"你的名字。"||3||4||6||8||
Is There Still Anything That Love Can Do?||出自"天气之子"||2||2||4||5||8
闪亮亮银河||出自"妖怪学园Y ～第N类接触～"||2||3||4||6||
残酷天使的行动纲领||出自"新世纪福音战士"||4||4||6||7||8
软软战车||||3||5||6||6||9
God knows...||出自"凉宮春日的憂鬱"||3||4||4||7||9
only my railgun||出自"科学超电磁炮"||3||5||6||7||
名侦探柯南 主题音乐||||3||1||5||6||
实现梦想的哆啦Ａ梦||||1||1||2||4||
向日葵的约定||||3||4||5||7||
面包超人进行曲||||2||1||5||1||
甜蜜歌声与苦涩舞步||出自"血界战线"||3||4||5||8||
零 ‐ZERO‐||福山雅治　「名探偵コナン ゼロの執行人」より||2||3||5||7||
Count Down||出自"名侦探柯南"||2||4||5||8||
Haruuta||出自"名侦探柯南 第11位前锋"||3||4||5||6||
Let It Go||出自"冰雪奇缘"||2||2||2||4||
咯咯咯鬼太郎||||1||1||1||2||10
XY&Z||出自"宝可梦 XY & Z"||1||2||5||9||
隔壁的龙猫||||2||3||1||5||
散步||出自"隔壁的龙猫"||1||1||4||5||9
永远同在||出自"千与千寻"||2||1||2||1||
崖上的波妞||||1||2||1||2||
伴随着你||出自"天空之城"||2||3||4||6||
ぐでたまテーマソング||||1||1||1||3||
ぐでたまぷちょへんざ||||1||1||3||4||
限界突破×Survivor||出自"七龙珠超"||3||3||3||3||8
Zenryoku Batankyuu||出自"Osomatsu San"||2||4||6||8||
Rain||||3||4||5||7||
Hikariare||出自"排球少年!! 乌野高校 VS 白鸟泽学园高校"||3||5||6||9||
僕らは今のなかで||μ's TVアニメ「ラブライブ！」より||4||6||6||8||
それは僕たちの奇跡||μ's TVアニメ「ラブライブ！」より||3||5||6||7||
Angelic Angel||μ's 映画「ラブライブ！The School Idol Movie」より||3||4||4||7||
My Soul,Your Beats!||出自"Angel Beats!"||3||4||7||8||
稍息立正站好||出自"樱桃小丸子"||1||2||3||4||
THE IDOLM@STER||出自"偶像大师"||3||4||4||8||8
アイ MUST GO！||「アイドルマスター」より||3||3||3||8||
Star!!||出自"偶像大师灰姑娘女孩"||3||4||5||6||9
GOIN'!!!||出自"偶像大师灰姑娘女孩"||3||4||5||6||8
Shine!!||出自"偶像大师灰姑娘女孩"||3||4||5||6||9
Magic day...!?||出自"偶像大师"||3||5||6||8||
魔法をかけて！||「アイドルマスター」より||3||3||4||7||6
GO MY WAY!!||出自"偶像大师"||3||5||5||7||
Kirame Kirari||出自"偶像大师"||3||6||7||9||
shiny smile||出自"偶像大师"||3||4||4||8||7
The world is all one !!||出自"偶像大师"||3||4||4||5||
SMOKY THRILL||出自"偶像大师"||4||5||6||8||
Jibun REST@RT||出自"偶像大师"||3||4||4||7||9
M@STERPIECE||出自"偶像大师"||2||3||4||6||
待ち受けプリンス||「アイドルマスター」より||3||5||5||9||
きゅんっ！ヴァンパイアガール||「アイドルマスター」より||3||3||3||6||
七彩ボタン||「アイドルマスター」より||3||4||4||7||
Honey Heartbeat ～10 Stars Mix～||出自"偶像大师"||3||4||7||9||10
ONLY MY NOTE||出自"偶像大师"||3||4||6||6||
Reason!!||出自"偶像大师 SideM"||1||2||3||6||
GLORIOUS RO＠D||出自"偶像大师 SideM"||2||3||3||7||
#博歌乐™音乐 （VOCALOID™）
Irodoru♡Future||Nobuyoshi Kobayashi(BNSI) feat. 未来小町||3||4||4||8||
像神一样啊||PINOCCHIOP feat. 初音未来||2||3||5||7||
Animal||DECO*27 feat. HATSUNE MIKU||3||4||4||7||
Cinderella||DECO*27 feat. HATSUNE MIKU||3||4||5||7||9
The Vampire||DECO*27 feat. 初音未来||3||5||6||8||
乙女解剖||DECO*27 feat. 初音未来||2||3||4||6||8
HIBANA||DECO*27 feat. 初音未来||4||5||6||8||10
Ghost Rule||DECO*27 feat. 初音未来||4||5||7||8||9
再见宣言||Chinozo feat. flower||3||5||6||8||
Hated by Life||Iori Kanzaki||2||3||5||7||8
怪兽少女不喷火||粗品 feat. 初音未来||3||5||6||8||9
Venom (feat. flower)||Kairiki bear||2||4||6||8||
KING||Kanaria feat. GUMI||2||5||6||8||
千本樱||Kurousa P feat. 初音未来||3||5||6||7||8
ROKI||mikito P feat. 镜音铃||3||3||4||7||
1,2, Fanclub||mikito P feat.GUMI・KAGAMINE RIN||3||4||6||8||
I want to be your heart||Yurry Canon feat. GUMI||3||4||6||8||
六兆年零一夜物语||kemu feat. IA||3||5||7||9||9
Haikei Doppelganger||kemu feat. GUMI||3||5||7||10||
查尔斯||balloon feat. flower||4||5||6||8||
Ameto Petora||balloon feat. flower||3||4||5||6||8
ASUNO YOZORA SHOKAIHAN||Orangestar feat. IA||4||6||7||9||
脑浆炸裂GIRL||rerulili feat. 初音未来・GUMI||4||5||6||8||9
Lost one的恸哭||Neru feat. 镜音铃||3||4||7||8||
東京テディベア||Neru feat.鏡音リン||4||6||6||8||
太阳系DISCO||Nayutan星人 feat. 初音未来||3||4||5||8||
Alien Alien||Nayutan星人 feat. 初音未来||3||5||6||9||
天之弱||１６４ feat. GUMI||4||5||6||8||
残響||164 feat.GUMI 「戦闘摂理解析システム#コンパス」より||2||4||5||6||9
Literary Nonsense||Eve||2||2||4||7||
Dramaturgy||Eve||2||2||3||5||8
Teo||Omoi feat.HATSUNE MIKU||2||5||6||8||
Dance Robot Dance||Nayutan星人 feat. 初音未来||3||4||4||9||
撥条少女時計||Drop＆葉月ゆら feat.初音ミク 「戦闘摂理解析システム#コンパス」より||2||3||4||8||
グラーヴェ||niki feat.初音ミク 「戦闘摂理解析システム#コンパス」より||2||2||4||8||
Alkali Rettousei||Kairiki bear feat. HATSUNE MIKU||3||4||5||7||
Violence Trigger||Hachioji P feat. HATSUNE MIKU||3||4||6||9||
ハイスペックニート||40mP feat.初音ミク 「戦闘摂理解析システム#コンパス」より||3||4||6||8||
Cantabile×Passione||OSTER project feat. HATSUNE MIKU||2||3||4||7||9
レトロマニア狂想曲||PolyphonicBranch feat.鏡音リン・鏡音レン 「戦闘摂理解析システム#コンパス」より||3||5||7||8||
キレキャリオン||ポリスピカデリー feat.初音ミク 「戦闘摂理解析システム#コンパス」より||2||3||4||8||
+♂(プラス男子)||ギガれをる feat.鏡音レン||4||5||6||7||9
Gigantic O.T.N.||Giga Reol||3||6||7||9||10
Kagerou Days||jin||3||5||5||7||8
ワールズエンド・ダンスホール||wowaka feat.初音ミク、巡音ルカ||4||5||6||9||
Monokuro Voice||cosMo＠暴走P feat. 初音未来・GUMI||4||6||7||10||10
Colorful Voice||cosMo＠暴走P feat. 初音未来・GUMI||5||7||7||9||10
初音未来的消失-剧场版-||cosMo＠暴走P feat. 初音未来||5||7||8||9||10
饭团在哪呢♪||Yomii feat. 初音未来||5||7||8||9||
M.S.S.Planet||M.S.S Project feat.初音ミク・GUMI||3||5||7||8||
TOORIYO||Tezuka feat. 镜音铃・镜音连||3||5||6||8||
mosimosi KAMISAMA||Tezuka feat. 镜音铃・镜音连||3||5||6||8||
EDY -Electrical Dancing Yoga-||feat. 镜音铃・镜音连||4||6||7||9||
SstTAarR*||M-O-T-U feat. 初音未来||5||7||8||10||
汪喵世界||feat. 镜音铃・镜音连 starring 下田麻美||4||5||6||9||
重金属Fugitive||Ryuwitty feat. GUMI||4||6||7||10||
Eternal bond||Ryuwitty feat. GUMI||5||6||8||8||
BORDERLESS||ZOLA PROJECT||4||6||5||8||
幾望の月||||4||5||7||9||
KARA鞠之花||Harunaba feat. Yuzuki Yukari||4||7||7||10||
Ghost Mask||Harunaba feat. Yuzuki Yukari & Ishiguro Chihiro||4||6||7||10||
花音反拍子||Harunaba feat.初音未来||3||5||6||9||
咖啡的味道||Harunaba feat. GUMI||4||5||6||9||
NINJIN NIN||丰永GONTA P feat. GUMI||3||4||5||8||
心跳不已的恋爱预感！？||Noriyuki feat. GUMI||3||4||5||7||
僕らの世界にダンスを||サカモト教授 feat. GUMI||4||5||5||7||
さちさちにしてあげる♪||小林幸子||3||6||7||7||10
4+1的各自的未来||Taiko de Time Travel 00's / cosMo＠暴走P feat. 初音未来||5||7||8||10||
TELL ME BEAT||kinoshita feat. 镜音铃||3||5||6||8||
#游戏音乐
GOING TO LUNATEA||出自"风之少年2  Lunatea's Veil"||2||4||6||8||
Libera Ray||steμ feat. siroa 出自"Synchronica"||4||5||7||10||
せかいのおと - sekai note -||FILTER SYSTEM 「シンクロニカ」より||1||2||4||8||
業 -善なる神とこの世の悪について-||光吉猛修 VS 穴山大輔 「CHUNITHM」より||5||6||7||9||10
MEGALOVANIA||出自"UNDERTALE"||4||5||7||9||
夢と希望||「UNDERTALE」より||3||5||6||8||
星之卡比 组曲||出自"Kirby's Return to Dream Land"||2||4||5||8||
メタナイトの逆襲メドレー||「星のカービィ ウルトラスーパーデラックス」より||3||4||7||7||10
Dance Robot Dance||Nayutan星人 feat. 初音未来||3||4||4||9||
撥条少女時計||Drop＆葉月ゆら feat.初音ミク 「戦闘摂理解析システム#コンパス」より||2||3||4||8||
グラーヴェ||niki feat.初音ミク 「戦闘摂理解析システム#コンパス」より||2||2||4||8||
Alkali Rettousei||Kairiki bear feat. HATSUNE MIKU||3||4||5||7||
Violence Trigger||Hachioji P feat. HATSUNE MIKU||3||4||6||9||
ハイスペックニート||40mP feat.初音ミク 「戦闘摂理解析システム#コンパス」より||3||4||6||8||
Cantabile×Passione||OSTER project feat. HATSUNE MIKU||2||3||4||7||9
残響||164 feat.GUMI 「戦闘摂理解析システム#コンパス」より||2||4||5||6||9
レトロマニア狂想曲||PolyphonicBranch feat.鏡音リン・鏡音レン 「戦闘摂理解析システム#コンパス」より||3||5||7||8||
キレキャリオン||ポリスピカデリー feat.初音ミク 「戦闘摂理解析システム#コンパス」より||2||3||4||8||
KA! KA! KA! KAMIZMODE!||From “ SAIKYO KAMIZMODE! ”||2||2||3||7||
ANiMA||xi 出自"DEEMO"||5||6||7||10||
MagiCatz||Sakuzyo 出自"DEEMO"||2||3||6||10||
Wish upon a shooting star||SUi 出自"DEEMO"||4||5||6||9||
Leviathan||NeLiME 出自"DEEMO"||4||7||7||9||
JOIN THE PAC -太鼓之达人 Ver.-||PAC-MAN 40周年官方主题曲||3||3||6||9||
KAGEKIYO||源平讨魔传Medley||4||5||7||8||10
No Way Back||出自"噬神者"||4||6||7||8||9
無慈悲な王||「GOD EATER BURST」より||3||6||6||7||
Wings of Tomorrow(Tatsujin Mix)||出自"噬神者2"||4||6||6||9||
Brave Sword, Braver Soul||出自"剑魂II"||3||5||5||7||
太鼓进行曲||||5||6||6||7||
The arrow was shot||出自"TALES OF THE ABYSS"||5||6||7||8||
光る闇||テイルズ オブ ザ ワールド レーヴ ユナイティア||3||5||5||8||
FLOWER||DJ YOSHITAKA 「jubeat」より||5||7||8||9||10
Garakuta Doll Play||t＋pazolite 「maimai」より||4||6||8||9||10
FUJIN Rumble||COSIO（ZUNTATA）「グルーヴコースター」より||5||6||8||10||
夜明けまであと3秒||「シンクロニカ」より||4||5||7||9||
Canon (Synchronica Remix)||出自"Synchronica"||3||5||6||8||
Synchronicity||出自"Synchronica"||3||3||6||8||
God Ray||出自"Synchronica"||5||6||7||10||
Surf Zapping||t+pazolite 出自"Synchronica"||4||6||7||10||
New World||出自"Synchronica"||3||6||7||9||
Synchronica Airline||Taku Inoue(BNSI) 出自"Synchronica"||4||6||7||9||
YURAME||mifumei 出自"Synchronica"||5||7||8||9||
駆け抜けてゆく||すえP 「シンクロニカ」より||4||5||6||8||
VERTeX||Hiro「maimai」より||5||7||8||10||
Scars of FAUNA||猫叉Master「jubeat」より||4||5||7||9||
Saika||Rabpit 出自"DEEMO"||3||4||6||8||
Got more raves？||E.G.G.「グルーヴコースター」より||5||7||8||9||10
電車で電車でGO！GO！GO！GC！ ‐ GMT remix ‐||COSIO（ZUNTATA／TAITO）／沢城千春「電車でGO！」||4||5||6||8||
オパ！オパ！RACER ‐ GMT mashup ‐||COSIO（ZUNTATA／TAITO）「ファンタジーゾーン」「RIDGE RACER」||5||6||8||9||
ファンタジーゾーン OPA-OPA！ ‐ GMT remix ‐||Hiro（SEGA）「ファンタジーゾーン」||4||6||7||7||
Over Clock～開放～||NAOKI feat.un∞limited 「クロスビーツレヴ」より||3||6||7||8||
電車で電車でOPA！OPA！OPA！ ‐ GMT mashup ‐||Yuji Masubuchi（BNSI）「電車でGO！」「ファンタジーゾーン」||4||6||7||8||
RIDGE RACER STEPS -GMT remix-||Yuji Masubuchi（BNSI）「RIDGE RACER」||4||6||7||9||
リッジでリッジでGO！GO！GO！ ‐ GMT mashup ‐||Hiro（SEGA）「RIDGE RACER」「電車でGO！」||4||6||7||9||
Ridge Racer||||4||7||8||8||9
Kamikaze Remix||出自"RIDGE RACERS 2"||3||6||8||10||
BLUE TOPAZ||出自"RAVE RACER"||4||5||7||8||
RAGE v.self||||3||4||6||8||
EAT'EM UP!||出自"R4 -RIDGE RACER TYPE4-"||3||5||6||8||
URBAN FRAGMENTS||出自"R4 -RIDGE RACER TYPE4-"||4||4||6||8||
Venomous||出自"RIDGE RACER 3D"||5||6||7||9||10
Angel Halo||出自"RIDGE RACER 3D"||5||7||8||10||
告诉我，熊熊朋友||出自"ＫＵＭＡ・ＴＯＭＯ"||2||3||5||8||
Night And Day||出自"空战奇兵2"||4||6||8||9||
IN THE ZONE||出自"空战奇兵X2 JOINT ASSAULT"||4||6||8||9||
ワンダーモモーイ||||4||5||6||7||
Doom Noiz||出自"Galaga Legions"||5||6||8||10||
Lightning Dance||出自"WANGAN MIDNIGHT MAXIMUMTUNE"||4||5||7||8||
Walking Through The Towers||「パズル＆ドラゴンズ」より||3||4||5||7||
Holding Hands||「パズル＆ドラゴンズ」より||3||5||6||7||
Unite The Force||「パズル＆ドラゴンズ」より||2||4||7||8||
バトル－電光石火－||「パズドラクロス」より||2||4||5||8||
如肌肉般的我们 ～肌肉爱的旋律～||出自"MUSCLE行进曲"||4||5||6||8||
PaPaPa Love||出自"MUSCLE行进曲"||3||5||6||8||
ピコピコ マッピー||マッピーメドレー × サカモト教授||4||6||7||8||
The Windmill Song||出自"风之少年 克罗诺亚"||4||6||6||8||
Good‐bye my earth||「ダライアスバースト」より||3||5||7||8||
BLAZING VORTEX||出自"致命极速"||5||6||7||7||10
Sunset Runaway||出自"致命极速"||4||6||8||9||
Wasabi Body Blow||出自"TEKKEN 3D PRIME EDITION"||3||4||6||9||
Abyss of hell||出自"TEKKEN Revolution"||5||7||8||8||10
Highschool love!||出自"TEKKEN TAG TOURNAMENT 2 Wii U EDITION"||3||4||6||7||
グレート！アニマルカイザー!!||「百獣大戦グレートアニマルカイザー」より||3||4||6||8||
チェインクロニクル 通常バトルメドレー||||3||5||6||8||9
チェインクロニクル 最終決戦メドレー||||4||6||6||8||9
チェインクロニクル 総力戦メドレー||||3||4||5||7||9
SYMPHONIC DRUAGA||||4||6||7||7||
ASSAULT BGM1||||3||5||6||8||
指先からはじまる物語||郁原ゆう 「しんぐんデストロ～イ！」より||3||3||4||8||
戦え！ T3防衛隊 ～GDI mix～||「TANK！ TANK！ TANK！」より||4||4||7||8||
Pastel Sealane||出自"BLAZER"||5||7||8||9||
METAL HAWK BGM1||||5||6||8||10||
Diver||出自"TREASURE GAUST: Gaust Diver"||3||5||6||9||
くらえ！ブットバースト!!||「友情装着！ブットバースト」より||2||2||4||6||
OUBU ROUKOU||出自"KNUCKLE HEADS"||4||5||7||8||
DRAGON SPIRIT Medley||||4||6||8||7||
BURNING FORCE Medley||||4||5||6||8||
なんどでも笑おう||THE IDOLM@STER FIVE STARS!!!!!||3||4||5||7||
THE IDOLM@STER||出自"偶像大师"||3||4||4||8||8
アイ MUST GO！||「アイドルマスター」より||3||3||3||8||
Star!!||出自"偶像大师灰姑娘女孩"||3||4||5||6||9
GOIN'!!!||出自"偶像大师灰姑娘女孩"||3||4||5||6||8
Shine!!||出自"偶像大师灰姑娘女孩"||3||4||5||6||9
Thank You!||出自"偶像大师 百万人演唱会！"||3||4||5||8||
Magic day...!?||出自"偶像大师"||3||5||6||8||
魔法をかけて！||「アイドルマスター」より||3||3||4||7||6
GO MY WAY!!||出自"偶像大师"||3||5||5||7||
Kirame Kirari||出自"偶像大师"||3||6||7||9||
shiny smile||出自"偶像大师"||3||4||4||8||7
The world is all one !!||出自"偶像大师"||3||4||4||5||
SMOKY THRILL||出自"偶像大师"||4||5||6||8||
Jibun REST@RT||出自"偶像大师"||3||4||4||7||9
M@STERPIECE||出自"偶像大师"||2||3||4||6||
待ち受けプリンス||「アイドルマスター」より||3||5||5||9||
きゅんっ！ヴァンパイアガール||「アイドルマスター」より||3||3||3||6||
七彩ボタン||「アイドルマスター」より||3||4||4||7||
Honey Heartbeat ～10 Stars Mix～||出自"偶像大师"||3||4||7||9||10
ONLY MY NOTE||出自"偶像大师"||3||4||6||6||
Reason!!||出自"偶像大师 SideM"||1||2||3||6||
GLORIOUS RO＠D||出自"偶像大师 SideM"||2||3||3||7||
#综合音乐
Aleph-0||LeaF||5||7||8||10||
Doppelgangers||Alice Schach and the Magic Orchestra||4||6||6||8||10
Kill My Fortune||Alice Schach and the Magic Orchestra||4||5||5||7||
Mopemope||LeaF||4||5||7||10||
Aragami||xi||4||7||8||10||
Parousia||xi||4||6||6||10||
FREEDOM DiVE↓||xi||4||6||7||10||
USATEI||东方Project Arrange / Amane + beatMARIO (COOL&CREATE)||3||5||7||9||
BATTLE NO.1||TANO*C Sound Team||4||6||6||10||
幻想に咲いた花||岸田教団&THE明星ロケッツ×草野華余子 「東方ダンマクカグラ」より||3||5||6||8||
マツヨイナイトバグ||COOL&CREATE feat.ビートまりおとまろん 「東方ダンマクカグラ」より||4||5||5||8||10
Connected World||somunia||4||5||5||8||
twinkle night (feat. somunia)||nyankobrq & yaca||3||4||5||7||9
Theme of 半泽直树 ~Main Title~||||1||2||2||8||
软软战车||||3||5||6||6||9
Hand Over (Prod. TEMPLIME)||Reina Hidaka (CV: Yuuka Shidomi), Kazune Shinonome (CV: Miho Amane), Futaba Kayano (CV: Sena Horikoshi) 出自"电音部"||3||4||4||9||
Hyper Bass (feat. Yunomi)||Mimito Sakurano (CV: Yurie Kozakai), Hina Minakami (CV: Nichika Omori), Shian Inubousaki (CV: Rena Hasegawa) 出自"电音部"||2||2||5||9||
Itadaki Babel (Prod. Kenmochi Hidefumi)||Tama Kurogane (CV: Akina) 出自"电音部"||2||3||5||8||
Shining Lights (feat. PSYQUI)||Karin Houou (CV: Kana Sukoya) 出自"电音部"||2||2||6||9||
Idol狂战士(feat.佐藤贵文)||Futaba Kayano (CV: Sena Horikoshi) 出自"电音部"||3||4||5||7||9
Mani Mani(Prod. TAKU INOUE)||Kazune Shinonome (CV: Miho Amane) 出自"电音部"||2||4||6||8||
Favorite Days||Reina Hidaka (CV: Yuuka Shidomi) 出自"电音部"||2||3||7||8||
Dogbite||t+pazolite||4||6||7||10||
waitin' for u||Jun Kuroda||5||6||6||10||
ALiVE||REDALiCE||3||4||6||9||
B.B.K.K.B.K.K.||nora2r||4||6||7||9||
Dreadnought||Mastermind(xi+nora2r)||4||6||6||9||10
エビカニクス||ケロポンズ||2||2||3||6||
RAINMAKER||新日本プロレス オカダ・カズチカ入場テーマ||3||4||5||8||
おさかな毎日！さかなクン||さかなクン||2||4||4||7||
スーパーD＆D ～完全にリードしてアイマイミー～||むらたたむ＆レディビアード||4||6||7||10||
D絶対！SAMURAIインザレイン||むらたたむ＆レディビアード||3||4||6||8||10
INSPION||サウンド制作スタジオ「INSPION」社歌||5||6||8||10||
Calamity Fortune||东方Project Arrange / LeaF||4||6||7||10||10
郢曲／晓暗||东方Project × NAMCO SOUNDS / LindaAI-CUE(BNSI)||3||5||8||10||
深绯之心脏 -SCARLET HEART-||东方Project × NAMCO SOUNDS / kyo(BNSI) feat. asana(IOSYS)||3||5||6||8||
Raiko-Taiko-Disco||东方Project × NAMCO SOUNDS / 渡边量(BNSI)||3||5||5||8||
Ladystar Wandering||东方Project × NAMCO SOUNDS / Junichi Nakatsuru(BNSI)||4||6||7||8||
Sakura Secret||东方Project × NAMCO SOUNDS / Taku Inoue(BNSI) 出自"Synchronica"||2||4||5||9||
NeGa/PoSi*ラブ/コール||東方Projectアレンジ 凋叶棕||3||4||6||6||8
ケロ⑨destiny||東方Projectアレンジ Silver Forest||4||6||6||9||
Endless Seeker||東方Projectアレンジ A‐One||3||5||6||8||
Scream out！ ‐達人Edit.‐||東方Projectアレンジ A‐One||3||5||6||8||9
幻想のサテライト||東方Projectアレンジ 豚乙女||4||6||7||9||
明星Rocket||东方Project Arrange / 岸田教团＆THE明星Rockets||3||5||6||8||
仙酌絶唱のファンタジア||東方Projectアレンジ 博麗神社例大祭コラボユニット||3||5||5||9||
Necro Fantasia ～ Arr.Demetori||东方Project Arrange / Demetori||5||7||8||10||
Grip & Break down !! -达人Edit.-||东方Project Arrange / SOUND HOLIC feat. Nana Takahashi||4||5||6||7||9
魔理沙偷走了重要的东西||东方Project Arrange / ARM + Yoshimi YOUNO(IOSYS) feat. Fujisaki Karin||4||5||6||9||
患部で止まってすぐ溶ける ～ 狂気の優曇華院||東方Projectアレンジ ARM (IOSYS) feat.miko||2||4||7||9||
元祖！天才チルノちゃん☆||東方Projectアレンジ コバヤシユウヤ(IOSYS) feat.miko(Alternative ending)||4||6||6||9||
チルノのパーフェクトさんすう教室 ⑨周年バージョン||東方Projectアレンジ IOSYSと愉快な⑨周年フレンズ||3||4||5||9||10
琪露诺的完美算术教室||东方Project Arrange / ARM + Yoshimi YOUNO(IOSYS) feat. miko||4||5||7||8||10
Bad Apple!! feat.nomico||东方Project Arrange / Alstroemeria Records||3||5||6||8||
花开艳丽终散落||东方Project Arrange / 幽闭星光||2||4||5||8||
月隐於丛云花散於风||东方Project Arrange / 幽闭星光||4||5||6||8||
Help me, ERINNNNNN!!||東方Projectアレンジ ビートまりお||3||4||7||8||
最终鬼畜妹Frandre・S||东方Project Arrange / beatMARIO||4||6||7||10||
Night of Knights / Knight of Nights||东方Project Arrange / beatMARIO||4||6||7||9||
#古典音乐
Kawachi Ondo ~Fushidukushi~||||2||2||3||6||
其方，激昂||||5||6||8||10||
竖波波卡||||4||5||7||10||
古典乐组曲（摇滚篇）||||4||5||8||8||
卡门第一组曲 斗牛士之歌||比才||3||5||5||7||
天堂与地狱序曲||奥芬巴赫||4||4||5||6||
威廉泰尔序曲||罗西尼||3||5||7||7||
奔驰的查理！||||4||7||8||10||
亲亲卡农||||3||4||5||8||
野蜂飞舞||里姆斯基科萨科夫||3||4||7||9||
第九号交响曲||贝多芬||3||3||3||6||
第七号交响曲节选||贝多芬||3||4||6||7||
天鹅湖||～still a duckling～||4||6||7||9||10
练习曲Op.10-4||||3||4||8||9||10
幻想即兴曲||||5||7||8||9||
千鼓千鼓||||4||6||8||9||
弩蚊怒夏||||5||7||8||10||
Ruslan and Lyudmila||米哈伊尔・格林卡||3||5||7||8||
丑角的晨歌||||5||7||7||8||
美丽又急促的多瑙河||||4||4||6||8||10
库普兰之墓||||4||7||8||8||
悼念公主的帕凡舞曲||～Kimi no Kodou～||3||5||5||6||8
小步舞曲||||4||7||8||9||
夜曲Op.9 No.2||||4||6||7||8||
小狗波奇||||5||7||8||10||
Hung-rock||||4||6||7||10||
触技与赋格与ROCK||||5||7||8||9||
Surfside Satie||||5||7||8||8||
Concerto in F||乔治・格什温||4||5||7||9||
俄罗斯民谣组曲||||4||4||7||7||
O Vreneli||||3||3||5||6||
#南梦宫原创音乐
Doppelgangers||Alice Schach and the Magic Orchestra||4||6||6||8||10
每天都是Donderful||"太鼓之达人 咚咚雷音祭"主题曲||2||4||5||8||
HIKARINOKANATAE||||4||5||8||9||
SORA-IV BUMPA SONG||||4||5||5||8||
LOVELY X||||4||5||6||7||8
神龙 ～Shinryu～||Azu♪ & Masahiro "Godspeed" Aoki||5||7||8||10||10
SUPERNOVA||USAO||5||7||8||10||10
R.I.P.Hero||D-D-Dice||4||6||6||9||10
狂澜怒涛||xi||4||7||8||9||10
今天是太鼓日||"Taiko no Tatsujin: Appare Sandaime"主题曲||2||4||5||5||
女神的世界 II||翡翠＆祗羽 feat. Yura Hatsuki||4||6||7||8||
其方，激昂||||5||6||8||10||
Challengers||Marulon||5||7||8||10||
Player's High||K.key||5||7||8||10||
弧||概念||5||7||8||10||
METAMETA☆Universe!||kyo(BNSI) × Mitsu(TRYTONELABO) feat. Zakuro Motoki||4||5||6||8||
Love You☆小咚||||4||6||6||8||8
TONGACHIN||Kimitaka Matsumae||4||6||7||9||
红茶店「雨天」||||3||4||5||6||8
GO ON ～朝向未来～||Taiko de Time Travel 2022 / steμ(BNSI) respecting Time Travelers||2||3||5||8||
The Nue and Morning Stars||Silentroom||4||7||8||10||
Unlimited Games||Ponchi♪ feat. haxchi||5||7||7||10||
Hello, Mr.JOKER||D-D-Dice||4||7||8||10||
The Future of the TAIKO DRUM||Taiko de Time Travel 2765 / 山茶花||5||7||8||10||10
ex寅 Trap!!||Chiharu Kaneko||4||6||7||10||
小咚 世界旅行||||4||4||6||7||
Solitude Star||春先 x beet||5||6||7||9||
Agent Hustle & Dr. Hassle||Cory Tarrow(BNSI)||4||5||6||10||9
Spectral Rider||Rio Hamamoto(BNSI)||5||6||7||10||
TAIKO NO 2000||Taiko de Time Travel B.C.E. / LindaAI-CUE(BNSI)||5||7||8||10||
the telescope in virtual reality||deli.||4||5||7||9||
punk bastards||Sobrem||5||6||7||9||
Sapphire On Fire||庭师||4||6||7||9||
最喜欢的太鼓鼓声||太鼓之达人20周年曲 / 粗品 feat. 小咚||3||6||7||8||9
平等院凤凰咚 vs 鸟兽戏咔||Taiko de Time Travel Heian / Yuya Kobayashi(IOSYS) feat. miko||3||5||6||7||
一世风靡||Taiko de Time Travel Edo / Kakumi Nishigomi||4||5||6||9||
大冒险TATSUDON||Taiko de Time Travel 60's / Katsuro Tajima(BNSI) feat. Sixties Choirs||2||4||6||8||
刻龙 ～Kokuryu～||Azu♪||5||7||7||10||
Bachi! Muchi!? Musclekingdom||Yuma.Mizo feat. Ai Ohsera ♡ Marumoko||5||7||7||10||
魑魅魍魉||Laur||4||6||7||10||
Bouquet with Hatred & Ugliness||t+pazolite||5||7||8||10||10
鼓舞曲「阎魔」||山本真央树||5||7||8||10||
Aloft in the wind||Qutabire||3||5||6||7||
Emma||BlackY feat. Risa Yuzuki||3||5||5||7||
Hello, Worldooon!!||Capchii feat. Kuroa*||3||5||6||7||
Don't Doubt This Love||Taiko de Time Travel 70's / Kawagen Kollagen(BNSI) with yuzuki||4||5||6||8||
Donder Time||Taiko de Time Travel 80's / Masako Ogami feat.Kotoko from Danchinomiya||4||6||6||8||
Hold me tight||Taiko de Time Travel 90's / Tatsh&musica with PARC MANTHER||4||6||6||8||
小咚音头||||2||3||6||7||
BOKURA NO MAE NI MICHI WA ARU||HONOKA||4||5||7||8||
Amber Light||BNSI(Junichi Nakatsuru)||5||7||8||9||
4+1的各自的未来||Taiko de Time Travel 00's / cosMo＠暴走P feat. 初音未来||5||7||8||10||
SHOUYU de Show you!||BNSI(Yoshihito Yano) feat.steμ&Funa-D||3||5||7||9||
Central Dogma Pt.2||Daisuke Kurosawa||5||6||8||10||
Parallel Lollipop||Taiko de Time Travel 10's / Sho Okada(BNSI)||4||6||7||9||
TELL ME BEAT||kinoshita feat. 镜音铃||3||5||6||8||
Kabukimono, Keep it up!||kabotya||2||4||6||8||
Amaterasu JK||Takahiro Akuta feat. Sachiko||4||4||5||8||
AkatoSirobaranoMajo||Dokuwaki||5||7||8||10||
LECIEL GLISSANDO||Yomii||5||6||7||10||
YOAKE||Capchii feat. Uzumaki||4||7||8||10||
Great Chick Appraiser||Rish feat. Choko||4||6||8||10||
One Two SanShino de Dondo Kakka!||AIkiritan feat. Yu-ki Hirose||1||1||4||7||9
VIVIVIVID||M-O-T-U||3||5||6||10||
震天动地！太鼓之达人||Taiko de Time Travel 20's/steμ×Masubuchi×Sasaoka feat.TakayoshiTanimoto&ChiakiTakahashi||2||5||7||8||
Nijiiro Baton||Ponchi♪ feat. haxchi × Donders||3||5||6||8||
Diving Drive||Tanchiky feat. MuMenkyo.||5||7||8||10||
PETA-PETA!?PUMPKIN||Yutopia Qremia||4||5||6||9||
PONPOKO RHYTHM||Mamyukka||4||6||6||7||
Rainbow of La Paz||LeNoir||4||7||8||9||10
星河一天||D-D-Dice||4||6||8||10||
Stick Trick ShowTime!!||MisomyL||5||6||8||10||
螺旋周回轨道||BlackY feat. Risa Yuzuki||4||6||7||9||10
The ephemeral dances in the primordial||Se-U-Ra||4||5||7||10||10
Vixtory||CHUBAY||5||7||7||10||10
wonderful ROUTINE||Yusuke Kudo(BNSI)||5||6||8||10||
ISSO KONOMAMADE||mifumei(BNSI) feat. 相泽||4||6||7||9||
零之交响曲||kyo(BNSI) feat. Sariyajin||3||4||6||8||10
Fly again!||矢野义人(BNSI) feat. 谷本贵义||2||3||4||7||
极限创作者加油歌||Yukiko Miyagi(BNSI) feat. suzune & Kiyohito Kawase||3||5||6||8||
令・和太鼓||翡翠||4||4||7||8||
竖波波卡||||4||5||7||10||
ERINGI NO EKUBO||||5||6||7||8||
Freeway3234||||4||6||7||8||
这就是爱||Taku Inoue(BNSI)||3||5||7||9||
memoria ficta||Versus||4||6||7||10||
TOKIMEKI♡DESTROYER!!||Ayatsugu_Otowa||4||5||7||9||
宠物店大战||chacol feat. Focco||4||5||7||10||
可笑可啸2000||||5||7||8||10||
後続・〆dley 2000||||5||7||8||10||
幕末维新谭||Daisuke Kurosawa x Masahiro "Godspeed" Aoki||5||7||8||10||
Hello! Don-chan||||3||5||6||6||
NAMAHAGE NO UTA||feat. DAIKI||4||6||7||9||
The Cutlass of Kathiawar||||4||5||7||8||
古典乐组曲（摇滚篇）||||4||5||8||8||
Angel Dream||||3||6||7||8||9
心动不已的祭典时间||||4||6||6||9||
连结！推展！打上天！||"太鼓之达人 合奏咚咚咚！"主题曲||4||5||7||9||
摇摇♪晃晃♪||"太鼓之达人 Nintendo Switch版！"主题曲||3||4||6||7||9
百花缭乱||||3||4||5||8||
恭喜毕业典礼||feat. unmo||4||6||7||10||
Struck Stardust||t+pazolite||5||6||7||10||10
DANGAN NOTES||cosMo＠暴走P||5||7||8||10||10
メカデス。||||4||7||7||7||
埼玉2000||||5||7||7||7||
工作2000||||5||7||8||10||
森罗万象||削除||5||7||8||10||
UFO Swingin'||Shibagaki feat. A.Dokuga||5||7||8||10||
流浪的琥珀公主||||3||4||5||8||
Tenkyuunoritsu||Capchii||4||6||7||10||
Sakura Secret||东方Project × NAMCO SOUNDS / Taku Inoue(BNSI) 出自"Synchronica"||2||4||5||9||
抓住那只音乐虫！||KiWi||3||5||6||9||
气焰万丈神乐||penoreri||5||7||8||10||
Connect Colours||Ponchi♪ feat. haxchi||4||6||7||10||
Colorful Voice||cosMo＠暴走P feat. 初音未来・GUMI||5||7||7||9||10
Monokuro Voice||cosMo＠暴走P feat. 初音未来・GUMI||4||6||7||10||10
疾风怒涛||xi||5||7||8||10||10
What's in the box?||Ujico＊||3||5||7||10||
WA ARUDO HERITE IJI - JO||feat. 团地ノ宫弥子||3||5||7||8||
Dead or Die||REDALiCE||5||7||8||10||
ARUFUWA||aran||4||7||8||10||
Dragoon||Massive New Krew||4||6||7||9||
Ko Ki Ku Kuru Kuru Kure Ko!||Moroboshi Nana / Kato Haruka||3||4||6||8||
Trust Game||feat. SaChi(harineko)||5||6||6||9||
ANOHI DEAETA KISEKI||Yuma.Mizo feat. Ai Ohsera, miko||4||6||7||10||
Cutie☆Demonic☆MAJIN EMO!!||Yuma Mizonokuchi feat. Ai Ohsera||5||7||8||10||
顶||CHUBAY||5||7||8||10||
Youthful Coaster||U-ske feat. KazuraNatsu||4||6||7||9||
GO GET'EM!||Satoshi Terashima||4||7||8||9||9
ARMAGEΔDON||BlackY||5||7||8||10||
colorful||SHOGO/野村涉悟||4||7||8||10||
Uchuhikoushi Boukentan||SHOGO/野村涉悟||4||7||8||10||
λ7708||Taiji||5||7||8||10||
Caribbean Knight||Taiji||5||7||7||10||
Toon Town's Toys' Tune||Retropolitaliens||4||5||6||10||
round and fast and crazy rhythm||Rish feat. Choko||5||7||8||10||
Nya-Nya-Nya-||Rish feat. Choko||4||6||7||10||
EterNal Ring||museo||4||6||7||10||
Coquette||Jun Kuroda||5||7||8||10||
CYBERgenicALICE||||4||5||6||9||
SHINING☆ABRACADABRA||- ALADDIN & MAGICAL LAMP PRINCESS -||3||4||6||9||
Magical Parfait||||4||7||8||9||
MAOU NO SHOWTIME||||4||6||7||9||
TOYMATIC☆PARADE!!||DJ Genki||5||7||8||10||
LOVE♡SPICE♡LIKE YOU!!!||DJ Genki feat. Nanahira,yukacco,Aitsuki Nakuru||4||7||8||10||
预～备砰！||feat. Kiddish||4||6||7||10||
AI TO JOUZAI NO MORI||||5||7||8||10||
Blessed Bouquet Buskers||||4||5||6||10||
OK I'm blue rat||E.G.G.||4||6||8||10||
Hung-rock||||4||6||7||10||
小麦粉☆||乡 拓郎||4||5||6||8||
KOKUSHIN CHRONICLE||||3||4||6||7||
星尘与利尼亚与我||feat. 结羽(pLumsonic!)||4||5||5||8||
Time Traveler||伊东歌词太郎||2||3||4||6||
KAGAMI NO KUNI NO ALICE||伊东歌词太郎||3||4||5||6||
8OROCHI||REDALiCE||5||7||8||10||10
兔子的尾巴||||3||4||5||7||
三濑川乱舞||||4||5||7||8||10
Gunslinger Cinderella||||5||6||7||9||
愿望便是希望者||||4||6||6||7||
再见了Varya||Mirai Kodai Orchestra feat. Haruka Shimotsuki||4||5||7||9||
UNDEAD HEART（愤怒的Warriors）||Eizo Sakamoto × Yusuke Takahama||5||7||8||10||
龙与黑炎的公主||||4||6||7||8||10
恭喜毕业典礼・2BAN||feat. unmo||4||6||7||10||
No Gravity||||4||6||7||10||
VICTORIA||Cranky||5||7||8||10||
天狗配乐||||4||7||7||9||
梦与现实的边界||||4||6||7||9||
安东尼||You'll Melt More!||4||6||6||9||
美丽又急促的多瑙河||||4||4||6||8||10
放学後☆魔术师||Marine base||4||6||6||8||
Marionette Pure||||4||5||7||9||
Love Fantasy||HONOKA||4||6||6||8||
KAGUTSUCHI||Massive New Krew||4||6||7||9||
KUSANAGI||aran||5||6||7||9||
黄泉的伊邪那美||||4||6||7||8||
All In My Heart||Someiyoshino feat. 高木美佑 (Wake Up, Girls!)||5||7||8||9||
Heaven's Rider||Rio Hamamoto(BNSI)||5||6||8||9||
Libra Express runs at night||||5||6||7||8||
KAGAYAKI WO MOTOMETE||Versus||5||6||6||8||
Choco Chiptune.||Ancraft||4||6||7||8||
凛||a_hisa||3||4||6||9||
攀爬！山峰百汇||unatra||3||6||8||9||
TOORIYO||Tezuka feat. 镜音铃・镜音连||3||5||6||8||
mosimosi KAMISAMA||Tezuka feat. 镜音铃・镜音连||3||5||6||8||
超绝技巧系少女||Nekokaburi Cyclone(xi + Nekomirin)||5||6||7||10||
SstTAarR*||M-O-T-U feat. 初音未来||5||7||8||10||
饭团在哪呢♪||Yomii feat. 初音未来||5||7||8||9||
KOKOROBO||Ujico＊||3||4||6||10||
NETEMO NETEMO||☆syoji☆ feat.Honoka♡Erika||3||6||6||8||
再怎么吃再怎么吃||☆syoji☆ feat.Honoka♡Erika||3||6||7||8||
雏鸟幻想曲||TSUYOMY||5||6||7||9||
ASAGAO||BTB||4||5||7||10||
冷冻库CJ ～呜呼面太鼓Brothers～||DJKurara||5||7||8||10||
Gloria||K.key||5||7||7||10||
小狗波奇||||5||7||8||10||
奔驰的查理！||||4||7||8||10||
女帝～Imbiratula～||||4||7||8||9||
魔方阵 - summon delta -||||4||6||7||9||
千鼓千鼓||||4||6||8||9||
EDY -Electrical Dancing Yoga-||feat. 镜音铃・镜音连||4||6||7||9||
Day by Day!||||3||5||7||8||
暗黑魔法少女||Silver Forest feat. Aki||4||6||6||9||
梦幻苍空||Silver Forest feat. SAYA||3||5||6||8||
GASHA DOKURO||||5||6||7||8||
Sacred Ruin||||5||6||7||9||10
Pico Pico Ruin||Sacred Ruin x Professor Sakamoto||5||6||7||9||10
Caramel Time☆||tanqun||4||4||6||8||
DENSHI DRUM NO TATSUJIN||Phenotas||4||6||7||9||
弩蚊怒夏||||5||7||8||10||
PURU PURU Simple||Her Ghost Friend||4||5||7||8||
super star shooter||blue marble||4||6||7||8||
魔法咖啡厅||||3||4||5||8||
Amanda||||3||4||5||8||
凤凰天舞无限崩||||4||5||7||9||
SHOUJO NO KAMI NO RYUUSHI||||4||5||7||9||
亚历山大 主题曲||||4||5||8||8||
合唱庆节！||with Tama☆Tai feat. 团地ノ宫||4||6||6||9||
SHUUGAKU TRAVELERS||Uchiyae Yuka||4||5||5||8||
郢曲／晓暗||东方Project × NAMCO SOUNDS / LindaAI-CUE(BNSI)||3||5||8||10||
深绯之心脏 -SCARLET HEART-||东方Project × NAMCO SOUNDS / kyo(BNSI) feat. asana(IOSYS)||3||5||6||8||
Raiko-Taiko-Disco||东方Project × NAMCO SOUNDS / 渡边量(BNSI)||3||5||5||8||
Ladystar Wandering||东方Project × NAMCO SOUNDS / Junichi Nakatsuru(BNSI)||4||6||7||8||
夏季衣著☆||tanqun democracy||3||4||6||6||
YURERU PLEAT JIKKOUIIN||feat. 团地ノ宫弥子||4||6||7||8||
傍晚时分||||4||5||7||8||
时空厅时空1课||feat. unmo||4||6||8||9||
时空厅搜查2课||feat. SaChi(harineko)||4||6||7||8||
NEE OSHIETE||||4||5||6||7||
Calculator||M-O-T-U||4||7||8||10||
Hurtling Boys||Sadakkey||5||7||8||10||
D's Adventure Note||Dan@Yomii||5||7||8||10||
OOZORA TO TAIKO NO ODORI||paraμ||4||6||8||9||
TSUN-DERE Café E YOKOSO☆||Nekojaga*||4||6||7||9||
DEBSTEP!||Yaju||5||7||8||10||
夜樱 Bladerz||PONKICHI||5||7||8||9||
化物月夜||Kunikichi||5||6||8||8||
Eternal bond||Ryuwitty feat. GUMI||5||6||8||8||
重金属Fugitive||Ryuwitty feat. GUMI||4||6||7||10||
心跳不已的恋爱预感！？||Noriyuki feat. GUMI||3||4||5||7||
NINJIN NIN||丰永GONTA P feat. GUMI||3||4||5||8||
ORESAMA Pirate||||3||5||6||8||
特雷门狂想曲||第42乐章「悲怆」||4||6||6||7||
MIINA NO OYASHIKI||||4||5||7||9||
OBAKE NO OSHIGOTO||||4||5||4||6||
Dream Tide||~Yumeno Chouryu~||3||5||7||8||
丰穰弥生||||4||6||7||8||
KURU KURU KUROKKURU||||3||4||5||8||
日全食2035||～SHOUJO NO JIKUU KAIKI NISSHOKU～||4||5||6||8||
Nightmare Survivor||||4||6||7||8||10
Phoenix||||4||5||6||7||
3piece-JazzParty!||||4||5||7||9||
KAZE NO KUNI NO RYUU TO KISHI||||4||5||7||8||
DIMENSIONS||||4||6||8||9||
和兰抚子||||4||5||6||8||
KOI NO SHOHOUSEN||||3||5||5||7||
我是合成器||||3||3||4||8||
junction||||4||5||6||9||
迈向希望的旋律||"太鼓之达人 V version"主题曲||3||3||6||7||
与你奏响的和弦||"Taiko no Tatsujin: Chibi Dragon to Fushigina Orb"主题曲||3||4||5||6||8
超时空Adventure||"太鼓之达人 咚与咔的时空大冒险"主题曲||4||5||5||6||
世界总是个谜团||"太鼓之达人 咚咔！神秘冒险记"主题曲||4||4||5||7||
FAMIRES WARS||||2||4||5||8||
Phantom Rider||Rio Hamamoto(BNSI)||4||6||7||8||9
Fly away||||4||5||5||7||
NINJA WA SAIKOU||||3||4||5||7||
初音未来的消失-剧场版-||cosMo＠暴走P feat. 初音未来||5||7||8||9||10
隼||||5||7||8||9||
KANADEA||||5||7||8||8||
MATSURI D/A||||5||7||8||8||
My Mine||||4||5||4||6||
Growing Up||||3||5||5||6||
Reviver||||3||4||5||8||
All Night de INDENAI||||3||4||6||7||
拉面 德 呦-面!!||||4||4||5||7||
Audio DE KA!||出自音响悬疑戏剧"AUDIO刑警"||4||4||6||9||
OMOI WO TENI NEGAI WO KOMETE||||4||5||5||7||
Hey, Mr. Professor||||3||4||6||7||
INU HOERU||||4||5||5||6||
KUON NO YORU||||4||5||6||8||
地平线上的疾风||||4||6||7||7||
The Magician's Dream||||4||6||7||8||
Marble Heart||||3||5||5||6||
ZERO NO NOCTURNE||||4||6||6||8||9
ZERO NO RHAPSODY||||4||6||7||9||
Cross Blue||||4||6||7||9||
Break Line||||3||5||7||8||
汪喵世界||feat. 镜音铃・镜音连 starring 下田麻美||4||5||6||9||
悼念公主的帕凡舞曲||～Kimi no Kodou～||3||5||5||6||8
苍之旋律||||4||6||7||9||10
朱之旋律||||4||7||8||10||
虹色·梦色·太鼓色||||3||5||4||6||
咚子的第一次约会||||4||4||3||4||8
Off ♨ Rock||||4||6||6||7||
Go Go - Kitchen||||5||5||7||7||10
Sports DigesDON||～Fill in The Sky～||4||5||6||7||9
Saturday Taiko Fever||||4||6||8||7||8
MIRAI ENO KAGI||||4||6||5||7||
Shining 65||||4||5||6||7||
风云！鼓棒老师||||3||5||6||7||
迅风丸||||3||4||6||8||9
DENSETSU NO MATSURI||||3||4||6||7||
Surfside Satie||||5||7||8||8||
小步舞曲||||4||7||8||9||
夜曲Op.9 No.2||||4||6||7||8||
幻想即兴曲||||5||7||8||9||
亲亲卡农||||3||4||5||8||
自私大小姐||||4||7||7||8||
DON'T CUT||||4||7||8||8||9
如夕颜般的你||||3||5||6||7||
CHIRIYUKU RAN NO TSUZURU UTA||||4||6||6||9||
Future Labo||||3||4||7||8||
友情POP||||4||4||7||6||
Many wow bang!||||4||4||7||7||9
NEGAIGOTO ☆ PUZZLE||||3||3||6||8||
Hello! Halloween||||3||2||6||8||
练习曲Op.10-4||||3||4||8||9||10
Metal Police||||4||6||7||9||9
库普兰之墓||||4||7||8||8||
NECOLOGY||||3||5||7||8||
Taiko Time||||5||6||7||9||10
丑角的晨歌||||5||7||7||8||
Mulberry||||4||6||6||7||
LOVE战!!||||3||5||7||8||
SHIRONEKO CARAMEL MUGEN NO WATAAME||||3||5||6||7||
DADAKKO MONSTER||||4||5||5||7||
梦色Coaster||||4||4||7||8||
你的光芒||||4||4||5||5||8
你的行星||||3||5||6||8||
触技与赋格与ROCK||||5||7||8||9||
天鹅湖||～still a duckling～||4||6||7||9||10
画龙点睛||||5||6||7||8||
真・画龙点睛||||4||5||6||9||9
月下美人||||4||6||7||8||
黑船来航||||4||5||6||8||
战国三弦||||4||4||6||9||
风云志士||||4||5||7||8||
樱花烂漫||||4||6||7||8||
太鼓乱舞 皆传||||4||5||7||8||
夜樱谢肉祭||||4||6||8||9||10
The Carnivorous Carnival||||4||6||7||9||
Evidence of evil||AJURIKA||5||7||8||10||
Turquoise Tachometer||AJURIKA||4||6||8||9||
伊卡洛斯不要走||AJURIKA||3||5||7||9||
KAZE NO FANTASY||||4||6||6||8||
Pastel Dream||||4||6||7||8||
Dun Aonghasa的吹笛手||||4||6||7||8||
Xastur之魔导书||||3||5||6||8||
利敦瓦纳的黄昏||||3||5||6||8||
被遗忘的提尔纳诺||||4||5||7||9||
宇宙SAMURAI||||3||6||7||8||
月影SASURAI||||5||6||7||8||9
NUMUSIKA ac.10||||3||4||8||9||
STAGE 0.ac11||||5||7||8||9||
亚空间游泳ac12.5||||5||7||8||9||
ARUMUSIKA ac14.0V||||4||7||7||9||
3Q-4U-AC00||||3||6||4||7||
SORA-I Earth Rise||||3||5||7||8||
SORA-II 格利泽581||||3||3||7||7||
SORA-VI 火ノ鸟||||5||5||7||9||
SORA-VII Cygnus Wall||||4||6||7||10||
季曲||～Seasons of Asia～||3||5||5||7||8
蓄势||～GEAR UP～||3||5||6||7||8
蜕变||～transformation～||3||5||6||7||8
春游||～happy excursion～||4||5||6||7||8
绽放||～Blooming～||3||5||6||7||8
花漾||～Flourishing Blossoms～||3||4||5||7||9
曙光||～Dawn～||4||5||7||7||8
蝶恋||～Obsession～||3||4||4||7||8
Rotter Tarmination||||4||6||7||8||10
dance storm||||4||6||6||7||9
咚咚咔咚～||||4||5||7||8||10
RUMBLE乱舞||||4||7||8||8||8
Lightning Passion||||4||5||6||7||9
Samba Alegria||||4||6||6||7||9
燎原ノ舞||||4||6||7||10||
旋风ノ舞【天】||||4||5||8||10||10
旋风ノ舞【地】||||4||6||7||9||
天妖ノ舞||||3||6||8||9||
Black Rose Apostle||||5||6||8||10||10
White Rose Insanity||||5||5||6||7||8
Red Rose Evangel||||5||7||7||9||
Blue Rose Ruin||||5||7||8||8||
Purple Rose Fusion||||5||7||8||10||
幽玄之乱||世阿弥||5||7||8||10||
双龙之乱||世阿弥||5||7||8||10||
紫煌之乱||世阿弥||5||6||8||10||
Xa||Tatsh||5||6||7||9||10
天照||Tatsh a.k.a 世阿弥||4||7||8||10||
月读命||Tatsh a.k.a 世阿弥||5||7||8||10||
须佐之男||Tatsh a.k.a 世阿弥||5||7||8||10||
Clotho||Tatsh feat. YuOda||5||7||7||10||
冬龙 ～Toryu～||Azu♪||4||5||7||8||9
春龙 ～Haryu～||Azu♪||4||5||7||8||9
夏龙 ～Karyu～||Azu♪||4||6||7||8||9
秋龙 ～Shiuryu～||Azu♪||4||6||7||9||10
冰龙 ～Kooryu～||Azu♪||5||7||8||9||10
花音反拍子||Harunaba feat.初音未来||3||5||6||9||
咖啡的味道||Harunaba feat. GUMI||4||5||6||9||
KARA鞠之花||Harunaba feat. Yuzuki Yukari||4||7||7||10||
Ghost Mask||Harunaba feat. Yuzuki Yukari & Ishiguro Chihiro||4||6||7||10||
TABANEITO||Harunaba feat. 石黑千寻||5||7||8||10||
Foo Foo Cassette||Harunaba feat. SaChi(harineko)||4||6||6||9||
拥有手中庭园的少女||Harunaba feat. 石黑千寻||5||7||8||10||
Goldfish City||Harunaba||4||7||8||10||
东京特许Kyo许可局局长!!||||3||4||6||8||
Princess of Donder||MOES feat. Kaiho Erika||4||5||5||9||
AISO WARAI||Chiharu Kaneko||5||6||7||8||
Ｇ意识过剩||||5||6||7||9||
承认欲Q||Chiharu Kaneko feat. haxchi||4||6||7||10||
χ谈||Chiharu Kaneko||5||7||8||10||
哀 want U||Chiharu Kaneko||5||6||8||10||
Amphit◇rite||Kaneko Chiharu||5||7||8||10||
poxei◆DOON||Chiharu Kaneko||5||7||8||10||
Shiny Kung-fu Revival||t+pazolite||4||6||7||9||
!!!Chaos Time!!!||t+pazolite||5||7||8||10||
毒LOＣＡＮdy♡||t+pazolite||3||4||6||9||
KAHATAREDOKI NO YUUWAKU||t+pazolite||2||3||6||9||10
IOSYS Autumn Carnivorous Festival 2014||D.watt(IOSYS) feat. Np Inutahiko & Hakase||3||6||7||9||
私立高天原学园高中・校歌||D.watt(IOSYS) feat. Np Inutahiko & Yamamoto Momiji||4||6||7||9||
YAMATAI ★ Night Party||Yuya Kobayashi (IOSYS) feat. Chiyoko||3||5||7||9||
圣德太鼓的「日出为止飞鸟」||Yuya Kobayashi (IOSYS) feat. miko||4||6||7||9||
My Muscle Heart||||3||4||5||9||
超幸运！七福快乐团组员||Yuya Kobayashi (IOSYS) feat. Yamamoto Momiji (monotone)||4||5||7||9||
神秘梅杰德的哀傷憂鬱||Yuya Kobayashi (IOSYS) feat. Yamamoto Momiji (monotone)||4||5||7||10||
PAN vs GOHAN! DAIKESSEN!||Yuya Kobayashi(IOSYS) feat. miko & Momiji Yamamoto||5||7||7||10||10
Infinite Rebellion||Daisuke Kurosawa 原曲 "幽玄之乱 / 世阿弥(Tatsh)"||5||7||8||10||
浓红||Daisuke Kurosawa x Kanako Kotera||4||6||7||10||
R.I.||Yamato x Daisuke Kurosawa||5||7||8||10||
Demon King of the Sixth Heaven||Daisuke Kurosawa x Masahiro "Godspeed" Aoki||5||7||8||10||
天下统一录||Daisuke Kurosawa x Masahiro "Godspeed" Aoki||5||7||8||10||
HARDCOREノ心得||DJ Myosuke||5||7||8||10||
Behemoth||DJ Myosuke||5||7||8||10||
Don't Stop the Game||DJ Myosuke||5||7||8||10||
mint tears||||4||6||7||10||
人のお金で焼肉を食したい！||INSPIONスペシャルコラボ||3||5||6||7||10
Ignis Danse||Yuji Masubuchi||4||7||8||10||
SAKURA EXHAUST||||3||6||7||9||
Taiko Drum Monster||steμ feat.siroa||3||5||7||10||
青天之黎明||steμ(BNSI) feat. siroa||3||6||7||10||
Taiko Roll||steμ(BNSI) feat. siroa||5||6||7||10||
快埼玉2000||||5||7||8||9||
Kecha-Don 2000||||5||6||8||9||
恋文2000||||5||7||8||9||
YOKUDERU 2000||||5||6||7||9||
TABERUNA 2000||||5||7||8||10||
北埼玉200||||5||7||8||9||
北埼玉2000||||5||7||8||10||
十露盘2000||||4||6||8||10||
Tenjiku2000||||4||7||8||10||
EkiBEN2000||||5||7||8||10||
X-DAY2000||||5||7||8||10||
〆dley 2000||||5||7||8||10||
万戈イム－一ノ十||||5||7||8||10||
又埼玉2000||||5||7||8||10||
SUUHAA 2000||||5||7||8||10||
DONCAMA 2000||||5||7||8||10||
NORUDON 2000||||4||6||7||10||
還是埼玉2000||||5||7||8||10||
≠MM||||5||7||8||10||
""";
  final release =
      await data.getReleaseList().firstWhere((element) => element.url == jpUrl);
  final songList = data.getSongList(release);
  final jpSongListGroup = await splitSongJP(songList);
  final cnSongListGroup = await splitSongCN(cnItemListString);
  final categoryCount = cnSongListGroup.length; // 8,
  for (int i = 0; i < categoryCount; i++) {
    final jpSongList = jpSongListGroup[i];
    final cnSongList = cnSongListGroup[i];
    for (int i1 = 0; i1 < cnSongList.length; i1++) {
      final cnSong = cnSongList[i1];
      final jpMaybeList =
          jpSongList.where((element) => element.maybe(cnSong)).toList();
      if (jpMaybeList.isEmpty) {
        continue;
      }
      print("${cnSong.name} ==> ");
      for (var jpSong in jpMaybeList) {
        print(jpSong.name);
/*
        if (jpSong.subtitle.isNotEmpty && cnSong.subtitle.isNotEmpty) {
          print("${jpSong.subtitle} ==> ${cnSong.subtitle}");
        }
*/
      }
    }
  }
}

Future<List<List<SongHuali>>> splitSongJP(Stream<SongItem> songList) async {
  List<List<SongHuali>> result = [];
  var groupIndex = -1;
  String? category;
  await for (final song in songList) {
    if (song.category != category) {
      groupIndex++;
      result.add([]);
    }
    category = song.category;
    final group = result[groupIndex];
    final difficultyList = DifficultyType.values
        .map((e) => song.getLevelTypeDifficulty(e))
        .toList();
    group.add(SongHuali(song.name, song.subtitle, difficultyList));
  }
  return result;
}

Future<List<List<SongHuali>>> splitSongCN(String str) async {
  List<List<SongHuali>> result = [];
  var groupIndex = -1;
  str.split('\n').where((element) => element.isNotEmpty).forEach((line) {
    if (line.startsWith('#')) {
      groupIndex++;
      result.add([]);
      return;
    }
    final group = result[groupIndex];
    final stringList = line.split('||');
    final name = stringList[0];
    final subtitle = stringList[1];
    final difficultyList =
        stringList.sublist(2).map((e) => e.isEmpty ? 0 : int.parse(e)).toList();
    group.add(SongHuali(name, subtitle, difficultyList));
  });
  return result;
}

class SongHuali {
  final String name;
  final String subtitle;
  final List<int> difficultyList;

  SongHuali(this.name, this.subtitle, this.difficultyList);

  bool maybe(SongHuali other) {
    return difficultyList.equals(other.difficultyList);
  }
}
