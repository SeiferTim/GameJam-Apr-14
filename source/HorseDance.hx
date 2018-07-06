package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class HorseDance extends FlxSprite
{

	private var _bornTimer:Float;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("images/horse-dance.png",  true,  42, 42);
		animation.add("dance", [0, 1, 2, 1], 2);
		animation.play("dance");
		
	}
	
	override public function revive():Void 
	{
		_bornTimer = 1;
		super.revive();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!alive || !exists)
			return;
		if (angularVelocity != 0)
		{
			_bornTimer -= elapsed;
			if(_bornTimer < 0)
				if (!isOnScreen())
					kill();
		}
		else if ((facing == FlxObject.LEFT && x + width < 0) || (facing == FlxObject.RIGHT && x > FlxG.width))
			kill();
		
		super.update(elapsed);
	}
	
}