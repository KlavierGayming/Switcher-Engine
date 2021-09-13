package;

import flixel.FlxG;

class SaveData {
    public static function initSave():Void {
    if (FlxG.save.data.songposbar = null)
        FlxG.save.data.songposbar = false;
    
    if (FlxG.save.data.noteasset == null)
        FlxG.save.data.noteasset == "NOTE";

    if (FlxG.save.data.noend == null)
        FlxG.save.data.noend = false;
    
    if (FlxG.save.data.emptyness == null)
        FlxG.save.data.emptyness = false;

    if (FlxG.save.data.bfThing == null)
        FlxG.save.data.bfThing = 'bf';
    trace('penis!\n' + FlxG.save.data.fridayAchievement + '\n' + FlxG.save.data.beatEveryWeekAchievement + '\n' + FlxG.save.data.beatFoolhardy + '\n' + FlxG.save.data.sus + '\n' + FlxG.save.data.started);
        if (FlxG.save.data.beatEveryWeekAchievement == null)
        {
				FlxG.save.data.fridayAchievement = false;
				FlxG.save.data.beatEveryWeekAchievement = false;
				FlxG.save.data.beatFoolhardy = false;
				FlxG.save.data.sus = false;
				FlxG.save.data.started = false;
        }
        if (FlxG.save.data.beatWeek0 == null)
        {
                FlxG.save.data.beatWeek0 = false;
                FlxG.save.data.beatWeek1 = false;
                FlxG.save.data.beatWeek2 = false;
                FlxG.save.data.beatWeek3 = false;
                FlxG.save.data.beatWeek4 = false;
                FlxG.save.data.beatWeek5 = false;
                FlxG.save.data.beatWeek6 = false;
                FlxG.save.data.beatWeek7 = false;
        }
    }
}