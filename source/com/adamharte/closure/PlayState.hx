package com.adamharte.closure;

import com.adamharte.closure.enemy.Enemy;
import com.adamharte.closure.enemy.SpineRunner;
import com.adamharte.closure.weapons.Bullet;
import com.adamharte.closure.weapons.PlayerWeapon;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var levelTilesPath:String;
	var levelObjectsPath:String;
	
	var _cameraFollowPoint:FlxObject;
	var _level:TiledLevel;
	var _player:Player;
	var _playerItems:FlxGroup;
	var _playerWeapon:PlayerWeapon;
	
	// Collision groups
	var _hazards:FlxGroup;
	var _objects:FlxGroup;
	
	
	override public function create():Void
	{
		levelTilesPath = 'assets/level_tiles.png';
		levelObjectsPath = 'assets/level_objects.png';
		
		Reg.score = 0;
		Reg.enemiesKilled = 0;
		
		// Setup groups.
		Reg.enemies = new FlxGroup();
		Reg.bullets = new FlxGroup();
		
		// Setup tile maps.
		_level = new TiledLevel(Reg.currentLevel.filePath);
		Reg.level = _level;
		buildLevel();
		
		_playerItems = new FlxGroup();
		
		_playerWeapon = new PlayerWeapon();
		_player = new Player(_level.playerSpawn.x, _level.playerSpawn.y, _playerWeapon);
		
		add(_level.foregroundTiles);
		add(_player);
		add(_playerItems);
		_playerItems.add(_playerWeapon);
		add(Reg.enemies);
		add(Reg.bullets);
		
		spawnEnemies();
		
		_hazards = new FlxGroup();
		_hazards.add(Reg.enemies);
		
		_objects = new FlxGroup();
		_objects.add(_player);
		_objects.add(Reg.enemies);
		_objects.add(Reg.bullets);
		
		_cameraFollowPoint = new FlxObject();
		_cameraFollowPoint.setPosition(_player.x, _player.y);
		
		// Setup camera.
		_cameraFollowPoint = new FlxObject();
		_cameraFollowPoint.setPosition(_player.x, _player.y);
		FlxG.camera.setBounds(0, 0, _level.fullWidth, _level.fullHeight, true);
		FlxG.camera.follow(_cameraFollowPoint, FlxCamera.STYLE_PLATFORMER, new FlxPoint(), 5);
		
		//FlxG.debugger.drawDebug = true;
		
		super.create();
		
		FlxG.camera.fade(0xff000000, 1, true);
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		_level = null;
		_player = null;
		_playerItems = null;
		_playerWeapon = null;
		Reg.enemies = null;
		Reg.bullets = null;
		
		_objects = null;
	}

	override public function update():Void
	{
		// Set the camera to a point halfway between the mouse and the player.
		var mouseOffsetX:Float = (FlxG.mouse.screenX - (FlxG.width / 2)) * 0.5;
		var mouseOffsetY:Float = (FlxG.mouse.screenY - (FlxG.height / 2)) * 0.5;
		_cameraFollowPoint.setPosition(_player.x + mouseOffsetX, _player.y + mouseOffsetY);
		
		
		// Handle all collisions.
		_level.collideWithLevel(_objects);
		FlxG.overlap(_hazards, _player, overlapHandler);
		FlxG.overlap(Reg.bullets, _hazards, shootHazardsOverlapHandler);
		
		
		super.update();
	}
	
	
	
	function buildLevel() 
	{
		_level.loadObjects();
		
		
		
	}
	
	function spawnEnemies() 
	{
		for (creaturePoint in _level.creatures) 
		{
			var creature:SpineRunner = cast(Reg.enemies.recycle(SpineRunner), SpineRunner);
			creature.init(creaturePoint.x, creaturePoint.y, _player);
		}
	}
	
	
	
	/**
	 * Handle collisions of enemies or their bullets with the player or player structures.
	 * 
	 * @param	hazard		Hazard such and an enemy or an enemies bullet.
	 * @param	friendly	Player or player structure.
	 */
	function overlapHandler(hazard:FlxObject, friendly:FlxObject) 
	{
		if (Std.is(hazard, Bullet)) 
		{
			var enemyBullet:Bullet = cast(hazard, Bullet);
			enemyBullet.kill();
			
			friendly.hurt(enemyBullet.damage);
		}
		else if (Std.is(hazard, Enemy) && Std.is(friendly, Player)) 
		{
			var enemy:Enemy = cast(hazard, Enemy);
			friendly.hurt(1);
		}
	}
	
	function shootHazardsOverlapHandler(playerBullet:Bullet, hazard:FlxObject):Void 
	{
		playerBullet.kill();
		if (!playerBullet.splashDamage) 
		{
			hazard.hurt(playerBullet.damage);
		}
	}
	
	
}