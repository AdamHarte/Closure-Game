package com.adamharte.closure;

import flixel.util.FlxPoint;
import openfl.Assets;
import haxe.io.Path;
import haxe.xml.Parser;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified below.
	private inline static var PATH_LEVEL_TILESHEETS = "assets/images/";
	
	// Array of tilemaps used for collision
	public var foregroundTiles:FlxGroup;
	public var foregroundTilemap:FlxTilemap;
	public var backgroundTiles:FlxGroup;
	public var playerSpawn:FlxPoint;
	public var portal:FlxPoint;
	public var creatures01:Array<FlxPoint>;
	public var creatures02:Array<FlxPoint>;
	public var creatures03:Array<FlxPoint>;
	
	private var collidableTileLayers:Array<FlxTilemap>;
	
	
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		
		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();
		
		//FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
		
		// Load Tile Maps
		for ( tileLayer in layers )
		{
			var tileSheetName:String = tileLayer.properties.get("tileset");
			
			if (tileSheetName == null)
			{
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
			}
				
			var tileSet:TiledTileSet = null;
			for (ts in tilesets)
			{
				if (ts.name == tileSheetName)
				{
					tileSet = ts;
					break;
				}
			}
			
			if (tileSet == null)
			{
				throw "Tileset '" + tileSheetName + " not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?";
			}
				
			var imagePath:Path = new Path(tileSet.imageSource);
			var processedPath:String = PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			foregroundTilemap = new FlxTilemap();
			foregroundTilemap.widthInTiles = width;
			foregroundTilemap.heightInTiles = height;
			foregroundTilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);
			
			if (tileLayer.properties.contains("nocollide"))
			{
				backgroundTiles.add(foregroundTilemap);
			}
			else
			{
				if (collidableTileLayers == null)
				{
					collidableTileLayers = new Array<FlxTilemap>();
				}
				
				foregroundTiles.add(foregroundTilemap);
				collidableTileLayers.push(foregroundTilemap);
			}
		}
	}
	
	public function loadObjects()
	{
		playerSpawn = new FlxPoint();
		portal = new FlxPoint();
		creatures01 = [];
		creatures02 = [];
		creatures03 = [];
		
		for (group in objectGroups)
		{
			for (obj in group.objects)
			{
				loadObject(obj, group);
			}
		}
	}
	
	private function loadObject(objectToLoad:TiledObject, objectsGroup:TiledObjectGroup)
	{
		var x:Int = objectToLoad.x;
		var y:Int = objectToLoad.y;
		
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (objectToLoad.gid != -1)
		{
			y -= objectsGroup.map.getGidOwner(objectToLoad.gid).tileHeight;
		}
		
		switch (objectToLoad.type.toLowerCase())
		{
			/*case 'player':
				playerSpawn.set(x, y);*/
				
			case 'portal':
				portal.set(x, y);
				playerSpawn.set(x + 64, y);
				
			case 'c01':
				Reg.currentLevel.enemyCount++;
				creatures01.push(new FlxPoint(x, y));
				
			case 'c02':
				Reg.currentLevel.enemyCount++;
				creatures02.push(new FlxPoint(x, y));
				
			case 'c03':
				Reg.currentLevel.enemyCount++;
				creatures03.push(new FlxPoint(x, y));
				
			default:
				throw 'Unknown tile: "' + objectToLoad.type.toLowerCase() + ', at [' + x +', '+ y + ']';
		}
	}
	
	public function collideWithLevel(obj:FlxGroup, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		if (collidableTileLayers != null)
		{
			for (map in collidableTileLayers)
			{
				// IMPORTANT: Always collide the map with objects, not the other way around. 
				//			  This prevents odd collision errors (collision separation code off by 1 px).
				return FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate);
			}
		}
		return false;
	}
}