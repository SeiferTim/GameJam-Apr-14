package ;

import flash.display.BitmapData;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;

class GameFont extends FlxSprite
{

	public static inline var STYLE_BIG_TITLE:Int = 0;
	public static inline var STYLE_HUGE_TITLE:Int = 1;
	public static inline var STYLE_TINY:Int = 2;
	public static inline var STYLE_GLOSSY:Int = 3;
	public static inline var STYLE_SMGLOSSY:Int = 4;
	public static inline var STYLE_SMSIMPLE:Int = 5;
	
	public static inline var COLOR_RED:Int = 0;
	public static inline var COLOR_CYAN:Int = 1;
	public static inline var COLOR_YELLOW:Int = 2;
	public static inline var COLOR_BLUE:Int = 3;
	public static inline var COLOR_GREEN:Int = 4;
	public static inline var COLOR_WHITE:Int = 5;
	public static inline var COLOR_SIMPLEGOLD:Int = 6;
	public static inline var COLOR_SIMPLEBLUE:Int = 7;
	public static inline var COLOR_SIMPLERED:Int = 8;
	public static inline var COLOR_SIMPLEGREEN:Int = 9;
	public static inline var COLOR_SIMPLEYELLOW:Int = 10;
	public static inline var COLOR_SIMPLEWHITE:Int = 11;
	
	
	
	
	private static var COLORS_RED:Array<Int> = [0xffff0000, 0xff660000, 0xffff6666, 0xff110000];
	private static var COLORS_CYAN:Array<Int> = [0xff00ffff,0xff006666,0xff66ffff,0xff001111];
	private static var COLORS_YELLOW:Array<Int> = [0xffffd948, 0xffffd638, 0xffffcc00, 0xffa88600];
	private static var COLORS_BLUE:Array<Int> = [0xff35baf3, 0xff29b0ea, 0xff1ea7e1, 0xff166e93];
	private static var COLORS_GREEN:Array<Int> = [0xff88e060, 0xff7dd655, 0xff73cd4b, 0xff47832c];
	private static var COLORS_WHITE:Array<Int> = [0xffffffff, 0xfff6f6f6, 0xffeeeeee, 0xffaaaaaa];
	private static var COLORS_SIMPLEGOLD:Array<Int> = [0xfff8f880,0xfff8f880, 0xfff8d838, 0xfff8b820,0xfff8b820, 0xfff88008, 0xfff8a008, 0xff0000a8];
	
	private static var COLORS_SIMPLEBLUE:Array<Int> = [0xff80f8f8,0xff80f8f8, 0xff38d8f8, 0xff20b8f8,0xff20b8f8, 0xff0880f8, 0xff08a0f8, 0xff000098];
	
	private static var COLORS_SIMPLERED:Array<Int> = [0xfff8c0f0,0xfff8c0f0, 0xfff888a0, 0xfff84060, 0xfff84060, 0xffc00000, 0xffe80048,0xff661367];
	private static var COLORS_SIMPLEGREEN:Array<Int> = [0xff98f870,0xff98f870, 0xff60d850, 0xff00a840, 0xff00a840, 0xff006018,0xff007818,0xff2b4006];
	private static var COLORS_SIMPLEYELLOW:Array<Int> = [0xfff8f858, 0xfff8f858, 0xfff8c800, 0xfff08808, 0xfff08808, 0xffc83800, 0xffd05000, 0xff7d7c0b];
	
	private static var COLORS_SIMPLEWHITE:Array<Int> = [0xffffffff,0xffffffff, 0xff000066];
	
	private static var ALIGN_LEFT:String = "left";
	private static var ALIGN_RIGHT:String = "right";
	private static var ALIGN_CENTER:String = "center";
	
	
	private var _text:String = "";
	private var _style:Int = 0;
	private var _textColor:Int = 0;
	private var _hasShadow:Bool = false;
	private var _hasInnerGlow:Bool = false;
	private var _hasOutline:Bool = false;
	public var align:String;
	private var _size:Int;
	private var _fieldWidth:Int = 0;
	
	
	public function new(X:Float=0, Y:Float=0, Text:String = "", Style:Int = 0, Color:Int = 0, Alignment:String = "left", Size:Int = -1, Width:Int = 0) 
	{
		super(X, Y);
		_style = Style;
		_text = Text;
		_textColor = Color;
		_size = Size;
		align = Alignment;
		_fieldWidth = Width;
		drawText();
		
	}
	
