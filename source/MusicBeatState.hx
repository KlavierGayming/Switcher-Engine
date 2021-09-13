package;

import flixel.tweens.FlxTween;
import flixel.input.actions.FlxActionInput;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
#if mobileC
import ui.FlxVirtualPad;
#end
import flixel.text.FlxText;
import flixel.FlxSprite;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	#if mobileC
	var _virtualpad:FlxVirtualPad;

	var trackedinputs:Array<FlxActionInput> = [];

	// adding virtualpad to state
	public function addVirtualPad(?DPad:FlxDPadMode, ?Action:FlxActionMode) {
		_virtualpad = new FlxVirtualPad(DPad, Action);
		_virtualpad.alpha = 0.75;
		add(_virtualpad);
		controls.setVirtualPad(_virtualpad, DPad, Action);
		trackedinputs = controls.trackedinputs;
		controls.trackedinputs = [];

		#if android
		controls.addAndroidBack();
		#end
	}
	
	override function destroy() {
		controls.removeFlxInput(trackedinputs);

		super.destroy();
	}
	#else
	public function addVirtualPad(?DPad, ?Action){};
	#end

	override function create()
	{
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	function unlockAchievement(id:Int)
	{
		var achievementDesc:String = '';
		switch (id)
		{
			case 0:
				achievementDesc = 'Gettin Freaky\nPlay FNF On A Friday Night!';
				FlxG.save.data.fridayAchievement = true;
			case 1:
				achievementDesc = 'A regular player\nYou beat every week on hard mode!';
				FlxG.save.data.beatEveryWeekAchievement = true;
			case 2:
				achievementDesc = 'Tankhardy\nYou beat the foolhardy tankman cover!';
				FlxG.save.data.beatFoolhardy = false;
				trace('penis!');
			case 3:
				achievementDesc = 'SUS\nYOU FOUND THE AMOGUS EASTER EGG!';
				FlxG.save.data.sus = true;
			case 4:
				achievementDesc = 'Getting Started\nBeat the tutorial';
				FlxG.save.data.started = true;
		}
		if (!getHowItIsFromID(id))
		{
			var thing:FlxText = new FlxText(10, 10, 0, "Achievement Unlocked!\n" + achievementDesc, 18);
			thing.scrollFactor.set();
			thing.alpha = 0;
			thing.text += "\n";
			add(thing);
			FlxTween.tween(thing, {alpha: 1}, 0.75, {onComplete: function(twn:FlxTween){
				new FlxTimer().start(2, function(tmr:FlxTimer){
					FlxTween.tween(thing, {alpha: 0}, 0.75, {onComplete: function(twn:FlxTween){
						thing.kill();
					}});
				});
			}});
			GameJolt.GameJoltAPI.getTrophy(getTrophyID(id));
		}
	}
	function getTrophyID(id:Int):Int
	{	
		var trophyID = 0;
		switch (id) {
			case 0:
				trophyID = 148529;
			case 1:
				trophyID = 148530;
			case 2:
				trophyID = 148531;
			case 3:
				trophyID = 148533;
			case 4:
				trophyID = 148532;
		}
		return trophyID;
	}
	function getHowItIsFromID(id:Int):Bool {
		var penis:Bool = false;
		switch (id)
		{
			case 0:
				penis = FlxG.save.data.fridayAchievement;
			case 1:
				penis = FlxG.save.data.beatEveryWeekAchievement;
			case 2:
				penis = FlxG.save.data.beatFoolhardy;
			case 3:
				penis = FlxG.save.data.sus;
			case 4:
				penis = FlxG.save.data.started;
		}
		return penis;
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
