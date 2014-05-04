package;

import flixel.*;
import flixel.input.mouse.FlxMouse;

class MenuState extends FlxState
{
	override public function create():Void
	{
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
