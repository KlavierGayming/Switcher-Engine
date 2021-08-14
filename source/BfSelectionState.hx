package;

import flixel.*;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.*;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;

class BfSelectionState extends MusicBeatState {
    var daName:FlxText;
    var daBf:Character;
    var arrow1:FlxSprite;
    var arrow2:FlxSprite;
    var menuItems:Array<String> = ['bf', 'jamey', 'mark', 'custom'];
    var curSelected:Int = 0;
    var exitButton:FlxUIButton;
    var exitNSaveButton:FlxUIButton;
    var textThing:FlxText;
    var config:Config = new Config();
    var endedAnims:Bool = false;
    var firstTimePressing:Bool = false;
    override function create()
    {
        super.create();
        curSelected = config.getbfmode();

        var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menuDesat'));
        bg.color = 0xFF05FF22;
        bg.updateHitbox();
        add(bg);

        arrow1 = new FlxSprite(5, 5);
        arrow1.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
        arrow1.animation.addByPrefix('idle', 'arrow left', 24, false);
        arrow1.animation.addByPrefix('pressed', 'arrow push left', 24, false);
        arrow1.animation.play('idle', false);
        add(arrow1);

        daName = new FlxText(arrow1.x + 55, arrow1.y, 0, FlxG.save.data.bfThing.toUpperCase(), 55);
        add(daName); //this line crashes the game wtf // nvm :)))

        arrow2 = new FlxSprite(arrow1.x + 55 + daName.width, arrow1.y);
        arrow2.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
        arrow2.animation.addByPrefix('idle', 'arrow right', 0, false);
        arrow2.animation.addByPrefix('pressed', 'arrow push right', 24, false);
        arrow2.animation.play('idle', false);
        add(arrow2);

        daBf = new Character(0, 0, FlxG.save.data.bfThing, true);
        daBf.screenCenter();
        daBf.playAnim('idle',true);
        add(daBf);

        exitNSaveButton = new FlxUIButton(895, 5, "Exit and save", exitThing);
        exitNSaveButton.resize(125,50);
        exitNSaveButton.setLabelFormat(24,FlxColor.BLACK,"center");
        add(exitNSaveButton);

        
        exitButton = new FlxUIButton(exitNSaveButton.x - exitNSaveButton.width - 35, 5, "Exit", exitThingTwo);
        exitButton.resize(125,50);
        exitButton.setLabelFormat(24,FlxColor.BLACK,"center");
        add(exitButton);


        textThing = new FlxText(0, FlxG.height - 30, 0, "", 16);
        add(textThing);
    } // bruh this is so little code why'd it take me so long to fuckin code

    override function update(elapsed:Float) {
        super.update(elapsed);

        for (touch in FlxG.touches.list)
        {
            if (touch.overlaps(arrow1) && touch.justPressed)
            {
                changeThing(-1);
                arrow1.animation.play('pressed');
                new FlxTimer().start(0.5, function(tmr:FlxTimer){
                    arrow1.animation.play('idle');
                }); // anim shit :spooky:
            }
            else if (touch.overlaps(arrow2) && touch.justPressed)
            {
                changeThing(1);
                arrow2.animation.play('pressed');
                new FlxTimer().start(0.5, function(tmr:FlxTimer){
                    arrow2.animation.play('idle');
                }); // anim shit :spooky:
            }
        }

        if (controls.LEFT_P)
        {
            changeThing(-1);
            arrow1.animation.play('pressed');
            new FlxTimer().start(0.5, function(tmr:FlxTimer){
                arrow1.animation.play('idle');
            }); // anim shit :spooky:
        }
        else if (controls.RIGHT_P)
        {
            changeThing(1);
            arrow2.animation.play('pressed');
            new FlxTimer().start(0.5, function(tmr:FlxTimer){
                arrow2.animation.play('idle');
            }); // anim shit :spooky:
        }

        if (FlxG.keys.justPressed.M)
        {
            playBfAnimations();
        }
    }
    function changeThing(howMuchThing:Int):Void
    {
        curSelected += howMuchThing;

        if (curSelected > 3)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = 3;

        daName.text = menuItems[curSelected].toUpperCase();

        remove(daBf);
        daBf = new Character(0, 0, menuItems[curSelected], true);
        daBf.screenCenter();
        daBf.playAnim('idle',true);
        add(daBf);

        if (menuItems[curSelected] == 'custom')
            textThing.text = 'Open apk editor and replace the thing in assets/shared/images/bf/custom with a custom skin for this idfk';
        else
            textThing.text = '';

        arrow2.x = daName.width + 55;
        arrow2.updateHitbox();

        // simple ass code but its long enought that it needs a fucktion
    }
    function exitThing():Void {
        FlxG.save.data.bfThing = menuItems[curSelected];
        FlxG.switchState(new OtherState());
    }

    function exitThingTwo():Void {
        FlxG.switchState(new OtherState());
    }
    function playBfAnimations():Void {
        new FlxTimer().start(1, function(tmr:FlxTimer){
            daBf.playAnim('idle', true);
            new FlxTimer().start(1, function(tmr:FlxTimer){
                    daBf.playAnim('singLEFT');
                    new FlxTimer().start(1, function(tmr:FlxTimer){
                        daBf.playAnim('singRIGHT');
                            new FlxTimer().start(1, function(tmr:FlxTimer){
                                daBf.playAnim('singUP');
                                new FlxTimer().start(1, function(tmr:FlxTimer){
                                    daBf.playAnim('singDOWN');
                                    new FlxTimer().start(1, function(tmr:FlxTimer){
                                        daBf.playAnim('idle', true);
                                    });
                            });
                        });
                    });
            });
        });
    }
}