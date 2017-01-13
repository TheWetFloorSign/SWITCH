package _blitEngine._gameObjects
{

	import _lib._PlayerInput.IInput;
	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import _lib._gameObjects.*;
	import _lib.*;
	import _lib._PlayerInput.KeyboardInput;
	import _lib._gameObjects._components.HitBox;
	import _lib._gameObjects._components.GraphicsComponent;

	public class Scene extends MovieClip
	{
		public static const QUIT:String = "onQuitMe";
		public static const RESET:String = "onResetMe";
		
		public var fps:int = 60;

		public var leftBound:int;
		public var rightBound:int;
		public var topBound:int;
		public var bottomBound:int;

		public var showFPS:Boolean = true;
		public var last:uint = getTimer();
		public var ticks:uint;

		public var camera:BitCamera;
		public var zoom:int;

		public var poolManager:PoolManager;

		public var storageArray:Array;
		public var typeList:Array =[];
		public var quadTree:QuadTree;

		public var playerInfo:PlayerInfo;
		public var debug:DebugBox = new DebugBox();
		/*private var pauseMenu:PauseScreen;
		private var goMenu:GameOverScreen;*/
		
		public var allowedCollisions:Array =  [];
		
		public var now:uint;
		public var delta:uint;
		public var steps:int;
		public var gc:GraphicsComponent;
		public var total:Number;
		
		public var signv:Number;
		public var signh:Number;
		
		public var ob1Hit:HitBox;
		public var ob2List:Array;
		public var refOb:BasicObject;
		
		public var pauseScene:Boolean;

		public function initializeGame():void
		{
			initializeScene();
			initializePools();
			createAssets();
			//stage.frameRate = fps;
			constructStage();
			setValues();
			positionAssets();
			createEvents();
			last = getTimer();
		}

		//-------------------------------Methods------------------------------------
		
		public function onGameLoop(e:Event):void
		{

			now = getTimer();
			delta = now - last;
			if (delta >= Math.floor(1000 / fps))
			{
				if (!pauseScene)
				{
					steps = delta / Math.floor(1000 / fps);
				
					for (var i:int = 0; i < steps; i++)
					{
						updateThis(storageArray);
						staticTileHit();
						hitDetection();
						exitCollisions(storageArray);
						//checkBounds(pc);
						//trace("one update ");
						//checkGameOver();
					}
					drawScene();
				}
				ticks = delta - steps * Math.floor(1000 / fps);
				last = now - ticks;
			}

		}

		public function addGameOb(ob:BasicObject):void
		{
			var included:Boolean = false;
			for (var i:int = storageArray.length -1; i >= 0;i--){
				if (storageArray[i] == ob)
				{
					included = true;
					trace("already exists");
					break;
				}
			}
			if(!included)storageArray.push(ob);
			if(ob.getComponent(HitBox) != null)quadTree.insert(ob);
		}
		
		public function removeGameOb(ob:BasicObject):void
		{
			for (var i:int = storageArray.length -1; i >= 0;i--){
				if (storageArray[i] == ob)
				{
					storageArray.splice(i, 1);
					quadTree.remove(ob);
					break;
				}
			}
		}
		public function drawScene():void
		{
			camera.canvas.lock();
			camera.update();
			total = storageArray.length-1;
			
			for (var a:int = total; a >=0; a--)
			{
				gc = storageArray[total-a].getComponent(GraphicsComponent);
				if (gc != null)
				{
					gc.render();
				}
			}
			camera.canvas.unlock();
		}
		
		public function orderCollisionDirection(a:BasicObject, b:BasicObject):int{
			
			if (a.y + a.getComponent(HitBox).centery < b.y + b.getComponent(HitBox).centery) {
				return -signv;
			} else if (b.y + b.getComponent(HitBox).centery < a.y + a.getComponent(HitBox).centery) {
				return signv;
			} else {
				if(a.x + a.getComponent(HitBox).centerx < b.x + b.getComponent(HitBox).centerx){
					return signh;
				}else if(a.x + a.getComponent(HitBox).centerx > b.x + b.getComponent(HitBox).centerx){
					return -signh;
				}
				return 0;
			}
		}		
		
		public function staticTileHit():void
		{
			var collided:Boolean = false;
			for (var i:int = storageArray.length - 1; i >= 0; i--)
			{
				
				if (storageArray[i].type != "tile" && storageArray[i].type != "ui" && storageArray[i].type != "bg" && storageArray[i].type != "attack")
				{
					ob1Hit = storageArray[i].getComponent(HitBox);
					if (ob1Hit == null)
					{
						continue;
					}
					refOb = storageArray[i];
					ob2List = quadTree.retrieveObjectsInArea(ExtraFunctions.broadPhaseRect(storageArray[i]));
					
					if (ob2List == null){
						//trace("was null");
						continue;
					}
					
					
					
					for (var k:int = ob2List.length - 1; k >= 0; k--)
					{
						if (ob2List[k].type != "tile"){
							ob2List.splice(k, 1);
						}
					}
					signv = (storageArray[i].y - storageArray[i].last.y >0)?-1:1;
					signh = (storageArray[i].x - storageArray[i].last.x >0)?-1:1;
					ob2List.sort(orderCollisionDirection);
					debug.debug("Objects in returned quadTree list for staticTileHit",ob2List.length-1);
						
					for (var j:int = ob2List.length - 1; j >= 0; j--)
					{	if (ob2List[j].getComponent(HitBox) != null && ExtraFunctions.broadCollision(ob2List[j], storageArray[i]))
						{
							ob2List[j].getComponent(HitBox).collisionResolution(storageArray[i]);
							collided = true;
						}
						
					}
					if (collided){
						quadTree.remove(storageArray[i]);
						quadTree.insert(storageArray[i]);
					}
					
					
				}
			}
			
		}
		
		public function hitDetection():void
		{
			
			for (var i:int = storageArray.length - 1; i >= 0; i--)
			{
				
				if (storageArray[i].type != "tile" && storageArray[i].type != "ui" && storageArray[i].type != "bg")
				{
					ob1Hit = storageArray[i].getComponent(HitBox);
					if (ob1Hit == null)
					{
						continue;
					}
					refOb = storageArray[i];
					ob2List = quadTree.retrieveObjectsInArea(new Rectangle(refOb.x + ob1Hit.left,
																					refOb.y + ob1Hit.top,
																					ob1Hit.size.x, 
																					ob1Hit.size.y));
					
					if (ob2List == null) continue;
					
					
					
					for (var k:int = ob2List.length - 1; k >= 0; k--)
					{
						if (ob2List[k].type == "tile" || ob2List[k].type == "ui" || ob2List[k].type == "bg" || ob2List[k].type == "attack" || ob2List[k].type == "player" || ob2List[k] == refOb){
							ob2List.splice(k, 1);
						}
					}
					signv = (refOb.last.y - refOb.y <0)?-1:1;
					signh = (refOb.last.x - refOb.x <0)?-1:1;
					ob2List.sort(orderCollisionDirection);
						
					for (var j:int = ob2List.length - 1; j >= 0; j--)
					{	
						if (ExtraFunctions.broadCollision(refOb, ob2List[j]))
						{
							ob2List[j].getComponent(HitBox).collisionResolution(refOb);
							refOb.getComponent(HitBox).collisionResolution(ob2List[j]);
							quadTree.remove(ob2List[j]);
							quadTree.insert(ob2List[j]);
						}
						
					}
					quadTree.remove(refOb);
					quadTree.insert(refOb);
					
				}
			}
			
		}
		
		public function recurAdd(groupOrObj:BasicObject):Array{
			var tempArray:Array = [];
			if (groupOrObj is ObjectGroup)
			{
				for(var i:int = 0; i<(groupOrObj as ObjectGroup).members.length; i++){
				tempArray = tempArray.concat(recurAdd((groupOrObj as ObjectGroup).members[i]));
			}
			}else
			{
				tempArray[0] = groupOrObj;
			}			
			return tempArray;
		}
		
		public function checkBounds(ob1:BasicObject):void
		{
			if (ob1.x < camera.levelBounds.x)
			{
				ob1.x = camera.levelBounds.x;
			}
			if (ob1.x > camera.levelBounds.width)
			{
				ob1.x = camera.levelBounds.width;
			}
			if (ob1.y < camera.levelBounds.y)
			{
				ob1.y = camera.levelBounds.y;
			}
			if (ob1.y > camera.levelBounds.height)
			{
				ob1.y = camera.levelBounds.height;
			}
		}

		public function updateThis(array:Array):void
		{
			for (var a:int = array.length - 1; a > -1; a--)
			{
				array[a].updateMe();
				
			}
		}
		
		public function exitCollisions(array:Array):void
		{
			for (var a:int = array.length - 1; a > -1; a--)
			{
				if (array[a].getComponent(HitBox) != null)
				{
					//trace(array[a]);
					array[a].getComponent(HitBox).exitCollision();
				}
			}
		}
		
		private function initializeScene():void
		{
			storageArray = [];
		}

		public function initializePools():void
		{

			poolManager = new PoolManager  ;
		}

		public function constructStage():void
		{
			this.addChild(camera);
			if (showFPS)
			{
				this.addChild(new FPSCounter(0,200,0x000000));
			}
		}

		public function createAssets():void
		{
			storageArray = [];
			camera = new BitCamera(1080, 720, 4);
			camera.debugHB = false;

			quadTree = new QuadTree(12, new Rectangle( -1200, -1200, 3600, 3600));
		}

		public function setValues():void
		{
			leftBound = 0;
			rightBound = stage.stageWidth;
			topBound = 0;
			bottomBound = stage.stageHeight;
			playerInfo.pointsTotal = 0;
			playerInfo.livesTotal = 0;
		}

		public function positionAssets():void
		{
			
		}

		public function createEvents():void
		{
			this.addEventListener(Event.ENTER_FRAME,onGameLoop);
		}

		public function removeEvents():void
		{
			this.removeEventListener(Event.ENTER_FRAME,onGameLoop);
		}

		public function showMe(target:MovieClip):void
		{
			target.addChild(this);
			initializeGame();
		}

		public function onResume(e:Event):void
		{
			//resumeGame();
		}

		public function onRetry(e:Event):void
		{
			killMe();
			this.dispatchEvent(new Event(World.RESET));
		}

		public function onOptions(e:Event):void
		{
			//resumeGame();
		}

		public function onQuit(e:Event):void
		{
			killMe();
			this.dispatchEvent(new Event(World.QUIT));
		}

		public function killMe():void
		{
			removeEvents();
			removeAssets();
		}

		private function removeAssets():void
		{
			for (var v:int = storageArray.length - 1; v > -1; v--)
			{
				storageArray[v].killMe();
			}

		}
	}
}