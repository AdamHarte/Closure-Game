package com.adamharte.closure.enemy;
import com.adamharte.closure.weapons.BombBullet;
import flixel.group.FlxGroup;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class TallSpitter extends Enemy
{

	public function new() 
	{
		super();
		
		loadGraphic('assets/images/creatures_02.png', true, 64, 64);
		width = 24;
		height = 60;
		offset.x = 22;
		offset.y = 4;
		
		_healthMax = 3;
		_reloadTime = 2.0;
		_jumpPower = 0;// 200;
		_walkSpeed = 0;// FlxRandom.intRanged(50, 70) + (Reg.levelNumber * 2);
		_jumpTimerLimit = -1;// Math.max(1.0 - (Reg.levelNumber * 0.02), 0.01);
		//_gibQuantity = 5;
		
		drag.x = _walkSpeed * 8;
		acceleration.y = Reg.gravity;
		//maxVelocity.x = _walkSpeed;
		maxVelocity.y = 1000; // _jumpPower;
		
		_canJump = false;
		_canWalk = false;
		
		// Setup animations.
		animation.add('idle', [1, 2, 3, 4], 6);
		//animation.add('walk', [1, 2, 3, 4], 6);
		animation.add('hit', [6, 8, 3, 1], 6);
		//animation.add('jump', [2, 3, 4], 6, false);
		animation.add('shoot', [5, 6, 7, 8, 9, 10, 11], 12, false);
		animation.add('death', [12, 13, 14, 15], 12, false);
		
		animation.play('idle');
	}
	
	override public function init(xPos:Float, yPos:Float, player:Player, ?bullets:FlxGroup):Void 
	{
		super.init(xPos, yPos, player, Reg.enemyBullets);
		
		_aggression = FlxRandom.intRanged(1, 3);
	}
	
	override function shoot() 
	{
		//super.shoot();
		
		_shootTimer = _reloadTime;
		
		// Make the shoot sound.
		//var soundId:String = (FlxRandom.chanceRoll(50)) ? 'ShootFire1' : 'ShootFire2';
		//FlxG.sound.play(soundId, 0.3);
		
		// Fire the bullet.
		var bullet:BombBullet = cast(_bullets.recycle(BombBullet), BombBullet);
		bullet.speed = 200;
		
		var mid = getMidpoint();
		mid.y -= 25;
		var playerMid = _player.getMidpoint();
		var shootAngle = FlxAngle.asRadians(FlxAngle.getAngle(mid, playerMid) - 90);
		bullet.shoot(mid, shootAngle);
		
		animation.play('shoot');
		
		new FlxTimer(0.8, shootEndTimer);
	}
	
	function shootEndTimer(timer:FlxTimer) 
	{
		if (!alive) 
		{
			return;
		}
		animation.play('idle');
	}
	
}