package _lib._screens
{

	import _blitEngine._PlayerInput.IInput;
	import _blitEngine._blit.SpriteLibrary;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import _lib._gameObjects.*;
	import _lib._gameObjects._player.*;
	import _lib._gameObjects._other.*;
	import _lib._gameObjects._gui.*;
	import _lib.*;
	import _blitEngine._PlayerInput.KeyboardInput;
	import _lib._gameObjects._components.HitBox;
	
	
	import _blitEngine._gameObjects.*;
	import _blitEngine.*;

	public class SHMUP_code extends Scene
	{
		
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
		private var pc:BasicObject;
		private var level:TileLevel;
		private var health:HealthMeter;
		
		private var spriteLibrary:SpriteLibrary = SpriteLibrary.getInstance();

		private var gamePaused:Boolean;

		private var testBG:TestBG;

		public function SHMUP_code(playerInfo:PlayerInfo)
		{
			this.playerInfo = playerInfo;
		}

		//-------------------------------Methods------------------------------------
		

		override public function constructStage():void
		{
			super.constructStage();		
			testBG.showMe(this);			
			
			
			level.showMe(this, playerInfo);
			pc.showMe(this, playerInfo);
			
			health.showMe(this);
			
			debug.newDebug(ExtraFunctions._stage);
			debug.displayNum = 5;
			debug.y = 600;
		}

		override public function endOfFrameUpdates():void
		{
			
		}
		
		override public function createAssets():void
		{
			super.createAssets();
			
			playerInput = new KeyboardInput(ExtraFunctions._stage, playerInfo);
			
			spriteLibrary.addSprite("SWITCH", switchSprites);
			spriteLibrary.addSprite("SOG", sogSprites);
			spriteLibrary.addSprite("tileSheet", tileSprites);
			spriteLibrary.addSprite("rubDummy", rubDummySprites);
			spriteLibrary.addSprite("dummy", dummySprites);
			spriteLibrary.addSprite("beachBall", ballSprites);
			spriteLibrary.addSprite("healthMeter", switchSprites);
			
			playerInput.addKeyboardActionBinding("up", PlayerInfo.UP);
			playerInput.addKeyboardActionBinding("up",PlayerInfo.BUTTON5);
			playerInput.addKeyboardActionBinding("down",PlayerInfo.DOWN);
			playerInput.addKeyboardActionBinding("left",PlayerInfo.LEFT);
			playerInput.addKeyboardActionBinding("right",PlayerInfo.RIGHT);
			playerInput.addKeyboardActionBinding("action1",PlayerInfo.BUTTON1); 
			playerInput.addKeyboardActionBinding("action3",PlayerInfo.BUTTON2);
			playerInput.addKeyboardActionBinding("action2", PlayerInfo.BUTTON3);
			playerInput.addKeyboardActionBinding("action4","q");
			playerInput.addKeyboardActionBinding("action5", 69); //takes either int or String;String can be lower or upper case, uses toUpper in function and put through Keyboard lookup;
			
			/*playerInput.addGamepadActionBinding("padLeft","Dpad_x");
			playerInput.addGamepadActionBinding("padRight", "Dpad_x");
			playerInput.addGamepadActionBinding("padUp","Dpad_y");
			playerInput.addGamepadActionBinding("padDown","Dpad_y");
			playerInput.addGamepadActionBinding("up", "BottomAction");
			playerInput.addGamepadActionBinding("action1", "RightAction");
			playerInput.addGamepadActionBinding("action2", "LeftAction");
			playerInput.addGamepadActionBinding("action4", "LeftShoulder");
			playerInput.addGamepadActionBinding("action5", "RightShoulder");
			playerInput.addGamepadActionBinding("action3", "LeftTrigger");
			playerInput.addGamepadActionBinding("action3", "RightTrigger");*/

			playerInput.addKeyboardActionBinding("increase",PlayerInfo.DEVBUT1);
			playerInput.addKeyboardActionBinding("decrease",PlayerInfo.DEVBUT2);
			
			
			var minClass:Class = ObjectList.classByID("Appartments");
			level = new TileLevel(new minClass().testJSON);

			sog = new SOG();
			switchPC = new PC();
			(sfw)?pc = sog:pc = switchPC;
			health = new HealthMeter(16,16);

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

		override public function setValues():void
		{
			super.setValues();
			pc.input = playerInput;
			gamePaused = false;

			camera.follow(pc);
		}

		override public function positionAssets():void
		{
			pc.y = level.playerSpawn.y;
			pc.x = level.playerSpawn.x + pc.getComponent(HitBox).right;
		}
	}
}