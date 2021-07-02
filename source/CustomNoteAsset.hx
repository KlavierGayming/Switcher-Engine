package;

import flixel.*;
import flixel.text.FlxText;

class CustomNoteAsset extends MusicBeatState {
    var notespr:FlxSprite;
    var txt:FlxText;
    var noteassetnum:Int = 0;
    var pressed:Bool = false;
    override function create()
    {
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.color = 0xFF0008fa;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

        notespr = new FlxSprite();
        notespr.frames = Paths.getSparrowAtlas('notes/' + FlxG.save.data.noteasset + '_assets','shared');
        notespr.animation.addByPrefix('up','arrowUP',24);
        notespr.animation.addByPrefix('upconfirm','up confirm',24);
        notespr.animation.play('up');
        notespr.screenCenter();
        add(notespr);

        txt = new FlxText(0, 550, 0, "Press left or right to change notetheme, enter/A to play the confirm anim. Current theme: LOADING", 20);
        add(txt); 
        txt.screenCenter(X);
    }

    override function update(elapsed:Float)
    {
        if (FlxG.save.data.noteasset == null)
            FlxG.save.data.noteasset = "NOTE";
        
        if (controls.LEFT_P)
            noteassetnum -= 1;
            txt.text = "Press left or right to change notetheme, enter/A to play the confirm anim. Current theme: " + FlxG.save.data.notetheme;
        if (controls.RIGHT_P)
            noteassetnum += 1;
            txt.text = "Press left or right to change notetheme, enter/A to play the confirm anim. \nCurrent theme: " + FlxG.save.data.notetheme;
        if (controls.ACCEPT)
            pressed = !pressed;
        if (controls.BACK)
            FlxG.switchState(new OtherState());

        if (pressed)
            notespr.animation.play('upconfirm');
        else if (!pressed)
            notespr.animation.play('up');

        if (noteassetnum > 6)
            noteassetnum = 0;
        if (noteassetnum < 0)
            noteassetnum = 6;

        

        switch (noteassetnum)
        {
            case 0:
                FlxG.save.data.noteasset = "NOTE";
            case 1:
                FlxG.save.data.noteasset = "BEATSABER";
            case 2:
                FlxG.save.data.noteasset = "KAPI";
            case 3:
                FlxG.save.data.noteasset = "TRIANGLE";
        }
    }
}