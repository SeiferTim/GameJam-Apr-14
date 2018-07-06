package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.system.scaleModes.RatioScaleMode;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		#if !debug
		addChild(new FlxGame(960, 540, MadeInSTLState, 1, 60, 60, false, true));
		#else
		addChild(new FlxGame(960, 540, MenuState, 1, 60, 60, true, true));
		#end
		FlxG.scaleMode = new RatioScaleMode();
	}
}
