package com.adamharte.closure;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	static public var tileWidth:Int = 16;
	static public var tileHeight:Int = 16;
	static public var tileHalfWidth:Int = 8;
	static public var tileHalfHeight:Int = 8;
	
	static public var gravity:Float = 840;
	
	static public var level:TiledLevel;
	static public var currentLevel(get, never):LevelData;
	
	//static public var enemies:FlxGroup;
	static public var bullets:FlxGroup;
	
	static public var debugGroup:FlxSprite;
	
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<LevelData> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var levelNumber:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
	
	
	
	static private function get_currentLevel():LevelData 
	{
		return Reg.levels[Reg.levelNumber];
	}
	
	
	
	static public function addLevel(levelName:String, fileName:String):Void 
	{
		var level:LevelData = new LevelData(levelName, fileName);
		Reg.levels.push(level);
	}
	
	
}