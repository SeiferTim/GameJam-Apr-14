package ;
import flixel.system.FlxPreloader;
import flixel.system.FlxPreloaderBase;

class MyPreloader extends FlxPreloader
{

	public function new() 
	{
		super(0, ['http://aethon.tims-world.com/', 'http://t1gam.tims-world.com/', FlxPreloaderBase.LOCAL]);
	}
	
}