package com.adamharte.closure.weapons;

import com.adamharte.closure.Reg;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Bullet extends FlxSprite
{
	public var speed:Float;
	public var damage:Float;
	public var splashDamage:Bool;
	public var splashDamageRadius:Float;
	
	private var dieOnHitWall:Bool;
	private var dieOnHitEnemy:Bool;
	
	
	public function new() 
	{
		super();
		
		dieOnHitWall = true;
		dieOnHitEnemy = true;
		
		damage = 1;
		splashDamage = false;
		splashDamageRadius = 0;
	}
	
	override public function update():Void
	{
		if (!alive) 
		{
			if (animation.finished) 
			{
				exists = false;
			}
		}
		else if (dieOnHitWall && touching != 0) 
		{
			kill();
		}
		
		super.update();
	}
	
	override public function kill():Void
	{
		if(!alive)
		{
			return;
		}
		
		if (splashDamage) 
		{
			splash();
		}
		
		acceleration.x = 0;
		acceleration.y = 0;
		velocity.x = 0;
		velocity.y = 0;
		angularVelocity = 0;
		
		alive = false;
		solid = false;
	}
	
	public function shoot(startLocation:FlxPoint, rotationAngle:Float):Void
	{
		reset(startLocation.x - width / 2, startLocation.y - height / 2);
		solid = true;
		angle = FlxAngle.asDegrees(rotationAngle);
		velocity.x = Math.cos(rotationAngle) * speed;
		velocity.y = Math.sin(rotationAngle) * speed;
	}
	
	
	
	/**
	 * Apply splash damage to all enemies in range.
	 */
	private function splash():Void 
	{
		/*Reg.enemies.forEachAlive(function(target:FlxBasic) {
			if (Std.is(target, Enemy)) 
			{
				var enemy:Enemy = cast(target, Enemy);
				//var dist:Int = FlxMath.distanceBetween(this, enemy);
				var dist:Float = this.getMidpoint().distanceTo(enemy.getMidpoint());
				if (dist < splashDamageRadius) 
				{
					var delta:Float = 1 - (dist / splashDamageRadius);
					enemy.hurt(damage * delta);
				}
			}
		});*/
		
		var dist:Float = this.getMidpoint().distanceTo(Reg.player.playerMidPoint);
		if (dist < splashDamageRadius) 
		{
			var delta:Float = 1 - (dist / splashDamageRadius);
			trace(damage * delta);
			Reg.player.hurt(damage * delta);
		}
		
	}
	
}