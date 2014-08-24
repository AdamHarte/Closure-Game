package com.adamharte.closure.gui;

import com.adamharte.closure.PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
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
		_bgBlocker = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x66000000);
		add(_bgBlocker);
		
		addMissionButtons();
		
		var scrollPt:FlxPoint = new FlxPoint();
		setAll('scrollFactor', scrollPt);
		
		super.create();
	}
	
	
	
	function addMissionButtons() 
	{
		var levelNum:Int = -1;
		for (levelData in Reg.levels) 
		{
			levelNum++;
			
			if (!levelData.completed) 
			{
				var missionBtn:FlxButton = new FlxButton(100, levelNum * 40, levelData.levelName, missionClick.bind(levelData.levelIndex));
				add(missionBtn);
			}
		}
	}
	
	
	
	function missionClick(levelIndex:Int) 
	{
		Reg.levelNumber = levelIndex;
		close();
		FlxG.switchState(new PlayState());
	}
	
}