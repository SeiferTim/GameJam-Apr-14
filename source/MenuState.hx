package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var _btnPlay:GameButton;
	private var _loaded:Bool = false;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.log.redirectTraces = true;
		Reg.init();
		
		_btnPlay = new GameButton(0, 0, "Play", goPlay, GameButton.STYLE_BLUE, true, 0, 0, 32);
		FlxSpriteUtil.screenCenter(_btnPlay, true, false);
		_btnPlay.y = FlxG.height - _btnPlay.height - 10;
		add(_btnPlay);
		
		GameControls.newState([_btnPlay]);
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true, doneFadeIn);
		
		super.create();
	}
		
	private function goPlay():Void
	{
		if (!_loaded)
		{
			return;
		}
		FlxG.camera.fade(FlxColor.BLACK, .33,false, doneFadeOut);
	}
	
	private function doneFadeOut():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	private function doneFadeIn():Void
	{
		trace("loaded");
		_loaded = true;
		GameControls.canInteract = true;
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
	override public function update():Void
	{
		GameControls.checkScreenControls();
		
		super.update();
		
		
		
	}	
}