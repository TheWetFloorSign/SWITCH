package {
	
	import _blitEngine.ExtraFunctions;
	import _blitEngine.FPSCounter;
	import _blitEngine.PlayerInfo;
	import _blitEngine.SoundManager;
	import _blitEngine._gameObjects.Scene;
	import _lib._screens.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[SWF(backgroundColor = "#000000", width="1080", height="720")]
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite{
		
		private var game:SHMUP_code;
		private var titleScreen:TitleScreen;
		private var soundManager:SoundManager;
		private var playerInfo:PlayerInfo;
		private var activeScreen:Object;
		
		public var fps:int = Math.ceil(1000/60);
		public var now:uint;
		public var last:uint;
		public var delta:uint;
		public var steps:uint = 0;
		public var maxStep:uint = 1.5 * fps;
		
		
		
		
		public var sceneList:Dictionary;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initialize();
		}
		
		private function initialize():void{
			ExtraFunctions._stage = stage;
			playerInfo = new PlayerInfo();
			
			sceneList = new Dictionary();
			
			playerInfo.gameBoundW = 400;
			playerInfo.gameBoundH = 550;
			soundManager = SoundManager.getInstance();
			soundManager.setMasterVolume(0.5);
			addScene("titleScene",new TitleScreen(playerInfo));
			addScene("gameScene",new SHMUP_code(playerInfo))
			
			stage.addEventListener(Event.DEACTIVATE, onWander);
			stage.addEventListener(Event.ENTER_FRAME, onGameLoop);
			
			
		}
		
		private function onWander(e:Event):void 
		{
			stage.removeEventListener(Event.DEACTIVATE, onWander);
			stage.addEventListener(Event.ACTIVATE, onFocus);
			activeScreen.pauseScene = true;
			soundManager.pauseAllSounds(true);
		}
		
		public function addScene(name:String, scene:Scene):void{
			if (sceneList[name] == null)
			{
				sceneList[name] = scene;
				if (activeScreen == null)
				{
					activeScreen = scene;
					activeScreen.showMe(this);
					stage.addChild(new FPSCounter(0, 0));
				}
			}
			else{
				Error("Scene of name " + name +" already exists.");
			}
		}
		
		public function changeScene(name:String):void{
			if (sceneList[name] != null)
			{
				activeScreen = sceneList[name];
				activeScreen.showMe(this);
				
				last = getTimer();
				stage.addChild(new FPSCounter(0, 0));
			}
			else{
				Error("Scene of name " + name +" does not exists.");
			}
		}
		
		private function onFocus(e:Event):void 
		{
			stage.removeEventListener(Event.ACTIVATE, onFocus);
			stage.addEventListener(Event.DEACTIVATE, onWander);
			activeScreen.pauseScene = false;
			soundManager.playAllSounds(true);
		}
		
		public function showMe(target:Sprite):void{
			target.addChild(this); 
			initialize();
		}
		
		private function onGameLoop(e:Event):void{
			now = getTimer();
			delta = now - last;
			last = now;
			if (!activeScreen.pauseScene)
			{
				steps += delta;
				if (steps > maxStep)
				{
					steps = maxStep;
				}
								
				while (steps >= fps)
				{
					activeScreen.gameLoop();
					steps = steps - fps;
				}
				activeScreen.drawScene();
				
				
			}
			activeScreen.incre = 0;
		}

	}
	
}
