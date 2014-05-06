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

		meshMap[0].addNeighbor(meshMap[1], new Vector2(50, 405), 1);
		meshMap[1].addNeighbor(meshMap[0], new Vector2(50, 405), 0);
		meshMap[0].addNeighbor(meshMap[2], new Vector2(405, 155), 2);
		meshMap[2].addNeighbor(meshMap[0], new Vector2(405, 155), 0);

		hero = new Hero();
		hero.currentMesh = meshMap[0];
		add(hero);

		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	public function findNavMesh(coord : Vector2) : NavMesh {
		for(i in 0...meshMap.length) {
			if(meshMap[i].isInside(coord)) {
				return meshMap[i];
			}
		}
		return null;
	}

	public function findDesiredPath() : Void {
		for(i in 0...meshMap.length) {
			meshMap[i].visited = false;
			meshMap[i].parent = null;
			meshMap[i].flowNumber = -1;
		}

		var open : Array<NavMesh> = new Array<NavMesh>();
		var current : NavMesh = hero.currentMesh;
		var idx : Int = -1;
		current.visited = true;
		current.parent = null;
		open.push(current);

		while(open.length > 0) {
			idx++;
			current = open.shift();
			current.flowNumber = idx;
			var neighbors = current.listOfNeighbors;
			for(i in 0...neighbors.length) {
				var neighbor : NavMesh = meshMap[neighbors[i]];
				if(!neighbor.visited) {
					neighbor.visited = true;
					neighbor.parent = current;
					open.push(neighbor);
				}
			}
		}
	}

	override public function update():Void
	{
		if(FlxG.mouse.justPressed) {
			var mouseVec = new Vector2(FlxG.mouse.screenX, FlxG.mouse.screenY);
			hero.clearTargets();
			var desiredMesh : NavMesh = findNavMesh(mouseVec);
			if(hero.currentMesh == desiredMesh) {
				hero.addTarget(desiredMesh, mouseVec);
			} else {
				findDesiredPath();
				var current = desiredMesh;
				var list = new Array<NavMesh>();
				while(current.parent != null) {
					list.push(current);
					current = current.parent;
				}
				list.reverse();
				for(i in 0...list.length) {
					current = list[i];
					hero.addTarget(current, current.neighbors.get(current.parent));
					current = current.parent;
				}
				hero.addTarget(desiredMesh, mouseVec);
			}
		}
		super.update();
	}	
}
