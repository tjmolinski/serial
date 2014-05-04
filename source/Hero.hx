package;

import flixel.*;

class Hero extends FlxSprite {
	private var targetX : Float;
	private var targetY : Float;

	public function new() {
		super(100, 100);
		targetX = 100;
		targetY = 100;
		makeGraphic(40, 40);
	}

	override public function update() {
		var speed : Float = 50.0;
		if(x < targetX) {
			x += speed * FlxG.elapsed;
		}
		if(x > targetX) {
			x -= speed * FlxG.elapsed;
		}
		if(y < targetY) {
			y += speed * FlxG.elapsed;
		}
		if(y > targetY) {
			y -= speed * FlxG.elapsed;
		}
	}

	public function setTarget(newX : Float, newY: Float) {
		targetX = newX;
		targetY = newY;
	}
}
