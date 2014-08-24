package com.adamharte.closure.gui;

import flixel.FlxSprite;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class MapToken extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic('assets/images/map_token.png', true, 32, 32);
		
		animation.add('idle', [1, 2, 3, 4], 6);
		animation.add('death', [5]);
		
		animation.play('idle');
		
	}
	
	override public function kill():Void 
	{
		if (!alive) 
		{
			return;
		}
		
		super.kill();
		
		//solid = false;
		exists = true;
		animation.play('death');
	}
	
}