package;

import flash.geom.Rectangle;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxGradient;
import flixel.math.FlxRect;

using flixel.util.FlxSpriteUtil;
using StringTools;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private static inline var EVENT_TEXT_SIZE:Int = 24;
	
	private var STAGE_OPENING:Int = 0;
	private var STAGE_SHOWCHOICES:Int = 1;
	private var STAGE_SHOWOUTCOME:Int = 2;
	private var STAGE_RESOLVE:Int = 3;
	
	
	private var _eventStage:Int = 0;
	private var _eventChoice:Int = 0;
	private var _eventPass:Bool = false;
	private var _eventPlayerNo:Int = -1;
	
	private var _txtChoice1Main:GameFont;
	private var _txtChoice2Main:GameFont;
	
	private var _txtChoice1:FlxEffectSprite;
	private var _txtChoice2:FlxEffectSprite;
	
	private var glitch1:FlxGlitchEffect;
	private var glitch2:FlxGlitchEffect;
	
	private var _fakeChoice1:FakeUIElement;
	private var _fakeChoice2:FakeUIElement;
	private var _choices:Array<IUIElement>;
	
	private var  _loaded:Bool = false;
	
	private var _weekNo:Int = 0;
	
	private var _players:Array<Player>;
	
	private var _txtWeek:GameFont;
	private var _strWeek:String = "Week [weekno]";
	
	private var _txtEvent:FlxEffectSprite;
	private var glitchEvent:FlxGlitchEffect;
	private var _txtEventMain:GameFont;
	private var _eventTxtNo:Int;
	
	private var _btnNext:GameButton;
	
	private var _grpChoices:FlxGroup;
	
	private var _strDesc:String = "The [role] (Player [playerno])";
	private var _txtDesc:GameFont;
	
	private var _strRes:String = "You [gl] 1 [stat].";
	
	private var _stars:StarBackground;
	private var _chart:StatChart;
	private var _playerBack:FlxSprite;
	
	private var _ship:Ship;
	
	/* Player Role Choose Stuff */
	private var _grpPlayerSelect:FlxGroup;
	
	private var _txtChoose:GameFont;
	private var _strChoose:String = "Player [playerno] Choose a Role";
	private var _playerChooseNo:Int = 0;
	
	private var _choosePlayers:Array<Player>;
	private var _picked:Array<Int> = [];
	private var _backs:Array<FlxSprite> = [];
	
	private var fakeUIs:Array<IUIElement> = [];
	private var _sprs:Array<FlxSprite> = [];
	
	private var ChoiceSound:String = "sounds/switch.wav";
	
	private var head_back_left:FlxSprite;
	private var head_back_right:FlxSprite;
	private var head_left:FlxSprite;
	private var head_right:FlxSprite;
	private var head_text_left:GameFont;
	private var head_text_right:GameFont;
	
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
		//GameControls.moveCursor(POSITIVE);

	}
	
	private function buildPlayerSelect():Void
	{
		_grpPlayerSelect = new FlxGroup();
		
		_grpPlayerSelect.add(new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK));
		
		
		var fakeUI:FakeUIElement;
		var txtRole:GameFont;
		var chart:StatChart;
		var back:FlxSprite;
		var sprP:FlxSprite;
		
		for (i in 0...5)
		{
			fakeUI = new FakeUIElement(10 + (i * (10 + ((FlxG.width - 60) / 5))), 40, Std.int((FlxG.width - 60) / 5), Std.int(FlxG.height - 60), pickPlayer.bind(i),null, false, "", ChoiceSound);
			fakeUIs.push(fakeUI);
			_grpPlayerSelect.add(fakeUI);
			
			back = new FlxSprite(fakeUI.x, fakeUI.y).makeGraphic(Std.int(fakeUI.width), Std.int(fakeUI.height), 0x0,true);
			back.drawRoundRect(0, 0, fakeUI.width, fakeUI.height, 10, 10, Enums.getRoleColor(i));
			back.alpha = .6;
			_grpPlayerSelect.add(back);			
			_backs.push(back);
			
			txtRole = new GameFont(0, 0, Enums.getRole(i), GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEBLUE, "center", 18);
			txtRole.x = fakeUI.x + (fakeUI.width / 2) - (txtRole.width / 2);
			txtRole.y = fakeUI.y + 10;
			
			_grpPlayerSelect.add(txtRole);
			
			sprP = new FlxSprite(0, 0, "images/" + Enums.getRole(i) + ".png");
			sprP.x = fakeUI.x + (fakeUI.width / 2) - (sprP.width / 2);
			sprP.y = fakeUI.y + (fakeUI.height / 2) - (sprP.height / 2);
			_grpPlayerSelect.add(sprP);
			_sprs.push(sprP);
			chart = new StatChart(fakeUI.x + (fakeUI.width / 2) - 60, fakeUI.y + fakeUI.height - 130, _choosePlayers[i]);
			_grpPlayerSelect.add(chart);
		}
		
		_txtChoose = new GameFont(0, 10, "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEGOLD, "center", 32);
		
		_grpPlayerSelect.add(_txtChoose);
		
		_txtChoose.text = _strChoose.replace("[playerno]", Std.string(_playerChooseNo + 1));
		_txtChoose.screenCenter(FlxAxes.X);
		
		var _stats:StatKey = new StatKey();
		
		_grpPlayerSelect.add(_stats);
		
		add(_grpPlayerSelect);
		
		//drawStatKey(10, FlxG.height - 30, FlxG.width -10, 20);
		
		
		
		GameControls.newState(fakeUIs);
	}
	
	private function pickPlayer(WhichPlayer:Int):Void
	{
		if (_picked.indexOf(WhichPlayer) == -1)
		{
			_picked.push(WhichPlayer);
			_players.push(_choosePlayers[WhichPlayer]);
			_players[_players.length - 1].role = WhichPlayer;
			
			cast(fakeUIs[WhichPlayer], FakeUIElement).active = false;
			cast(fakeUIs[WhichPlayer], FakeUIElement).visible = false;
			_backs[WhichPlayer].alpha = .2;
			_sprs[WhichPlayer].alpha = .6;
			//Reg.PlaySound("sounds/Button.wav", .33);
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
		
		
		
		// add the game interface!
		
		var b:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0xff333333, 0xff888888, 0xff666666], 1, 12);
		add(b);
		b = FlxGradient.createGradientFlxSprite(FlxG.width - 4, FlxG.height - 4, [0xff333333, 0xff888888, 0xff666666], 1, 192);
		b.x = 2;
		b.y = 2;
		add(b);
		
		
		_txtEventMain = new GameFont(20, FlxG.height * 0.65, "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEWHITE, "left", EVENT_TEXT_SIZE, Std.int(FlxG.width - 40));
		_txtEventMain = new GameFont(20, FlxG.height * 0.65, "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEWHITE, "left", EVENT_TEXT_SIZE, Std.int(FlxG.width - 40));
		
		glitchEvent = new FlxGlitchEffect(4, 1, 0.05, FlxGlitchDirection.HORIZONTAL);
		_txtEvent = new FlxEffectSprite(_txtEventMain, [glitchEvent]);
		_txtEvent.setPosition(_txtEventMain.x, _txtEventMain.y);
		
		_btnNext = new GameButton(0, 0, "NEXT", advanceEvent, GameButton.STYLE_GREEN, true, 0, 0, 24);
		_btnNext.x = FlxG.width - _btnNext.width - 16;
		_btnNext.y = FlxG.height -  _btnNext.height-26;
		_btnNext.alpha = 0;
		
		
		_txtChoice1Main = new GameFont(160, FlxG.height * 0.65, "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEWHITE, "left", EVENT_TEXT_SIZE, Std.int(FlxG.width - 180));
		
		glitch1 = new FlxGlitchEffect(4, 1, 0.05, FlxGlitchDirection.HORIZONTAL);
		
		_txtChoice1 = new FlxEffectSprite(_txtChoice1Main, [glitch1]);
		_txtChoice1.alpha = 0;
		_txtChoice1.setPosition(_txtChoice1Main.x, _txtChoice1Main.y);
		
		_txtChoice2Main = new GameFont(160, _txtChoice1.y + (_txtChoice1.height*2), "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEWHITE, "left", EVENT_TEXT_SIZE,Std.int(FlxG.width - 180));
		
		glitch2 = new FlxGlitchEffect(4, 1, 0.05, FlxGlitchDirection.HORIZONTAL);
		
		_txtChoice2 = new FlxEffectSprite(_txtChoice2Main, [glitch2]);
		_txtChoice2.alpha = 0;
		_txtChoice2.setPosition(_txtChoice2Main.x, _txtChoice2Main.y);
		
		_grpChoices  = new FlxGroup();

		_txtDesc = new GameFont(0, 0, _strDesc, GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEGOLD, "center", EVENT_TEXT_SIZE, 0);
		_txtDesc.screenCenter(FlxAxes.X);
		_txtDesc.y = _txtChoice1.y - _txtDesc.height - 10;
		
		_playerBack = FlxGradient.createGradientFlxSprite(FlxG.width, Std.int(_txtDesc.height + 6), [0xff000000, 0xff000000, 0xff000000], 1, 0);
		
		_playerBack.x = 0;
		_playerBack.y = _txtDesc.y - 4;
		add(_playerBack);
		
		add(_txtDesc);
		
		_txtWeek = new GameFont(20, _txtDesc.y, _strWeek.replace("[weekno]", Std.string(_weekNo+1)), GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEGOLD, "left", EVENT_TEXT_SIZE,0);
		add(_txtWeek);
		
		_stars = new StarBackground(12, 12, FlxG.width - 24, Std.int(_playerBack.y - 20) );
		_stars.starXOffset = -.6;
		
		b = drawRoundBox(Std.int(_stars.x - 2), Std.int(_stars.y - 2), Std.int(_stars.width + 4), Std.int(_stars.height + 4));
		add(b);
		
		add(_stars);
		
		b = drawRoundBox(10,Std.int(_txtEventMain.y - 10),Std.int(FlxG.width - 20), Std.int(FlxG.height - _txtEventMain.y-10));
		add(b);
		
		add(new StatKey());
		
		add(_txtEvent);
		add(_btnNext);
		add(_grpChoices);
		
		add(_txtChoice1);
		
		add(_txtChoice2);
		
		_ship = new Ship(FlxRect.get(_stars.x, _stars.y, _stars.width, _stars.height));
		add(_ship);
		
		head_back_left = drawRoundBox(0, 0, 218, 218);
		head_back_left.x = 30;
		head_back_left.y = _txtEventMain.y - 288;
		head_back_left.visible = false;
		add(head_back_left);
		
		head_back_right = drawRoundBox(0, 0, 218, 218);
		head_back_right.x = FlxG.width - 248;
		head_back_right.y = _txtEventMain.y - 288;
		head_back_right.visible = false;
		add(head_back_right);
		
		var t:FlxAtlasFrames = FlxAtlasFrames.fromSparrow("images/heads.png", "images/heads.xml");
		
		
		head_left = new FlxSprite();
		head_left.frames = t;
		head_left.animation.addByNames("c", ["Captain_head.png"]);
		head_left.animation.addByNames("d", ["Doctor_head.png"]);
		head_left.animation.addByNames("e", ["Engineer_head.png"]);
		head_left.animation.addByNames("g", ["Gunner_head.png"]);
		head_left.animation.addByNames("p", ["Pilot_head.png"]);
		head_left.x = head_back_left.x;
		head_left.y = head_back_left.y;
		head_left.flipX = true;
		head_left.visible = false;
		add(head_left);
		
		head_text_left = new GameFont(head_back_left.x, head_back_left.y +2, "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEBLUE, "center", 18, 218);
		head_text_left.visible = false;
		add(head_text_left);
		
		head_right = new FlxSprite();
		head_right.frames = t;
		head_right.animation.addByNames("c", ["Captain_head.png"]);
		head_right.animation.addByNames("d", ["Doctor_head.png"]);
		head_right.animation.addByNames("e", ["Engineer_head.png"]);
		head_right.animation.addByNames("g", ["Gunner_head.png"]);
		head_right.animation.addByNames("p", ["Pilot_head.png"]);
		head_right.x = head_back_right.x;
		head_right.y = head_back_right.y;
		head_right.visible = false;
		add(head_right);
		
		head_text_right = new GameFont(head_back_right.x, head_back_right.y + 2, "", GameFont.STYLE_SMSIMPLE, GameFont.COLOR_SIMPLEBLUE, "center", 18, 218);
		head_text_right.visible = false;
		add(head_text_right);
		
		startEvent();
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true, doneChooseFadeIn, true);
	}
	
	private function drawRoundBox(X:Int, Y:Int, Width:Int, Height:Int):FlxSprite
	{
		var b:FlxSprite = new FlxSprite(X, Y);
		b.makeGraphic(Width,Height,0x0);
		b.drawRoundRect(0, 0, b.width, b.height, 16, 16, 0xff000000, { color:0xff888888, thickness:2 } );
		return b;
	}
	
	private function chooseOne():Void
	{
		GameControls.canInteract = false;
		_fakeChoice1.kill();
		_fakeChoice2.kill();
		FlxTween.num(1, 0, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, onComplete: doneChoicesOut }, txtChoicesAlpha);
		_eventChoice = 0;
		
	}

	private function chooseTwo():Void
	{
		GameControls.canInteract = false;
		_fakeChoice1.kill();
		_fakeChoice2.kill();
		FlxTween.num(1, 0, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, onComplete: doneChoicesOut }, txtChoicesAlpha);
		_eventChoice = 1;
		
	}
	
	private function doneChoicesOut(T:FlxTween):Void
	{
		checkPassFail();
		
	}
	
	private function checkPassFail():Void
	{
		if (FlxG.random.bool(_players[_eventPlayerNo].stats[Reg.events[_weekNo].choices[_eventChoice].stat] * 10))
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
		_txtWeek.text = _strWeek.replace("[weekno]", Std.string(_weekNo + 1));
		_eventPlayerNo = getPlayerByRole( Reg.events[_weekNo].activePlayer);
		
		_txtDesc.text = _strDesc.replace("[playerno]", Std.string(_eventPlayerNo + 1)).replace("[role]", Enums.getRole(Reg.events[_weekNo].activePlayer));
		_txtDesc.screenCenter(FlxAxes.X);
		makePlayerBack(Reg.events[_weekNo].activePlayer);
		
		head_back_left.visible = head_back_right.visible = head_left.visible = head_right.visible = false;
		
		setEventText();
	}
	
	private function makePlayerBack(Role:Int):Void
	{
		_playerBack.pixels =  FlxGradient.createGradientBitmapData(FlxG.width, Std.int(_txtDesc.height + 2), [ FlxColor.getDarkened( Enums.getRoleColor(Role), .6), 0xff000000, FlxColor.getDarkened(Enums.getRoleColor(Role), .6)], 1, 0);
		var r:Rectangle = new Rectangle();
		r.setTo(0, 0, FlxG.width, 1);
		_playerBack.pixels.fillRect(r, FlxColor.getDarkened( Enums.getRoleColor(Role), .2));
		r.setTo(0, _playerBack.height - 1, FlxG.width, 1);
		_playerBack.pixels.fillRect(r, FlxColor.getDarkened( Enums.getRoleColor(Role), .4));
		
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
	
	private function checkHeads(Text:String):String
	{
		var LeftHead = ~/\[L([CDEGP])\]/;
		var RightHead = ~/\[R([CDEGP])\]/;
		if (LeftHead.match(Text))
		{
			head_left.animation.play(LeftHead.matched(1).toLowerCase());
			head_text_left.text = switch(LeftHead.matched(1).toLowerCase()) {
				case "c":
					"Captain";
				case "d":
					"Doctor";
				case "e":
					"Engineer";
				case "g":
					"Gunner";
				case "p":
					"Pilot";
				default:
					"";
			};
			head_text_left.x = head_back_left.x + (head_back_left.width / 2) - (head_text_left.width / 2);
			head_text_left.visible = head_back_left.visible = head_left.visible = true;
			Text = LeftHead.replace(Text, "");
		}
		else
		{
			head_text_left.visible = head_back_left.visible = head_left.visible = false;
		}
		
		if (RightHead.match(Text))
		{
			head_right.animation.play(RightHead.matched(1).toLowerCase());
			head_text_right.text = switch(RightHead.matched(1).toLowerCase()) {
				case "c":
					"Captain";
				case "d":
					"Doctor";
				case "e":
					"Engineer";
				case "g":
					"Gunner";
				case "p":
					"Pilot";
				default:
					"";
			};
			head_text_right.x = head_back_right.x + (head_back_right.width / 2) - (head_text_right.width / 2);
			head_text_right.visible = head_back_right.visible = head_right.visible = true;
			Text = RightHead.replace(Text, "");
		}
		else
		{
			head_text_right.visible = head_back_right.visible = head_right.visible = false;
		}
		return Text;
	}
	
	private function setEventText():Void
	{
		head_text_left.visible = head_back_left.visible = head_left.visible = false;
		head_text_right.visible = head_back_right.visible = head_right.visible = false;
		
		if (_eventStage== STAGE_OPENING)
		{
			if (Reg.events[_weekNo].opening[_eventTxtNo].charAt(0) == "*")
			{
				Reg.events[_weekNo].opening[_eventTxtNo] = Reg.events[_weekNo].opening[_eventTxtNo].substring(1, Reg.events[_weekNo].opening[_eventTxtNo].length - 1);
				FlxG.camera.shake(0.025, 0.25);
				Reg.PlaySound("sounds/Week Screen.wav", .8);
			}
			
			_txtEventMain.text = checkHeads(Reg.events[_weekNo].opening[_eventTxtNo]);
			
			_txtEvent.alpha = 0;
			_ship.problem(_weekNo);
			FlxTween.num(0, 1, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, onComplete:doneEventTextIn }, txtEventAlpha);
			GameControls.changeUIs([_btnNext]);
		}
		else if (_eventStage == STAGE_SHOWCHOICES)
		{
			_txtChoice1Main.text = Reg.events[_weekNo].choices[0].texts[0];
			_txtChoice2Main.text = Reg.events[_weekNo].choices[1].texts[0];
			_txtChoice2Main.y = _txtChoice1Main.y + _txtChoice1Main.height + 10;
			
			_txtChoice1.setPosition(_txtChoice1Main.x, _txtChoice1Main.y);
			_txtChoice2.setPosition(_txtChoice2Main.x, _txtChoice2Main.y);
			
			_txtChoice1Main.updateFramePixels();
			_txtChoice1Main.draw();
			
			if (_fakeChoice1 != null)
				_fakeChoice1 = FlxDestroyUtil.destroy(_fakeChoice1);
			if (_fakeChoice2 != null)
				_fakeChoice2 = FlxDestroyUtil.destroy(_fakeChoice2);
			
			_fakeChoice1 = new FakeUIElement(_txtChoice1Main.x - 4, _txtChoice1Main.y - 4, Std.int(_txtChoice1Main.width + 8), Std.int(_txtChoice1Main.height + 8), chooseOne, null, false, "", ChoiceSound);
			_grpChoices.add(_fakeChoice1);
			
			_fakeChoice2 = new FakeUIElement(_txtChoice2Main.x - 4, _txtChoice2Main.y - 4, Std.int(_txtChoice2Main.width + 8), Std.int(_txtChoice2Main.height + 8), chooseTwo, null, false, "", ChoiceSound);
			_grpChoices.add(_fakeChoice2);
			
			if (_chart != null)
				_chart = FlxDestroyUtil.destroy(_chart);
			_chart = new StatChart(20, FlxG.height - 120 - 30, _players[_eventPlayerNo]);
			add(_chart);
			_chart.alpha = 0;
			
			_choices = [_fakeChoice1, _fakeChoice2];
			
			head_right.animation.play(switch (Enums.getRole(_players[_eventPlayerNo].role)) {
				case "Captain":
					"c";
				case "Doctor":
					"d";
				case "Engineer":
					"e";
				case "Gunner":
					"g";
				case "Pilot":
					"p";
				default:
					"";
			});
			head_back_right.visible = head_right.visible = true;
			
			FlxTween.num(0, 1, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, onComplete:doneChoicesIn }, txtChoicesAlpha);
			GameControls.changeUIs(_choices);
		}
		else if (_eventStage == STAGE_SHOWOUTCOME)
		{
			if (_eventPass)
			{
				_txtEventMain.text = checkHeads(Reg.events[_weekNo].choices[_eventChoice].passTexts[_eventTxtNo]);
				_ship.fixed(_weekNo);
			}
			else
				_txtEventMain.text = checkHeads(Reg.events[_weekNo].choices[_eventChoice].failTexts[_eventTxtNo]);
			
			_txtEvent.alpha = 0;
			FlxTween.num(0, 1, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, onComplete:doneEventTextIn }, txtEventAlpha);
			GameControls.changeUIs([_btnNext]);
		}
		else if (_eventStage == STAGE_RESOLVE)
		{
			if (_eventPass)
			{
				_txtEventMain.text = _strRes.replace('[gl]', 'gain').replace('[stat]', Enums.getStat(Reg.events[_weekNo].choices[_eventChoice].passResult));
				_players[_eventPlayerNo].stats[Reg.events[_weekNo].choices[_eventChoice].passResult]++;
			}
			else
			{
				_txtEventMain.text = _strRes.replace('[gl]', 'lose').replace('[stat]', Enums.getStat(Reg.events[_weekNo].choices[_eventChoice].failResult));
				_players[_eventPlayerNo].stats[Reg.events[_weekNo].choices[_eventChoice].failResult]--;
				Reg.flags.push(Reg.events[_weekNo].choices[_eventChoice].flag);
			}
			
			_txtEvent.alpha = 0;
			FlxTween.num(0, 1, .33, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, onComplete:doneEventTextIn }, txtEventAlpha);
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
		
		
	}
	
	private function txtChoicesAlpha(Value:Float):Void
	{
		_chart.alpha = _txtChoice1.alpha = _txtChoice2.alpha = Value;
		glitch2.strength = glitch1.strength = Std.int(100 - (Value * 100));
	}
	
	private function advanceEvent():Void
	{
		if (!_btnNext.active || _btnNext.alpha != 1)
			return;
		GameControls.canInteract = false;
		_btnNext.active = false;
		FlxTween.num(1, 0, .2, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, onComplete:doneEventTextOut }, txtEventAndBtnNextAlpha);
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
			#if FLX_DEMO_VERSION
			if (_weekNo == 3)
			{
				_weekNo = 9;
			}
			#end
			if (_weekNo < Reg.events.length)
			{
				
				FlxG.camera.fade(FlxColor.BLACK, .33,false, doneNextQuestOut);
				
			}
			else
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, false, doneAllEvents);
			}
		}
	}
	
	private function doneAllEvents():Void
	{
		FlxG.switchState(new EndState());
	}
	
	private function doneNextQuestOut():Void
	{
		startEvent();
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
	}
	
	
	private function txtEventAndBtnNextAlpha(Value:Float):Void
	{
		_txtEvent.alpha = _btnNext.alpha = Value;
		glitchEvent.strength = Std.int(100 - (Value * 100));
	}
	
	private function doneEventTextIn(T:FlxTween):Void
	{
		FlxTween.num(0, 1, .2, { type:FlxTween.ONESHOT, ease:FlxEase.circInOut, onComplete:doneEventNextIn }, btnNextAlpha);
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
		glitchEvent.strength = Std.int(100 - (Value * 100));
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
						rStat = FlxG.random.int(0, stats.length - 1, newStats);
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
	override public function update(elapsed:Float):Void
	{

		GameControls.checkScreenControls();
		super.update(elapsed);
	}	
}