package;

class Path {
	public var target : Vector2;
	public var current : Int;

	public function new(newTarget : Vector2, newCurrent : Int) {
		target = newTarget;
		current = newCurrent;
	}
}
