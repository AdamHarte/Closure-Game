package com.adamharte.closure.gui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class MissionMap extends FlxSubState
{
	var _bgBlocker:FlxSprite;
	
	
	override public function create():Void 
	{
		trace('MissionMap create');
		
		_bgBlocker = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x66000000);
		add(_bgBlocker);
		
		addMissionButtons();
		
		var scrollPt:FlxPoint = new FlxPoint();
		setAll('scrollFactor', scrollPt);
		
		super.create();
	}
	
	
	
	function addMissionButtons() 
	{
		
		for (levelData in Reg.levels) 
		{
			
		}
		
	}
	
}