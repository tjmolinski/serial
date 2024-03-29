package;

import flixel.*;
import flixel.text.*;

class Victim extends Character {
	public var targets : Array<Vector2> = new Array<Vector2>();
	public var targetIdx : Int = 0;
	var noise : SoundVfx;

	public function new(newX : Int, newY : Int) {
		super(newX, newY);
		noise = new SoundVfx("images/tap.png", 0, 0);
		cast(FlxG.state, PlayState).container.add(noise);
	}

	override public function update() {
		var currentTarget = targets[targetIdx];
		var speed = 25.0;

		if(animation.curAnim.curFrame == 0) {
			noise.alpha = 1;
			noise.x = cast(x, Int);
		        noise.y = cast(y, Int);
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
				targetIdx++;
				if(targetIdx > 1) {
					targetIdx = 0;
				}
			}
		}

		super.update();
	}

	public function addTarget(newTarget : Vector2) : Void {
		targets.push(newTarget);
	}
}
