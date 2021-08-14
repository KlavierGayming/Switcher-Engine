package;
import flixel.tweens.FlxTween;
import flixel.*;
import flixel.text.FlxText;
import flixel.util.*;
import flixel.group.FlxGroup.FlxTypedGroup;


class TextThingState extends MusicBeatState {
    var menuItems:Array<String> = ['Thing: off', 'Ass: idk', 'Useless'];
    var curSelected:Int = 0;
    var selector:FlxSprite;
	var grpOptionsTexts:FlxTypedGroup<FlxText>;
    var thing:Bool = false;

    override function create() {
        super.create();
        grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);

		selector = new FlxSprite().makeGraphic(5, 5, FlxColor.RED);
		add(selector);

        if (thing)
            {
                menuItems[menuItems.indexOf('Thing: off')] = 'Thing: on';
            }
		for (i in 0...menuItems.length)
		{
			var optionText:FlxText = new FlxText(20, 20 + (i * 50), 0, menuItems[i], 32);
			optionText.ID = i;
			grpOptionsTexts.add(optionText);
		}
    }
    override function update(elapsed:Float) {
        super.update(elapsed);
        if (controls.UP_P)
            curSelected -= 1;
        if (controls.DOWN_P)
            curSelected += 1;

        if (curSelected < 0)
            curSelected = menuItems.length - 1;
    
        if (curSelected >= menuItems.length)
            curSelected = 0;

        grpOptionsTexts.forEach(function(txt:FlxText)
            {
                txt.visible = false;
    
                if (txt.ID == curSelected)
                    txt.visible = true;
            });
            if (controls.ACCEPT)
                {
                    switch (menuItems[curSelected])
                    {
                        case "Thing: off":
                            thing = !thing;
                            FlxG.resetState();
                    }
                }
    }
}