package;

import flixel.*;

class House extends FlxSprite {

	public var brokenInto : Bool = false;

	public function new(newX : Int, newY : Int) {
		super(newX, newY);
		loadGraphic("images/HouseShell.png");
		scale.set(0.5, 0.5);
	}

	override public function update() : Void {
		if(brokenInto) {
			loadGraphic("images/HouseEmpty.png");
		}
	}

	public function breakInto() : Void {
		brokenInto = true;
	}
}
