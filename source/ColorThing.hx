package ;

import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxGradient;

class ColorThing extends FlxGroup
{

	private var _dir:Int;
	private var _y:Int;
	
	private var _head:FlxSprite;
	private var _body1:FlxSprite;
	private var _body2:FlxSprite;
	
	public function new(Y:Int = 0, Dir:Int ) 
	{
		super();
		_y = Y;
		_dir = Dir;
		
		_head = FlxGradient.createGradientFlxSprite(Std.int((FlxG.width / 6) * 10), 46, [0x0, 0x0,0xffffffff,0xffff00ff, 0xffff0000, 0xffffff00, 0xff00ff00, 0xff00ffff, 0xff0000ff,0xffff00ff], 1, _dir == FlxObject.LEFT ? 0:180);
		_body1 = FlxGradient.createGradientFlxSprite(Std.int((FlxG.width / 6) * 8), 46, [0xffff00ff, 0xffff0000, 0xffffff00, 0xff00ff00, 0xff00ffff, 0xff0000ff,0xffff00ff], 1, _dir == FlxObject.LEFT ? 0 : 180);
		_body2 = FlxGradient.createGradientFlxSprite(Std.int((FlxG.width / 6) * 8), 46, [0xffff00ff, 0xffff0000, 0xffffff00, 0xff00ff00, 0xff00ffff, 0xff0000ff,0xffff00ff], 1, _dir == FlxObject.LEFT ? 0 : 180);
		_head.alpha = _body1.alpha = _body2.alpha = .8;
		_head.blend = _body1.blend = _body2.blend = BlendMode.SCREEN;
		add(_head);
		add(_body1);
		add(_body2);
		
		_head.y = _body1.y = _body2.y = _y;
		
		if (_dir == FlxObject.LEFT)
		{
			_head.x = FlxG.width;
			_body1.x = _head.x + _head.width-1;
			_body2.x = _body1.x + _body1.width-1;
			_head.velocity.x = _body1.velocity.x = _body2.velocity.x = -600;
		}
		else
		{
			_head.x = -_head.width;
			_body1.x = _head.x - _body1.width+1;
			_body2.x = _body1.x - _body2.width+1;
			_head.velocity.x = _body1.velocity.x = _body2.velocity.x = 600;
		}
		
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (_dir == FlxObject.LEFT)
		{
			if (_head.x <= -_head.width)
				_head.kill();
			if (_body1.x <= -_body1.width)
				_body1.x = _body2.x + _body2.width - 1;
			if (_body2.x <= -_body2.width)
				_body2.x = _body1.x + _body1.width -1;
				
		}
		else
		{
			if (_head.x >= FlxG.width)
				_head.kill();
				
			if (_body1.x >= FlxG.width)
				_body1.x = _body2.x - _body1.width + 1;
			
			if (_body2.x >= FlxG.width)
				_body2.x = _body1.x - _body2.width + 1;
		}
		
		super.update(elapsed);
	}
	
}