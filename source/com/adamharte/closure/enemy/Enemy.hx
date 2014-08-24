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
	var _canJump:Bool;
	var _canWalk:Bool;
	var _agroDistance:Float; // Distance that the player can get, before waking the enemy.
	var _agroed:Bool;
	
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		_canJump = true;
		_canWalk = true;
		_agroDistance = 600;
		_agroed = false;
		
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
		
		animation.play('idle');
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		_player = null;
		_bullets = null;
	}
	
	override public function update():Void 
	{
		if (!alive) 
		{
			if (isTouching(FlxObject.FLOOR)) 
			{
				acceleration.set();
				solid = false;
			}
			
			super.update();
			return;
		}
		
		acceleration.x = 0;
		
		// Set direction of the target to work out which way enemy should walk.
		var isTargetRight:Bool = Math.abs(FlxAngle.angleBetween(this, _target)) < (Math.PI * 0.5);
		_targetDirection = (isTargetRight) ? FlxObject.RIGHT : FlxObject.LEFT;
		
		var distanceToPlayer:Float = this.getMidpoint().distanceTo(Reg.player.playerMidPoint);
		
		if (distanceToPlayer < _agroDistance) 
		{
			_agroed = true;
		}
		
		if (!FlxSpriteUtil.isFlickering(this) && _agroed) 
		{
			if (_canWalk && velocity.y == 0) 
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
				if (_canJump && _agroed && _jumpTimer > _jumpTimerLimit) 
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
				var chance:Float = 0.2;
				if (_canJump && _agroed && tile == 0 && FlxRandom.chanceRoll(chance)) 
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
		if (_shootTimer == 0 && _agroed /*&& (playerDist < minShootRange || mainframeDist < minShootRange)*/) 
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
		if (!alive) 
		{
			return;
		}
		
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
		
		FlxSpriteUtil.stopFlickering(this);
		//_gibs.at(this);
		//_gibs.start(true, 3, 0, _gibQuantity);
		Reg.score += 100;
		Reg.enemiesKilled++;
		
		//solid = false;
		exists = true;
		velocity.set();
		acceleration.x = 0;
		//acceleration.set();
		animation.play('death');
		//FlxG.sound.play('Explosion', 0.5);
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