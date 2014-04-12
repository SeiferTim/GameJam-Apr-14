package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

class EndState extends FlxState
{

	private var _loaded:Bool = false;
	
	override public function create():Void 
	{
		
		
		FlxG.camera.fade(FlxColor.BLACK, 1, true, doneFadeIn);
		
		GameControls.newState([]);
		
		super.create();
		
	}
	
	private function doneFadeIn():Void
	{
		_loaded = true;
		GameControls.canInteract = true;
	}
	
}