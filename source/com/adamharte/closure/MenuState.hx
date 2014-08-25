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
		FlxG.cameras.bgColor = 0xff1e2936;
		
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		Reg.levelNumber = 0;
		Reg.score = 0;
		
		
		var title:FlxText = new FlxText(0, 0, 0, 'Closure', 32);
		title.screenCenter(true, true);
		title.y -= 20;
		add(title);
		
		var credits:FlxText = new FlxText(0, 0, 256, 'by Adam Harte');
		credits.screenCenter();
		credits.x += 120;
		//credits.y += 10;
		add(credits);
		
		_playBtn = new FlxButton(0, 0, "Play", playBtnClick);
		_playBtn.screenCenter();
		_playBtn.y += 30;
		add(_playBtn);
		
		var helpText:FlxText = new FlxText(0, 0, 0, '[A]/[D] to Move\n[W] to Jump\n[Mouse] to Shoot', 10);
		helpText.setFormat(null, 12, 0xffffff, 'center');
		helpText.antialiasing = true;
		helpText.screenCenter(true);
		helpText.y = FlxG.height - 70;
		add(helpText);
		
		super.create();
		
		//playBtnClick(); // Skip menu for faster development.
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