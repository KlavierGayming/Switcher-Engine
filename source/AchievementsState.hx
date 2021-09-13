package;
import flixel.*;
import flixel.util.*;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class AchievementsState extends MusicBeatState {
    var grpAchievements:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var achievementNames:Array<String> = ['Gettin Freaky', 'A regular player', 'Tankhardy', 'SUS', 'Getting Started'];
    var achievementDescriptions:Array<String> = ['Play FNF On A Friday Night!', 'You beat every week on hard mode!', 'You beat the foolhardy tankman cover!', 'YOU FOUND THE AMOGUS EASTER EGG!', 'Beat the tutorial'];
    var penisText:FlxText;
    override function create() {
        var bg:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('menuDesat'));
        bg.color = 0xFFF700FF;
        bg.updateHitbox();
        add(bg);

        grpAchievements = new FlxTypedGroup<Alphabet>();
        add(grpAchievements);
        for (i in 0...5)
        {
            var achievementPenis:Alphabet = new Alphabet(0,(70 * i) + 30,(!getHowItIsFromID(i) ? "Locked" : achievementNames[i]), true, false);
            achievementPenis.isMenuItem = true;
            grpAchievements.add(achievementPenis);
            trace(achievementNames[i] + ':\n' + getHowItIsFromID(i));
        }
        var idk:FlxSprite = new FlxSprite(0,FlxG.height - 20).makeGraphic(FlxG.width, 30, FlxColor.BLACK);
        idk.alpha = 0.5;
        add(idk);
        penisText = new FlxText(0, FlxG.height - 20, 0, (!getHowItIsFromID(curSelected) ? "Locked" : achievementDescriptions[0]), 16);
        add(penisText);
        changeThing();

        super.create();
    }

    function changeThing(?pp = 0)
    {
        curSelected += pp;

        if (curSelected == achievementNames.length)
            curSelected = 0;
        else if (curSelected < 0)
            curSelected = achievementNames.length - 1;

        var bullShit:Int = 0;

        for (item in grpAchievements.members)
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
        if (grpAchievements.members[curSelected].text != 'Locked')
            penisText.text = achievementDescriptions[curSelected];
        else
            penisText.text = 'Locked';
    }
    override function update(_:Float) {
        super.update(_);
        if (controls.UP_P)
        {
            changeThing(-1);
        }
        else if (controls.DOWN_P)
        {
            changeThing(1);
        }

        if (controls.BACK)
        {
            FlxG.switchState(new OtherState());
        }
    } 
}