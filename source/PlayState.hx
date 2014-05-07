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
	var house : House;
	var meshMap : Array<NavMesh>;

	override public function create():Void
	{
		meshMap = new Array<NavMesh>();

		var points = new Array<Vector2>();
		points.push(new Vector2(10, 190));
		points.push(new Vector2(500, 190));
		points.push(new Vector2(500, 230));
		points.push(new Vector2(10, 230));
		meshMap.push(new NavMesh(points));

		points = new Array<Vector2>();
		points.push(new Vector2(510, 190));
		points.push(new Vector2(620, 190));
		points.push(new Vector2(620, 400));
		points.push(new Vector2(510, 400));
		meshMap.push(new NavMesh(points));

		meshMap[0].addNeighbor(meshMap[1], new Vector2(505, 210), 1);
		meshMap[1].addNeighbor(meshMap[0], new Vector2(505, 210), 0);

		house = new House(-70, -80);
		add(house);
		
		hero = new Hero(550, 350);
		hero.currentMesh = meshMap[1];
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
			trace("X:" + FlxG.mouse.screenX + ", Y:" + FlxG.mouse.screenY);
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
