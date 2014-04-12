package ;

class Player
{
	public var role:Int;
	public var stats:Array<Int>;
	
	
	public function new(Role:Int = -1, Judgement:Int, Luck:Int, Logic:Int, Physique:Int, Finesse:Int) 
	{
		role = Role;
		stats = [Judgement, Luck, Logic, Physique, Finesse];
	}
	
}