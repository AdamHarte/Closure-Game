package com.adamharte.closure;

import com.adamharte.closure.Reg;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Player extends FlxSprite
{
	var _jumpPower:Int;
	var _spawnPoint:FlxPoint;
	
	
	public function new(startX:Float, startY:Float) 
	{
		_jumpPower = 300;
		
		super(startX, startY);
		
		_spawnPoint = new FlxPoint(startX, startY);
		
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
		maxVelocity.y = _jumpPower;
		
		// Setup animations.
		animation.add('idle', [1]);
		animation.add('run', [2, 3, 4, 5, 6, 7, 8, 9], 12);
		
		//animation.play('run');
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		
	}
	
	override public function update():Void 
	{
		
		
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
			//FlxG.sound.play('Jump', 0.5);
			//animation.play('jump');
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
		
		
		
		super.update();
	}
	
}