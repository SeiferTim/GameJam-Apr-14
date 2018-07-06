package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxAxes;
import flixel.util.FlxColor;

#if desktop
import flixel.ui.FlxButton;
#end

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var _btnPlay:GameButton;
	private var _loaded:Bool = false;
	
	private var _logo:FlxSprite;
	
	#if desktop
	private var _btnFS:FlxButton;
	private var _btnClose:FlxButton;
	#end
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.log.redirectTraces = true;
		Reg.init();
		
		var stars:StarBackground = new StarBackground(0, 0, Std.int(FlxG.width * 1.5), Std.int(FlxG.height * 1.5),500);
		stars.screenCenter(FlxAxes.XY);
		//stars.starXOffset = 100;
		stars.angularVelocity = 6;
		add(stars);
		
		_logo = new FlxSprite(0, 0, "assets/images/logo.png");
		_logo.screenCenter(FlxAxes.XY);
		_logo.alpha = 0;
		add(_logo);
		
		_btnPlay = new GameButton(0, 0, "Play", goPlay, GameButton.STYLE_BLUE, true, 0, 0, 32);
		_btnPlay.screenCenter(FlxAxes.X);
		_btnPlay.y = FlxG.height - _btnPlay.height - 10;
		_btnPlay.onUp.sound = null;
		_btnPlay.alpha = 0;
		add(_btnPlay);
		
		#if desktop
		_btnClose = new FlxButton(FlxG.width - 40, 8, "", Reg.exit);
		_btnClose.loadGraphic("assets/images/close.png", true, 32, 32);
		add(_btnClose);
		_btnFS = new FlxButton(FlxG.width - 76, 8, "", Reg.fullscreen);
		_btnFS.loadGraphic("assets/images/fullscreen.png", true, 32, 32);
		add(_btnFS);
		#end
		
		
		GameControls.newState([_btnPlay]);
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true, doneFadeIn);
		
		Reg.PlayMusic("theme", .2);
		
		super.create();
	}
		
	private function goPlay():Void
	{
		if (!_loaded)
		{
			return; 
		}
		Reg.PlaySound("sounds/Play-Button.wav");
		
		FlxG.camera.fade(FlxColor.BLACK, .33,false, doneFadeOut);
	}
	
	private function doneFadeOut():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	private function doneFadeIn():Void
	{
		_loaded = true;
		GameControls.canInteract = true;
		FlxTween.num(0, 1, 1, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut }, logoAlpha);
		FlxTween.num(0, 1, .66, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, startDelay: .66 }, btnAlpha);
	}
	
	
	private function btnAlpha(Value:Float):Void
	{
		_btnPlay.alpha = Value;
	}
	
	private function logoAlpha(Value:Float):Void
	{
		_logo.alpha = Value;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		GameControls.checkScreenControls();
		
		super.update(elapsed);
		
		
		
	}	
}