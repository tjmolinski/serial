package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flash.display.*;

class NavMesh extends FlxObject {

	private var points : Array<Vector2>;
	public var canvas : Graphics;
	public var shape : Shape;

	public function new(newPoints : Array<Vector2>) {
		super();
		points = newPoints;
		shape = new Shape();
		canvas = shape.graphics;

		canvas.beginFill(0xFF0000, 0.5);
		canvas.moveTo(points[0].x, points[0].y);
		for(i in 0...(points.length)) {
			canvas.lineTo(points[i].x, points[i].y);
		}
		canvas.endFill();
		flash.Lib.current.addChild(shape);
	}

	public function isConcave() : Bool {
		var pos : Int = 0;
		var neg : Int = 0;
		var length :Int = points.length;

		for(i in 0...length) {
			var p0 = points[i];
			var p1 = points[(i+1) % length];
			var p2 = points[(i+2) % length];

			var v0 = new Vector2(p0.x - p1.x, p0.y - p1.y);
			var v1 = new Vector2(p1.x - p2.x, p1.y - p2.y);
			var cross = (v0.x * v1.y) - (v0.y * v1.x);

			if(cross < 0) {
				neg += 1;
			} else {
				pos += 1;
			}
		}

		return (neg != 0 && pos != 0);
	}

	public function isInside(target : Vector2) : Bool {
		var inside : Bool = false;
		var length : Int = points.length;
		var i : Int = 0;
		var j : Int = length-1;
		while(i < length) {
			if((((points[i].y <= target.y) && (target.y < points[j].y)) ||
				((points[j].y <= target.y) && (target.y < points[i].y))) &&
				(target.x < (points[j].x - points[i].x) * (target.y - points[i].y) / (points[j].y - points[i].y) + points[i].x)) {
				inside = !inside;
			}
			j = i++;
		}
		return inside;
	}
}
