package com.adamharte.closure.weapons;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class BombBullet extends Bullet
{
	static private var liveTimerMax:Float = 2;
	
	var _liveTimer:Float;
	
	
	public function new() 
	{
		super();
		
		damage = 6;
		splashDamage = true;
		splashDamageRadius = 100;
		dieOnHitWall = false;
		acceleration.y = Reg.gravity;
		elasticity = 0.5;
		
		loadGraphic('assets/images/projectiles.png', true, 16, 16);
		width = 11;
		height = 11;
		//offset.set(6, 5);
		
		animation.add('idle', [8, 9, 10, 11], 12);
		animation.add('explode', [8], 24, false);
	}
	
	override public function update():Void 
	{
		_liveTimer = Math.max(_liveTimer - FlxG.elapsed, 0);
		if (_liveTimer == 0) 
		{
			kill();
		}
		
		if (touching == FlxObject.DOWN) 
		{
			drag.x = 1000;
			angularDrag = 1300;
		}
		else
		{
			drag.x = 0;
			angularDrag = 300;
		}
		
		super.update();
	}
	
	override public function kill():Void
	{
		if(!alive)
		{
			return;
		}
		
		Reg.goreGibs.at(this);
		Reg.goreGibs.start(true, 3, 0, 15);
		Reg.goreSmallGibs.at(this);
		Reg.goreSmallGibs.start(true, 2, 0, 30);
		
		animation.play('explode');
		
		//var hitSound:String = (FlxRandom.chanceRoll()) ? 'Hit1' : 'Hit2';
		FlxG.sound.play('Explosion1', 0.5);
		
		super.kill();
	}
	
	override public function shoot(startLocation:FlxPoint, rotationAngle:Float):Void
	{
		super.shoot(startLocation, rotationAngle);
		
		animation.play('idle');
		_liveTimer = liveTimerMax;
		acceleration.y = Reg.gravity;
		angularVelocity = FlxRandom.floatRanged(300, 800) * (FlxRandom.chanceRoll() ? 1 : -1);
		angularDrag = 300;
	}
	
}