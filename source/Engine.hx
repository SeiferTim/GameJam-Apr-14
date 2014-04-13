package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;

class Engine extends FlxSprite
{

	var _lifespan:Float;
	
	public function new() 
	{
		super(0, 0, "images/engine.png");
		reset(0, 0);
	}
	
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		alpha = FlxRandom.floatRanged(.6, .99);
		velocity = FlxAngle.rotatePoint(100, 0, 0, 0, FlxRandom.floatRanged(178, 182));
		_lifespan = FlxRandom.floatRanged(.9, 1.2);
	}

	override public function update():Void 
	{
		if (!alive || !exists)
			return;
		if (alpha <= 0)
			kill();
		else
			alpha -= FlxG.elapsed*.8;
		super.update();
	}
	
}