package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import openfl.Lib;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import options.OptionsMenu;
#if mobileC
import ui.Mobilecontrols;
#end
import Rank;
import hscript.*;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState;
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	var difficStr:String = "Easy";
	public static var deathCount:Int = 0;
	public static var isChangeDiffic:Bool = false;

	var halloweenLevel:Bool = false;

	var isThereAFuckingModchart:Bool = false;
	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;

	var isDownScroll:Bool = new Config().getdownscroll();
	var isDownscroll:Bool = new Config().getdownscroll();
	//splash
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	var noteSplashOp:Bool = FlxG.save.data.noteSplash;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	public var misses:Int = 0;
	public var accuracy:Float = 100;
	public var rating:String = "S";
	public var ratingplus:String = "(MFC)";
	public var goods:Int = 0;
	public var sicks:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;
	public var notehit:Int = 0;
	var mashingViolation:Int = 0;
	var disabledKeys:Bool = false;

	var isNoBg:Bool = new Config().getnobg();
	var isNoGf:Bool = new Config().getnogf();
	var isNoSwitch:Bool = new Config().getnoswitch();
	var isPerWeek:Bool = new Config().getperweek();
	var isNeo:Bool = new Config().getneo();

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var songTxt:FlxText;
	var rank:Rank;


    // me when funi
	var phillyBgNeo:FlxSprite;
	var phillyBg:FlxSprite;
    var watchtower:FlxSprite;
	var picoSpeaker:FlxSprite;
	var bgGlitcher:FlxSprite;
	var stageFrontGlitcher:FlxSprite;
	var stageBackWIRE:FlxSprite;
	// end of the funi :pensive:

	// more funi but this time it's camHUD shit lol!
	var funiRating:FlxSprite;
	var songPosBar:FlxBar;
    var songPosBG:FlxSprite;
	var songName:FlxText;
	// end of the funi 2 :pensive:

	//tankbop shit
	var tankBop1:FlxSprite;
	var tankBop2:FlxSprite;
	var tankBop3:FlxSprite;
	var tankBop4:FlxSprite;
	var tankBop5:FlxSprite;
	var tankBop6:FlxSprite;
	//end of tankbop

	var poison:Bool = false;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end
	var songLength:Float = 0; // this gets moved out of there cuz of shit

	#if mobileC
	var mcontrols:Mobilecontrols; 
	#end
	var cpuStrums:FlxTypedGroup<FlxSprite>;

	var oldDadCol:FlxColor;

	var modchart:String = '';
	var modcharting:Bool = false;

	override public function create()
	{
		var mc:String = Paths.modChart('modchart', SONG.song);
		instance = this;
		try{
			modchart = sys.io.File.getContent(Asset2File.getPath(mc, '.txt'));
			modcharting = true;
			trace('modchart found fart poopoo (at ' + Asset2File.getPath(mc, '.txt') + ')');
		}
		catch(e)
		{
			modcharting = false;
			trace('no modchart cuz ' + e.message);
		}

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		var sploosh = new NoteSplash();
		sploosh.setupNoteSplash(100, 100, 0);
		sploosh.alpha = 0.6;
		grpNoteSplashes.add(sploosh);

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'dunk':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dunk/hexIsGaming'));	
			case 'ram':
				dialogue = CoolUtil.coolTextFile(Paths.txt('ram/hexIsGaming'));
			case 'hello-world':
				dialogue = CoolUtil.coolTextFile(Paths.txt('hello-world/hexIsGaming'));
			case 'glitcher':
				dialogue = CoolUtil.coolTextFile(Paths.txt('glitcher/hexIsGaming'));
		}

		switch (storyDifficulty)
	    {
			case 0:
				difficStr = "Easy";
			case 1:
				difficStr = "Normal";
			case 2:
			    difficStr = "hard";
		}

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end

		if (!FlxG.save.data.emptyness)
		{
		switch (SONG.song.toLowerCase())
		{
                        case 'spookeez' | 'monster' | 'south': 
                        {
                                curStage = 'spooky';
	                          halloweenLevel = true;
						
		                  var hallowTex = Paths.getSparrowAtlas('halloween_bg');

	                          halloweenBG = new FlxSprite(-200, -100);
		                      halloweenBG.frames = if (isNeo){ Paths.getSparrowAtlas('neo/stages/halloween_bg', 'shared'); } else { hallowTex; }
	                          halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	                          halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	                          halloweenBG.animation.play('idle');
	                          halloweenBG.antialiasing = true;
							  if (!isNoBg)
	                          add(halloweenBG);

						  if (!isNoBg)
		                  isHalloween = true;
		          }
		          case 'pico' | 'blammed' | 'philly': 
                        {
		                  curStage = 'philly';

						  if (!isNeo)
		                  phillyBg = new FlxSprite(0, 0).loadGraphic(Paths.image('phillyBg','shared'));
						  else
						  phillyBg = new FlxSprite(0, 0).loadGraphic(Paths.image('neo/stages/phillyBg','shared'));
		                  phillyBg.antialiasing = true;
		                  phillyBg.scrollFactor.set(0.9, 0.9);
		                  phillyBg.active = false;
						  if (!isNoBg)
		                  add(phillyBg);



						  phillyBgNeo = new FlxSprite(0, 0).loadGraphic(Paths.image('phillyBgNeo','shared'));
		                  phillyBgNeo.antialiasing = true;
		                  phillyBgNeo.scrollFactor.set(0.9, 0.9);
		                  phillyBgNeo.active = false;

		          }
		          case 'milf' | 'satin-panties' | 'high':
		          {
		                  curStage = 'limo';
		                  defaultCamZoom = 0.90;


		                  var skyBG:FlxSprite;
						  if (!isNeo)
						  skyBG = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
						  else
						  skyBG = new FlxSprite(-120, -50).loadGraphic(Paths.image('neo/stages/limoSunset','shared'));
		                  skyBG.scrollFactor.set(0.1, 0.1);
						  if (!isNoBg)
		                  add(skyBG);


						  
		                  var bgLimo:FlxSprite = new FlxSprite(-200, 480);
		                  bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
						  if (!isNoBg)
		                  add(bgLimo);
						  else if (isNeo) {}

						if (!isNeo)
						{
		                  grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						  if (!isNoBg)
		                  add(grpLimoDancers);

		                  for (i in 0...5)
		                  {
		                          var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
		                          dancer.scrollFactor.set(0.4, 0.4);
		                          grpLimoDancers.add(dancer);
		                  }
						}
						


		                  var overlayShit:FlxSprite;
						  if (!isNeo)
						  overlayShit = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
						  else
						  overlayShit = new FlxSprite(-500, -600).loadGraphic(Paths.image('neo/stages/limoOverlay', 'shared'));
		                  overlayShit.alpha = 0.5;
		                  // add(overlayShit);

		                  // var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

		                  // FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

		                  // overlayShit.shader = shaderBullshit;

		                  var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

		                  limo = new FlxSprite(-120, 550);
		                  limo.frames = if (!isNeo) {limoTex;} else {Paths.getSparrowAtlas('neo/stages/limoDrive', 'shared');}
		                  limo.animation.addByPrefix('drive', "Limo stage", 24);
		                  limo.animation.play('drive');
		                  limo.antialiasing = true;

		                  fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
		                  // add(limo);
		          }
		          case 'cocoa' | 'eggnog':
		          {
	                          curStage = 'mall';

		                  defaultCamZoom = 0.80;

		                  var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
		                  bg.antialiasing = true;
		                  bg.scrollFactor.set(0.2, 0.2);
		                  bg.active = false;
		                  bg.setGraphicSize(Std.int(bg.width * 0.8));
		                  bg.updateHitbox();
						  if (!isNoBg)
		                  add(bg);

		                  upperBoppers = new FlxSprite(-240, -90);
		                  upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
		                  upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
		                  upperBoppers.antialiasing = true;
		                  upperBoppers.scrollFactor.set(0.33, 0.33);
		                  upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
		                  upperBoppers.updateHitbox();
						  if (!isNoBg)
		                  add(upperBoppers);

		                  var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
		                  bgEscalator.antialiasing = true;
		                  bgEscalator.scrollFactor.set(0.3, 0.3);
		                  bgEscalator.active = false;
		                  bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
		                  bgEscalator.updateHitbox();
						  if (!isNoBg)
		                  add(bgEscalator);

		                  var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
		                  tree.antialiasing = true;
		                  tree.scrollFactor.set(0.40, 0.40);
						  if (!isNoBg)
		                  add(tree);

		                  bottomBoppers = new FlxSprite(-300, 140);
		                  bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
		                  bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
		                  bottomBoppers.antialiasing = true;
	                          bottomBoppers.scrollFactor.set(0.9, 0.9);
	                          bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
		                  bottomBoppers.updateHitbox();
						  if (!isNoBg)
		                  add(bottomBoppers);

		                  var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
		                  fgSnow.active = false;
		                  fgSnow.antialiasing = true;
						  if (!isNoBg)
		                  add(fgSnow);

		                  santa = new FlxSprite(-840, 150);
		                  santa.frames = Paths.getSparrowAtlas('christmas/santa');
		                  santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
		                  santa.antialiasing = true;
						  if (!isNoBg)
		                  add(santa);
		          }
		          case 'winter-horrorland':
		          {
		                  curStage = 'mallEvil';
		                  var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
		                  bg.antialiasing = true;
		                  bg.scrollFactor.set(0.2, 0.2);
		                  bg.active = false;
		                  bg.setGraphicSize(Std.int(bg.width * 0.8));
		                  bg.updateHitbox();
						  if (!isNoBg)
		                  add(bg);

		                  var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
		                  evilTree.antialiasing = true;
		                  evilTree.scrollFactor.set(0.2, 0.2);
						  if (!isNoBg)
		                  add(evilTree);

		                  var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
	                          evilSnow.antialiasing = true;
						  if (!isNoBg)
		                  add(evilSnow);
                        }
		          case 'senpai' | 'roses':
		          {
		                  curStage = 'school';

		                  // defaultCamZoom = 0.9;

		                  var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
		                  bgSky.scrollFactor.set(0.1, 0.1);
						  if (!isNoBg)
		                  add(bgSky);

		                  var repositionShit = -200;

		                  var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
		                  bgSchool.scrollFactor.set(0.6, 0.90);
						  if (!isNoBg)
		                  add(bgSchool);

		                  var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
		                  bgStreet.scrollFactor.set(0.95, 0.95);
						  if (!isNoBg)
		                  add(bgStreet);

		                  var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
		                  fgTrees.scrollFactor.set(0.9, 0.9);
						  if (!isNoBg)
		                  add(fgTrees);

		                  var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
		                  var treetex = Paths.getPackerAtlas('weeb/weebTrees');
		                  bgTrees.frames = treetex;
		                  bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
		                  bgTrees.animation.play('treeLoop');
		                  bgTrees.scrollFactor.set(0.85, 0.85);
						  if (!isNoBg)
		                  add(bgTrees);

		                  var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
		                  treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
		                  treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
		                  treeLeaves.animation.play('leaves');
		                  treeLeaves.scrollFactor.set(0.85, 0.85);
						  if (!isNoBg)
		                  add(treeLeaves);

		                  var widShit = Std.int(bgSky.width * 6);

		                  bgSky.setGraphicSize(widShit);
		                  bgSchool.setGraphicSize(widShit);
		                  bgStreet.setGraphicSize(widShit);
		                  bgTrees.setGraphicSize(Std.int(widShit * 1.4));
		                  fgTrees.setGraphicSize(Std.int(widShit * 0.8));
		                  treeLeaves.setGraphicSize(widShit);

		                  fgTrees.updateHitbox();
		                  bgSky.updateHitbox();
		                  bgSchool.updateHitbox();
		                  bgStreet.updateHitbox();
		                  bgTrees.updateHitbox();
		                  treeLeaves.updateHitbox();

		                  bgGirls = new BackgroundGirls(-100, 190);
		                  bgGirls.scrollFactor.set(0.9, 0.9);

		                  if (SONG.song.toLowerCase() == 'roses')
	                          {
		                          bgGirls.getScared();
		                  }

		                  bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
		                  bgGirls.updateHitbox();
						  if (!isNoBg)
		                  add(bgGirls);
		          }
		          case 'thorns':
		          {
		                  curStage = 'schoolEvil';

		                  var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
		                  var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

		                  var posX = 400;
	                          var posY = 200;

		                  var bg:FlxSprite = new FlxSprite(posX, posY);
		                  bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
		                  bg.animation.addByPrefix('idle', 'background 2', 24);
		                  bg.animation.play('idle');
		                  bg.scrollFactor.set(0.8, 0.9);
		                  bg.scale.set(6, 6);
						  if (!isNoBg)
		                  add(bg);

		                  /* 
		                           var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
		                           bg.scale.set(6, 6);
		                           // bg.setGraphicSize(Std.int(bg.width * 6));
		                           // bg.updateHitbox();
		                           add(bg);

		                           var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
		                           fg.scale.set(6, 6);
		                           // fg.setGraphicSize(Std.int(fg.width * 6));
		                           // fg.updateHitbox();
		                           add(fg);

		                           wiggleShit.effectType = WiggleEffectType.DREAMY;
		                           wiggleShit.waveAmplitude = 0.01;
		                           wiggleShit.waveFrequency = 60;
		                           wiggleShit.waveSpeed = 0.8;
		                    */

		                  // bg.shader = wiggleShit.shader;
		                  // fg.shader = wiggleShit.shader;

		                  /* 
		                            var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
		                            var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

		                            // Using scale since setGraphicSize() doesnt work???
		                            waveSprite.scale.set(6, 6);
		                            waveSpriteFG.scale.set(6, 6);
		                            waveSprite.setPosition(posX, posY);
		                            waveSpriteFG.setPosition(posX, posY);

		                            waveSprite.scrollFactor.set(0.7, 0.8);
		                            waveSpriteFG.scrollFactor.set(0.9, 0.8);

		                            // waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
		                            // waveSprite.updateHitbox();
		                            // waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
		                            // waveSpriteFG.updateHitbox();

		                            add(waveSprite);
		                            add(waveSpriteFG);
		                    */
		          }
				  case 'ugh' | 'guns':
				  {
					defaultCamZoom = 0.8;
					curStage = 'tank';
					var sky:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankSky','week7'));
					sky.scrollFactor.set(0.9, 0.9);
					if (!isNoBg)
					add(sky);

					var clouds:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankClouds','week7'));
					if (!isNoBg)
					add(clouds);

					var mountains:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankMountains','week7'));
					if (!isNoBg)
					add(mountains);

					var ruins:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankRuins','week7'));
					if (!isNoBg)
					add(ruins);

					var buildings:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankBuildings','week7'));
					if (!isNoBg)
					add(buildings);

					var watchtower:FlxSprite = new FlxSprite(100, 120);
					watchtower.frames = Paths.getSparrowAtlas('tankWatchtower','week7');
					watchtower.animation.addByPrefix('bop', 'watchtower gradient color instance 1', 24);
					watchtower.animation.play('bop');
					if (!isNoBg)
					add(watchtower);
					

					var ground:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankGround','week7'));
					if (!isNoBg)
					add(ground);


					tankBop1 = new FlxSprite(-500,650);
					tankBop1.frames = Paths.getSparrowAtlas('tank0','week7');
					tankBop1.animation.addByPrefix('bop', 'fg tankhead far right instance 1', 24);
					tankBop1.scrollFactor.set(1.7, 1.5);
					tankBop1.antialiasing = true;
	
					tankBop2 = new FlxSprite(-300,750);
					tankBop2.frames = Paths.getSparrowAtlas('tank1','week7');
					tankBop2.animation.addByPrefix('bop','fg tankhead 5 instance 1', 24);
					tankBop2.scrollFactor.set(2.0, 0.2);
					tankBop2.antialiasing = true;
	
					tankBop3 = new FlxSprite(450,940);
					tankBop3.frames = Paths.getSparrowAtlas('tank2','week7');
					tankBop3.animation.addByPrefix('bop','foreground man 3 instance 1', 24);
					tankBop3.scrollFactor.set(1.5, 1.5);
					tankBop3.antialiasing = true;
	
					tankBop4 = new FlxSprite(1300,1200);
					tankBop4.frames = Paths.getSparrowAtlas('tank3','week7');
					tankBop4.animation.addByPrefix('bop','fg tankhead 4 instance 1', 24);
					tankBop4.scrollFactor.set(3.5, 2.5);
					tankBop4.antialiasing = true;
	
					tankBop5 = new FlxSprite(1300,900);
					tankBop5.frames = Paths.getSparrowAtlas('tank4','week7');
					tankBop5.animation.addByPrefix('bop','fg tankman bobbin 3 instance 1', 24);
					tankBop5.scrollFactor.set(1.5, 1.5);
					tankBop5.antialiasing = true;
	
					tankBop6 = new FlxSprite(1620,700);
					tankBop6.frames = Paths.getSparrowAtlas('tank5', 'week7');
					tankBop6.animation.addByPrefix('bop','fg tankhead far right instance 1', 24);
					tankBop6.scrollFactor.set(1.5, 1.5);
					tankBop6.antialiasing = true;
				  }
				  case 'stress' | 'foolhardy':
				  {
					  curStage = 'tank2';
                      defaultCamZoom = 0.9;

					  var sky:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankSky','week7'));
					  sky.scrollFactor.set(0.9, 0.9);
					  if (!isNoBg)
					  add(sky);
  
					  var clouds:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankClouds','week7'));
					  if (!isNoBg)
					  add(clouds);
  
					  var mountains:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankMountains','week7'));
					  if (!isNoBg)
					  add(mountains);
  
					  var ruins:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankRuins','week7'));
					  if (!isNoBg)
					  add(ruins);
  
					  var buildings:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankBuildings','week7'));
					  if (!isNoBg)
					  add(buildings);
  
					  var watchtower:FlxSprite = new FlxSprite(100, 120);
					  watchtower.frames = Paths.getSparrowAtlas('tankWatchtower','week7');
					  watchtower.animation.addByPrefix('bop', 'watchtower gradient color instance 1', 24);
					  watchtower.animation.play('bop');
					  if (!isNoBg)
					  add(watchtower);
  
					  var ground:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('tankGround','week7'));
					  if (!isNoBg)
					  add(ground);
					  
					  tankBop1 = new FlxSprite(-500,650);
					  tankBop1.frames = Paths.getSparrowAtlas('tank0','week7');
					  tankBop1.animation.addByPrefix('bop', 'fg tankhead far right instance 1', 24);
					  tankBop1.scrollFactor.set(1.7, 1.5);
					  tankBop1.antialiasing = true;
	  
					  tankBop2 = new FlxSprite(-300,750);
					  tankBop2.frames = Paths.getSparrowAtlas('tank1','week7');
					  tankBop2.animation.addByPrefix('bop','fg tankhead 5 instance 1', 24);
					  tankBop2.scrollFactor.set(2.0, 0.2);
					  tankBop2.antialiasing = true;
	  
					  tankBop3 = new FlxSprite(450,940);
					  tankBop3.frames = Paths.getSparrowAtlas('tank2','week7');
					  tankBop3.animation.addByPrefix('bop','foreground man 3 instance 1', 24);
					  tankBop3.scrollFactor.set(1.5, 1.5);
					  tankBop3.antialiasing = true;
	  
					  tankBop4 = new FlxSprite(1300,1200);
					  tankBop4.frames = Paths.getSparrowAtlas('tank3','week7');
					  tankBop4.animation.addByPrefix('bop','fg tankhead 4 instance 1', 24);
					  tankBop4.scrollFactor.set(3.5, 2.5);
					  tankBop4.antialiasing = true;
	  
					  tankBop5 = new FlxSprite(1300,900);
					  tankBop5.frames = Paths.getSparrowAtlas('tank4','week7');
					  tankBop5.animation.addByPrefix('bop','fg tankman bobbin 3 instance 1', 24);
					  tankBop5.scrollFactor.set(1.5, 1.5);
					  tankBop5.antialiasing = true;
	  
					  tankBop6 = new FlxSprite(1620,700);
					  tankBop6.frames = Paths.getSparrowAtlas('tank5', 'week7');
					  tankBop6.animation.addByPrefix('bop','fg tankhead far right instance 1', 24);
					  tankBop6.scrollFactor.set(1.5, 1.5);
					  tankBop6.antialiasing = true;
				  }
				  case 'dunk' | 'encore':
				  {
					defaultCamZoom = 0.9;
					curStage = 'hexz';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback-day','hex'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					if (!isNoBg)
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront-day','hex'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					if (!isNoBg)
					add(stageFront);
				  }
				  case 'ram':
				  {
				    defaultCamZoom = 0.9;
				    curStage = 'hexss';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('sunset/stageback','hex'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					if (!isNoBg)
					add(bg);
  
					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('sunset/stagefront-day','hex'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
				    stageFront.active = false;
					if (!isNoBg)
				    add(stageFront);
				  }
				  case 'hello-world':
				  {
				  defaultCamZoom = 0.9;
				  curStage = 'hexr';
				  var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('night/field-night-back','hex'));
				  bg.antialiasing = true;
				  bg.scrollFactor.set(0.9, 0.9);
				  bg.active = false;
				  if (!isNoBg)
				  add(bg);
	
				  var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('night/field-night-front','hex'));
				  stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				  stageFront.updateHitbox();
				  stageFront.antialiasing = true;
				  stageFront.scrollFactor.set(0.9, 0.9);
				  stageFront.active = false;
				  if (!isNoBg)
				  add(stageFront);
				  }
				  case 'glitcher':
				  {
					defaultCamZoom = 0.9;
					curStage = 'hexng';
					bgGlitcher = new FlxSprite(-600, -200).loadGraphic(Paths.image('glitcher/glitcherstageback','hex'));
					bgGlitcher.antialiasing = true;
					bgGlitcher.scrollFactor.set(0.9, 0.9);
					bgGlitcher.active = false;
					add(bgGlitcher);
	  
					stageFrontGlitcher = new FlxSprite(-650, 600).loadGraphic(Paths.image('glitcher/glitcherstagefront','hex'));
					stageFrontGlitcher.setGraphicSize(Std.int(stageFrontGlitcher.width * 1.1));
					stageFrontGlitcher.updateHitbox();
					stageFrontGlitcher.antialiasing = true;
					stageFrontGlitcher.scrollFactor.set(0.9, 0.9);
					stageFrontGlitcher.active = false;
					if (!isNoBg)
				    add(stageFrontGlitcher);

					stageBackWIRE = new FlxSprite(-600, -200).loadGraphic(Paths.image('WIRE/WIREStageBack','hex'));
					stageBackWIRE.antialiasing = true;
					stageBackWIRE.scrollFactor.set(0.9, 0.9);
					stageBackWIRE.active = false;

				  }
		          default:
		          {
		                  defaultCamZoom = 0.9;
		                  curStage = 'stage';
		                  var bg:FlxSprite;
						  if (!isNeo)
						  bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						  else
				          bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('neo/stages/stageback'));
		                  bg.antialiasing = true;
		                  bg.scrollFactor.set(0.9, 0.9);
		                  bg.active = false;
						  if (!isNoBg)
		                  add(bg);

		                  var stageFront:FlxSprite;
						  if (isNeo)
						  stageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('neo/stages/stagefront'));
						  else
						  stageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
		                  stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		                  stageFront.updateHitbox();
		                  stageFront.antialiasing = true;
		                  stageFront.scrollFactor.set(0.9, 0.9);
		                  stageFront.active = false;
						  if (!isNoBg)
		                  add(stageFront);
						  
		                  var stageCurtains:FlxSprite;
						  if (!isNeo)
						  stageCurtains = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						  else
						  stageCurtains = new FlxSprite(-500, -300).loadGraphic(Paths.image('neo/stages/stagecurtains'));
		                  stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		                  stageCurtains.updateHitbox();
		                  stageCurtains.antialiasing = true;
		                  stageCurtains.scrollFactor.set(1.3, 1.3);
		                  stageCurtains.active = false;

						  if (!isNoBg)
		                  add(stageCurtains);
		          }
              }
			}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'tank':
				gfVersion = 'gf-tankman';
		    case 'tank2':
				gfVersion = 'picoSpinny';
			case 'hexss':
				gfVersion = 'gfSunset';
			case 'hexr':
				gfVersion = 'gfNight';
			case 'hexng':
				gfVersion = 'gfGlitcher';
		}

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'tankman':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'tank':
				boyfriend.x += 120;
				dad.x += 120;
				gf.x += 100;

				boyfriend.y -= 25;
				dad.y -= 100;
				gf.y -= 25;
			case 'tank2':
				boyfriend.x += 240;
				dad.x += 120;
				gf.x += 100;

				boyfriend.y -= 25;
				dad.y -= 100;
				gf.y -= 25;
		}


		if (!isNoGf)
		{
		add(gf);
		}

		// Shitty layering but whatev it works LOL
	if (!isNoBg)
	{
		if (curStage == 'limo')
			add(limo);
	}
	else if (FlxG.save.data.emptyness) {}

	if (!FlxG.save.data.emptyness)
	{
		add(dad);
		add(boyfriend);
	}

		//again shitty layering but whatever
	if (!isNoBg)
	{
		if (curStage == 'tank' || curStage == 'tank2')
		{
			add(tankBop1);
			add(tankBop2);
			add(tankBop3);
			add(tankBop4);
			add(tankBop5);
			add(tankBop6);
		}
	}
	else if (FlxG.save.data.emptyness) {}

		

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		var isNoCut:Bool = new Config().getnocut();

		
		var isNoIcon:Bool = new Config().getnoicon();
		

		strumLine = new FlxSprite(0, (isDownScroll ? FlxG.height - 150 : 50)).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);


		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);
		add(grpNoteSplashes);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * (isDownScroll ? 0.1 : 0.9)).loadGraphic(Paths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		if (!isNoIcon)
		{
		add(healthBarBG);
		}

		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songposbar)
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
	
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', -4, songLength);
				songPosBar.numDivisions = 1000;
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(0xFF666666, 0xFF12a13a);
				add(songPosBar);
	
				songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song.toUpperCase(), 16);
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
	
				songPosBG.cameras = [camHUD];
				songPosBar.cameras = [camHUD];
				songName.cameras = [camHUD];
			}

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		

		scoreTxt = new FlxText(10, 0, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		songTxt = new FlxText(5, 5, 0, "", 20);
		songTxt.text = SONG.song.toUpperCase() + " (" + difficStr.toUpperCase() + ") - Switcher Engine " + MainMenuState.switcherEngineVer;
		songTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		songTxt.text += "\n";
		songTxt.scrollFactor.set();
		add(songTxt);





		funiRating = new FlxSprite(0, 550);
		funiRating.frames = Paths.getSparrowAtlas('ratings','shared');
		funiRating.animation.addByPrefix('kewl', 'kewl');
		funiRating.animation.addByPrefix('ayy', 'ayyy');
		funiRating.animation.addByPrefix('angy', 'angy');
		funiRating.animation.addByPrefix('ded','ded');
		funiRating.x = FlxG.width - funiRating.width - 10;
		funiRating.y = FlxG.height - funiRating.height - 10;
		add(funiRating);
		funiRating.animation.play('kewl');

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		if (!isNoIcon)
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		if (!isNoIcon)
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		funiRating.cameras = [camHUD];
		doof.cameras = [camHUD];
		songTxt.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];

		rank = new Rank();

		#if mobileC
			mcontrols = new Mobilecontrols();
			switch (mcontrols.mode)
			{
				case VIRTUALPAD_RIGHT | VIRTUALPAD_LEFT | VIRTUALPAD_CUSTOM:
					controls.setVirtualPad(mcontrols._virtualPad, FULL, NONE);
				case HITBOX:
					controls.setHitBox(mcontrols._hitbox);
				default:
			}
			trackedinputs = controls.trackedinputs;
			controls.trackedinputs = [];

			var camcontrol = new FlxCamera();
			FlxG.cameras.add(camcontrol);
			camcontrol.bgColor.alpha = 0;
			mcontrols.cameras = [camcontrol];

			mcontrols.visible = false;

			add(mcontrols);
		#end

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode && !isNoCut)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
                case 'ugh':	
					ughIntro();
				case 'guns':
					gunsIntro();
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}
		// for thorns modchart, too lazy to do complicated shit.
		oldDadCol = dad.color;
		super.create();
	}

	function picoSwitch():Void
	{
		remove(gf);
		remove(boyfriend);
		remove(dad);
		remove(phillyBg);

		gf = new Character(400, 130, 'gfNeo');
		boyfriend = new Boyfriend(770, 450, 'bfNeo');
		dad = new Character(100, 400, 'picoNeo');

		add(phillyBgNeo);
		if (!isNoGf)
		add(gf);

		add(dad);
		add(boyfriend);
	}
	function picoBack():Void
	{
		remove(gf);
		remove(phillyBgNeo);
		remove(dad);
		remove(boyfriend);

		boyfriend = new Boyfriend(770, 450, 'bf');
		dad = new Character(100, 400, 'pico');
		gf = new Character(400, 130, 'gf');

		add(phillyBg);
		if (!isNoGf)
		add(gf);

		add(boyfriend);
		add(dad);
	}
	function glitcherSwitch():Void
	{
		remove(gf);
		remove(boyfriend);
		remove(dad);
        remove(bgGlitcher);
		remove(stageFrontGlitcher);

		add(stageBackWIRE);
		boyfriend = new Boyfriend(770, 450, 'bfWire');
		dad = new Character(100, 100, 'hexWire');
		add(boyfriend);
		add(dad);
	}
	function glitcherBack():Void
	{
		remove(stageBackWIRE);
		remove(boyfriend);
		remove(dad);

		dad = new Character(100, 100, SONG.player2);
		boyfriend = new Boyfriend(770, 450, SONG.player1);
		add(bgGlitcher);
		add(stageFrontGlitcher);
		add(gf);
		add(boyfriend);
		add(dad);
	}
	function ughIntro()
		{
			var video = new VideoPlayer(0, 0, 'videos/ughcutscene.webm');
			video.finishCallback = () -> {
				remove(video);
				startCountdown();
			}
			video.ownCamera();
			video.setGraphicSize(Std.int(video.width * 2));
			video.updateHitbox();
			add(video);
			video.play();
		}
		function gunsIntro()
		{
			var video = new VideoPlayer(0, 0, 'videos/gunscutscene.webm');
			video.finishCallback = () -> {
				remove(video);
				startCountdown();
			}
			video.ownCamera();
			video.setGraphicSize(Std.int(video.width * 2));
			video.updateHitbox();
			add(video);
			video.play();
		}
		function stressIntro()
		{
			var video = new VideoPlayer(0, 0, 'videos/stresscutscene.webm');
			video.finishCallback = () -> {
				remove(video);
				startCountdown();
			}
			video.ownCamera();
			video.setGraphicSize(Std.int(video.width * 2));
			video.updateHitbox();
			add(video);
			video.play();
		}
	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		#if mobileC
		mcontrols.visible = true;
		#end

		
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		

		

        #if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else {}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}
	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else if (player == 0)
			{
				cpuStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			if (player == 1)
				trace('player x #' + i + ": " + babyArrow.x + " player y #" + i + ": " + babyArrow.y);
			else
				trace('opponent x #' + i + ": " + babyArrow.x + " opponent y #" + i + ": " + babyArrow.y);
			strumLineNotes.add(babyArrow);
		}
	}
	public function fixNotePos():Void{
		var cpux:Array<Int> = [50, 162, 274, 386];
		var bfx:Array<Int> = [690, 802, 914, 1026];
		for (i in 0...4)
		{
			playerStrums.members[i].x = bfx[i];
			playerStrums.members[i].y = 40;
			cpuStrums.members[i].x = cpux[i];
			cpuStrums.members[i].y = 40;
		}
		trace('tried note fix :sunglasses:');
	}
	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function updateInfo() {
		// accuracy!!
		accuracy = FlxMath.roundDecimal((notehit / (notehit + misses) * 100), 2);
		if (Math.isNaN(accuracy))
				{
					accuracy = 100;
				}
		
				// rating!!
                rating = "??"; // incase it doesnt load or start idk
				if (accuracy == 100)
				{
					rating = "S";
				}
				else if (accuracy >= 90)
				{
					rating = "S";
				}
				else if (accuracy >= 80)
				{
					rating = "A";
				}
				else if (accuracy >= 70)
				{
					rating = "B";
				}
				else if (accuracy >= 60)
				{
					rating = "C";
				}
				else if (accuracy >= 50)
				{
					rating = "D";
				}
				else if (accuracy >= 30)
				{
					rating = "E";
				}
				else
				{
					rating = "F";
				}
	}

	override public function update(elapsed:Float)
	{
		songTxt.text = SONG.song.replace('-', ' ').toUpperCase() + " (" + difficStr.toUpperCase() + ") - Switcher Engine " + MainMenuState.switcherEngineVer + ' | ' + cast(Lib.current.getChildAt(0), Main).getFPS() + 'FPS';
		if (mashingViolation > 8)
		{
			scoreTxt.color = FlxColor.RED;
			stopSpamming();
		}
		if (mashingViolation > 50)
		{
			mashingViolation = 0;
			scoreTxt.color = FlxColor.WHITE;
		}
		accuracy = FlxMath.roundDecimal((notehit / (notehit + misses) * 100), 2);
		if (Math.isNaN(accuracy))
			{
				accuracy = 100;
			}

			rating = "??"; // incase it doesnt load or start idk
			if (accuracy == 100)
			{
				rating = "S";
			}
			else if (accuracy >= 90)
			{
				rating = "S";
			}
			else if (accuracy >= 80)
			{
				rating = "A";
			}
			else if (accuracy >= 70)
			{
				rating = "B";
			}
			else if (accuracy >= 60)
			{
				rating = "C";
			}
			else if (accuracy >= 50)
			{
				rating = "D";
			}
			else if (accuracy >= 30)
			{
				rating = "E";
			}
			else
			{
				rating = "F";
			}

		#if !debug
		perfectMode = false;
		#end

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}



		super.update(elapsed);
		if (!FlxG.save.data.bot)
		{
			scoreTxt.text = "Score:" + songScore
			 + "\nMisses:" + misses 
			 + "\nNote hits:" + notehit 
			 + "\nCombo:" + combo 
			 + "\nTime Elapsed: " + Std.string(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2)) 
			 + "s\nAccuracy: " + accuracy
			 + "%\nRank: "+ rating + " " + ratingplus + "\n";

			 scoreTxt.y = FlxG.height - scoreTxt.height + 20;

		}
		else
		{
			scoreTxt.text = "BOTPLAY - SE 1.0";
			scoreTxt.y = FlxG.height - 20;
		}

		if (isDownscroll && !FlxG.save.data.bot)
		{
			scoreTxt.text = "Score:" + songScore
			+ " | Misses:" + misses 
			+ " | Note hits:" + notehit 
			+ " | Combo:" + combo 
			+ " | Accuracy: " + accuracy
			+ "% | Rank: "+ rating + " " + ratingplus;

			scoreTxt.alignment = CENTER;
			scoreTxt.y = FlxG.height - scoreTxt.height;
			scoreTxt.screenCenter(X);
		}

		switch (rating)
		{
			case 'S' | 'A':
				funiRating.animation.play('kewl');
			case 'B' | 'C':
				funiRating.animation.play('ayy');
			case 'D' | 'E':
				funiRating.animation.play('angy');
			default:
				funiRating.animation.play('dead');
		}

		
		if (FlxG.keys.justPressed.ENTER #if android || FlxG.android.justReleased.BACK #end && (startedCountdown && canPause))
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.H && (startedCountdown && canPause))
			{
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				openSubState(new ChangeDifficSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;
		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;


		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		if (FlxG.keys.justPressed.EIGHT && FlxG.keys.pressed.CONTROL)
			FlxG.switchState(new AnimationDebug(SONG.player1));
		#end

		if (startingSong)
			{
				if (startedCountdown)
				{
					Conductor.songPosition += FlxG.elapsed * 1000;
					if (Conductor.songPosition >= 0)
						startSong();
				}
			}
			else
			{
				// Conductor.songPosition = FlxG.sound.music.time;
				Conductor.songPosition += FlxG.elapsed * 1000;
				/*@:privateAccess
				{
					FlxG.sound.music._channel.
				}*/
				songPositionBar = Conductor.songPosition;
	
				if (!paused)
				{
					songTime += FlxG.game.ticks - previousFrameTime;
					previousFrameTime = FlxG.game.ticks;
	
					// Interpolation type beat
					if (Conductor.lastSongPos != Conductor.songPosition)
					{
						songTime = (songTime + Conductor.songPosition) / 2;
						Conductor.lastSongPos = Conductor.songPosition;
						// Conductor.songPosition += FlxG.elapsed * 1000;
						// trace('MISSED FRAME');
					}
				}
	
				// Conductor.lastSongPos = FlxG.sound.music.time;
			}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			deathCount += 1;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			if (SONG.song.toLowerCase() == 'stress')
			{
				FlxG.sound.play(Paths.soundRandom('jeffGameover/jeffGameover-', 1, 25));
			}
			
			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (isDownScroll)
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed, 2)))
				else
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
				// i am so fucking sorry for this if condition
				if (daNote.isSustainNote
					&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))
					&& !isDownscroll)
				{
					var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
					swagRect.y /= daNote.scale.y;
					swagRect.height -= swagRect.y;

					daNote.clipRect = swagRect;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (Math.abs(daNote.noteData))
					{
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
					}



					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;



					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				if (daNote.mustPress)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;

						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				var isPractice:Bool = new Config().getpractice();

				if (daNote.y < -daNote.height && !isDownScroll || (daNote.y >= strumLine.y + 106) && isDownScroll)
				{
					if (daNote.tooLate && !isPractice || !daNote.wasGoodHit && !isPractice)
					{
						health -= 0.0475;
						vocals.volume = 0;
						misses += 1;
						combo = 0;
						noteMissTwo(daNote.noteData);
					}
					if (daNote.tooLate && isPractice || !daNote.wasGoodHit && isPractice)
					{
						health += 0.0475;
						vocals.volume = 1;
						misses += 1;
						combo = 0;
						songScore = 0;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		if (!inCutscene && !FlxG.save.data.bot)
			keyShit();
		else if (!inCutscene && FlxG.save.data.bot)
			keyShitBot();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	public function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				//if (FlxG.save.data.noend) delayed :((((

					switch (storyWeek)
					{
						case 0:
							FlxG.save.data.beatWeek0 = true;
						case 1:
							FlxG.save.data.beatWeek1 = true;
						case 2:
							FlxG.save.data.beatWeek2 = true;
						case 3:
							FlxG.save.data.beatWeek3 = true;
						case 4:
							FlxG.save.data.beatWeek4 = true;
						case 5:
							FlxG.save.data.beatWeek5 = true;
						case 6:
							FlxG.save.data.beatWeek6 = true;
						case 7:
							FlxG.save.data.beatWeek7 = true;
					}
					if (FlxG.save.data.beatWeek0 && FlxG.save.data.beatWeek1 && FlxG.save.data.beatWeek2 && FlxG.save.data.beatWeek3 && FlxG.save.data.beatWeek4 && FlxG.save.data.beatWeek5 && FlxG.save.data.beatWeek6 && FlxG.save.data.beatWeek7)
					{
						unlockAchievement(1);
						new FlxTimer().start(3, function(tmr:FlxTimer){
							FlxG.switchState(new StoryMenuState());
						});
					}
					else if (SONG.song.toLowerCase() == 'tutorial')
					{
						unlockAchievement(4);
						new FlxTimer().start(3, function(tmr:FlxTimer){
							FlxG.switchState(new StoryMenuState());
						});
					}
					else
						FlxG.switchState(new StoryMenuState());
				//else
				//	openSubState(new EndSongSubstate());

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
			
				deathCount = 0;

				if (SONG.validScore)
				{
					#if newgrounds
					NGio.unlockMedal(60961);
					#end
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}


				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				
				if (!isPerWeek)
				deathCount = 0;

				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				LoadingState.loadAndSwitchState(new PlayState());
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			if (SONG.song.toLowerCase() == 'foolhardy')
			{
				unlockAchievement(2);
				new FlxTimer().start(3, function(tmr:FlxTimer){
					FlxG.switchState(new FreeplayState());
				});
			}
			else
				FlxG.switchState(new FreeplayState());
			deathCount = 0;
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float, daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating = daNote.rating;

		switch(daRating)
		{
			case 'shit':
				score = -300;
				combo = 0;
				misses++;
				health -= 0.2;
				shits++;
			case 'bad':
				daRating = 'bad';
				bads++;
			case 'good':
				daRating = 'good';
				score = 200;
				goods++;
				if (health < 2)
					health += 0.04;
			case 'sick':
				if (health < 2)
					health += 0.1;
				sicks++;
				if (noteSplashOp)
					{
						var recycledNote = grpNoteSplashes.recycle(NoteSplash);
						recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
						grpNoteSplashes.add(recycledNote);
					}
		}

		rank.goodhit = notehit;
		rank.misses = misses;


		songScore += score;

		if (bads == 0 && shits == 0 && goods == 0 && misses == 0)
		{
			ratingplus = "(MFC)";
		}
		else if (goods >= 1 && bads == 0 && shits == 0 && misses == 0)
		{
			ratingplus = "(GFC)";
		}
		else if (bads >= 1 && misses == 0 || shits >= 1 && misses == 0)
		{
			ratingplus = "(FC)";
		}
		else if (misses <= 10 && misses != 0)
		{
			ratingplus = "(SBCD)";
		}
		else if (misses < 100)
		{
			ratingplus = "(Clear)";
		}
		else if (misses > 100)
		{
			ratingplus = "(Get a bit better)";
		}

	    

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}
	private function keyShit():Void // I've invested in emma stocks
		{			// control arrays, order L D R U
			var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
			var pressArray:Array<Bool> = [
				controls.LEFT_P,
				controls.DOWN_P,
				controls.UP_P,
				controls.RIGHT_P
			];
			var releaseArray:Array<Bool> = [
				controls.LEFT_R,
				controls.DOWN_R,
				controls.UP_R,
				controls.RIGHT_R
			];

	 
			// Prevent player input if bot is on
			if(FlxG.save.data.bot)
			{
				holdArray = [false, false, false, false];
				pressArray = [false, false, false, false];
				releaseArray = [false, false, false, false];
			} 
			// HOLDS, check for sustain notes
			if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
						goodNoteHit(daNote);
				});
			}
	 
			// PRESSES, check for note hits
			if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
			{
				boyfriend.holdTimer = 0;
	 
				var possibleNotes:Array<Note> = []; // notes that can be hit
				var directionList:Array<Int> = []; // directions that can be hit
				var dumbNotes:Array<Note> = []; // notes to kill later
				var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
				
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
					{
						if (!directionsAccounted[daNote.noteData])
						{
							if (directionList.contains(daNote.noteData))
							{
								directionsAccounted[daNote.noteData] = true;
								for (coolNote in possibleNotes)
								{
									if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
									{ // if it's the same note twice at < 10ms distance, just delete it
										// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
										dumbNotes.push(daNote);
										break;
									}
									else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
									{ // if daNote is earlier than existing note (coolNote), replace
										possibleNotes.remove(coolNote);
										possibleNotes.push(daNote);
										break;
									}
								}
							}
							else
							{
								possibleNotes.push(daNote);
								directionList.push(daNote.noteData);
							}
						}
					}
				});	 
				for (note in dumbNotes)
				{
					FlxG.log.add("killing dumb ass note at " + note.strumTime);
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
	 
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	 
				var dontCheck = false;

				if (perfectMode)
					goodNoteHit(possibleNotes[0]);
				else if (possibleNotes.length > 0 && !dontCheck)
				{
					for (coolNote in possibleNotes)
					{
						if (pressArray[coolNote.noteData])
						{
							scoreTxt.color = FlxColor.WHITE;
							goodNoteHit(coolNote);
						}
					}
				}

			}
			
			if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !holdArray.contains(true))
			{
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					boyfriend.playAnim('idle');
			}
	 
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if ((pressArray[spr.ID]) && spr.animation.curAnim.name != 'confirm')
					spr.animation.play('pressed');
				if (!holdArray[spr.ID])
					spr.animation.play('static');
	 
				if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else
					spr.centerOffsets();
			});
		}
		private function keyShitBot():Void
			{
				// HOLDING
				var up = controls.UP;
				var right = controls.RIGHT;
				var down = controls.DOWN;
				var left = controls.LEFT;
		
				var upP = controls.UP_P;
				var rightP = controls.RIGHT_P;
				var downP = controls.DOWN_P;
				var leftP = controls.LEFT_P;
		
				var upR = controls.UP_R;
				var rightR = controls.RIGHT_R;
				var downR = controls.DOWN_R;
				var leftR = controls.LEFT_R;
		
				var controlArray:Array<Bool> = [leftP, downP, upP, rightP];
		
				// FlxG.watch.addQuick('asdfa', upP);
				if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic || FlxG.save.data.bot)
				{
					boyfriend.holdTimer = 0;
		
					var possibleNotes:Array<Note> = [];
		
					var ignoreList:Array<Int> = [];
		
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							// the sorting probably doesn't need to be in here? who cares lol
							possibleNotes.push(daNote);
							possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		
							ignoreList.push(daNote.noteData);
						}
					});
		
					if (possibleNotes.length > 0)
					{
						var daNote = possibleNotes[0];
		
						if (perfectMode)
							noteCheck(true, daNote);
		
						// Jump notes
						if (possibleNotes.length >= 2)
						{
							if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
							{
								for (coolNote in possibleNotes)
								{
									if (controlArray[coolNote.noteData] || FlxG.save.data.bot)
										goodNoteHit(coolNote);
									else
									{
										var inIgnoreList:Bool = false;
										for (shit in 0...ignoreList.length)
										{
											if (controlArray[ignoreList[shit]])
												inIgnoreList = true;
										}
									}
								}
							}
							else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
							{
								noteCheck(controlArray[daNote.noteData], daNote);
							}
							else
							{
								for (coolNote in possibleNotes)
								{
									noteCheck(controlArray[coolNote.noteData], coolNote);
								}
							}
						}
						else // regular notes?
						{
							noteCheck(controlArray[daNote.noteData], daNote);
						}
						/* 
							if (controlArray[daNote.noteData])
								goodNoteHit(daNote);
						 */
						// trace(daNote.noteData);
						/* 
								switch (daNote.noteData)
								{
									case 2: // NOTES YOU JUST PRESSED
										if (upP || rightP || downP || leftP)
											noteCheck(upP, daNote);
									case 3:
										if (upP || rightP || downP || leftP)
											noteCheck(rightP, daNote);
									case 1:
										if (upP || rightP || downP || leftP)
											noteCheck(downP, daNote);
									case 0:
										if (upP || rightP || downP || leftP)
											noteCheck(leftP, daNote);
								}
							//this is already done in noteCheck / goodNoteHit
							if (daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
						 */
					}
		
				}
		
				if ((up || right || down || left) && !boyfriend.stunned && generatedMusic || FlxG.save.data.bot)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
						{
							switch (daNote.noteData)
							{
								// NOTES YOU ARE HOLDING
								case 0:
									if (left || FlxG.save.data.bot)
										goodNoteHit(daNote);
								case 1:
									if (down || FlxG.save.data.bot)
										goodNoteHit(daNote);
								case 2:
									if (up || FlxG.save.data.bot)
										goodNoteHit(daNote);
								case 3:
									if (right || FlxG.save.data.bot)
										goodNoteHit(daNote);
							}
						}
					});
				}
		
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					{
						boyfriend.playAnim('idle');
					}
				}
		
				playerStrums.forEach(function(spr:FlxSprite)
				{
					switch (spr.ID)
					{
						case 0:
							if ((leftP || FlxG.save.data.bot) && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (leftR || FlxG.save.data.bot)
								spr.animation.play('static');
						case 1:
							if ((downP || FlxG.save.data.bot) && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (downR || FlxG.save.data.bot)
								spr.animation.play('static');
						case 2:
							if ((upP || FlxG.save.data.bot) && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (upR || FlxG.save.data.bot)
								spr.animation.play('static');
						case 3:
							if ((rightP || FlxG.save.data.bot) && spr.animation.curAnim.name != 'confirm')
								spr.animation.play('pressed');
							if (rightR || FlxG.save.data.bot)
								spr.animation.play('static');
					}
		
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}
	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			//health -= 0.04;
			//if (combo > 5 && gf.animOffsets.exists('sad'))
			//{
				//gf.playAnim('sad');
			//}
			//combo = 0;

			//songScore -= 10;

			//FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');


			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}
		}
	}
	function noteMissTwo(direction:Int = 1):Void
        {
                FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

			switch (direction)
		    {
                    case 0:
                        boyfriend.playAnim('singLEFTmiss', true);
                    case 1:
                        boyfriend.playAnim('singDOWNmiss', true);
                    case 2:
                        boyfriend.playAnim('singUPmiss', true);
                    case 3:
                        boyfriend.playAnim('singRIGHTmiss', true);
            }
        }



	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP || FlxG.save.data.bot)
			goodNoteHit(note);
	}

	function goodNoteHit(note:Note):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		note.rating = Ratings.CalculateRating(noteDiff);
		if (note.rating == 'miss')
		{
			noteMiss(note.noteData);
			return;
		}
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note);
				combo += 1;
				notehit += 1;
			}

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;

			switch (note.noteData)
			{
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}
		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}
	function stopSpamming():Void {
		disabledKeys = true;
		new FlxTimer().start(2, function(tmr:FlxTimer){
			disabledKeys = false;
		});
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}

		if (SONG.song.toLowerCase() == 'stress')
		{
			if (curStep == 737)
			{
				dad.playAnim('good');
			}
	    }
		if (poison)
		{
			if (dad.animation.curAnim.name.startsWith('sing'))
			{
				health -= 0.005;
				trace('death');
			}
			trace('funi');
		}

		if (modcharting)
		{
			var interp:Interp = new Interp();
			var parser:Parser = new Parser();
			var program = parser.parseString(modchart);
			interp.variables.set("game",this);
			interp.variables.set("PlayState",PlayState);
			interp.variables.set("FlxG",FlxG);
			interp.variables.set("Sys",Sys);
			interp.variables.set("Math",Math);
			interp.variables.set("FlxSprite",FlxSprite);
			interp.variables.set("FlxObject",FlxObject);
			interp.variables.set("Character",Character);
			interp.variables.set("Note",Note);
			interp.variables.set("dad",dad);
			interp.variables.set("bf",boyfriend);
			interp.variables.set("FlxTimer",FlxTimer);
			interp.variables.set("FlxSprite",FlxSprite);
			interp.variables.set("FlxTween",FlxTween);
			interp.variables.set("FlxEase",FlxEase);
			interp.variables.set("FlxText",FlxText);
			interp.variables.set("Alphabet",Alphabet);
			interp.variables.set("MusicBeatState",MusicBeatState);
			interp.variables.set('ModCharts', ModCharts);
			interp.variables.set("camFollow",camFollow);
			interp.variables.set("curBeat",curBeat);
			interp.variables.set("iconP1",iconP1);
			interp.variables.set("iconP2",iconP2);
			interp.variables.set('camHUD', camHUD);
			interp.variables.set('scoreTxt', scoreTxt);
			interp.variables.set("playerStrums",playerStrums);
			interp.variables.set("cpuStrums",cpuStrums);
			interp.variables.set("strumLineNotes",strumLineNotes);
			interp.variables.set("FlxCamera",FlxCamera);
			interp.variables.set("defaultCamZoom",defaultCamZoom);
			interp.variables.set('fixNotePos', function(){fixNotePos();});
			interp.variables.set("notes",notes);
			interp.variables.set('curStep',curStep);
			interp.variables.set('oldDadCol', oldDadCol);
			try{
				interp.execute(program);
			}
			catch(e){
				trace('umm ' + e.message);
			}
		}

	
	if (!isNoBg)
	{
		if (SONG.song.toLowerCase() == 'glitcher')
		{
			switch (curStep)
			{
				case 582:
					glitcherSwitch();
				case 837:
					glitcherBack();
			}
		}
		if (SONG.song.toLowerCase() == 'pico')
		{
			switch (curStep)
	        {
				case 418:
					picoSwitch();
                case 758:
					picoBack();
			}
		}
		if (SONG.song.toLowerCase() == 'philly')
		{
			switch (curStep)
			{
				case 447:
					picoSwitch();
				case 771:
					picoBack();
			}
		}
		if (SONG.song.toLowerCase() == 'blammed')
		{
			switch (curStep)
			{
				case 512:
					picoSwitch();
				case 768:
					picoBack();
			}
		}
	}
	else if (!isNoSwitch) {}
	else if (!isNeo) {}
	else if (FlxG.save.data.emptyness) {}
	

	if (dad.curCharacter == 'tankman' && SONG.song.toLowerCase() == 'ugh')
		{
			if (curStep == 59 || curStep == 443 || curStep == 523 || curStep == 827)
			{
				dad.addOffset("singUP", 45, 0);
				
				dad.animation.getByName('singUP').frames = dad.animation.getByName('ughAnim').frames;
			}
			if (curStep == 64 || curStep == 448 || curStep == 528 || curStep == 832)
			{
				dad.addOffset("singUP", 24, 56);
				dad.animation.getByName('singUP').frames = dad.animation.getByName('oldSingUP').frames;
			}
		}
	}
	
	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing") || FlxG.save.data.bot)
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}
		
    if (!isNoBg)
	{
		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
		    {
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			}
		    case 'tank' | 'tank2':
			{
				tankBop1.animation.play('bop');
				tankBop2.animation.play('bop');
				tankBop3.animation.play('bop');
				tankBop4.animation.play('bop');
				tankBop5.animation.play('bop');
				tankBop6.animation.play('bop');
			}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}
	} else if (FlxG.save.data.emptyness) {}
	
        

	var curLight:Int = 0;
}
}