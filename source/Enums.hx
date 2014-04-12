package ;

class Enums
{

	public static inline var ROLE_CAPTAIN:Int = 0;
	public static inline var ROLE_PILOT:Int = 1;
	public static inline var ROLE_DOCTOR:Int = 2;
	public static inline var ROLE_GUNNER:Int = 3;
	public static inline var ROLE_ENGINEER:Int = 4;
	
	public static inline var STAT_JUDGEMENT:Int = 0;
	public static inline var STAT_LUCK:Int = 1;
	public static inline var STAT_LOGIC:Int = 2;
	public static inline var STAT_PHYSIQUE:Int = 3;
	public static inline var STAT_FINESSE:Int = 4;
	
	public static function parseRole(Role:String):Int
	{
		if (Role == 'captain')
			return ROLE_CAPTAIN;
		else if (Role == 'pilot')
			return ROLE_PILOT;
		else if (Role == 'doctor')
			return ROLE_DOCTOR;
		else if (Role == 'gunner')
			return ROLE_GUNNER;
		else if (Role == 'engineer')
			return ROLE_ENGINEER;
		else
			return -1;
		
	}
	
	public static function getRole(Role:Int):String
	{
		switch(Role)
		{
			case 0:
				return 'Captain';
			case 1:
				return 'Pilot';
			case 2:
				return 'Doctor';
			case 3:
				return 'Gunner';
			case 4:
				return 'Engineer';
			default:
				return '';
				
		}
	}
	
	public static function getStat(Stat:Int):String
	{
		switch (Stat)
		{
			case 0:
				return 'Judgement';
			case 1:
				return 'Luck';
			case 2:
				return 'Logic';
			case 3:
				return 'Physique';
			case 4:
				return 'Finesse';
			default:
				return '';
		}
	}
	
	public static function parseAttrib(Attrib:String):Int
	{
		if (Attrib == 'Judgement')
			return STAT_JUDGEMENT;
		else if (Attrib == 'Luck')
			return STAT_LUCK;
		else if (Attrib == 'Logic')
			return STAT_LOGIC;
		else if (Attrib == 'Physique')
			return STAT_PHYSIQUE;
		else if (Attrib == 'Finesse')
			return STAT_FINESSE;
		else
			return -1;
	}
	
	
}