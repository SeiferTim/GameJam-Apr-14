package ;

class Choice
{

	public var texts(default, null):Array<String>;
	public var stat(default, null):Int;
	public var passTexts(default, null):Array<String>;
	public var passResult(default, null):Int;
	public var failTexts(default, null):Array<String>;
	public var failResult(default, null):Int;
	public var flag(default, null):String;
	
	public function new(Texts:Array<String>, Stat:Int, PassTexts:Array<String>, PassResult:Int, FailTexts:Array<String>, FailResult:Int, Flag:String = "") 
	{
		texts = Texts.copy();
		stat = Stat;
		passTexts = PassTexts.copy();
		passResult = PassResult;
		failTexts = FailTexts.copy();
		failResult = FailResult;
		flag = Flag;
	}
	
}