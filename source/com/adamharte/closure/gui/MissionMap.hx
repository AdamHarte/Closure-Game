package com.adamharte.closure.gui;

import com.adamharte.closure.PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class MissionMap extends FlxState
{
	var _bgBlocker:FlxSprite;
	var _container:FlxSpriteGroup;
	var _step:Int;
	
	
	override public function create():Void 
	{
		_bgBlocker = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x66000000);
		add(_bgBlocker);
		
		var map:FlxSprite = new FlxSprite().loadGraphic('assets/images/map.png', false, 160, 480);
		map.setGraphicSize(852, 2556);
		map.origin.set();
		
		var pageHeight:Float = (2556 - FlxG.height) / 5;
		for (level in Reg.levels) 
		{
			if (!level.completed) 
			{
				_step = Std.int(level.levelIndex / 2);
				break;
			}
		}
		
		_container = new FlxSpriteGroup();
		_container.setPosition(0, FlxG.height - 2556);
		_container.add(map);
		_container.scrollFactor.set();
		add(_container);
		
		addMissionButtons();
		
		var upBtn:FlxButton = new FlxButton(FlxG.width / 2 - 50, 10, '^', upBtnClick);
		var downBtn:FlxButton = new FlxButton(FlxG.width / 2 - 50, FlxG.height - 30, 'v', downBtnClick);
		
		add(upBtn);
		add(downBtn);
		
		var scrollPt:FlxPoint = new FlxPoint();
		setAll('scrollFactor', scrollPt);
		
		super.create();
		
		FlxG.camera.fade(0xff000000, 1, true);
		refreshMap();
	}
	
	
	
	function addMissionButtons() 
	{
		var levelNum:Int = -1;
		for (levelData in Reg.levels) 
		{
			levelNum++;
			
			var newX = FlxRandom.intRanged(100, FlxG.width - 100);
			var newY = 2556 - 200 - (levelNum * 200);
			var mapToken:MapToken = new MapToken(newX, newY);
			_container.add(mapToken);
			
			if (levelData.completed) 
			{
				mapToken.animation.play('death');
			}
			else
			{
				var missionBtn:FlxButton = new FlxButton(newX - 24, newY + 34, 'Enter Portal', missionClick.bind(levelData.levelIndex));
				_container.add(missionBtn);
			}
		}
	}
	
	function refreshMap() 
	{
		_step = Std.int(FlxMath.bound(_step, 0, 4));
		var targetY = (FlxG.height - 2556) / 5 * (5-_step);
		FlxTween.cubicMotion(_container, 0, _container.y, 0, _container.y, 0, targetY, 0, targetY, 0.8);
	}
	
	
	
	function upBtnClick() 
	{
		_step++;
		refreshMap();
	}
	
	function downBtnClick() 
	{
		_step--;
		refreshMap();
	}
	
	function missionClick(levelIndex:Int) 
	{
		Reg.levelNumber = levelIndex;
		FlxG.switchState(new PlayState());
	}
	
}