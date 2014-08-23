package com.adamharte.closure.weapons;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class RevolverBullet extends Bullet
{

	public function new() 
	{
		super();
		
		loadGraphic('assets/images/projectiles.png', true);
		width = 8;
		height = 7;
		
		animation.add('idle', [0]);
		animation.add('hit', [1, 2, 3], 24, false);
	}
	
	override public function kill():Void
	{
		if(!alive)
		{
			return;
		}
		
		animation.play('hit');
		
		var hitSound:String = (FlxRandom.chanceRoll()) ? 'Hit1' : 'Hit2';
		//FlxG.sound.play(hitSound, 0.5);
		
		super.kill();
	}
	
	override public function shoot(startLocation:FlxPoint, rotationAngle:Float):Void
	{
		super.shoot(startLocation, rotationAngle);
		
		animation.play('idle');
	}
	
}