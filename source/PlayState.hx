package;

import flixel.*;
import flixel.text.FlxText;
import flixel.util.*;
import flixel.plugin.MouseEventManager;
import flixel.group.FlxTypedGroup;

class PlayState extends FlxState
{
	public var hero : Hero;
	var victim : Victim;
	var house : House;
	var breakInto : Interactable;
	var door : Interactable;
	var meshMap : Array<NavMesh>;
	var objective : FlxText;
	public var container : FlxTypedGroup<ExtendedSprite>;

	override public function create():Void
	{
		FlxG.debugger.visible = true;
		FlxG.plugins.add(new MouseEventManager());
		meshMap = new Array<NavMesh>();
		container = new FlxTypedGroup<ExtendedSprite>();

		var points = new Array<Vector2>();
	       	points.push(new Vector2(390, 380));
		points.push(new Vector2(620, 380));
		points.push(new Vector2(620, 390));
		points.push(new Vector2(390, 390));
		meshMap.push(new NavMesh(points));

		hero = new Hero(550, 370);
		hero.currentMesh = meshMap[0];
		hero._z = -2;
		container.add(hero);

		victim = new Victim(15, 385);
		victim.addTarget(new Vector2(15, 385));
		victim.addTarget(new Vector2(380, 385));
		victim._z = -1;
		container.add(victim);

		house = new House(-200, 100);
		house._z = 5;
		container.add(house);

		breakInto = new Interactable("images/Interactable.png", 400, 310, onBreakIntoClick);
		breakInto._z = -5;
		container.add(breakInto);

		door = new Interactable("images/door.png", 180, 280, onEnterDoorway);
		breakInto._z = 0;
		container.add(door);

		container.sort(sortByZ);
		add(container);

		objective = new FlxText((FlxG.width/2)-50, FlxG.height - 20, 300, "Break Into The House");
		objective.setFormat(null, 12, FlxColor.WHITE, "left", 1, FlxColor.BLACK);
		add(objective);

		super.create();
	}

	private function sortByZ(order : Int, sprite1 : ExtendedSprite, sprite2 : ExtendedSprite) : Int {
		return FlxSort.byValues(order, sprite1._z, sprite2._z);
	}

	private function onBreakIntoClick() : Void {
		house.breakInto();
		house._z = -5;
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
		points.push(new Vector2(10, 380));
		points.push(new Vector2(10, 390));
		points.push(new Vector2(390, 390));
		points.push(new Vector2(390, 380));
		meshMap.push(new NavMesh(points));

		meshMap[0].addNeighbor(meshMap[1], new Vector2(390, 385), 1);
		meshMap[1].addNeighbor(meshMap[0], new Vector2(390, 385), 0);
	}

	public function getClosestNavMesh(coord : Vector2) : Vector2 {
		var closest : Float;
		var desiredPoint : Vector2 = new Vector2(0, 0);
		//TODO: Clean this shit up
		for(i in 0...meshMap.length) {
			var points = meshMap[i].points;
			var a = Vector2.getClosestPoint(points[0], points[1], coord);
			var b = Vector2.getClosestPoint(points[0], points[2], coord);
			var c = Vector2.getClosestPoint(points[3], points[1], coord);
			var d = Vector2.getClosestPoint(points[3], points[2], coord);
			var distA = Vector2.getDistance(a, coord);
			var distB = Vector2.getDistance(b, coord);
			var distC = Vector2.getDistance(c, coord);
			var distD = Vector2.getDistance(d, coord);
			closest = distA;
			desiredPoint = a;
			if(closest > distB) {
				closest = distB;
				desiredPoint = b;
			}
			if(closest > distC) {
				closest = distC;
				desiredPoint = c;
			}
			if(closest > distD) {
				closest = distD;
				desiredPoint = d;
			}
		}
		//trace(desiredPoint.x + " " + desiredPoint.y);
		return desiredPoint;
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
		if(getDistance(door.x, door.y, hero.x, hero.y) < 125.0) {
			door.revive();
		} else {
			door.kill();
		}

		if(FlxG.mouse.pressed) {
			//trace("X:" + FlxG.mouse.screenX + ", Y:" + FlxG.mouse.screenY);
			//var mousePoint = new Vector2(FlxG.mouse.screenX, FlxG.mouse.screenY);
			//var test = Vector2.getClosestPoint(new Vector2(10, 390), new Vector2(390,390), mousePoint);
			//trace(test.x + " " + test.y);
			var mouseVec = new Vector2(FlxG.mouse.screenX, FlxG.mouse.screenY);
			hero.clearTargets();
			var desiredPoint : Vector2 = mouseVec;
			var desiredMesh : NavMesh = findNavMesh(desiredPoint);
			if(desiredMesh == null) {
				desiredPoint = getClosestNavMesh(mouseVec);
				desiredMesh = findNavMesh(desiredPoint);
			}

			if(hero.currentMesh == desiredMesh) {
				hero.addTarget(desiredMesh, desiredPoint);
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
				hero.addTarget(desiredMesh, desiredPoint);
			}
		}
		super.update();
	}	
}
