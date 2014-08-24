package com.adamharte.closure.weapons;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class BombBullet extends Bullet
{

	public function new() 
	{
		super();
		
		loadGraphic('assets/images/projectiles.png', true, 16, 16);
		width = 11;
		height = 11;
		//offset.set(6, 5);
		
		animation.add('idle', [8, 9, 10, 11], 12);
		animation.add('hit', [8], 24, false);
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