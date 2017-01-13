package _lib._screens
{

	import _lib._PlayerInput.IInput;
	import _lib._gameObjects._enemies._minions.Attack;
	import _lib._gameObjects._enemies._minions.BeachBall;
	import _lib._gameObjects._enemies._minions.Dummy;
	import _lib._gameObjects._enemies._minions.RubDummy;
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
	import _lib._gameObjects._player.*;
	import _lib._gameObjects._other.*;
	import _lib._gameObjects._gui.*;
	import _lib.*;
	import _lib._PlayerInput.KeyboardInput;
	import _lib._gameObjects._components.HitBox;
	import _lib._gameObjects._components.GraphicsComponent;

	public class SHMUP_code_old extends MovieClip
	{

		public static const QUIT:String = "onQuitMe";
		public static const RESET:String = "onResetMe";

		private var fps:int = 60;
		
		private var sfw:Boolean = false;
		
		public var soundManager:SoundManager = SoundManager.getInstance();

		private var playerInput:IInput;
		private var boundries:Object;
		[Embed(source="../../../bin/_sprites/SuperOffice_Sprites.png")]
		private var SogSheet:Class;
		private var sogSprites:Bitmap = new SogSheet();
		[Embed(source="../../../bin/_sprites/BeatEmUpSprites20160327.png")]
		private var SwitchSheet:Class;
		private var switchSprites:Bitmap = new SwitchSheet();
		[Embed(source="../../../bin/_sprites/TileSheet.png")]
		private var TestSheet:Class;
		private var tileSprites:Bitmap = new TestSheet();
		[Embed(source="../../../bin/_sprites/DummySprites.png")]
		private var DummySheet:Class;
		private var dummySprites:Bitmap = new DummySheet();
		[Embed(source="../../../bin/_sprites/RubDummy.png")]
		private var RubDummySheet:Class;
		private var rubDummySprites:Bitmap = new RubDummySheet();
		[Embed(source="../../../bin/_sprites/BeachBallSprites.png")]
		private var BallSheet:Class;
		private var ballSprites:Bitmap = new BallSheet();
		[Embed(source = "../../../bin/_audio/punchTest1.mp3")]
		private var PunchSound:Class;
		[Embed(source="../../../bin/_audio/Title - Copy - Lowest.mp3")]
		private var TitleSound:Class;
		[Embed(source="../../../bin/_audio/dashTest1.mp3")]
		private var DashSound:Class;
		[Embed(source="../../../bin/_audio/SE 1.mp3")]
		private var JumpSound:Class;
		[Embed(source="../../../bin/_audio/SE 2.mp3")]
		private var LandSound:Class;
		[Embed(source="../../../bin/_audio/wiffTest1.mp3")]
		private var WiffSound:Class;
		[Embed(source="../../../bin/_audio/ballTest1.mp3")]
		private var BallSound:Class;
		private var sog:SOG;
		private var switchPC:PC;
		private var dummy:Dummy;
		private var beachBall:BeachBall;
		private var pc:BasicObject;
		private var refOb:BasicObject;
		private var level:TileLevel;
		private var tile:Tile;
		private var health:HealthMeter;
		private var rubDummy:RubDummy;

		private var gamePaused:Boolean;

		private var leftBound:int;
		private var rightBound:int;
		private var topBound:int;
		private var bottomBound:int;

		private var testBG:TestBG;

		private var showFPS:Boolean = true;
		private var last:uint = getTimer();
		private var ticks:uint;

		public var camera:BitCamera;
		private var zoom:int;

		private var poolManager:PoolManager;

		public var storageArray:Array;
		private var typeList:Array =[];
		private var quadTree:QuadTree;

		private var playerInfo:PlayerInfo;
		private var debug:DebugBox = new DebugBox();
		/*private var pauseMenu:PauseScreen;
		private var goMenu:GameOverScreen;*/
		
		private var allowedCollisions:Array =  [];
		
		private var now:uint;
		private var delta:uint;
		private var steps:int;
		private var gc:GraphicsComponent;
		private var total:Number;
		
		private var signv:Number;
		private var signh:Number;
		
		private var ob1Hit:HitBox;
		private	var ob2List:Array;
		
		private var colmatrix:Array =  [[1, 1, 1, 1, 1],
										[1, 1, 1, 1],
										[1, 1, 1],
										[1, 1],
										[1]];

		public function SHMUP_code(playerInfo:PlayerInfo)
		{
			this.playerInfo = playerInfo;
		}

		public function initializeGame():void
		{
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
				steps = delta / Math.floor(1000 / fps);
				for (var i:int = 0; i < steps; i++)
				{
					updateControls(pc);
					updateThis(storageArray);
					staticTileHit();
					hitDetection();
					exitCollisions(storageArray);
					checkBounds(pc);
					//trace("one update ");
					checkGameOver();
				}
				drawScene();
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

		private function checkGameOver():void
		{
			if (playerInfo.livesTotal <= 0 && ! pc.alive)
			{
				gameOver();
			}
		}
		
		private function orderCollisionDirection(a:BasicObject, b:BasicObject):int{
			
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
		
		
		
		private function staticTileHit():void
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
		
		private function hitDetection():void
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
		
		private function recurAdd(groupOrObj:BasicObject):Array{
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
		
		private function checkBounds(ob1:BasicObject):void
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

		private function updateThis(array:Array):void
		{
			for (var a:int = array.length - 1; a > -1; a--)
			{
				array[a].updateMe();
				
			}
		}
		
		private function exitCollisions(array:Array):void
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

		private function updateControls(target:BasicObject = null):void
		{
			playerInput.isActionActivated("increase") ? health._health++:health._health = health._health;
			playerInput.isActionActivated("decrease") ? health._health--:health._health = health._health;
		}

		private function gameOver():void
		{
			this.removeEventListener(Event.ENTER_FRAME,onGameLoop);
			//goMenu.showMe(this);
		}

		private function pauseGame():void
		{
			this.removeEventListener(Event.ENTER_FRAME,onGameLoop);
			gamePaused = true;
			/*playerInfo.soundManager.stopAllSounds();
			playerInfo.soundManager.playSound("Pause",playerInfo.menuVol);
			pauseMenu.showMe(this);*/
		}

		private function resumeGame():void
		{
			this.addEventListener(Event.ENTER_FRAME,onGameLoop);
			gamePaused = false;
			//playerInfo.soundManager.playSound("level1",playerInfo.musicVol);
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

			testBG.showMe(this);
			
			
			pc.showMe(this, playerInfo);
			level.showMe(this);
			health.showMe(this);
			beachBall.showMe(this, playerInfo);
			dummy.showMe(this, playerInfo);
			rubDummy.showMe(this, playerInfo);
			
			debug.newDebug(this);
			debug.displayNum = 1;
		}

		public function createAssets():void
		{
			
			playerInput = new KeyboardInput(stage, playerInfo);
			
			playerInput.addKeyboardActionBinding("up", PlayerInfo.UP);
			playerInput.addKeyboardActionBinding("up",PlayerInfo.BUTTON5);
			playerInput.addKeyboardActionBinding("down",PlayerInfo.DOWN);
			playerInput.addKeyboardActionBinding("left",PlayerInfo.LEFT);
			playerInput.addKeyboardActionBinding("right",PlayerInfo.RIGHT);
			playerInput.addKeyboardActionBinding("action1",PlayerInfo.BUTTON1);
			playerInput.addKeyboardActionBinding("action3",PlayerInfo.BUTTON2);
			playerInput.addKeyboardActionBinding("action2", PlayerInfo.BUTTON3);
			playerInput.addKeyboardActionBinding("action4", Keyboard[String("q").toUpperCase()]);
			playerInput.addKeyboardActionBinding("action5", PlayerInfo.BUTTON6);
			
			playerInput.addGamepadActionBinding("padLeft","Dpad_x");
			playerInput.addGamepadActionBinding("padRight", "Dpad_x");
			playerInput.addGamepadActionBinding("padUp","Dpad_y");
			playerInput.addGamepadActionBinding("padDown","Dpad_y");
			playerInput.addGamepadActionBinding("up", "BottomAction");
			playerInput.addGamepadActionBinding("action1", "RightAction");
			playerInput.addGamepadActionBinding("action2", "LeftAction");
			playerInput.addGamepadActionBinding("action4", "LeftShoulder");
			playerInput.addGamepadActionBinding("action5", "RightShoulder");
			playerInput.addGamepadActionBinding("action3", "LeftTrigger");
			playerInput.addGamepadActionBinding("action3", "RightTrigger");

			playerInput.addKeyboardActionBinding("increase",PlayerInfo.DEVBUT1);
			playerInput.addKeyboardActionBinding("decrease",PlayerInfo.DEVBUT2);
			storageArray = [];
			camera = new BitCamera(1080, 720, 4);
			camera.debugHB = false;

			level = new TileLevel(tileSprites);
			quadTree = new QuadTree(12, new Rectangle( -1200, -1200, 3600, 3600));

			sog = new SOG(sogSprites);
			switchPC = new PC(switchSprites);
			(sfw)?pc = sog:pc = switchPC;
			health = new HealthMeter(switchSprites);
			
			dummy = new Dummy(dummySprites);
			beachBall = new BeachBall(ballSprites);
			rubDummy = new RubDummy(rubDummySprites);

			testBG = new TestBG();
			
			soundManager.addLibrarySound(PunchSound, "punch");
			soundManager.addLibrarySound(TitleSound, "stage1");
			soundManager.addLibrarySound(DashSound, "dash");
			soundManager.addLibrarySound(WiffSound, "wiff");
			soundManager.addLibrarySound(BallSound, "ball");
			soundManager.addLibrarySound(JumpSound, "jump");
			soundManager.addLibrarySound(LandSound, "land");
			soundManager.playSound("stage1",0.1,0,200);

			//pauseMenu = new PauseScreen(playerInfo);
			//goMenu = new GameOverScreen(playerInfo);

		}

		public function setValues():void
		{
			leftBound = 0;
			rightBound = stage.stageWidth;
			topBound = 0;
			bottomBound = stage.stageHeight;
			playerInfo.pointsTotal = 0;
			playerInfo.livesTotal = 0;
			pc.input = playerInput;
			gamePaused = false;

			camera.follow(pc);
		}

		public function positionAssets():void
		{
			/*pc.x = level.playerSpawn.x;
			pc.y = level.playerSpawn.y;*/
			trace(pc.getComponent(HitBox).right);
			pc.y = level.playerSpawn.y;
			pc.x = level.playerSpawn.x + pc.getComponent(HitBox).right;
			dummy.y = level.playerSpawn.y + 24;
			dummy.x = level.playerSpawn.x + 240;
			beachBall.y = dummy.y;
			beachBall.x = dummy.x;
			rubDummy.y = dummy.y;
			rubDummy.x = dummy.x;
			health.x = 16;
			health.y = 16;
			/*pauseMenu.x = 120;
			pauseMenu.y = stage.stageHeight / 2 - (116 / 2);*/
		}

		public function createEvents():void
		{
			this.addEventListener(Event.ENTER_FRAME,onGameLoop);
			/*pauseMenu.addEventListener(PauseScreen.RESUME,onResume);
			pauseMenu.addEventListener(PauseScreen.RETRY,onRetry);
			pauseMenu.addEventListener(PauseScreen.OPTION,onOptions);
			pauseMenu.addEventListener(PauseScreen.QUIT,onQuit);
			goMenu.addEventListener(GameOverScreen.RETRY,onRetry);
			goMenu.addEventListener(GameOverScreen.QUIT,onQuit);*/
		}

		public function removeEvents():void
		{
			this.removeEventListener(Event.ENTER_FRAME,onGameLoop);
			/*pauseMenu.removeEventListener(PauseScreen.RESUME,onResume);
			pauseMenu.removeEventListener(PauseScreen.RETRY,onRetry);
			pauseMenu.removeEventListener(PauseScreen.OPTION,onOptions);
			pauseMenu.removeEventListener(PauseScreen.QUIT,onQuit);
			goMenu.removeEventListener(GameOverScreen.RETRY,onRetry);
			goMenu.removeEventListener(GameOverScreen.QUIT,onQuit);*/
		}

		public function showMe(target:MovieClip):void
		{
			target.addChild(this);
			initializeGame();
		}

		public function onResume(e:Event):void
		{
			resumeGame();
		}

		public function onRetry(e:Event):void
		{
			killMe();
			this.dispatchEvent(new Event(SHMUP_code.RESET));
		}

		public function onOptions(e:Event):void
		{
			resumeGame();
		}

		public function onQuit(e:Event):void
		{
			killMe();
			this.dispatchEvent(new Event(SHMUP_code.QUIT));
		}

		public function killMe():void
		{
			removeEvents();
			removeAssets();
			//playerInfo.soundManager.stopSound("level1");
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