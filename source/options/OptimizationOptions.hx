package options;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import Config;
import WebViewVideo;

import flixel.util.FlxSave;

class OptimizationOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var insubstate:Bool = false;

	//var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['no gf: off', 'no bgs: off', 'opti char sprites: off', 'no health icons: off', 'no bg switches: off', 'About'];

	var UP_P:Bool;
	var DOWN_P:Bool;
	var BACK:Bool;
	var ACCEPT:Bool;

	// stuff.
	public var accuracyDisabled:Bool = false;

	var _saveconrtol:FlxSave;

	var config:Config = new Config();

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		//controlsStrings = CoolUtil.coolTextFile('assets/data/controls.txt');
		menuBG.color = 0x7429130;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);


		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		if (config.getnogf()){
			menuItems[menuItems.indexOf('no gf: off')] = 'no gf: on';
		}

		if (config.getnobg()){
			menuItems[menuItems.indexOf('no bgs: off')] = 'no bgs: on';
		}

		if (config.getoptimization()){
			menuItems[menuItems.indexOf('opti char sprites: off')] = 'opti char sprites: on';
		}

		if (config.getnoicon()){
			menuItems[menuItems.indexOf('no health icons: off')] = 'no health icons: on';
		}

		if (config.getnoswitch()){
			menuItems[menuItems.indexOf('no bg switches: off')] = 'no bg switches: on';
		}

		for (i in 0...menuItems.length)
		{ 
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		#if mobileC
		addVirtualPad(UP_DOWN, A_B);
		#end
		
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (controls.ACCEPT)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "no gf: on" | "no gf: off":
					config.setnogf();
					FlxG.resetState();
				case "no bgs: on" | "no bgs: off":
					config.setnobg();
					FlxG.resetState();
				case 'opti char sprites: on' | 'opti char sprites: off':
					config.setoptimization();
					FlxG.resetState();
				case "no health icons: on" | "no health icons: off":
					config.setnoicon();
					FlxG.resetState();
				case "no bg switches: on" | "no bg switches: off":
					config.setnoswitch();
					FlxG.resetState();
			}
		}

		if (isSettingControl)
			waitingInput();
		else
		{
			if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
				FlxG.switchState(new options.OptionsMenu());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
		}
	}

	function waitingInput():Void
	{
		if (false)// fix this FlxG.keys.getIsDown().length > 0
		{
			//PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
		}
		// PlayerSettings.player1.controls.replaceBinding(Control)
	}

	var isSettingControl:Bool = false;

	function changeBinding():Void
	{
		if (!isSettingControl)
		{
			isSettingControl = true;
		}
	}

	function changeSelection(change:Int = 0)
	{
		/* #if !switch
		NGio.logEvent('Fresh');
		#end
		*/
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	// (this function is not working)
	function changeLabel(i:Int, text:String) {
		var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, text, true, false);
		controlLabel.isMenuItem = true;
		controlLabel.targetY = i;
		
		grpControls.forEach((basic)->{
			trace(basic.text);
			if (basic.text == menuItems[i])
			{
				grpControls.remove(basic);
			}
		});
		grpControls.insert(i, controlLabel);	
		menuItems[i] = text;
	}

	override function closeSubState()
		{
			insubstate = false;
			super.closeSubState();
		}	
}
