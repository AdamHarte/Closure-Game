package com.adamharte.closure.weapons;

import com.adamharte.closure.Player;
import com.adamharte.closure.Reg;
import com.adamharte.closure.weapons.WeaponType;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class PlayerWeapon extends FlxSprite
{
	private var _weaponType:WeaponType;
	private var _barrelOffset:Float;
	private var _bulletSpeed:Float;
	private var _reloadTimer:Float;
	private var _reloadMax:Float;
	private var _shotReady:Bool;
	private var _manualReloadOverride:Bool;
	private var _shootSound:String;
	//private var _shootSoundSlow:String;
	
	
	
	function get_weaponType():WeaponType 
	{
		return _weaponType;
	}
	function set_weaponType(value:WeaponType):WeaponType 
	{
		switch (value) 
		{
			case WeaponType.RevolverWeapon:
				loadGraphic('assets/images/weapons.png', false, 32, 32);
				setFacingFlip(FlxObject.LEFT, true, false);
				setFacingFlip(FlxObject.RIGHT, false, false);
				width = 18;
				height = 8;
				offset.set(2, 2);
				origin.set(4, 4);
				
				_manualReloadOverride = true;
				_reloadMax = 0.2;
				_barrelOffset = 6.0;
				_bulletSpeed = 800;
				_shootSound = 'Shoot';
				//_shootSoundSlow = 'ShootSlow';
			case WeaponType.BowWeapon:
				loadGraphic('assets/images/weapons.png', false, 32, 32);
				setFacingFlip(FlxObject.LEFT, true, false);
				setFacingFlip(FlxObject.RIGHT, false, false);
				width = 18;
				height = 8;
				offset.set(2, 2);
				
				_manualReloadOverride = true;
				_reloadMax = 0.2;
				_barrelOffset = 6.0;
				_bulletSpeed = 350;
				_shootSound = 'Shoot';
				//_shootSoundSlow = 'ShootSlow';
			case WeaponType.FlameWeapon:
				//
		}
		return _weaponType = value;
	}
	public var weaponType(get_weaponType, set_weaponType):WeaponType;
	
	function get_barrelOffset():Float 
	{
		return _barrelOffset;
	}
	function set_barrelOffset(value:Float):Float 
	{
		return _barrelOffset = value;
	}
	public var barrelOffset(get_barrelOffset, set_barrelOffset):Float;
	
	function get_shotReady():Bool 
	{
		return _shotReady;
	}
	public var shotReady(get_shotReady, null):Bool;
	
	function get_manualReloadOverride():Bool 
	{
		return _manualReloadOverride;
	}
	/**
	 * Everytime the player clicks to shoot, then the weapon is reloaded first, so they do not have to wait for the reload timer.
	 */
	public var manualReloadOverride(get_manualReloadOverride, null):Bool;
	
	
	
	public function new() 
	{
		super();
		
		_shotReady = false;
		_reloadTimer = 0;
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void
	{
		_reloadTimer += FlxG.elapsed;
		if (_reloadTimer >= _reloadMax) 
		{
			reload();
		}
	}
	
	/**
	 * Fire a bullet along the given angle.
	 * @param	angle	In Radians.
	 * @param	power	Number between 0 and 1. Only some bullets use power.
	 */
	public function shoot(angle:Float, power:Float):Void 
	{
		if (!alive) return;
		
		_shotReady = false;
		_reloadTimer = 0;
		
		// Make the shoot sound.
		//var soundId:String = (FlxG.timeScale < 0.7) ? _shootSoundSlow : _shootSound;
		FlxG.sound.play(_shootSound, 0.5);
		
		// Find the bullet start position based on player and gun.
		var op:Float = Math.sin(angle) * barrelOffset;
		var ad:Float = Math.cos(angle) * barrelOffset;
		getMidpoint(_point);
		_point.x += ad;
		_point.y += op;
		
		// Setup a bullet from the pool.
		var bullet:Bullet;
		switch (weaponType) 
		{
			case WeaponType.RevolverWeapon:
				bullet = cast(Reg.bullets.recycle(RevolverBullet), RevolverBullet);
				bullet.speed = _bulletSpeed;
			case WeaponType.BowWeapon:
				bullet = cast(Reg.bullets.recycle(RevolverBullet), RevolverBullet);
				bullet.speed = _bulletSpeed;
			case WeaponType.FlameWeapon:
				bullet = cast(Reg.bullets.recycle(FlameBullet), FlameBullet);
				bullet.speed = _bulletSpeed;
		}
		
		// Fire the bullet.
		bullet.shoot(_point, angle);
	}
	
	public function reload():Void 
	{
		_reloadTimer = 0;
		_shotReady = true;
	}
	
	override public function kill():Void
	{
		if(!alive)
		{
			return;
		}
		
		super.kill();
		
		solid = false;
		exists = true;
		visible = false;
		
	}
	
}