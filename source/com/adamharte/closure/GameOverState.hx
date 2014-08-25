package com.adamharte.closure;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class GameOverState extends FlxState
{

	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xff1e2936;
		
		var title:FlxText = new FlxText(0, 0, 0, 'Thanks for playing!', 32);
		title.screenCenter(true, true);
		title.y -= 20;
		add(title);
		
		/*var _playBtn = new FlxButton(0, 0, "Play again", playBtnClick);
		_playBtn.screenCenter();
		_playBtn.y += 30;
		add(_playBtn);*/
		
	}
	
	/*function playBtnClick() 
	{
		Reg.levels
	}*/
	
}