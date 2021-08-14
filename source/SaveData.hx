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
    }
    function returnABoolArray():Array<Bool> {
        var bool:Array<Bool> = [FlxG.save.data.songposbar, FlxG.save.data.emptyness, FlxG.save.data.isnogf, FlxG.save.data.ispractice, FlxG.save.data.isnocut];
        return bool;
    }
}