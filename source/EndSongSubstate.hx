package;

import flixel.text.FlxText;
import flixel.*;
import flixel.util.FlxColor;

class EndSongSubstate extends MusicBeatSubstate {

    private var camHUD:FlxCamera;
    var playState:PlayState;
    override function create() {
        camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
        playState = new PlayState();
        var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
        black.screenCenter();
        black.alpha = 0.5;
        add(black);

        var text1:FlxText = new FlxText(0, 0, 0, "");
        text1.text = "You beat the song! \n\n Bads: " + playState.bads
        + "\nGoods: " + playState.goods 
        + "\nSicks: " + playState.sicks
        + "\n\nMisses: " + playState.misses
        + "\nNotehits: " + playState.notehit
        + "\nAccuracy: " + playState.accuracy
        + "\nRank (based on accuracy lmao.): " + playState.rating
        + "\nHow well you did (the thing behind the rating.): " + playState.ratingplus;
        text1.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
        add(text1);

        var text2:FlxText = new FlxText(FlxG.width - 400, FlxG.height - 8, 0, "Press enter/tap the screen to continue");
        text2.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
        add(text2);

        text1.cameras = [camHUD];
        text2.cameras = [camHUD];
    }
    override function update(elapsed:Float) {

        for (touch in FlxG.touches.list)
        {
            if (touch.justPressed)
            {
                if (PlayState.isStoryMode)
                    FlxG.switchState(new StoryMenuState());
                else
                    FlxG.switchState(new FreeplayState());
            }
        }

        if (FlxG.keys.justPressed.ENTER)
        {
            if (PlayState.isStoryMode)
                FlxG.switchState(new StoryMenuState());
            else
                FlxG.switchState(new FreeplayState());
        }
    }
}