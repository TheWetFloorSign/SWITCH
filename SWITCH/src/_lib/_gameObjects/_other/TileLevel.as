﻿package  _lib._gameObjects._other{
	
	
	import _blitEngine.BitPoint;
	import _blitEngine._gameObjects.BasicObject;
	import _blitEngine._gameObjects.ObjectGroup;
	import _lib._gameObjects.LevelManager;
	import _lib._gameObjects._other.Tile;
	import _blitEngine.PlayerInfo;
	import _blitEngine.BitCamera;
	import _lib._gameObjects._components.HitBox;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import _lib.TestJSON2;
	import _lib.TestJSON;
	import _blitEngine.ExtraFunctions;
	import _lib._gameObjects._components.GraphicsComponent;
	import _lib._gameObjects.ObjectList;
	import flash.events.Event;
	
	public class TileLevel extends ObjectGroup{
		
		private var tempFR:URLLoader;
		// TestJSON - as file with tile data and map layers for easy testing. Works with setLevel(). Is currently NOT reading extern .txt files
		private var testJSON:Object;
		private var testOb:Object;
		public var playerSpawn:Point;
		public var mapBounds:Rectangle;
		//------------------------------constructor-------------------------------------------
		
		public function TileLevel(levelJSON:Object = null) {
		// Define basic stats for new generic object: _tic(a counter) set to zero, lives forever, 
		// base points, dies on hit, only moves down, and basic audio.
			members = new Array();
			playerSpawn = new Point(0,0);
			(levelJSON == null)?testJSON = (new TestJSON().testJSON):testJSON = levelJSON;
		}
		
		//------------------------------Gets and Sets-------------------------------------------
						
		
		//------------------------------Methods-------------------------------------------
		override public function showMe(scene:Object, playerInfo:PlayerInfo = null):void{
			
			_scene = scene;
			_camera = scene.camera;
			_playerInfo = playerInfo;
			//loadLevelJSON();
			setLevel();
			onShowMe();
		}
		override public function updateMe():void{
			//for each(var member:* in members)member.updateMe();
		}
		
		/*override public function exitCollision():void{
			for each(var member:* in members)member.exitCollision();
		}*/
		
		public function loadLevelJSON():void{
			tempFR = new URLLoader();
			trace("in load");
			tempFR.addEventListener(Event.COMPLETE, mapLoaded)
			tempFR.load(new URLRequest("test5.txt"));
		}
		
		public function setLevel():void{
			testOb = testJSON;
			drawMap(testOb.background);
			findSpawns();
			placeObjects();
			_camera.updateBounds(mapBounds);
			
		}
		
		public function mapLoaded(e:Event):void{
			testOb = JSON.parse(e.target.data);
			drawMap(testOb.background);
			findSpawns();
			_camera.updateBounds(mapBounds);
		}
		
		public function drawMap(map:Array):void{
			var mapWidth:int = map[0].length;
			var mapHeight:int = map.length;
			mapBounds = new Rectangle(0, 0, (mapWidth) * 24, (mapHeight) * 24);
			for (var h:int = map.length -1; h >=0; h--){
				for (var w:int = map[0].length -1; w >= 0; w--){
					if (map[h][w] != 0 && map[h][w] != undefined){
						
						
						var tile:Tile = new Tile();
						tile._immovable = true;
						var newT:Object = new Object();
						for each(var tar:* in testOb.tiles){
							if (tar.id == map[h][w]){
								newT = tar;
								break;
							}
						}
						if (newT.frames[0].flip) tile.getComponent(GraphicsComponent)._hFlip = -1;
						
						tile.loadAnimation(newT.frames);
						if(newT.slope){
							tile.slope = newT.slope;
							tile.slopePosition = newT.slopePosition;
						}
												

						tile.x = (w * 24)+(12);
						tile.y = h * newT.frames[0].frameSize[0] + newT.frames[0].frameSize[0];
						if (newT.hitbox != undefined) tile.addHitBox(1, 1);
						tile.last.x = tile.x;
						tile.last.y = tile.y;
						if(map[h-1] == undefined || (map[h-1][w] == 0 || map[h-1][w] == undefined))tile.allowCollision |= ExtraFunctions.DOWN;
						if(map[h+1] == undefined || (map[h+1][w] == 0 || map[h+1][w] == undefined))tile.allowCollision |= ExtraFunctions.UP;
						if(map[h][w - 1] == 0 || map[h][w-1] == undefined) tile.allowCollision |= ExtraFunctions.LEFT;
						if(map[h][w+1] == 0 || map[h][w+1] == undefined) tile.allowCollision |= ExtraFunctions.RIGHT;
						members.push(tile);
						tile.showMe(_scene);
					}
				}
			}
		}
		
		public function findSpawns():void{
			var i:int = 0;
			while (testOb.spawns != undefined && testOb.spawns[i] != undefined)
			{
				
				playerSpawn = new Point(testOb.spawns[i].location.x,testOb.spawns[i].location.y);
				
				i++;
			}
			//trace(playerSpawn.x + "is spawn");
		}
		override public function onShowMe():void{
			var manager:LevelManager = _scene.getManager(LevelManager);
			if (manager == null)
			{
				manager = new LevelManager(_scene, this);
				_scene.addManager(manager);
			}
			var tempJSON:Object = new TestJSON2();
			manager.addLevel("level2", new TileLevel(tempJSON.testJSON));
			tempJSON = new TestJSON();
			manager.addLevel("level1", new TileLevel(tempJSON.testJSON));
		}
		
		public function placeObjects():void
		{
			var i:int = 0;
			var idString:String;
			var type:Class;
			while (testOb.objectSpawns != undefined && testOb.objectSpawns[i] != undefined)
			{
				for each(var tar:* in testOb.objects){
					if (tar.id == testOb.objectSpawns[i].id){
						idString = tar.idName;
						break;
					}
				}
				type = ObjectList.classByID(idString);
				if (type != null)
				{
					var newObject:BasicObject = new type();
					newObject.last.x = newObject.x = testOb.objectSpawns[i].location.x;
					newObject.last.y = newObject.y = testOb.objectSpawns[i].location.y;
					if (newObject is Door)
					{
						trace(testOb.objectSpawns[i].level);
						(newObject as Door).target = testOb.objectSpawns[i].level;
						(newObject as Door).position = new BitPoint(testOb.objectSpawns[i].position.x, testOb.objectSpawns[i].position.y);
					}
					members.push(newObject);
					newObject.showMe(_scene, _playerInfo);
				}
				
				i++;
			}
		}
		
	}	
}