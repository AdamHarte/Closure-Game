package com.adamharte.closure.enemy;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Enemy extends FlxSprite
{
	var _targetDirection:Int;
	var _target:FlxSprite;
	var _healthMax:Float;
	var _reloadTime:Float;
	var _jumpPower:Int;
	var _walkSpeed:Int;
	var _player:Player;
	var _bullets:FlxGroup;
	var _jumpTimer:Float;
	var _jumpTimerLimit:Float;
	var _shootTimer:Float;
	var _aggression:Int;
	
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
	}
	
	public function init(xPos:Float, yPos:Float, player:Player, ?bullets:FlxGroup):Void 
	{
		reset(xPos + offset.x, yPos + offset.y);
		_player = player;
		_bullets = bullets;
		
		_target = _player;
		health = _healthMax;
		_jumpTimer = 0;
		_shootTimer = 0;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		_player = null;
		_bullets = null;
	}
	
	override public function update():Void 
	{
		acceleration.x = 0;
		
		// Set direction of the target to work out which way enemy should walk.
		var isTargetRight:Bool = Math.abs(FlxAngle.angleBetween(this, _target)) < (Math.PI * 0.5);
		_targetDirection = (isTargetRight) ? FlxObject.RIGHT : FlxObject.LEFT;
		
		if (!FlxSpriteUtil.isFlickering(this)) 
		{
			if (velocity.y == 0) 
			{
				animation.play('walk');
			}
			acceleration.x += (_targetDirection == FlxObject.RIGHT) ? drag.x : -drag.x;
		}
		
		if (velocity.y == 0) 
		{
			if (isTouching(_targetDirection)) // blocked by anything but the mainframe.
			{
				_jumpTimer += FlxG.elapsed;
				if (_jumpTimer > _jumpTimerLimit) 
				{
					velocity.y = -_jumpPower;
					animation.play('jump');
					_jumpTimer = 0;
				}
			}
			else if (isTouching(FlxObject.FLOOR))
			{
				//Detect if walking off edge, and randomly decide to jump.
				var tx:Int = Math.round(x / Reg.tileWidth);
				var ty:Int = Math.round(y / Reg.tileHeight);
				var dir:Int = (_targetDirection == FlxObject.RIGHT) ? 1 : -1;
				var tile:Int = Reg.level.foregroundTilemap.getTile(tx + dir, ty + 1);
				var chance:Int = 5;
				if (tile == 0 && FlxRandom.chanceRoll(chance)) 
				{
					velocity.y = -_jumpPower;
					animation.play('jump');
				}
			}
		}
		else
		{
			_jumpTimer = 0;
		}
		
		if (velocity.x > 0) 
		{
			facing = FlxObject.RIGHT;
		}
		else if (velocity.x < 0)
		{
			facing = FlxObject.LEFT;
		}
		
		// Shoot
		_shootTimer = Math.max(_shootTimer - FlxG.elapsed, 0);
		if (_shootTimer == 0 /*&& (playerDist < minShootRange || mainframeDist < minShootRange)*/) 
		{
			//var canSeePlayer:Bool = Reg.tileMap.ray(getMidpoint(), _player.playerMidPoint);
			if (/*canSeePlayer &&*/ FlxRandom.chanceRoll(_aggression)) 
			{
				shoot();
			}
		}
		
		super.update();
	}
	
	override public function hurt(damage:Float):Void 
	{
		animation.play('hit');
		FlxSpriteUtil.flicker(this, 0.4);
		Reg.score += 10;
		
		super.hurt(damage);
	}
	
	override public function kill():Void 
	{
		if (!alive) 
		{
			return;
		}
		
		super.kill();
		
		//FlxG.sound.play('Explosion', 0.5);
		
		FlxSpriteUtil.stopFlickering(this);
		//_gibs.at(this);
		//_gibs.start(true, 3, 0, _gibQuantity);
		Reg.score += 100;
		Reg.enemiesKilled++;
	}
	
	
	
	private function shoot() 
	{
		_shootTimer = _reloadTime;
		
		// Make the shoot sound.
		//FlxG.sound.play('EnemyShoot', 0.3);
		
		// Fire the bullet.
		/*var bullet:Lazer = cast(_bullets.recycle(Lazer), Lazer);
		bullet.speed = 200;
		bullet.shoot(getMidpoint(), Math.PI);*/
	}
	
}