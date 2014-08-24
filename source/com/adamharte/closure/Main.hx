package com.adamharte.closure;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;

class Main extends Sprite 
{
	var gameWidth:Int = 852;// 568;// 1136;// 640; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 480;// 340;// 640;// 480; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = MenuState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = true; // Whether to start the game in fullscreen on desktop targets
	
	// You can pretty much ignore everything from here on - your code should go in your states.
	
	public static function main():Void
	{	
		Lib.current.addChild(new Main());
	}
	
	public function new() 
	{
		super();
		
		loadLevels();
		
		if (stage != null) 
		{
			init();
		}
		else 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	private function init(?E:Event):Void 
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		setupGame();
	}
	
	function loadLevels():Void 
	{
		// Name source: http://pagannames.witchipedia.com/masculine
		//Reg.addLevel('Test Level', 'test_level');
		Reg.addLevel('01', 'aapep');
		Reg.addLevel('02', 'abasi');
		Reg.addLevel('03', 'abejide');
		Reg.addLevel('04', 'adlar');
		Reg.addLevel('05', 'aldo');
		//Reg.addLevel('06', 'argos');
		//Reg.addLevel('07', 'bertram');
		//Reg.addLevel('08', 'bjarki');
		//Reg.addLevel('09', 'carrick');
		//Reg.addLevel('10', 'casta');
		//Reg.addLevel('11', 'cien');
		//Reg.addLevel('12', 'corvus');
		//Reg.addLevel('13', 'enfys');
		//Reg.addLevel('14', 'fenrir');
		//Reg.addLevel('15', 'gawain');
		//Reg.addLevel('16', 'gogol');
		//Reg.addLevel('17', 'greer');
		//Reg.addLevel('18', 'hakon');
		//Reg.addLevel('19', 'inali');
		//Reg.addLevel('20', 'isfet');
		//Reg.addLevel('21', 'ivo');
		//Reg.addLevel('22', 'kiran');
		//Reg.addLevel('23', 'leander');
		//Reg.addLevel('24', 'lorcan');
		//Reg.addLevel('25', 'lyall');
		//Reg.addLevel('26', 'madura');
		//Reg.addLevel('27', 'marc');
		//Reg.addLevel('28', 'marc');
		
	}
	
	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
	}
}