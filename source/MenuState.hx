package;

import flixel.*;

class MenuState extends FlxState
{
	override public function create():Void
	{
		var upplayer : FlxSprite = new FlxSprite();
		upplayer.loadGraphic("images/manwalkup.png", true, 31, 85);
		upplayer.animation.add("up", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		upplayer.animation.play("up");
		upplayer.x = 100;
		add(upplayer);

		var downplayer : FlxSprite = new FlxSprite();
		downplayer.loadGraphic("images/manwalkdown.png", true, 33, 86);
		downplayer.animation.add("down", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		downplayer.x = 200;
		add(downplayer);
		downplayer.animation.play("down");

		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		if(FlxG.mouse.justPressed) {
			var newState : FlxState = new PlayState();
			FlxG.switchState(newState);
		}
		super.update();
	}	
}
