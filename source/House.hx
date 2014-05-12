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
		//Ugh this is fucking pitiful...
		//Figure a better way to start changing graphics
		//Better way to interact with world
		if(FlxG.keys.justPressed.SPACE) {
			brokenInto = !brokenInto;
		}
		if(brokenInto) {
			loadGraphic("images/HouseEmpty.png");
		}
	}
}
