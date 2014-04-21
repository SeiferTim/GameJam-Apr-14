package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
using flixel.util.FlxSpriteUtil;

class StatKey extends FlxGroup
{

	public function new() 
	{
		super(6);
		var b:FlxSprite = new FlxSprite(10, FlxG.height - 16);
		b.makeGraphic(FlxG.width - 20 , 28, 0x0);
		add(b);
		b.drawRoundRect(0, 0, b.width, b.height, 16, 16, 0xff111111, { color:0xff888888, thickness:2 } );
		var txtKey:FlxText = new FlxText(10, FlxG.height - 16, (FlxG.width - 20) / 5, "Judgement");
		txtKey.setFormat(null, 10, 0xff00ff, "center", FlxText.BORDER_OUTLINE, 0x888888);
		add(txtKey);
		txtKey = new FlxText(txtKey.x+txtKey.width, txtKey.y, (FlxG.width - 20) / 5, "Luck");
		txtKey.setFormat(null, 10, 0x00ff00, "center", FlxText.BORDER_OUTLINE, 0x888888);
		add(txtKey);
		txtKey = new FlxText(txtKey.x+txtKey.width, txtKey.y, (FlxG.width - 20) / 5, "Logic");
		txtKey.setFormat(null, 10, 0x0000ff, "center", FlxText.BORDER_OUTLINE, 0x888888);
		add(txtKey);
		txtKey = new FlxText(txtKey.x+txtKey.width, txtKey.y, (FlxG.width - 20) / 5, "Physique");
		txtKey.setFormat(null, 10, 0xff0000, "center", FlxText.BORDER_OUTLINE, 0x888888);
		add(txtKey);
		txtKey = new FlxText(txtKey.x+txtKey.width, txtKey.y, (FlxG.width - 20) / 5, "Finesse");
		txtKey.setFormat(null, 10, 0xffff00, "center", FlxText.BORDER_OUTLINE, 0x888888);
		add(txtKey);
	}
	
}