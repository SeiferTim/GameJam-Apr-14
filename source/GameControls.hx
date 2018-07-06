package ;

import flixel.FlxG;

import flixel.math.FlxPoint;

class GameControls
{

	private static var _selButton:Int = -1;
	public static var _lastSelected:Int = -1;
	
	private static var _uis:Array<IUIElement>;
	
	public static inline var INPUT_DELAY:Float = .1;
	
	private static var _pressDelay:Float = .5;
	public static var  canInteract:Bool = false;
	
	private static inline var _sndRoll:String = "sounds/rollover.wav";
	
	
	#if !FLX_NO_MOUSE
	static public inline var MOUSE_SLEEP:Float = 3;
	static public var lastMouseMove:Float=0;
	static public var lastMousePos:FlxPoint;
	#end
	
	public static function init() 
	{
		#if !FLX_NO_MOUSE
		lastMouseMove = 0;
		lastMousePos = FlxPoint.get();
		#end
		_uis = new Array<IUIElement>();
		_lastSelected = -1;
	}

	
	public static function newState(Buttons:Array<IUIElement>):Void
	{
		if (Buttons.length > 0)
			_selButton = 0;
		else
			_selButton = -1;
		_lastSelected = -1;
		_uis = Buttons;
		canInteract = false;
	}
	
	public static function changeUIs(UIs:Array<IUIElement>):Void
	{
		if (_uis != null)
		{
			if (_uis.length > 0)
			{
				for (b in _uis)
				{
					b.selected = false;
					b.toggled = false;
				}
			}
		}
		_lastSelected = -1;
		_uis = UIs;
		_selButton = UIs.length > 0 ? -1 : 0;
	}
	
	public static function checkScreenControls():Void
	{
		#if !FLX_NO_MOUSE
		GameControls.updateMouse();
		#end
		
	
		if (_selButton != _lastSelected)
		{
			if (_uis.length > 0)
			{
				for (b in _uis)
					b.selected = false;
				if (_selButton != -1)
				{
					_uis[_selButton].selected = true;
					FlxG.sound.play(_sndRoll);
				}
			}
			_lastSelected = _selButton;
		}
	}
	
	
	public static function mouseSleep():Void
	{
		#if !FLX_NO_MOUSE
		
		if (FlxG.mouse.visible)
		{
			FlxG.mouse.visible = false;
			lastMouseMove = 0;
		}
		
		#end
	}
	
	#if !FLX_NO_MOUSE
	public static function updateMouse():Void
	{
		if (FlxG.mouse.x == lastMousePos.x && FlxG.mouse.y == lastMousePos.y)
		{	
			if(lastMouseMove > 0)
				lastMouseMove -= FlxG.elapsed;
		}
		else
		{
			lastMouseMove = MOUSE_SLEEP;
			FlxG.mouse.getPosition(lastMousePos);
			
		}
		if (lastMouseMove > 0)
		{
			if (canInteract && !FlxG.mouse.visible)
				FlxG.mouse.visible = true;
		}
		else
		{
			mouseSleep();
		}
		if (FlxG.mouse.visible)
		{
			var overAny:Bool = false;
			for (i in 0..._uis.length)
			{
				if (_uis[i].active)
				{
					if (FlxG.mouse.overlaps(cast _uis[i]))
					{
						_selButton = i;
						if (FlxG.mouse.justReleased)
							_uis[i].forceStateHandler(FakeUIElement.CLICK_EVENT);
						overAny = true;
					}
				}
			}
			if (!overAny)
				_selButton = -1;
		}
	}
	#end
}

enum Direction {
	POSITIVE;
	NEGATIVE;
}