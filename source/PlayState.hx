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
	var meshMap : Array<NavMesh>;

	override public function create():Void
	{
		meshMap = new Array<NavMesh>();

		var points = new Array<Vector2>();
		points.push(new Vector2(10, 10));
		points.push(new Vector2(400, 10));
		points.push(new Vector2(400, 400));
		points.push(new Vector2(10, 400));
		meshMap.push(new NavMesh(points));

		points = new Array<Vector2>();
		points.push(new Vector2(10, 410));
		points.push(new Vector2(90, 410));
		points.push(new Vector2(90, 470));
		points.push(new Vector2(10, 470));
		meshMap.push(new NavMesh(points));

		points = new Array<Vector2>();
		points.push(new Vector2(410, 10));
		points.push(new Vector2(500, 10));
		points.push(new Vector2(500, 300));
		points.push(new Vector2(410, 300));
		meshMap.push(new NavMesh(points));

		meshMap[0].addNeighbor(meshMap[1], new Vector2(50, 405));
		meshMap[1].addNeighbor(meshMap[0], new Vector2(50, 405));
		meshMap[0].addNeighbor(meshMap[2], new Vector2(405, 155));
		meshMap[2].addNeighbor(meshMap[0], new Vector2(405, 155));

		hero = new Hero();
		hero.currentMesh = 0;
		add(hero);

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
			hero.clearTargets();
			for(i in 0...meshMap.length) {
				if(meshMap[i].isInside(mouseVec)) {
					if(hero.currentMesh != i) {
						var target = meshMap[hero.currentMesh].neighbors.get(meshMap[i]);
						var newPath = new Path(target, i);
						hero.addTarget(newPath);
					}
					var newPath = new Path(mouseVec, i);
					hero.addTarget(newPath);
				}
			}
		}
		super.update();
	}	
}
