package ;

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;

class StarBackground extends FlxSprite
{

	private var _canvas:BitmapData;
	private var _stars:Array<Star>;
	private var _depthColours:Array<Int>;
	public var starXOffset:Float = 1;
	public var starYOffset:Float = 0;
	private var _delay:Float = .1;
	
	
	public function new(X:Int = 0, Y:Int = 0, Width:Int, Height:Int) 
	{
		super(X,Y);
		_canvas = new BitmapData(Width, Height, false, FlxColor.BLACK);
		width = Width;
		height = Height;
		_stars = new Array<Star>();
		var star:Star;
		for (i in 0...200)
		{
			star = new Star(i,Std.int(FlxRandom.intRanged(0,Width)), Std.int(FlxRandom.intRanged(0, Height)));
			_stars.push(star);
		}
		_depthColours = FlxGradient.createGradientArray(1, 10, [0xff585858, 0xffF4F4F4]);
		
	}
	
	private function updateStarfield():Void
	{
		if (FlxRandom.chanceRoll(5))
		{
			_flashRect.setTo(0, FlxRandom.floatRanged(0,height), FlxG.width, 2);
			_canvas.fillRect(_flashRect, _depthColours[FlxRandom.intRanged(6,9)]);	
		}
		
		for (s in _stars)
		{
			s.x += Std.int((starXOffset * s.speed));
			s.y += Std.int((starYOffset * s.speed));
			
			
		
			if (s.speed > 8)
			{
				_flashRect.setTo(s.x, s.y, 3, 3);
				_canvas.fillRect(_flashRect, _depthColours[s.speed - 1]);	
			}
			else if (s.speed > 6)
			{
				_flashRect.setTo(s.x, s.y, 2, 2);
				_canvas.fillRect(_flashRect, _depthColours[s.speed - 1]);
			}
			else
			{
				_canvas.setPixel32(s.x, s.y, _depthColours[s.speed - 1]);
			}
			if (s.x > width)
				s.x = 0;
			else if (s.x < 0)
				s.x = Std.int(width);
			if (s.y > height)
				s.y = 0;
			else if (s.y < 0)
				s.y = Std.int(height);
		}
	}
	
	override public function draw():Void 
	{
		
			_canvas.lock();
			_canvas.fillRect(_canvas.rect, FlxColor.BLACK);
			updateStarfield();
			_canvas.unlock();
			
			pixels = _canvas;
			updateFrameData();
		
		super.draw();
	}
	
}