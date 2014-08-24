package com.adamharte.closure.gui;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class StatusOverlay extends FlxGroup
{
	var _statusText:FlxText;
	var _showTimer:Float;
	var _showDuration:Float;
	
	
	public function new() 
	{
		super();
		
		exists = false;
		
		_statusText = new FlxText(0, FlxG.height * 0.30, FlxG.width);
		_statusText.setFormat(null, 14, 0xb82535, 'center');
		
		add(_statusText);
		
		var scrollPt:FlxPoint = new FlxPoint();
		setAll('scrollFactor', scrollPt);
		
		//show('GET READY');
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		_statusText = null;
	}
	
	override public function update():Void
	{
		_showTimer = Math.min(_showTimer + FlxG.elapsed, _showDuration);
		var finishedShowing:Bool = (_showTimer >= _showDuration);
		if (finishedShowing) 
		{
			hide();
		}
	}
	
	public function show(statusText:String, showDuration:Float = 2.0):Void 
	{
		_statusText.text = statusText;
		_showDuration = showDuration;
		_showTimer = 0;
		
		revive();
	}
	
	public function hide():Void 
	{
		_statusText.text = '';
		
		exists = false;
	}
	
}