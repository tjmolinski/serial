package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class Hero extends FlxSprite {
	public var currentMesh : Int;
	public var targets : Array<Path> = new Array<Path>();

	public function new() {
		super(0, 0);
		makeGraphic(40, 40, FlxColor.BLUE);
	}

	override public function update() {
		var speed : Float = 50.0;
		var currentTarget = targets[0].target;
		if(currentTarget != null) {
		currentMesh = targets[0].current;
		if(x < currentTarget.x) {
			x += speed * FlxG.elapsed;
		}
		if(x > currentTarget.x) {
			x -= speed * FlxG.elapsed;
		}
		if(y < currentTarget.y) {
			y += speed * FlxG.elapsed;
		}
		if(y > currentTarget.y) {
			y -= speed * FlxG.elapsed;
		}

		if((Math.abs(x - currentTarget.x) < 0.5) &&
			(Math.abs(x - currentTarget.x) < 0.5)) {
			x = currentTarget.x;
			y = currentTarget.y;
			targets.shift();
		}
		}
	}

	public function clearTargets() : Void {
		targets = new Array<Path>();
	}

	public function addTarget(newPath : Path) : Void {
		targets.push(newPath);
	}
}
