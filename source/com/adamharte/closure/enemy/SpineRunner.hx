package com.adamharte.closure.enemy;
import com.adamharte.closure.weapons.FlameBullet;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class SpineRunner extends Enemy
{

	public function new() 
	{
		super();
		
		loadGraphic('assets/images/creatures_01.png', true, 64, 64);
		width = 62;
		height = 38;
		offset.x = 2;
		offset.y = 26;
		
		_healthMax = 4;
		_reloadTime = 2.0;
		_jumpPower = 240;
		_walkSpeed = FlxRandom.intRanged(50, 70) + (Reg.levelNumber * 2);
		_jumpTimerLimit = Math.max(1.0 - (Reg.levelNumber * 0.02), 0.01);
		//_gibQuantity = 5;
		_agroDistance = 600;
		
		drag.x = _walkSpeed * 8;
		acceleration.y = Reg.gravity;
		maxVelocity.x = _walkSpeed;
		maxVelocity.y = 1000; // _jumpPower;
		
		// Setup animations.
		animation.add('idle', [1], 6);
		animation.add('walk', [5, 6, 7, 8, 9], 12);
		animation.add('hit', [5, 6, 3, 5], 6);
		animation.add('jump', [2, 3, 4], 6, false);
		animation.add('death', [10, 11, 12, 13], 6, false);
		
		//animation.play('idle');
	}
	
	override public function init(xPos:Float, yPos:Float, player:Player, ?bullets:FlxGroup):Void 
	{
		super.init(xPos, yPos, player, Reg.enemyBullets);
		
		_aggression = FlxRandom.intRanged(0, 3);// 0; // Stop enemy from shooting.
	}
	
	override function shoot() 
	{
		//super.shoot();
		
		_shootTimer = _reloadTime;
		
		// Make the shoot sound.
		var soundId:String = (FlxRandom.chanceRoll(50)) ? 'ShootFire1' : 'ShootFire2';
		FlxG.sound.play(soundId, 0.3);
		
		// Fire the bullet.
		var bullet:FlameBullet = cast(_bullets.recycle(FlameBullet), FlameBullet);
		bullet.speed = 200;
		
		var mid = getMidpoint();
		var playerMid = _player.getMidpoint();
		var shootAngle = FlxAngle.asRadians(FlxAngle.getAngle(mid, playerMid) - 90);
		bullet.shoot(mid, shootAngle);
	}
	
}