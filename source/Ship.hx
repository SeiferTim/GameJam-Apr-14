package ;

import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;
using flixel.util.FlxSpriteUtil;

class Ship extends FlxGroup
{

	private var _ship:FlxSprite;
	
	private var _engines:FlxTypedGroup<Engine>;
	
	private var _engine2online:Bool = true;
	private var _engine3online:Bool = true;
	private var _emitted:Bool = false;
	
	public function new(Bounds:FlxRect) 
	{
		super();
		_ship = new FlxSprite(0, 0, "images/ship.png");
		_ship.x = Bounds.x +(Bounds.width / 2) - (_ship.width / 2);
		_ship.y = Bounds.y +(Bounds.height / 2) - (_ship.height / 2);
		
		_engines = new FlxTypedGroup<Engine>(4000);
		add(_engines);
		
		add(_ship);
		
		
		
		FlxTween.num(_ship.y - 20, _ship.y + 20, 4, { type:FlxTween.PINGPONG, ease:FlxEase.quintInOut, loopDelay:1 }, shipY);
	}
	
	private function shipY(Value:Float):Void
	{
		_ship.y = Value;
		
	}
	override public function draw():Void 
	{
		super.draw();
	}
	
	public function problem(Week:Int):Void
	{
		switch(Week)
		{
			case 0:
				
			case 1:
				_engine2online = false;
			case 2:
				
			case 3:
				
			case 4:
				
			case 5:
				_engine3online = false;
			case 6:
				
			case 7:
				
			case 8:
				
			case 9:
		}
	}
	public function fixed(Week:Int):Void
	{
		switch(Week)
		{
			case 0:
				
			case 1:
				_engine2online = true;
			case 2:
				
			case 3:
				
			case 4:
				
			case 5:
				_engine3online = true;
			case 6:
				
			case 7:
				
			case 8:
				
			case 9:
		}
	}
	
	override public function update():Void 
	{
		if (!_emitted)
		{
			
		
			var e:Engine;
			
			for (i in 0...3)
			{
				e = _engines.recycle();
				if (e == null)
				{
					e = new Engine();
				}
				e.reset(_ship.x +20, _ship.y + (_ship.height * .25) + 25 +( i*6)+FlxRandom.intRanged(0,3));
				_engines.add(e);
			}
			
			
			for (i in 0...3)
			{
				if (_engine2online || FlxRandom.chanceRoll(10))
				{
					e  = _engines.recycle();
					if (e == null)
					{
						e = new Engine();
					}
					e.reset(_ship.x +10, _ship.y + (_ship.height * .75)-(i*6)-FlxRandom.intRanged(0,3));
					_engines.add(e);
				}
			}
			
			
			for (i in 0...3)
			{
				if (_engine3online || FlxRandom.chanceRoll(10))
				{
					e = _engines.recycle();
				
					if (e == null)
					{
						e = new Engine();
					}
					e.reset(_ship.x +30, _ship.y + (_ship.height * .5) +( i*6)+FlxRandom.intRanged(0,3));
					_engines.add(e);
				}
			}
		}
		_emitted = !_emitted;
		
		super.update();
	}
}