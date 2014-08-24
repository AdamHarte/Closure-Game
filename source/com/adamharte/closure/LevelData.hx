package com.adamharte.closure;

import openfl.Assets;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class LevelData
{
	public var levelName:String;
	public var enemyCount:Int;
	public var fileName:String;
	public var filePath(get, never):String;
	public var completed:Bool;
	
	
	private function get_filePath():String 
	{
		return 'assets/levels/' + fileName + '.tmx';
	}
	
	
	public function new(levelName:String, fileName:String) 
	{
		this.levelName = levelName;
		this.fileName = fileName;
		completed = false;
	}
	
}