package ;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
using flixel.util.FlxSpriteUtil;

class StatChart extends FlxSprite
{

	private var _points:Array<FlxPoint>;
	
	public function new(X:Float=0, Y:Float=0, P:Player) 
	{
		super(X, Y);
		makeGraphic(120, 120, 0x0,true);
		_points = new Array<FlxPoint>();
		
		for (i in 0...5)
		{
			_points.push(FlxPoint.get(60,0));
			
			_points[i].rotate(FlxPoint.weak(), ((360 / 5)*i));
			_points[i].x += 60;
			_points[i].y += 60;
			
		}
		this.drawPolygon(_points, 0x11003399, { color: 0x66003399, thickness:2 } );
		
		for (j in 0...12)
		{
			_points = new Array<FlxPoint>();
			for (i in 0...5)
			{
				_points.push(FlxPoint.get(j*5, 0));
				
				_points[i].rotate(FlxPoint.weak(), ((360 / 5) * i) - 90);
				_points[i].x += 60;
				_points[i].y += 60;
				
			}
			this.drawPolygon(_points, 0x0, { color: 0x66003399, thickness:1 } );
		}
		
		
		
		_points = new Array<FlxPoint>();
		
		for (i in 0...5)
		{
			_points.push(FlxPoint.get(P.stats[i]*6, 0));
			
			_points[i].rotate(FlxPoint.weak(), ((360 / 5)*i)-90);
			_points[i].x += 60;
			_points[i].y += 60;
			
		}
		
		this.drawPolygon(_points, 0x3300ff00, { color: 0xff00ff00, thickness:4 } );
		
		_points = new Array<FlxPoint>();
		for (i in 0...6)
		{
			_points.push(FlxPoint.get(56, 0));
			
			_points[i].rotate(FlxPoint.weak(), ((360 / 5)*i)-90);
			_points[i].x += 60;
			_points[i].y += 60;
			
		}
		
		this.drawCircle(_points[0].x, _points[0].y, 4, 0xffff00ff);
		this.drawCircle(_points[1].x, _points[1].y, 4, 0xff00ff00);
		this.drawCircle(_points[2].x, _points[2].y, 4, 0xff0000ff);
		this.drawCircle(_points[3].x, _points[3].y, 4, 0xffff0000);
		this.drawCircle(_points[4].x, _points[4].y, 4, 0xffffff00);
		
		dirty = true;
	}
	
}