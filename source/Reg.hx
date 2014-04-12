package;

import flash.events.Event;
import flixel.util.FlxSave;
import haxe.xml.Fast;
import haxe.xml.Parser;
import openfl.Assets;


/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	
	
	public static var FONT_KPIXELMINI:String = "fonts/kenpixel_mini.ttf";

	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	static public var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	static public var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	static public var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	static public var score:Int = 0;
	/**
	 * Generic bucket for storing different <code>FlxSaves</code>.
	 * Especially useful for setting up multiple save slots.
	 */
	static public var save:FlxSave = new FlxSave();
	
	static public var initialized:Bool = false;
	
	static public var events:Array<GameEvent>;
	
	static public var flags:Array<String>;
	
	static public function init():Void
	{
		if (initialized)
			return;
		initialized = true;
		flags = new Array<String>();
		GameControls.init();
		loadEvents("data/events.xml");
	}
	
	private static function loadEvents(EventData:Dynamic):Void
	{
		
		var xml:Xml;
		var node:Fast;
		var source:Fast;
		var str:String = "";
		
		if (Std.is(EventData, Class))
		{
			str = Type.createInstance(EventData, []);
		}
		else if (Std.is(EventData, String))
		{
			str = Assets.getText(EventData);
		}
		
		xml = Parser.parse(str);
		source = new Fast(xml);
		
		var week:Int;
		var activePlayer:Int;
		var openings:Array<String>;
		var subNode:Fast;
		var choice1:Choice;
		var choice1Lines:Array<String>;
		var choice1Attrib:Int;
		var choice1PassLines:Array<String>;
		var choice1FailLines:Array<String>;
		var choice1FailAttrib:Int;
		var choice1PassAttrib:Int;
		var choice2:Choice;
		var choice2Lines:Array<String>;
		var choice2Attrib:Int;
		var choice2PassLines:Array<String>;
		var choice2FailLines:Array<String>;
		var choice2FailAttrib:Int;
		var choice2PassAttrib:Int;
		var choice1Flag:String;
		var choice2Flag:String;

		events = new Array<GameEvent>();
		
		
		for (node in source.nodes.event)
		{
			week = Std.parseInt(node.node.week.innerData);
			activePlayer = Enums.parseRole(node.node.active_player.innerData);
			openings = new Array<String>();
			for (subNode in node.node.opening.nodes.line)
			{
				openings.push(subNode.innerData);
			}
			
			choice1Lines = new Array<String>();
			
			for (subNode in node.node.choice_one.nodes.line)
			{
				choice1Lines.push(subNode.innerData);
			}
			
			choice1Attrib = Enums.parseAttrib(node.node.choice_one.node.attrib.innerData);
			
			choice1PassAttrib = Enums.parseAttrib(node.node.choice_one.node.pass.node.attrib.innerData);
			
			choice1PassLines = new Array<String>();
			for (subNode in node.node.choice_one.node.pass.nodes.line)
			{
				choice1PassLines.push(subNode.innerData);
			}
			
			choice1FailAttrib = Enums.parseAttrib(node.node.choice_one.node.fail.node.attrib.innerData);
			
			choice1FailLines = new Array<String>();
			for (subNode in node.node.choice_one.node.fail.nodes.line)
			{
				choice1FailLines.push(subNode.innerData);
			}
			
			choice1FailAttrib = Enums.parseAttrib(node.node.choice_one.node.fail.node.attrib.innerData);
			
			choice1Flag = node.node.choice_one.node.fail.node.score.innerData;
		
			choice1 = new Choice(choice1Lines, choice1Attrib, choice1PassLines, choice1PassAttrib, choice1FailLines, choice1FailAttrib, choice1Flag);
			
			choice2Lines = new Array<String>();
			
			for (subNode in node.node.choice_two.nodes.line)
			{
				choice2Lines.push(subNode.innerData);
			}
			
			choice2Attrib = Enums.parseAttrib(node.node.choice_two.node.attrib.innerData);
			
			choice2PassAttrib = Enums.parseAttrib(node.node.choice_two.node.pass.node.attrib.innerData);
			
			choice2PassLines = new Array<String>();
			for (subNode in node.node.choice_two.node.pass.nodes.line)
			{
				choice2PassLines.push(subNode.innerData);
			}
			
			choice2FailAttrib = Enums.parseAttrib(node.node.choice_two.node.fail.node.attrib.innerData);
			
			choice2FailLines = new Array<String>();
			for (subNode in node.node.choice_two.node.fail.nodes.line)
			{
				choice2FailLines.push(subNode.innerData);
			}
			
			choice2FailAttrib = Enums.parseAttrib(node.node.choice_two.node.fail.node.attrib.innerData);
		
			choice2Flag = node.node.choice_two.node.fail.node.score.innerData;
			
			choice2 = new Choice(choice2Lines, choice2Attrib, choice2PassLines, choice2PassAttrib, choice2FailLines, choice2FailAttrib, choice2Flag);
			
			events.push(new GameEvent(week, activePlayer, openings, [choice1, choice2]));
			
		}
		
		
	}

}