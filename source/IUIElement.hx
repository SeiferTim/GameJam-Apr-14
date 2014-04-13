package ;

import flixel.FlxCamera;
import flixel.util.FlxPoint;

interface IUIElement
{

	public var selected:Bool;
	public var toggled:Bool;
	public var active(default, set):Bool;
	public var visible(default, set):Bool;
	public function overlapsPoint(point:FlxPoint, InScreenSpace:Bool = false, ?Camera:FlxCamera):Bool;
	public function forceStateHandler(event:String):Void;
	
}