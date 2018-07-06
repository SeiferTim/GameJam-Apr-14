package ;

import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class MadeInSTLState extends FlxState
{

	private var _sprArch:FlxSprite;
	//private var _txtText:GameFont;
	//private var _txtWave:FlxWaveSprite;
	private var _txtWave:FlxSprite;
	private var _sprArchWave:FlxWaveEffect;
	private var _startYA:Float;
	private var _startYB:Float;
	private var timer:FlxTimer;
	private var effSprite:FlxEffectSprite;
	
	override public function create():Void 
	{
		
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		
		
		bgColor = FlxColor.BLACK;
		
		_sprArch = new FlxSprite(0, 0, "images/arch.png");
		_sprArch.screenCenter(FlxAxes.XY);
		_sprArchWave = new FlxWaveEffect(FlxWaveMode.ALL, 10, 0.5, 3, 5, FlxWaveDirection.HORIZONTAL); //new FlxWaveSprite(_sprArch, WaveMode.ALL, 500);
		effSprite = new FlxEffectSprite(_sprArch, [_sprArchWave]);
		effSprite.alpha = 0;
		effSprite.setPosition(_sprArch.x, _sprArch.y);
		add(effSprite);
		
		//_txtText = new GameFont(0, 0, "Made in Saint Louis", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLERED, "center",100);
		
		//_txtText.y = _sprArch.y - (_txtText.height *.25) + _sprArch.height - _txtText.height;
		//_txtWave = new FlxWaveSprite(_txtText, WaveMode.ALL, 500,10);
		
		_txtWave = new FlxSprite(0, 0, "images/madeinstl.png");
		_txtWave.screenCenter(FlxAxes.XY);
		_txtWave.y = _sprArch.y - (_txtWave.height *.25) + _sprArch.height - _txtWave.height;
		_txtWave.alpha = 0;
		add(_txtWave);
		
		_startYA = effSprite.y;
		_sprArch.y += 40;
		_startYB = _txtWave.y;
		_txtWave.y += 40;
		
		//add(_txtText);
		
		//FlxTimer.start(1, doFirstFlash);
		
		timer = new FlxTimer();
		
		fadeIn();
		
		super.create();
	}
	
	
	
	private function fadeIn():Void
	{
		
		FlxTween.tween(effSprite, { alpha:1,  y:_startYA }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.sineInOut } );
		FlxTween.tween(_sprArchWave, {strength:0}, 1, { type:FlxTween.ONESHOT, ease:FlxEase.sineInOut } );
		
		timer.start(.66, doTextIn);
	}
	
	private function doTextIn(T:FlxTimer):Void
	{
		FlxG.sound.play("sounds/madeinstl.wav", 1, false, true, doneMadeInSound);
		
		FlxTween.tween(_txtWave, { alpha:.8, y:_startYB }, 1, { type:FlxTween.ONESHOT, ease:FlxEase.sineInOut } );
		
	}
	
	
	private function doneMadeInSound():Void
	{
		timer.start(1, goFadeOut);
	}
	
	private function goFadeOut(T:FlxTimer):Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .66, false, doneFadeOut);
	}
	
	private function doneFadeOut():Void
	{
		FlxG.switchState(new MenuState());
	}
	
}