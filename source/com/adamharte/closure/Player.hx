package com.adamharte.closure;

import com.adamharte.closure.Reg;
import com.adamharte.closure.weapons.PlayerWeapon;
import com.adamharte.closure.weapons.WeaponType;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Player extends FlxSprite
{
	public var playerMidPoint:FlxPoint;
	
	var _maxHealth:Int;
	var _jumpPower:Int;
	var _weapon:PlayerWeapon;
	var _restart:Float;
	var _spawnPoint:FlxPoint;
	
	
	public function new(startX:Float, startY:Float, weapon:PlayerWeapon) 
	{
		_spawnPoint = new FlxPoint(startX, startY);
		_weapon = weapon;
		_weapon.weaponType = WeaponType.RevolverWeapon;
		
		_maxHealth = 10;
		_jumpPower = 300;
		playerMidPoint = new FlxPoint();
		_restart = 0;
		
		super(startX, startY);
		
		//makeGraphic(16, 16, FlxColor.BLUE);
		loadGraphic('assets/images/player.png', true, 64, 64);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		width = 18;
		height = 48;
		offset.set(22, 14);
		
		var runSpeed:Int = 150;
		drag.x = runSpeed * 8;
		acceleration.y = Reg.gravity;
		maxVelocity.x = runSpeed;
		maxVelocity.y = _jumpPower * 3;
		
		// Setup animations.
		animation.add('idle', [2]);
		animation.add('run', [3, 4, 5, 6, 7, 8, 9, 10], 12);
		animation.add('jump', [11, 12, 13, 14], 10, false);
		
		health = _maxHealth;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		playerMidPoint = null;
		_weapon = null;
		_spawnPoint = null;
	}
	
	override public function update():Void 
	{
		if (!alive) 
		{
			_restart += FlxG.elapsed;
			if (_restart > 2) 
			{
				//respawn();
				FlxG.switchState(new PlayState());
			}
			return;
		}
		
		getMidpoint(playerMidPoint);
		
		//Movement
		acceleration.x = 0;
		if(FlxG.keys.pressed.A)
		{
			acceleration.x -= drag.x;
		}
		else if(FlxG.keys.pressed.D)
		{
			acceleration.x += drag.x;
		}
		
		var isAimingRight:Bool = Math.abs(FlxAngle.angleBetweenMouse(this)) < (Math.PI * 0.5);
		//facing = (isAimingRight) ? FlxObject.RIGHT : FlxObject.LEFT;
		if (velocity.x != 0) 
		{
			facing = (velocity.x > 0) ? FlxObject.RIGHT : FlxObject.LEFT;
		}
		
		// Jumping
		if (velocity.y == 0 && (FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)) 
		{
			velocity.y = -_jumpPower;
			FlxG.sound.play('Jump', 0.5);
			animation.play('jump');
		}
		
		// Animation
		if (velocity.y != 0)
		{
			// Don't change animation if our Y vel is zero.
		}
		else if(velocity.x == 0)
		{
			animation.play('idle');
		}
		else 
		{
			animation.play('run');
		}
		
		// Weapons.
		//_weapon.facing = facing;
		_weapon.facing = (isAimingRight) ? FlxObject.RIGHT : FlxObject.LEFT;
		_weapon.angle = FlxAngle.getAngle(_weapon.getMidpoint(), FlxG.mouse.getWorldPosition()) + ((isAimingRight) ? -90 : 90);
		if (isAimingRight)
		{
			_weapon.offset.set(2, 2);
			_weapon.origin.set(4, 4);
		}
		else 
		{
			_weapon.offset.set(30, 2);
			_weapon.origin.set(28, 4);
		}
		
		// Shoot
		if ((_weapon.manualReloadOverride && FlxG.mouse.justPressed) || (_weapon.shotReady && FlxG.mouse.pressed)) 
		{
			var shootPower:Float = _weapon.getMidpoint().distanceTo(FlxG.mouse.getWorldPosition());
			shootPower = Math.min(Math.max(shootPower - 30, 0), 70) / 70; // Raw power value range is 30-100. So we bring that to be 0-1 range.
			_weapon.shoot(FlxAngle.asRadians((isAimingRight) ? _weapon.angle : _weapon.angle - 180), shootPower);
		}
		
		
		
		super.update();
		
		var weaponOffset:FlxPoint = new FlxPoint(2, 12);
		if (!isAimingRight)
		{
			weaponOffset.set(18, 12);
		}
		_weapon.setPosition(x + weaponOffset.x, y + weaponOffset.y);
		
	}
	
	override public function hurt(damage:Float):Void
	{
		if (FlxSpriteUtil.isFlickering(this)) 
		{
			return;
		}
		
		FlxSpriteUtil.flicker(this, 0.2);
		
		super.hurt(damage);
	}
	
	override public function kill():Void
	{
		if(!alive)
		{
			return;
		}
		
		FlxSpriteUtil.stopFlickering(this);
		
		//TODO: Hide arm/weapon.
		_weapon.kill();
		
		//FlxG.sound.play('Explosion', 0.6);
		
		super.kill();
		
		solid = false;
		exists = true;
		visible = false;
		velocity.set();
		acceleration.x = 0;
		
		//Reg.playerGibs.at(this);
		//Reg.playerGibs.start(true, 5, 0, 30);
		
		FlxG.camera.shake(0.05, 0.4);
	}
	
	
	
	function respawn() 
	{
		reset(_spawnPoint.x, _spawnPoint.y);
		solid = true;
		acceleration.x = 0;
		velocity.set();
		_restart = 0;
		exists = true;
		visible = true;
		health = _maxHealth;
		
		//TODO: Show arm/weapon.
		_weapon.reset(x, y);
		_weapon.exists = true;
		_weapon.visible = true;
		_weapon.reload();
		
		FlxSpriteUtil.flicker(this, 1.0);
	}
	
}