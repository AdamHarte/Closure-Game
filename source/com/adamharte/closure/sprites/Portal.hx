package com.adamharte.closure.sprites;

import flixel.FlxSprite;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Portal extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic('assets/images/portal.png', true, 64, 64);
		immovable = true;
		
		// Setup animations.
		animation.add('idle', [1, 2, 3, 4, 5], 12);
		
	}
	
	public function init(xPos:Float, yPos:Float):Void 
	{
		reset(xPos + offset.x, yPos + offset.y);
		animation.play('idle');
	}
	
}