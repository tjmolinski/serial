package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.input.mouse.FlxMouse;

class PlayState extends FlxState
{

	var hero : Hero;

	override public function create():Void
	{
		hero = new Hero();
		add(hero);

		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		if(FlxG.mouse.justPressed) {
			hero.setTarget(FlxG.mouse.screenX, FlxG.mouse.screenY);
		}
		super.update();
	}	
}
