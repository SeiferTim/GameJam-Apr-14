package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

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
		alpha = FlxG.random.float(.6, .99);
		velocity.set(100, 0);
		velocity.rotate(FlxPoint.weak(), FlxG.random.float(178, 182));
		_lifespan = FlxG.random.float(.9, 1.2);
	}

	override public function update(elapsed:Float):Void 
	{
		if (!alive || !exists)
			return;
		if (alpha <= 0)
			kill();
		else
			alpha -= elapsed * .8;
		super.update(elapsed);
	}
	
}