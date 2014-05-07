package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class Hero extends FlxSprite {
	public var currentMesh : NavMesh;
	public var targets : Array<Vector2> = new Array<Vector2>();
	public var targetMeshes : Array<NavMesh> = new Array<NavMesh>();

	public function new(newX : Int, newY : Int) {
		super(newX, newY);
		makeGraphic(20, 20, FlxColor.BLUE);
	}

	override public function update() {
		var speed : Float = 50.0;
		var currentTarget = targets[0];
		if(currentTarget != null) {
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

			if((Math.abs(x - currentTarget.x) < 1) &&
				(Math.abs(y - currentTarget.y) < 1)) {
				trace("hit target");
				x = currentTarget.x;
				y = currentTarget.y;
				targets.shift();
				targetMeshes.shift();
				if(targetMeshes[0] != null) {
					currentMesh = targetMeshes[0];
				}
			}
		}
	}

	public function clearTargets() : Void {
		targets = new Array<Vector2>();
		targetMeshes = new Array<NavMesh>();
	}

	public function addTarget(newMesh : NavMesh, newTarget : Vector2) : Void {
		targets.push(newTarget);
		targetMeshes.push(newMesh);
	}
}
