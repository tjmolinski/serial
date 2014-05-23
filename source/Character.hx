package;

import flixel.*;

class Character extends FlxSprite {
	var downSprite : FlxSprite;
	var upSprite : FlxSprite;
	var leftSprite : FlxSprite;
	var rightSprite : FlxSprite;
	var currentSprite : FlxSprite;
	
	public function new(newX : Int, newY : Int) {
		super(newX, newY);

		downSprite = new FlxSprite();
		downSprite.loadGraphic("images/manwalkdown.png", true, 33, 86);
		downSprite.animation.add("test", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		downSprite.animation.play("test");
		upSprite = new FlxSprite();
		upSprite.loadGraphic("images/manwalkup.png", true, 31, 85);
		upSprite.animation.add("test", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		upSprite.animation.play("test");
		leftSprite = new FlxSprite();
		leftSprite.loadGraphic("images/manwalkleft.png", true, 51, 84);
		leftSprite.animation.add("test", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		leftSprite.animation.play("test");
		rightSprite = new FlxSprite();
		rightSprite.loadGraphic("images/manwalkright.png", true, 51, 84);
		rightSprite.animation.add("test", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		rightSprite.animation.play("test");

		setAnimation(upSprite);

		//TODO: Fix when real art comes
		//This will cause some weird issues since all sprite sheets are not the same size
		offset.set(15, 70);
	}

	public function setAnimation(sprite : FlxSprite) {
		if(sprite != currentSprite) {
			currentSprite = sprite;
			loadGraphicFromSprite(currentSprite);
			animation.resume();
		}
	}
}
