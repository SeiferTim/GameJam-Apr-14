package ;


class GameEvent
{

	public var weekNo(default, null):Int;
	public var activePlayer(default, null):Int;
	public var opening(default, null):Array<String>;
	public var choices(default, null):Array<Choice>;
	
	public function new(WeekNo:Int, ActivePlayer:Int, Opening:Array<String>, Choices:Array<Choice>)
	{
		weekNo = WeekNo;
		activePlayer = ActivePlayer;
		opening = Opening;
		choices = Choices;
	}
	
}