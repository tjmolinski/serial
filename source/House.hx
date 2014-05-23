package;

import flixel.*;

class House extends ExtendedSprite {

	public var brokenInto : Bool = false;
	var phase : Int = -1;

	public function new(newX : Int, newY : Int) {
		super(newX, newY);
		loadGraphic("images/HouseShell.png");
		scale.set(0.5, 0.5);
	}

	override public function update() : Void {
		if(brokenInto && phase >= 0) {
			changeInterior();
		}
	}

	public function breakInto() : Void {
		brokenInto = true;
		phase = 0;
	}

	public function enterDoor() : Void {
		phase++;
		if(phase > 1) {
			phase = 0;
		}
		changeInterior();
	}

	private function changeInterior() : Void {
		loadGraphic("images/HousePhase"+phase+".png");
	}
}
