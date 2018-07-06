package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
using StringTools;

class EndState extends FlxState
{

	private var _loaded:Bool = false;
	
	private var _grpHorses:FlxTypedGroup<HorseDance>;
	private var _grpBack:FlxGroup;
	private var _grpFloat:FlxTypedGroup<HorseDance>;
	private var _grpFloat2:FlxTypedGroup<HorseDance>;
	private var _mars:FlxSprite;
	private var timer:FlxTimer;
	private var horseTimer:FlxTimer;
	
	
	private var _strMission:String = "MISSION COMPLETE\n\n[flags]\nGreat Job...?";
	private var _txtEnd:GameFont;
	
	private var _curMessage:Int = 0;
	private var _messages:Array<String>=[];
	
	override public function create():Void 
	{
		
		var stars = new StarBackground(0, 0, FlxG.width, FlxG.height, 500);
		stars.starXOffset = -.2;
		stars.starYOffset = -.6;
		add(stars);
		
		_grpFloat = new FlxTypedGroup<HorseDance>();
		_grpFloat2 = new FlxTypedGroup<HorseDance>();
		_grpBack = new FlxGroup();
		_grpHorses = new FlxTypedGroup<HorseDance>();
		
		add(_grpFloat);
		
		
		_mars = new FlxSprite(0, FlxG.height, "images/mars.png");
		_mars.screenCenter(FlxAxes.X);
		add(_mars);
		add(_grpFloat2);
		add(_grpBack);
		
		
		add(_grpHorses);
		
		
		_txtEnd = new GameFont(0, 0, "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEWHITE, "center", 32);
		_txtEnd.alpha = 0;
		add(_txtEnd);
		_txtEnd.text = _strMission.replace("[flags]", Reg.flags.join("\n"));
		_txtEnd.screenCenter(FlxAxes.XY);
		
		_messages.push("Credits");
		_messages.push("Team Lead / Programming\n\nTim I Hely");
		_messages.push("Art\n\nCam Vo");
		_messages.push("Writing\n\nDakota Jones");
		_messages.push("Design\n\nJevion White");
		_messages.push("Design\n\nRyan Winzen");
		_messages.push("Music\n\nFat Bard");
		_messages.push("End Music\n\nKevin MacLeod\n(ie: Found on Internet)");
		_messages.push("Thanks for Playing!");
		
		timer = new FlxTimer();
		horseTimer = new FlxTimer();
		
		FlxG.camera.fade(FlxColor.BLACK, 1, true, doneFadeIn);
		
		GameControls.newState([]);
		
		super.create();
		
	}
	
	private function addHorses(T:FlxTimer):Void
	{
		var h:HorseDance = _grpHorses.recycle();
		
		if (h == null)
		{
			h = new HorseDance();
		}
		h.x = -42;
		h.y = 10;
		h.facing = FlxObject.RIGHT;
		h.velocity.x = 40;
		_grpHorses.add(h);
	
		
		h = _grpHorses.recycle();
		
		if (h == null)
		{
			h = new HorseDance();
		}
		h.x = FlxG.width;
		h.y = 57;
		h.facing = FlxObject.LEFT;
		h.velocity.x = -40;
		_grpHorses.add(h);
		
		
		
		h = _grpHorses.recycle();
		
		if (h == null)
		{
			h = new HorseDance();
		}
		h.x = -42;
		h.y = FlxG.height - 57 - 42;
		h.facing = FlxObject.RIGHT;
		h.velocity.x = 40;
		_grpHorses.add(h);

		
		h = _grpHorses.recycle();

		if (h == null)
		{
			h = new HorseDance();
		}
		h.x = FlxG.width;
		h.y = FlxG.height - 52;
		h.facing = FlxObject.LEFT;
		h.velocity.x = -40;
		_grpHorses.add(h);
		
		
		for (i in 0...3)
		{
			h = _grpFloat.recycle();
			if (h == null)
				h = new HorseDance();
			//var side:Int = FlxG.random.int(0, 4);
			if (FlxG.random.bool())
			{
				h.x = FlxG.random.bool() ? -41 : FlxG.width-1;
				h.y = FlxG.random.int( -41, FlxG.height-1);
			}
			else
			{
				h.x = FlxG.random.int( -41, FlxG.width-1);
				h.y = FlxG.random.bool() ? -41 : FlxG.height-1;		
			}
			
			h.angularVelocity = FlxG.random.int(10, 100) * FlxG.random.sign();
			h.velocity.x = FlxG.random.int(10, 100) * FlxG.random.sign();
			h.velocity.y = FlxG.random.int(10, 100) * FlxG.random.sign();
			_grpFloat.add(h);
		}
		for (i in 0...3)
		{
			h = _grpFloat2.recycle();
			if (h == null)
				h = new HorseDance();
			//var side:Int = FlxG.random.int(0, 4);
			if (FlxG.random.bool())
			{
				h.x = FlxG.random.bool() ? -41 : FlxG.width-1;
				h.y = FlxG.random.int( -41, FlxG.height-1);
			}
			else
			{
				h.x = FlxG.random.int( -41, FlxG.width-1);
				h.y = FlxG.random.bool() ? -41 : FlxG.height-1;		
			}
			
			h.angularVelocity = FlxG.random.int(10, 100) * FlxG.random.sign();
			h.velocity.x = FlxG.random.int(10, 100) * FlxG.random.sign();
			h.velocity.y = FlxG.random.int(10, 100) * FlxG.random.sign();
			_grpFloat2.add(h);
		}
	}
	
	private function doneFadeIn():Void
	{
		_loaded = true;
		GameControls.canInteract = true;
		FlxTween.num(0, 380, 5, { type:FlxTween.ONESHOT, ease:FlxEase.sineOut, onComplete:doneMarsUp }, marsUp);
		FlxTween.num(0, 1, .33, { type:FlxTween.ONESHOT, ease:FlxEase.sineInOut, onComplete:doneFirstMessage }, txtAlpha);
	}
	
	private function txtAlpha(Value:Float):Void
	{
		_txtEnd.alpha = Value;
	}
	
	private function doneFirstMessage(T:FlxTween):Void
	{
		
		timer.start(5, doneWaiting, 1);
	}
	
	private function doneWaiting(T:FlxTimer):Void
	{
		FlxTween.num(1, 0, .33, { type:FlxTween.ONESHOT, ease:FlxEase.sineInOut, onComplete:doneFirstMessageOut }, txtAlpha);
	}
	
	private function doneFirstMessageOut(T:FlxTween):Void
	{
		showMessage();
	}
	
	private function showMessage():Void
	{
		_txtEnd.x = FlxG.width;
		_txtEnd.alpha = 1;
		_txtEnd.text = _messages[_curMessage];
		_txtEnd.screenCenter(FlxAxes.Y);
		FlxTween.num(_txtEnd.x, (FlxG.width / 2) - (_txtEnd.width / 2), .33, { type:FlxTween.ONESHOT, ease:FlxEase.bounceOut, onComplete:doneShowMessage }, txtX);
	}
	
	private function txtX(Value:Float):Void
	{
		_txtEnd.x = Value;
	}
	
	private function doneShowMessage(T:FlxTween):Void
	{
		timer.start(2, messageWait);
	}
	
	private function messageWait(T:FlxTimer):Void
	{
		FlxTween.num(_txtEnd.x, -_txtEnd.width, .33, { type:FlxTween.ONESHOT, ease:FlxEase.backIn, onComplete:doneShowMessageTwo }, txtX);
	}
	
	private function doneShowMessageTwo(T:FlxTween):Void
	{
		if (_curMessage < _messages.length)
		{
			_curMessage++;
			showMessage();
		}
		else
		{
			_txtEnd.kill();
			_txtEnd = new GameFont(0, 0, "AETHON\n\nMission to Mars", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEYELLOW, "center", 48);
			_txtEnd.alpha = 0;
			_txtEnd.screenCenter(FlxAxes.XY);
			add(_txtEnd);
			FlxTween.num(0, 1, .2, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut }, txtAlpha);
		}
	}
	
	private function marsUp(Value:Float):Void
	{
		_mars.y = FlxG.height - Value;
	}
	
	private function doneMarsUp(T:FlxTween):Void
	{
		FlxTween.num(1, 0, .66, { type:FlxTween.ONESHOT, onComplete:musicOut }, musicVol);
		_grpBack.add(new ColorThing(8, FlxObject.LEFT));
		_grpBack.add(new ColorThing(55, FlxObject.RIGHT));
		_grpBack.add(new ColorThing(FlxG.height - 57 - 42 - 2, FlxObject.LEFT));
		_grpBack.add(new ColorThing(FlxG.height - 54, FlxObject.RIGHT));
		horseTimer.start(1, addHorses,0);
	}
	
	private function musicOut(T:FlxTween):Void
	{
		
		Reg.PlayMusic("ending");
		FlxG.sound.music.volume = 1;
	}
	
	private function musicVol(Value:Float):Void
	{
		FlxG.sound.music.volume = Value;
	}
	
}