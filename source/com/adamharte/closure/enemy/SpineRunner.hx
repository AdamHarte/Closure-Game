package com.adamharte.closure.enemy;
import flixel.FlxObject;
import flixel.group.FlxGroup;
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
		
		loadGraphic('assets/images/creatures_01.png', true, 32, 32);
		width = 31;
		height = 19;
		offset.x = 1;
		offset.y = 13;
		
		_healthMax = 1;
		_reloadTime = 2.0;
		_jumpPower = 300;
		_walkSpeed = FlxRandom.intRanged(50, 70) + (Reg.levelNumber * 2);
		_jumpTimerLimit = Math.max(1.0 - (Reg.levelNumber * 0.02), 0.01);
		//_gibQuantity = 5;
		
		drag.x = _walkSpeed * 8;
		acceleration.y = Reg.gravity;
		maxVelocity.x = _walkSpeed;
		maxVelocity.y = _jumpPower;
		
		// Setup animations.
		animation.add('idle', [1], 6);
		animation.add('walk', [5, 6, 7, 8, 9], 12);
		animation.add('hit', [5, 6, 3, 5], 6);
		animation.add('jump', [2, 3, 4], 6, false);
		
		animation.play('idle');
	}
	
	override public function init(xPos:Float, yPos:Float, player:Player, ?bullets:FlxGroup):Void 
	{
		super.init(xPos, yPos, player);
		
		_aggression = 0; // Stop enemy from shooting.
	}
	
}