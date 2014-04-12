package ;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;


class Star
{

	public var index:Int;
	public var x:Int;
	public var y:Int;
	public var d:Int;
	public var r:Float;
	public var alpha:Float;
	public var speed:Int;
	
	
	public function new(Index:Int, X:Int, Y:Int) 
	{
		index = Index;
		x = X;
		y = Y;
		d = 1;
		speed = 1 + Std.int(FlxRandom.float() * 10);
		r = FlxRandom.float() * Math.PI * 2;
		alpha = 0;
		
	}
	
}