	private function drawText():Void
	{
		
		var size:Int = 8;
		var colors:Array <Int> = [];
		var font:String = Reg.FONT_KPIXELMINI;
		
		switch(_style)
		{
			
			case STYLE_SMSIMPLE:
				font = Reg.FONT_KPIXELMINI;
				_hasShadow = true;
		}
		if (_size != -1)
			size = _size;
		switch (_textColor)
		{
			case COLOR_RED:
				colors = COLORS_RED.copy();
			
			case COLOR_CYAN:
				colors = COLORS_CYAN.copy();
				
			case COLOR_YELLOW:
				colors = COLORS_YELLOW.copy();
				
			case COLOR_GREEN:
				colors = COLORS_GREEN.copy();
				
			case COLOR_BLUE:
				colors = COLORS_BLUE.copy();
				
			case COLOR_WHITE:
				colors = COLORS_WHITE.copy();
				
			case COLOR_SIMPLEGOLD:
				colors = COLORS_SIMPLEGOLD.copy();
				
			case COLOR_SIMPLEBLUE:
				colors = COLORS_SIMPLEBLUE.copy();
				
			case COLOR_SIMPLERED:
				colors = COLORS_SIMPLERED.copy();
				
			case COLOR_SIMPLEGREEN:
				colors = COLORS_SIMPLEGREEN.copy();
				
			case COLOR_SIMPLEYELLOW:
				colors = COLORS_SIMPLEYELLOW.copy();
				
			case COLOR_SIMPLEWHITE:
				colors = COLORS_SIMPLEWHITE.copy();
		}
		
		var tmpText:FlxText = new FlxText(0, 0, _fieldWidth, _text);
		tmpText.setFormat(font, size, 0x000000, align);
		
		tmpText.resetFrame();
		tmpText.drawFrame();
		
		var r:Rectangle = tmpText.pixels.getColorBoundsRect(0xff000000, 0x00000000, false);
		if (Std.int(r.width) == 0 || Std.int(r.height) == 0)
		{
			pixels = new BitmapData(1, 1, true, 0x0);
		}
		else
		{
			var b1:BitmapData = new BitmapData(Std.int(r.width), Std.int(r.height), true, 0x0);
			b1.copyPixels(tmpText.pixels, r, new Point());
			
			var b2:BitmapData;
			var spr:FlxSprite;
			var dropShad:DropShadowFilter;
			//var outline:DropShadowFilter;
			//var inglow:DropShadowFilter;
			var spr2:FlxSprite;
			var b3:BitmapData;
			var b4:BitmapData;
			spr = new FlxSprite();
			
			pixels = new BitmapData(Std.int(r.width), Std.int(r.height), true, 0x0);
			if (style == STYLE_SMSIMPLE)
			{
				var shadowColor:Int = colors.pop();
				b2 = FlxGradient.createGradientBitmapData(Std.int(r.width), Std.int(r.height), colors);
				spr = new FlxSprite();				
				FlxSpriteUtil.alphaMask(spr, b2, b1);
				makeGraphic(Std.int(spr.width + 4), Std.int(spr.height + 14), 0x0, true);
				pixels.copyPixels(spr.pixels, spr.pixels.rect, new Point(2, 2));
				
				
				if (_hasShadow)
				{
					dropShad = new DropShadowFilter(2, 45, shadowColor, 1, 2, 2, 4);
					pixels.applyFilter(pixels, pixels.rect, new Point(), dropShad);
				}
			}
			else if (style != STYLE_GLOSSY && style != STYLE_SMGLOSSY)
			{
				spr2 = new FlxSprite();
				b2 = FlxGradient.createGradientBitmapData(Std.int(r.width), Std.int(r.height), [colors[0], colors[1]]);
				b3 = new BitmapData(b1.width, b1.height, true, colors[3]);
				b4 = new BitmapData(b1.width + 4, b1.height +4, true, 0x0);
				if (_hasOutline)
				{
					//outline = new DropShadowFilter(0, 90, colors[3], 1, 4, 4, 20);
					//pixels.applyFilter(pixels, pixels.rect, new Point(), outline);
					
					FlxSpriteUtil.alphaMask(spr2, b3, b1);
					
					
					for (sx in 0...3)
					{
						for (sy in 0...3)
						{
							b4.copyPixels(spr2.pixels, spr2.pixels.rect, new Point(sx, sy), spr2.pixels, new Point(0, 0), true);
						}
					}
				}
				
				FlxSpriteUtil.alphaMask(spr, b2, b1);
				makeGraphic(Std.int(spr.width + 4), Std.int(spr.height + 14), 0x0, true);
				if (_hasOutline)
				{
					pixels.copyPixels(b4, b4.rect, new Point(1, 1));
				}
				pixels.copyPixels(spr.pixels, spr.pixels.rect, new Point(2, 2), pixels,new Point(2,2),true);
				
				/*if (_hasInnerGlow)
				{			
					//inglow = new GlowFilter(colors[2], 1, 2, 2, 4, 1, true, false);
					inglow = new DropShadowFilter(0, 0, colors[2], 1, 8, 8, 4, 1, true, false);
					inglow
					pixels.applyFilter(pixels, pixels.rect, new Point(), inglow);
				}*/
				
				if (_hasShadow)
				{
					dropShad = new DropShadowFilter(1, 90, colors[3], .8, 4, 4, 2);
					pixels.applyFilter(pixels, pixels.rect, new Point(), dropShad);
				}
				
				b3 = FlxDestroyUtil.dispose(b3);
				b4 = FlxDestroyUtil.dispose(b4);
				spr2 = FlxDestroyUtil.destroy(spr2);
			}
			else
			{
				spr2 = new FlxSprite();
				b2 = new BitmapData(b1.width, b1.height, true, 0xffffffff);
				b3 = new BitmapData(b1.width, b1.height, true, colors[3]);
				b4 = new BitmapData(b1.width + 4, b1.height +4, true, 0x0);
				FlxSpriteUtil.alphaMask(spr2, b3, b1);			
				
				for (sx in 0...3)
				{
					for (sy in 0...3)
					{
						b4.copyPixels(spr2.pixels, spr2.pixels.rect, new Point(sx, sy), spr2.pixels, new Point(0, 0), true);
					}
				}
				
				
				b2.fillRect(new Rectangle(0, 0, b1.width, b1.height), colors[0]);
				b2.fillRect(new Rectangle(0, (b1.height / 2), b1.width, 1), colors[1]);
				b2.fillRect(new Rectangle(0, (b1.height / 2) + 1, b1.width, b1.height), colors[2]);
				
				FlxSpriteUtil.alphaMask(spr, b2, b1);
				makeGraphic(Std.int(spr.width + 4), Std.int(spr.height + 4), 0x0, true);
				
				//
				pixels.copyPixels(b4, b4.rect, new Point(1, 1));
				pixels.copyPixels(spr.pixels, spr.pixels.rect, new Point(2, 2), pixels,new Point(2,2),true);
				
				
				
				/*
				inglow = new GlowFilter(colors[0], 1, 2, 2, 4, 1, true);
				pixels.applyFilter(pixels, pixels.rect, new Point(), inglow);
				
				outline = new DropShadowFilter(0, 90, colors[3], 1, 4, 4, 20);
				pixels.applyFilter(pixels, pixels.rect, new Point(), outline);*/
				
				b3 = FlxDestroyUtil.dispose(b3);
				b4 = FlxDestroyUtil.dispose(b4);
				spr2 = FlxDestroyUtil.destroy(spr2);
				
			}
			FlxG.bitmap.remove(FlxG.bitmap.get(FlxG.bitmap.findKeyForBitmap(b1)));
			FlxG.bitmap.remove(FlxG.bitmap.get(FlxG.bitmap.findKeyForBitmap(b2)));
			b1 = FlxDestroyUtil.dispose(b1);
			b2 = FlxDestroyUtil.dispose(b2);
			
			spr = FlxDestroyUtil.destroy(spr);
		}
		
		
		dirty = true;
		updateFramePixels();
		
		
		
	}
	
	function get_text():String 
	{
		return _text;
	}
	
	function set_text(value:String):String 
	{
		if (_text != value)
		{
			_text = value;
			drawText();
		}
		return _text;
	}
	
	public var text(get_text, set_text):String;
	
	function get_style():Int 
	{
		return _style;
	}
	
	function set_style(value:Int):Int 
	{
		if (_style != value)
		{
			_style = value;
			drawText();
		}
		return _style;
	}
	
	public var style(get_style, set_style):Int;
	
	function get_textColor():Int 
	{
		return _textColor;
	}
	
	function set_textColor(value:Int):Int 
	{
		if (_textColor != value)
		{
			_textColor = value;
			drawText();
		}
		return _textColor;
	}
	
	public var textColor(get_textColor, set_textColor):Int;
	
}