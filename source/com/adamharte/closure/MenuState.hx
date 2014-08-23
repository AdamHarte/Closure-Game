package com.adamharte.closure;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	var _playBtn:FlxButton;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_playBtn = new FlxButton(0, 0, "Play", playBtnClick);
		_playBtn.screenCenter();
		add(_playBtn);
		
		super.create();
		
		playBtnClick(); // Skip menu for faster development.
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		
		_playBtn = FlxDestroyUtil.destroy(_playBtn);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}
	
	
	
	function playBtnClick() 
	{
		FlxG.switchState(new PlayState());
	}
}