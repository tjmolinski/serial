package;

import flixel.*;
import flixel.text.FlxText;
import flixel.util.*;
import flixel.plugin.MouseEventManager;
import flixel.group.FlxTypedGroup;

class PlayState extends FlxState
{
	var hero : Hero;
	var victim : Victim;
	var house : House;
	var breakInto : Interactable;
	var door : Interactable;
	var meshMap : Array<NavMesh>;
	var objective : FlxText;
	var container : FlxTypedGroup<ExtendedSprite>;

	override public function create():Void
	{
		FlxG.debugger.visible = true;
		FlxG.plugins.add(new MouseEventManager());
		meshMap = new Array<NavMesh>();
		container = new FlxTypedGroup<ExtendedSprite>();

		var points = new Array<Vector2>();
		points.push(new Vector2(210, 190));
		points.push(new Vector2(500, 190));
		points.push(new Vector2(500, 220));
		points.push(new Vector2(210, 220));
		meshMap.push(new NavMesh(points));

		points = new Array<Vector2>();
		points.push(new Vector2(510, 190));
		points.push(new Vector2(620, 190));
		points.push(new Vector2(620, 400));
		points.push(new Vector2(510, 400));
		meshMap.push(new NavMesh(points));

		meshMap[0].addNeighbor(meshMap[1], new Vector2(505, 210), 1);
		meshMap[1].addNeighbor(meshMap[0], new Vector2(505, 210), 0);

		hero = new Hero(550, 370);
		hero.currentMesh = meshMap[1];
		hero.z = -2;
		container.add(hero);

		victim = new Victim(180, 204);
		victim.addTarget(new Vector2(80, 203));
		victim.addTarget(new Vector2(180, 204));
		victim.z = -1;
		container.add(victim);

		house = new House(-70, -80);
		house.z = 5;
		container.add(house);

		breakInto = new Interactable("images/Interactable.png", 210, 150, onBreakIntoClick);
		breakInto.z = -5;
		container.add(breakInto);

		door = new Interactable("images/door.png", 125, 125, onEnterDoorway);
		breakInto.z = 0;
		container.add(door);

		container.sort(sortByZ);
		add(container);

		objective = new FlxText((FlxG.width/2)-50, FlxG.height - 20, 300, "Break Into The House");
		objective.setFormat(null, 12, FlxColor.WHITE, "left", 1, FlxColor.BLACK);
		add(objective);

		super.create();
	}

	private function sortByZ(order : Int, sprite1 : ExtendedSprite, sprite2 : ExtendedSprite) : Int {
		return FlxSort.byValues(order, sprite1.z, sprite2.z);
	}

	private function onBreakIntoClick() : Void {
		house.breakInto();
		house.z = -5;
		container.sort(sortByZ);
		addHouseNav();
		breakInto.kill();
		objective.setFormat(null, 12, FlxColor.RED, "left", 2, FlxColor.BLACK);
	}

	private function onEnterDoorway() : Void {
		house.enterDoor();
	}

	public function addHouseNav() : Void {
		var points = new Array<Vector2>();
		points.push(new Vector2(50, 190));
		points.push(new Vector2(210, 190));
		points.push(new Vector2(210, 220));
		points.push(new Vector2(50, 220));
		meshMap.push(new NavMesh(points));
		meshMap[0].addNeighbor(meshMap[2], new Vector2(210, 210), 1);
		meshMap[2].addNeighbor(meshMap[0], new Vector2(210, 210), 1);
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

	public function getDistance(P1X : Float, P1Y : Float,  P2X : Float, P2Y : Float) : Float {
		var XX : Float = P2X - P1X;
		var YY : Float = P2Y - P1Y;
		return Math.sqrt( XX * XX + YY * YY );
	}

	override public function update():Void
	{
		//trace(getDistance(breakInto.x, breakInto.y, hero.x, hero.y));
		if(!house.brokenInto) {
			if(getDistance(breakInto.x, breakInto.y, hero.x, hero.y) < 80.0) {
				breakInto.revive();
			} else {
				breakInto.kill();
			}
		}
		if(getDistance(door.x, door.y, hero.x, hero.y) < 75.0) {
			door.revive();
		} else {
			door.kill();
		}

		if(FlxG.mouse.pressed) {
			//trace("X:" + FlxG.mouse.screenX + ", Y:" + FlxG.mouse.screenY);
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
