package _lib._screens{
	
	import flash.display.MovieClip;
	import flash.events.*;
	import _lib.PlayerInfo;
	import _lib.SoundManager;
	import _lib._gameObjects._gui.*;
	
	public class PauseScreen extends MovieClip{
		
		public static const RESUME:String = "onPauseResume";
		public static const QUIT:String = "onPauseQuit";
		public static const OPTION:String  = "onPauseOptions";
		public static const RETRY:String = "onPauseReset";
		
		private var playerInfo:PlayerInfo;
		//private var soundManager:SoundManager;
		
		private var pauseText:SpriteText;
		private var resumeText:SpriteText;
		private var quitText:SpriteText;
		private var optionsText:SpriteText;
		private var retryText:SpriteText;
		
		private var rightArrow:RightArrow;
		
		private var optionsList:Array;
		
		private var selOption:int = 0;
		
		public function PauseScreen(playerInfo:PlayerInfo) {
			this.playerInfo = playerInfo;
		}
		
		public function initialize():void{
			createAssets();
			addAssets();
			positionAssets();
			createEvents();
		}
		
		private function createAssets():void{
			pauseText = new SpriteText("pause");
			resumeText = new SpriteText("resume");
			quitText = new SpriteText("quit");
			optionsText = new SpriteText("options");
			retryText = new SpriteText("retry");
			
			rightArrow = new RightArrow();
			
			optionsList = new Array(resumeText,quitText,optionsText,retryText);
			selOption = 0;
		}
		
		private function addAssets():void{
			addChild(pauseText);
			addChild(resumeText);
			addChild(quitText);
			addChild(optionsText);
			addChild(retryText);
			addChild(rightArrow);
		}
		
		private function positionAssets():void{
			pauseText.x = 40;
			resumeText.x = 20;
			resumeText.y = 60;
			quitText.x = 20;
			quitText.y = 80;
			optionsText.x = 20;
			optionsText.y = 100;
			retryText.x = 20;
			retryText.y = 120;
			
			rightArrow.y = optionsList[selOption].y;
		}
		
		private function createEvents():void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			//stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
		}
		
		private function removeEvents():void{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			//stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
		}
		
		public function showMe(target:MovieClip):void{
			target.addChild(this);
			initialize();
		}
		
		public function killMe():void{
			removeEvents();
			removeChild(pauseText);
			removeChild(resumeText);
			removeChild(quitText);
			removeChild(optionsText);
			removeChild(retryText);
			removeChild(rightArrow);
			parent.removeChild(this);
		}
		
		public function onKeyboardDown(e:KeyboardEvent):void{
			
				if(e.keyCode == PlayerInfo.UP){
					selOption--;
					updateArrow();
					playerInfo.soundManager.playSound("MenuSelect",playerInfo.menuVol);
				}
				
				if(e.keyCode == PlayerInfo.DOWN){
					selOption++;
					updateArrow();
					playerInfo.soundManager.playSound("MenuSelect",playerInfo.menuVol);
				}		
			
				if(e.keyCode == PlayerInfo.BUTTON1){
					dispatchMenuEvent();
					playerInfo.soundManager.playSound("MenuSelect",playerInfo.menuVol);
				}
			
		}
		
		public function updateArrow():void{
			if(selOption > optionsList.length - 1) selOption = 0;
			if(selOption < 0) selOption = optionsList.length - 1;
			rightArrow.y = optionsList[selOption].y;
		}
		
		public function dispatchMenuEvent():void{
			if(selOption == 0){
				this.dispatchEvent(new Event(PauseScreen.RESUME));
			}
			
			if(selOption == 1){
				this.dispatchEvent(new Event(PauseScreen.QUIT));
			}
			
			if(selOption == 2){
				this.dispatchEvent(new Event(PauseScreen.OPTION));
			}
			
			if(selOption == 3){
				this.dispatchEvent(new Event(PauseScreen.RETRY));
			}
			killMe();
		}
	}	
}