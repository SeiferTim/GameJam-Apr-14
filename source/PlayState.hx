package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import lime.Constants.Window;
using flixel.util.FlxSpriteUtil;
using StringTools;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var STAGE_OPENING:Int = 0;
	private var STAGE_SHOWCHOICES:Int = 1;
	private var STAGE_SHOWOUTCOME:Int = 2;
	private var STAGE_RESOLVE:Int = 3;
	
	
	private var _eventStage:Int = 0;
	private var _eventChoice:Int = 0;
	private var _eventPass:Bool = false;
	private var _eventPlayerNo:Int = -1;
	
	private var _txtChoice1:GameFont;
	private var _txtChoice2:GameFont;
	private var _fakeChoice1:FakeUIElement;
	private var _fakeChoice2:FakeUIElement;
	private var _choices:Array<IUIElement>;
	
	private var  _loaded:Bool = false;
	
	private var _weekNo:Int = 0;
	
	private var _players:Array<Player>;
	
	private var _txtWeek:GameFont;
	private var _strWeek:String = "Week [weekno]";
	
	private var _txtEvent:GameFont;
	private var _eventTxtNo:Int;
	
	private var _btnNext:GameButton;
	
	private var _grpChoices:FlxGroup;
	
	private var _strDesc:String = "The [role] (Player [playerno])";
	private var _txtDesc:GameFont;
	
	private var _strRes:String = "You [gl] 1 [stat].";
	
	private var _stars:StarBackground;
	private var _chart:StatChart;
	
	
	/* Player Role Choose Stuff */
	private var _grpPlayerSelect:FlxGroup;
	
	private var _txtChoose:GameFont;
	private var _strChoose:String = "Player [playerno] Choose a Role";
	private var _playerChooseNo:Int = 0;
	
	private var _choosePlayers:Array<Player>;
	private var _picked:Array<Int> = [];
	
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		
		buildPlayers();
		
		buildPlayerSelect();
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true, doneFadeIn);
		
		super.create();
	}
	
	private function doneFadeIn():Void
	{
		_loaded = true;
		GameControls.canInteract = true;
	}
	
	private function buildPlayerSelect():Void
	{
		_grpPlayerSelect = new FlxGroup();
		
		_grpPlayerSelect.add(new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK));
		
		var fakeUIs:Array<IUIElement> = new Array<IUIElement>();
		var fakeUI:FakeUIElement;
		var txtRole:GameFont;
		var chart:StatChart;
		for (i in 0...5)
		{
			fakeUI = new FakeUIElement(10 + (i * (10 + ((FlxG.width - 60) / 5))), 40, Std.int((FlxG.width - 60) / 5), Std.int(FlxG.height - 50), pickPlayer.bind(i),null, false);
			fakeUIs.push(fakeUI);
			_grpPlayerSelect.add(fakeUI);
			txtRole = new GameFont(0, 0, Enums.getRole(i), GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEBLUE, "center", 18);
			txtRole.x = fakeUI.x + (fakeUI.width / 2) - (txtRole.width / 2);
			txtRole.y = fakeUI.y + 10;
			_grpPlayerSelect.add(txtRole);
			chart = new StatChart(fakeUI.x + (fakeUI.width / 2) - 60, fakeUI.y + fakeUI.height - 130, _choosePlayers[i]);
			_grpPlayerSelect.add(chart);
		}
		
		_txtChoose = new GameFont(0, 10, "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEGOLD, "center", 32);
		
		_grpPlayerSelect.add(_txtChoose);
		
		_txtChoose.text = _strChoose.replace("[playerno]", Std.string(_playerChooseNo + 1));
		_txtChoose.screenCenter(true, false);
		
		add(_grpPlayerSelect);
		
		GameControls.newState(fakeUIs);
	}
	
	private function pickPlayer(WhichPlayer:Int):Void
	{
		if (_picked.indexOf(WhichPlayer) == -1)
		{
			_picked.push(WhichPlayer);
			_players.push(_choosePlayers[WhichPlayer]);
			_players[_players.length - 1].role = WhichPlayer;
			FlxG.camera.flash(0x66ffffff, .33, true);
			_playerChooseNo++;
			if (_playerChooseNo > 4)
			{
				FlxG.camera.fade(FlxColor.BLACK, .66, false, doneChoose);
				GameControls.canInteract = false;
			}
			else
			{
				_txtChoose.text = _strChoose.replace("[playerno]", Std.string(_playerChooseNo + 1));
			}
		}
	}
	
	private function doneChoose():Void
	{
		_grpPlayerSelect.kill();
		
		_stars = new StarBackground(20, 20, FlxG.width - 40, 200);
		_stars.starXOffset = .6;
		add(_stars);
		
		// add the game interface!
		
		_txtWeek = new GameFont(10, 10, _strWeek.replace("[weekno]", Std.string(_weekNo+1)), GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEGOLD, "left", 18,0);
		add(_txtWeek);
		
		_txtEvent = new GameFont(10, FlxG.height * 0.7, "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEWHITE, "left", 22, Std.int(FlxG.width-20));
		add(_txtEvent);
		
		_btnNext = new GameButton(0, 0, "NEXT", advanceEvent, GameButton.STYLE_GREEN, true, 0, 0, 18);
		_btnNext.x = FlxG.width - _btnNext.width - 10;
		_btnNext.y = FlxG.height - _btnNext.height - 10;
		_btnNext.alpha = 0;
		add(_btnNext);
		
		_txtChoice1 = new GameFont(140, FlxG.height * 0.7, "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEWHITE, "left", 22, Std.int(FlxG.width - 150));
		_txtChoice1.alpha = 0;
		
		_txtChoice2 = new GameFont(140, _txtChoice1.y + (_txtChoice1.height*2), "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEWHITE, "left", 22,Std.int(FlxG.width - 150));
		_txtChoice2.alpha = 0;
		
		_grpChoices  = new FlxGroup();
		add(_grpChoices);
		
		add(_txtChoice1);
		
		add(_txtChoice2);
		
		
		_txtDesc = new GameFont(0, 0, _strDesc, GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEGOLD, "center", 18, 0);
		_txtDesc.screenCenter(true, false);
		_txtDesc.y = _txtChoice1.y - _txtDesc.height - 10;
		add(_txtDesc);
		
		startEvent();
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true, doneChooseFadeIn);
	}
	
	private function chooseOne():Void
	{
		GameControls.canInteract = false;
		_fakeChoice1.kill();
		_fakeChoice2.kill();
		FlxTween.num(1, 0, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, complete: doneChoicesOut }, txtChoicesAlpha);
		_eventChoice = 0;
		
	}

	private function chooseTwo():Void
	{
		GameControls.canInteract = false;
		_fakeChoice1.kill();
		_fakeChoice2.kill();
		FlxTween.num(1, 0, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, complete: doneChoicesOut }, txtChoicesAlpha);
		_eventChoice = 1;
		
	}
	
	private function doneChoicesOut(T:FlxTween):Void
	{
		checkPassFail();
		
	}
	
	private function checkPassFail():Void
	{
		if (FlxRandom.chanceRoll(_players[_eventPlayerNo].stats[Reg.events[_weekNo].choices[_eventChoice].stat] * 10))
			_eventPass = true;
		else 
			_eventPass = false;
		
		_eventStage = STAGE_SHOWOUTCOME;
		_eventTxtNo = 0;
		setEventText();
	}
	
	private function startEvent():Void
	{
		_eventTxtNo = 0;
		_eventPlayerNo = getPlayerByRole( Reg.events[_weekNo].activePlayer);
		_txtDesc.text = _strDesc.replace("[playerno]", Std.string(_eventPlayerNo+1)).replace("[role]", Enums.getRole(Reg.events[_weekNo].activePlayer));
		
		setEventText();
	}
	
	private function getPlayerByRole(Role:Int):Int
	{
		for (i in 0...5)
		{
			if (_players[i].role == Role)
				return i;
		}
		return -1;
	}
	
	private function setEventText():Void
	{
		
		if (_eventStage== STAGE_OPENING)
		{
			_txtEvent.text = Reg.events[_weekNo].opening[_eventTxtNo];
			_txtEvent.alpha = 0;
			FlxTween.num(0, 1, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, complete:doneEventTextIn }, txtEventAlpha);
			GameControls.changeUIs([_btnNext]);
		}
		else if (_eventStage == STAGE_SHOWCHOICES)
		{
			_txtChoice1.text = Reg.events[_weekNo].choices[0].texts[0];
			_txtChoice2.text = Reg.events[_weekNo].choices[1].texts[0];
			_txtChoice2.y = _txtChoice1.y + _txtChoice1.height + 10;
			_txtChoice1.updateFrameData();
			_txtChoice1.draw();
			
			if (_fakeChoice1 != null)
				_fakeChoice1 = FlxDestroyUtil.destroy(_fakeChoice1);
			if (_fakeChoice2 != null)
				_fakeChoice2 = FlxDestroyUtil.destroy(_fakeChoice2);
			
			_fakeChoice1 = new FakeUIElement(_txtChoice1.x - 4, _txtChoice1.y - 4, Std.int(_txtChoice1.width + 8), Std.int(_txtChoice1.height + 8), chooseOne, null, false);
			_grpChoices.add(_fakeChoice1);
			
			_fakeChoice2 = new FakeUIElement(_txtChoice2.x - 4, _txtChoice2.y - 4, Std.int(_txtChoice2.width + 8), Std.int(_txtChoice2.height + 8), chooseTwo, null, false);
			_grpChoices.add(_fakeChoice2);
			
			if (_chart != null)
				_chart = FlxDestroyUtil.destroy(_chart);
			_chart = new StatChart(10, FlxG.height - 130, _players[_eventPlayerNo]);
			add(_chart);
			_chart.alpha = 0;
			
			_choices = [_fakeChoice1, _fakeChoice2];
			
			FlxTween.num(0, 1, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, complete:doneChoicesIn }, txtChoicesAlpha);
			GameControls.changeUIs(_choices);
		}
		else if (_eventStage == STAGE_SHOWOUTCOME)
		{
			if (_eventPass)
				_txtEvent.text = Reg.events[_weekNo].choices[_eventChoice].passTexts[_eventTxtNo];
			else
				_txtEvent.text = Reg.events[_weekNo].choices[_eventChoice].failTexts[_eventTxtNo];
			_txtEvent.alpha = 0;
			FlxTween.num(0, 1, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, complete:doneEventTextIn }, txtEventAlpha);
			GameControls.changeUIs([_btnNext]);
		}
		else if (_eventStage == STAGE_RESOLVE)
		{
			if (_eventPass)
			{
				_txtEvent.text = _strRes.replace('[gl]', 'gain').replace('[stat]', Enums.getStat(Reg.events[_weekNo].choices[_eventChoice].passResult));
				_players[_eventPlayerNo].stats[Reg.events[_weekNo].choices[_eventChoice].passResult]++;
			}
			else
			{
				_txtEvent.text = _strRes.replace('[gl]', 'lose').replace('[stat]', Enums.getStat(Reg.events[_weekNo].choices[_eventChoice].failResult));
				_players[_eventPlayerNo].stats[Reg.events[_weekNo].choices[_eventChoice].failResult]--;
				Reg.flags.push(Reg.events[_weekNo].choices[_eventChoice].flag.;
			}
			_txtEvent.alpha = 0;
			FlxTween.num(0, 1, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, complete:doneEventTextIn }, txtEventAlpha);
			GameControls.changeUIs([_btnNext]);
			
		}
		else
		{
			return;
		}
		
	}
	
	private function doneChoicesIn(T:FlxTween):Void
	{
		GameControls.canInteract = true;
		//_fakeChoice1.active = true;
		//_fakeChoice2.active = true;
		
		
	}
	
	private function txtChoicesAlpha(Value:Float):Void
	{
		_chart.alpha = _txtChoice1.alpha = _txtChoice2.alpha = Value;
	}
	
	private function advanceEvent():Void
	{
		if (!_btnNext.active || _btnNext.alpha != 1)
			return;
		GameControls.canInteract = false;
		_btnNext.active = false;
		FlxTween.num(1, 0, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, complete:doneEventTextOut }, txtEventAndBtnNextAlpha);
	}
	
	private function doneEventTextOut(T:FlxTween):Void
	{
		
		_eventTxtNo++;
		if (_eventStage == STAGE_OPENING)
		{
			if (_eventTxtNo < Reg.events[_weekNo].opening.length )
			{
				setEventText();
			}
			else
			{
				_eventTxtNo = 0;
				_eventStage = STAGE_SHOWCHOICES;
				setEventText();
			}
		}
		else if (_eventStage == STAGE_SHOWOUTCOME)
		{

			if (_eventTxtNo < (_eventPass ? Reg.events[_weekNo].choices[_eventChoice].passTexts.length : Reg.events[_weekNo].choices[_eventChoice].failTexts.length ))
			{
				setEventText();
			}
			else
			{
				_eventStage = STAGE_RESOLVE;
				setEventText();
			}
			
		}
		else if (_eventStage == STAGE_RESOLVE)
		{
			_eventTxtNo = 0;
			_eventStage = STAGE_OPENING;
			_weekNo++;
			if (_weekNo < Reg.events.length)
			{
				_txtWeek.text = _strWeek.replace("[weekno]", Std.string(_weekNo+1));
				startEvent();
			}
		}
	}
	
	private function txtEventAndBtnNextAlpha(Value:Float):Void
	{
		_txtEvent.alpha = _btnNext.alpha = Value;
	}
	
	private function doneEventTextIn(T:FlxTween):Void
	{
		FlxTween.num(0, 1, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, complete:doneEventNextIn }, btnNextAlpha);
	}
	
	private function doneEventNextIn(T:FlxTween):Void
	{
		GameControls.canInteract = true;
		_btnNext.active = true;
	}
	
	private function btnNextAlpha(Value:Float):Void
	{
		_btnNext.alpha = Value;
	}
	
	private function txtEventAlpha(Value:Float):Void
	{
		_txtEvent.alpha = Value;
	}
	
	private function doneChooseFadeIn():Void
	{
		GameControls.canInteract = true;
	}
	
	private function buildPlayers():Void
	{
		_choosePlayers = new Array<Player>();
		_players = new Array<Player>();
		
		var startStats:Array<Int> = [2, 3, 4, 5];
		
		var stats:Array<Int>;
		var newStats:Array<Int>;
		var rStat:Int;
		for (i in 0...5)
		{
			stats = new Array<Int>();
			stats = startStats.copy();
			newStats = new Array<Int>();
			for (a in 0...5)
			{			
				if (a == i)
				{
					newStats.push(6);
				}
				else
				{
					rStat = 0;
					while (rStat == 0)
					{
						rStat = FlxRandom.intRanged(0, stats.length - 1, newStats);
					}
					newStats.push(stats[rStat]);
				}
			}
			_choosePlayers.push( new Player(-1,newStats[0], newStats[1], newStats[2], newStats[3], newStats[4]));
		}
		
		
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