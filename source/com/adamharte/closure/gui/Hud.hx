package com.adamharte.closure.gui;

import flixel.group.FlxGroup;
import flixel.ui.FlxBar;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Hud extends FlxGroup
{
	public var playerHealth:Float;
	
	var _healthBar:FlxBar;
	

	public function new() 
	{
		super();
		
		_healthBar = new FlxBar(20, 20, FlxBar.FILL_LEFT_TO_RIGHT, 100, 10, this, 'playerHealth', 0, 10);
		
		add(_healthBar);
		
		var scrollPt:FlxPoint = new FlxPoint();
		setAll('scrollFactor', scrollPt);
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		_healthBar = null;
		
	}
	
	/*override public function update():Void 
	{
		super.update();
	}*/
	
}