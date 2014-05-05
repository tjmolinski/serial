package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.input.mouse.FlxMouse;

class PlayState extends FlxState
{

	var hero : Hero;
	var mesh : NavMesh;

	override public function create():Void
	{
		var points = new Array<Vector2>();
		points.push(new Vector2(10, 10));
		points.push(new Vector2(400, 10));
		points.push(new Vector2(300, 200));
		points.push(new Vector2(400, 400));
		points.push(new Vector2(10, 400));
		mesh = new NavMesh(points);

		hero = new Hero();
		if(mesh.isConcave()) {
		add(hero);
		}

		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		if(FlxG.mouse.justPressed) {
			var mouseVec = new Vector2(FlxG.mouse.screenX, FlxG.mouse.screenY);
			if(mesh.isInside(mouseVec)) {
				hero.setTarget(mouseVec);
			}
		}
		super.update();
	}	
}
