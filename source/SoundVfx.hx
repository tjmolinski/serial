package;

import flixel.*;

class SoundVfx extends ExtendedSprite {

	var hero : Hero;
	var fadeRate : Float = 1.0;
	var moveSpeed : Float = 100.0;

	public function new(asset : String, newX : Int, newY : Int) {
		super(newX, newY);
		alpha = 0;
		loadGraphic(asset);
		hero = cast(FlxG.state, PlayState).hero;
	}

	override public function update() {
		if(alpha < 0) {
			return;
		}

		alpha -= fadeRate * FlxG.elapsed;

		if(x < hero.x) {
			x += moveSpeed * FlxG.elapsed;
		}
		if(x > hero.x) {
			x -= moveSpeed * FlxG.elapsed;
		}
		if(y < hero.y - 60) { //-60 for the offset to go to his head
			y += moveSpeed * FlxG.elapsed;
		}
		if(y > hero.y - 60) {
			y -= moveSpeed * FlxG.elapsed;
		}

		super.update();
	}
}
