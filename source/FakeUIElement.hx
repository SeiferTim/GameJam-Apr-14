package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class FakeUIElement extends FlxSprite implements IUIElement
{

	public var selected:Bool = false;
	public var toggled(default, set):Bool = false;
	public var onX:Void->Void;
	public var onInput:Int->Void;
	
	private var _keepToggled:Bool = true;
	
	public static inline var CLICK_EVENT:String = "click_button";
	public static inline var OVER_EVENT:String = "over_button";
	public static inline var DOWN_EVENT:String = "down_button";
	public static inline var OUT_EVENT:String = "out_button";
	
	public var overSound:String = "";
	public var upSound:String = "";
	
	public function new(X:Float = 0, Y:Float = 0, Width:Int = 1, Height:Int = 1, OnX:Void->Void=null, OnInput:Int->Void=null, KeepToggled:Bool = true, OverSound:String = "", UpSound:String = "")
	{
		super(X, Y);
		onX = OnX;
		onInput = OnInput;
		overSound = OverSound;
		upSound = UpSound;
		_keepToggled = KeepToggled;
		width = Width;
		height = Height;
		makeGraphic(Std.int(width), Std.int(height), 0x0);
		FlxSpriteUtil.drawRoundRect(this, 0, 0, width, height, 10, 10, FlxColor.WHITE);
		alpha = .6;
		visible = false;
		selected = false;
		toggled = false;
	}
	
	public function forceStateHandler(event:String):Void {
		switch(event) {
			case CLICK_EVENT:	onUpHandler();
		}
	}

	
	private function onUpHandler():Void
	{
		if (!toggled)
		{
			if (upSound != "")
				FlxG.sound.play(upSound);
			if (onX != null)
				onX();
		}
		if(_keepToggled)
			toggled = !toggled;
		
	}
	
	public function input(Input:Int = 0):Void
	{
		if (onInput!=null)
			onInput(Input);
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		if (selected)
		{
			alpha = .6;
			visible = true;
			if (toggled)
			{
				alpha = .8;
				
			}
		}
		else
		{
			visible = false;
		}

		super.update(elapsed);
	}
	
	private function set_toggled(Value:Bool):Bool
	{
		toggled = Value;
		return toggled;
	}
	
}