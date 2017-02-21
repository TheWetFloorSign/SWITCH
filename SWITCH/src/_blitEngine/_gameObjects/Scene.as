package _blitEngine._gameObjects
{

	import _blitEngine._PlayerInput.IInput;
	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import _blitEngine._gameObjects.*;
	import _blitEngine.*;
	import _blitEngine._PlayerInput.KeyboardInput;
	import _lib._gameObjects._components.HitBox;
	import _blitEngine._Managers.*;
	import _lib._gameObjects._components.GraphicsComponent;

	public class Scene
	{
		public static const QUIT:String = "onQuitMe";
		public static const RESET:String = "onResetMe";
		

		public var leftBound:int;
		public var rightBound:int;
		public var topBound:int;
		public var bottomBound:int;

		protected var parent:Object;
		
		public var camera:BitCamera;
		public var zoom:int;

		public var poolManager:PoolManager;
		public var managerList:Array = [];

		public var storageArray:Array;
		public var collisionArray:Array;
		public var typeList:Array =[];
		public var quadTree:QuadTree;

		public var playerInfo:PlayerInfo;
		public var debug:DebugBox = new DebugBox();
		/*private var pauseMenu:PauseScreen;
		private var goMenu:GameOverScreen;*/
		
		public var allowedCollisions:Array =  [];
		
		
		public var gc:GraphicsComponent;
		public var total:Number;
		
		public var signv:Number;
		public var signh:Number;
		
		public var ob1Hit:HitBox;
		private var hit1:HitBox;
		private var hit2:HitBox;
		public var ob2List:Array;
		public var refOb:BasicObject;
		
		public var colMatrix:Array = [];
					
		
		public var pauseScene:Boolean;
		
		public var incre:int = 0;

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
		}

		//-------------------------------Methods------------------------------------
		
		public function gameLoop():void
		{

			updateThis(storageArray);
			staticTileHit();
			hitDetection();
			exitCollisions(storageArray);
			endOfFrameUpdates();
		}
		
		public function endOfFrameUpdates():void
		{}
		
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
			if (!included) storageArray.push(ob);
		}
		
		public function removeGameOb(ob:BasicObject):void
		{
			for (var i:int = storageArray.length -1; i >= 0;i--){
				if (storageArray[i] == ob)
				{
					storageArray.splice(i, 1);
					break;
				}
			}
		}
		
		public function addManager(manager:IManager):void{
			managerList.push(manager);
		}
		
		public function getManager(manager:Class):*{
			for (var i:int = managerList.length -1; i >= 0; i--)
			{
				if (managerList[i] is manager)
				{
					return managerList[i];
				}
			}
			return null;
		}
		
		public function drawScene():void
		{
			camera.update();
		}	
		
		public function staticTileHit():void
		{
			quadTree.overlap(getTagged("player",""), getTagged("tile"));
			
			debug.debug("");
			
		}
		
		public function hitDetection():void
		{
			quadTree.overlap(getTagged("attack","player"), getTagged(""));
			
			
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
		
		public function getTagged(...tags):Array
		{
			var temp:Array = [];
			for (var k:int = tags.length - 1; k >= 0; k--)
			{
				for (var i:int = storageArray.length - 1; i >= 0; i--)
				{
					if (storageArray[i].type == tags[k])
					{
						temp.push(storageArray[i]);
					}
				}
			}
			return temp;
		}

		public function updateThis(array:Array):void
		{
			var updated:int = 0;
			for (var a:int = array.length - 1; a > -1; a--)
			{
				if (array[a]._alive)
				{
					array[a].updateMe();
					updated++;
				}
				
			}
			//trace(updated);
		}
		
		public function exitCollisions(array:Array):void
		{
			var hit1:HitBox;
			for (var a:int = array.length - 1; a > -1; a--)
			{
				hit1 = array[a].getComponent(HitBox);
				if (hit1 != null)
				{
					//trace(array[a]);
					hit1.exitCollision();
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
			
			/*if (showFPS)
			{
				//this.addChild(new FPSCounter(0,200,0xffffff));
			}*/
		}

		public function createAssets():void
		{
			storageArray = [];
			camera = new BitCamera(1080, 720, 4);
			camera.debugHB = false;

			quadTree = new QuadTree(20,6, new Rectangle( 0, 0, 1000, 650));
		}

		public function setValues():void
		{
			leftBound = 0;
			//rightBound = stage.stageWidth;
			topBound = 0;
			//bottomBound = stage.stageHeight;
			playerInfo.pointsTotal = 0;
			playerInfo.livesTotal = 0;
		}

		public function positionAssets():void
		{
			
		}

		public function loadLevel():void
		{
		/*	level.killMe();
			level2 = new TileLevel2();
			level2.showMe(this);*/
		}
		
		public function createEvents():void
		{
		}

		public function removeEvents():void
		{
		}

		public function showMe(target:Sprite):void
		{
			//target.addChild(this);
			parent = target;
			initializeGame();
		}

		public function onResume(e:Event):void
		{
			//resumeGame();
		}

		public function onRetry(e:Event):void
		{
			killMe();
		}

		public function onOptions(e:Event):void
		{
			//resumeGame();
		}

		public function onQuit(e:Event):void
		{
			killMe();
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