package com.adamharte.closure;

import com.adamharte.closure.enemy.Enemy;
import com.adamharte.closure.enemy.SpineRunner;
import com.adamharte.closure.enemy.SpineSprinter;
import com.adamharte.closure.enemy.TallSpitter;
import com.adamharte.closure.gui.Hud;
import com.adamharte.closure.gui.MissionMap;
import com.adamharte.closure.gui.StatusOverlay;
import com.adamharte.closure.sprites.Portal;
import com.adamharte.closure.weapons.Bullet;
import com.adamharte.closure.weapons.PlayerWeapon;
import flixel.effects.particles.FlxEmitter;
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
		
		Reg.bulletWoundGibs = new FlxEmitter();
		Reg.bulletWoundGibs.setXSpeed(-100, 100);
		Reg.bulletWoundGibs.setYSpeed(-60, 20);
		Reg.bulletWoundGibs.setRotation(-720, -720);
		Reg.bulletWoundGibs.gravity = 360;
		Reg.bulletWoundGibs.bounce = 0.1;
		Reg.bulletWoundGibs.makeParticles('assets/images/gore_sml_gibs.png', 60, 16, true, 0.5);
		
		Reg.goreGibs = new FlxEmitter();
		Reg.goreGibs.setXSpeed(-150, 150);
		Reg.goreGibs.setYSpeed(-400, 0);
		Reg.goreGibs.setRotation(-720, -720);
		Reg.goreGibs.gravity = 360;
		Reg.goreGibs.bounce = 0.5;
		Reg.goreGibs.makeParticles('assets/images/gore_gibs.png', 60, 16, true, 0.5);
		
		Reg.goreSmallGibs = new FlxEmitter();
		Reg.goreSmallGibs.setXSpeed(-150, 150);
		Reg.goreSmallGibs.setYSpeed(-400, 0);
		Reg.goreSmallGibs.setRotation(-720, -720);
		Reg.goreSmallGibs.gravity = 360;
		Reg.goreSmallGibs.bounce = 0.5;
		Reg.goreSmallGibs.makeParticles('assets/images/gore_sml_gibs.png', 60, 16, true, 0.5);
		
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
		Reg.player = _player;
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
		add(Reg.bulletWoundGibs);
		add(Reg.goreGibs);
		add(Reg.goreSmallGibs);
		//add(Reg.explosionGibs);
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
		_objects.add(Reg.bulletWoundGibs);
		_objects.add(Reg.goreGibs);
		_objects.add(Reg.goreSmallGibs);
		
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
		
		Reg.statusOverlay.show(Reg.currentLevel.levelName);
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		_level = null;
		_hud = null;
		Reg.statusOverlay = null;
		_player = null;
		Reg.player = null;
		_playerItems = null;
		_playerWeapon = null;
		_portal = null;
		Reg.enemies = null;
		Reg.bullets = null;
		Reg.enemyBullets = null;
		Reg.bulletWoundGibs = null;
		Reg.goreGibs = null;
		Reg.goreSmallGibs = null;
		//Reg.explosionGibs = null;
		
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
			FlxG.switchState(new MissionMap());
		}
		
		/*if (FlxG.mouse.wheel != 0) 
		{
			//FlxG.game.width *= (FlxG.mouse.wheel > 0) ? 1.1 : 0.9;
			//FlxG.game.height *= (FlxG.mouse.wheel > 0) ? 1.1 : 0.9;
			//FlxG.camera.zoom += (FlxG.mouse.wheel > 0) ? 0.2 : -0.2;
		}*/
		
		super.update();
	}
	
	
	
	function buildLevel() 
	{
		_level.loadObjects();
		
		_portal.init(_level.portal.x, _level.portal.y);
		
	}
	
	function spawnEnemies() 
	{
		for (creaturePoint in _level.creatures01) 
		{
			var creature:SpineRunner = cast(Reg.enemies.recycle(SpineRunner), SpineRunner);
			creature.init(creaturePoint.x, creaturePoint.y, _player);
		}
		for (creaturePoint in _level.creatures02) 
		{
			var creature:TallSpitter = cast(Reg.enemies.recycle(TallSpitter), TallSpitter);
			creature.init(creaturePoint.x, creaturePoint.y, _player);
		}
		for (creaturePoint in _level.creatures03) 
		{
			var creature:SpineSprinter = cast(Reg.enemies.recycle(SpineSprinter), SpineSprinter);
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
		
		Reg.statusOverlay.show('AREA CLEARED');
		
		new FlxTimer().start(1, finishedLevelFade);
	}
	
	function finishedLevelFade(timer:FlxTimer):Void 
	{
		//FlxG.cameras.fade(0xff000000, 1, false, winLevelFadeHandler);
		winLevelFadeHandler();
	}
	
	function winLevelFadeHandler():Void 
	{
		var allComplete:Bool = true;
		for (level in Reg.levels) 
		{
			if (!level.completed) 
			{
				allComplete = false;
				break;
			}
		}
		
		if (allComplete) 
		{
			FlxG.switchState(new GameOverState());
		}
		else 
		{
			FlxG.switchState(new MissionMap());
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
			if (enemyBullet.velocity.x > 0) 
			{
				Reg.bulletWoundGibs.setXSpeed(-10, 100);
			}
			else 
			{
				Reg.bulletWoundGibs.setXSpeed(-100, 10);
			}
			
			Reg.bulletWoundGibs.at(enemyBullet);
			Reg.bulletWoundGibs.start(true, 3, 0, 20);
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
				if (playerBullet.velocity.x > 0) 
				{
					Reg.bulletWoundGibs.setXSpeed(-10, 100);
				}
				else 
				{
					Reg.bulletWoundGibs.setXSpeed(-100, 10);
				}
				
				Reg.bulletWoundGibs.at(playerBullet);
				Reg.bulletWoundGibs.start(true, 3, 0, 20);
				hazard.hurt(playerBullet.damage);
			}
		}
	}
	
	
}