package;

class Vector2 {
	public var x : Float;
	public var y : Float;

	public function new(newX : Float, newY : Float) {
		x = newX;
		y = newY;
	}

	public function dot(other : Vector2) : Float {
		return (x*other.x) + (y*other.y);
	}

	public static function getClosestPoint(a : Vector2, b : Vector2, p : Vector2) : Vector2 {
		var aToP = new Vector2(p.x-a.x, p.y-a.y);
		var aToB = new Vector2(b.x-a.x, b.y-a.y);
		var aToBSqr = (aToB.x*aToB.x) + (aToB.y*aToB.y);
		var dot = aToP.dot(aToB);
		var t = dot/aToBSqr;
		var newX = a.x + (aToB.x*t);
		var newY = a.y + (aToB.y*t);
		//TODO:
		////////////PUT THIS IN A CLAMP FUNCTION////
		if(a.x < b.x) {
			if(newX < a.x) {
				newX = a.x;
			}
		} else {
			if(newX < b.x) {
				newX = b.x;
			}
		}
		if(a.x > b.x) {
			if(newX > a.x) {
				newX = a.x;
			}
		} else {
			if(newX > b.x) {
				newX = b.x;
			}
		}
		if(a.y < b.y) {
			if(newY < a.y) {
				newY = a.y;
			}
		} else {
			if(newY < b.y) {
				newY = b.y;
			}
		}
		if(a.y > b.y) {
			if(newY > a.y) {
				newY = a.y;
			}
		} else {
			if(newY > b.y) {
				newY = b.y;
			}
		}
		////////////////
		return new Vector2(newX, newY);
	}
}
