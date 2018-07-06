package ;
import flixel.FlxG;

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
		speed = FlxG.random.int(1, 10);
		r = FlxG.random.float(0, Math.PI * 2);
		alpha = 0;
		
	}
	
}