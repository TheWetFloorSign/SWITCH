package  _lib._gameObjects._other{
	
	
	import _blitEngine._gameObjects.ObjectGroup;
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
	import _blitEngine.ExtraFunctions;
	import _lib._gameObjects._components.GraphicsComponent;
	import flash.events.Event;
	
	public class TileLevel2 extends ObjectGroup{
		
		private var tempFR:URLLoader;
		// TestJSON - as file with tile data and map layers for easy testing. Works with setLevel(). Is currently NOT reading extern .txt files
		private var testJSON:TestJSON2;
		private var testOb:Object;
		public var playerSpawn:Point;
		public var mapBounds:Rectangle;
		public var staticMap:Array = [];
		//------------------------------constructor-------------------------------------------
		
		public function TileLevel2() {
		// Define basic stats for new generic object: _tic(a counter) set to zero, lives forever, 
		// base points, dies on hit, only moves down, and basic audio.
			members = new Array();
			playerSpawn = new Point(0,0);
			testJSON = new TestJSON2();
		}
		
		//------------------------------Gets and Sets-------------------------------------------
						
		
		//------------------------------Methods-------------------------------------------
		override public function showMe(scene:Object, playerInfo:PlayerInfo = null):void{
			
			_scene = scene;
			_camera = scene.camera;
			//loadLevelJSON();
			setLevel();
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
			testOb = testJSON.testJSON;
			drawMap(testOb.background);
			findSpawns(testOb.spawns);
			_camera.updateBounds(mapBounds);
		}
		
		public function mapLoaded(e:Event):void{
			testOb = JSON.parse(e.target.data);
			drawMap(testOb.background);
			findSpawns(testOb.spawns);
			_camera.updateBounds(mapBounds);
		}
		
		public function drawMap(map:Array):void{
			var mapWidth:int = map[0].length;
			var mapHeight:int = map.length;
			trace("width/height:  " + mapWidth + ":" + mapHeight);
			mapBounds = new Rectangle(0, 0, (mapWidth) * 24, (mapHeight) * 24);
			for (var h:int = map.length -1; h >=0; h--){
				staticMap[h] = [];
				for (var w:int = map[0].length -1; w >= 0; w--){
					if (map[h][w] != 0 && map[h][w] != undefined){
						
						
						var tile:Tile = new Tile();
						tile._immovable = true;
						var newT:Object = new Object();
						for each(var tar:* in testOb.tiles)
						{
							if (tar.id == map[h][w])
							{
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
					//	trace(newT.hitbox);
						if (newT.hitbox != undefined) tile.addHitBox(1, 1);
						//trace(tile.getComponent(HitBox));
						tile.last.x = tile.x;
						tile.last.y = tile.y;
						if(map[h-1] == undefined || (map[h-1][w] == 0 || map[h-1][w] == undefined))tile.allowCollision |= ExtraFunctions.DOWN;
						if(map[h+1] == undefined || (map[h+1][w] == 0 || map[h+1][w] == undefined))tile.allowCollision |= ExtraFunctions.UP;
						if(map[h][w - 1] == 0 || map[h][w-1] == undefined) tile.allowCollision |= ExtraFunctions.LEFT;
						if(map[h][w+1] == 0 || map[h][w+1] == undefined) tile.allowCollision |= ExtraFunctions.RIGHT;
						//staticMap[h][w] = tile;
						members.push(tile);
						tile.showMe(_scene);
					}
				}
			}
		}
		
		public function findSpawns(map:Array):void{
			var mapWidth:int = map[0].length;
			var mapHeight:int = map.length;
			
			for(var l:int = 0; l < map.length; l++){
				for(var w:int = map[0].length -1; w>=0; w--){
					if(map[l][w] != 0){
						switch(map[l][w]){
							case 1:
								playerSpawn = new Point(w * 24,l * 24);
								break;
							default:
								break;
						}
					}
				}
			}
			//trace(playerSpawn.x + "is spawn");
		}
		
	}	
}