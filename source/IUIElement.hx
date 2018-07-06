package ;

import flixel.FlxCamera;
import flixel.math.FlxPoint;

interface IUIElement
{

	public var selected:Bool;
	public var toggled(default, set):Bool;
	public var active(default, set):Bool;
	public var visible(default, set):Bool;
	public function overlapsPoint(point:FlxPoint, InScreenSpace:Bool = false, ?Camera:FlxCamera):Bool;
	public function forceStateHandler(event:String):Void;
	
}