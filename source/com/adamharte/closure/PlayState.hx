package com.adamharte.closure;

import com.adamharte.closure.enemy.Enemy;
import com.adamharte.closure.enemy.SpineRunner;
import com.adamharte.closure.gui.Hud;
import com.adamharte.closure.gui.MissionMap;
import com.adamharte.closure.gui.StatusOverlay;
import com.adamharte.closure.sprites.Portal;
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
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var levelTilesPath:String;
	var levelObjectsPath:String;
	
	var _cameraFollowPoint:FlxObject;
	var _hud:Hud;
	var _level:TiledLevel;
	var _player:Player;
	var _playerItems:FlxGroup;
	var _playerWeapon:PlayerWeapon;
	var _portal:Portal;
	
	// Collision groups
	var _hazards:FlxGroup;
	var _objects:FlxGroup;
	
	var _levelComplete:Bool;
	
	
	override public function create():Void
	{
		levelTilesPath = 'assets/level_tiles.png';
		levelObjectsPath = 'assets/level_objects.png';
		
		_levelComplete = false;
		
		Reg.score = 0;
		Reg.enemiesKilled = 0;
		
		_portal = new Portal();
		
		// Setup groups.
		Reg.enemies = new FlxGroup();
		Reg.bullets = new FlxGroup();
		Reg.enemyBullets = new FlxGroup();
		
		// Setup tile maps.
		_level = new TiledLevel(Reg.currentLevel.filePath);
		Reg.level = _level;
		buildLevel();
		
		_playerItems = new FlxGroup();
		
		_playerWeapon = new PlayerWeapon();
		_player = new Player(_level.playerSpawn.x, _level.playerSpawn.y, _playerWeapon);
		//_player.velocity.set(150, -300);
		
		_hud = new Hud();
		Reg.statusOverlay = new StatusOverlay();
		
		add(_level.foregroundTiles);
		add(_portal);
		add(_player);
		add(_playerItems);
		_playerItems.add(_playerWeapon);
		add(Reg.enemies);
		add(Reg.bullets);
		add(Reg.enemyBullets);
		add(_hud);
		add(Reg.statusOverlay);
		
		spawnEnemies();
		
		_hazards = new FlxGroup();
		_hazards.add(Reg.enemies);
		_hazards.add(Reg.enemyBullets);
		
		_objects = new FlxGroup();
		_objects.add(_player);
		_objects.add(Reg.enemies);
		_objects.add(Reg.bullets);
		_objects.add(Reg.enemyBullets);
		
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
		_hud = null;
		Reg.statusOverlay = null;
		_player = null;
		_playerItems = null;
		_playerWeapon = null;
		_portal = null;
		Reg.enemies = null;
		Reg.bullets = null;
		Reg.enemyBullets = null;
		
		_objects = null;
	}

	override public function update():Void
	{
		// Check win.
		if (Reg.enemiesKilled == Reg.currentLevel.enemyCount && Reg.enemyBullets.countLiving() == 0) 
		{
			finishedLevel();
		}
		
		// Set the camera to a point halfway between the mouse and the player.
		var mouseOffsetX:Float = (FlxG.mouse.screenX - (FlxG.width / 2)) * 0.5;
		var mouseOffsetY:Float = (FlxG.mouse.screenY - (FlxG.height / 2)) * 0.5;
		_cameraFollowPoint.setPosition(_player.x + mouseOffsetX, _player.y + mouseOffsetY);
		
		
		// Handle all collisions.
		_level.collideWithLevel(_objects);
		FlxG.overlap(_hazards, _player, overlapHandler);
		FlxG.overlap(Reg.bullets, _hazards, shootHazardsOverlapHandler);
		
		_hud.playerHealth = _player.health;
		
		if(FlxG.keys.justPressed.E)
		{
			openSubState(new MissionMap());
		}
		
		super.update();
	}
	
	
	
	function buildLevel() 
	{
		_level.loadObjects();
		
		_portal.init(_level.portal.x, _level.portal.y);
		
	}
	
	function spawnEnemies() 
	{
		for (creaturePoint in _level.creatures) 
		{
			var creature:SpineRunner = cast(Reg.enemies.recycle(SpineRunner), SpineRunner);
			creature.init(creaturePoint.x, creaturePoint.y, _player);
		}
	}
	
	function finishedLevel():Void 
	{
		if (_levelComplete) 
		{
			return;
		}
		_levelComplete = true;
		Reg.currentLevel.completed = true;
		
		Reg.scores[Reg.levelNumber] = Reg.score;
		//Reg.score = 0;
		
		//_statusOverlay.show('SUCCESS');
		
		new FlxTimer().start(1, finishedLevelFade);
	}
	
	function finishedLevelFade(timer:FlxTimer):Void 
	{
		//FlxG.cameras.fade(0xff000000, 1, false, winLevelFadeHandler);
		winLevelFadeHandler();
	}
	
	function winLevelFadeHandler():Void 
	{
		//TODO: Go to town level.
		openSubState(new MissionMap());
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
		if (!Std.is(hazard, Bullet) && playerBullet.alive)
		{
			playerBullet.kill();
			if (!playerBullet.splashDamage) 
			{
				hazard.hurt(playerBullet.damage);
			}
		}
	}
	
	
}