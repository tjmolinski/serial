package;

import flixel.*;

class Hero extends Character {
	public var currentMesh : NavMesh;
	public var targets : Array<Vector2> = new Array<Vector2>();
	public var targetMeshes : Array<NavMesh> = new Array<NavMesh>();

	public function new(newX : Int, newY : Int) {
		super(newX, newY);
	}

	/*
	 * HACK!!!!
	 * TODO: Remove for better functionality
	 */
	var dblClick : Bool = false;
	var clickDelay : Float = 1;
	var doubleClickPeriod : Float = 0.15;
	private function checkDoubleClick() : Void {
		clickDelay += FlxG.elapsed;
		if(FlxG.mouse.justPressed) {
			if(clickDelay < doubleClickPeriod) {
				dblClick = true;
			} else {
				dblClick = false;
				clickDelay = 0;
			}
		}
	}

	override public function update() {
		var speed : Float;
		var walk : Float = 35.0;
		var sneak : Float = 20.0;
		var run : Float = 75.0;
		var currentTarget = targets[0];

		checkDoubleClick();

		if(dblClick) {
			speed = run;
		} else if(FlxG.mouse.pressed) {
			//targets[targets.length-1] = new Vector2(FlxG.mouse.screenX, FlxG.mouse.screenY);
			dblClick = false;
			speed = sneak;
		} else {
			speed = walk;
		}

		if(currentTarget != null) {
			if(x < currentTarget.x) {
				setAnimation(rightSprite);
				x += speed * FlxG.elapsed;
			}
			if(x > currentTarget.x) {
				setAnimation(leftSprite);
				x -= speed * FlxG.elapsed;
			}
			if(y < currentTarget.y) {
				setAnimation(downSprite);
				y += speed * FlxG.elapsed;
			}
			if(y > currentTarget.y) {
				setAnimation(upSprite);
				y -= speed * FlxG.elapsed;
			}

			if(Math.abs(y - currentTarget.y) < 1) {
				y = currentTarget.y;
			}
			if(Math.abs(x - currentTarget.x) < 1) {
				x = currentTarget.x;
			}
			if(x == currentTarget.x && y == currentTarget.y) {
				//trace("hit target");
				targets.shift();
				targetMeshes.shift();
				if(targetMeshes[0] != null) {
					currentMesh = targetMeshes[0];
				} else {
					animation.pause();
					dblClick = false;
				}
			}
		}
		
		super.update();
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
