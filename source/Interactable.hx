package;

import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.*;
import flixel.plugin.MouseEventManager;

class Interactable extends FlxSprite {

	private var callback : Dynamic;

	public function new(asset : String, newX : Int, newY : Int, cb : Dynamic) {
		super(newX, newY);
		loadGraphic(asset);
		callback = cb;
		scale.set(0.1, 0.1);
		updateHitbox();
		MouseEventManager.add(this, onMouseDown, onMouseUp, onMouseOver, onMouseOut, false, true, false);
	}

	private function onMouseDown(sprite : FlxSprite) {
	}
	private function onMouseUp(sprite : FlxSprite) {
		callback();
	}
	private function onMouseOver(sprite : FlxSprite) {
	}
	private function onMouseOut(sprite : FlxSprite) {
	}
}
