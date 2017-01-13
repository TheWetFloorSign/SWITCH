package _lib._screens{
	
	import flash.display.MovieClip;
	import flash.events.*;
	import _lib.PlayerInfo;
	import _lib.SoundManager;
	import _lib._gameObjects._gui.*;
	
	public class GameOverScreen extends MovieClip{
		
		public static const QUIT:String = "onGOQuit";
		public static const RETRY:String = "onGOReset";
		
		private var subScoreScreen:SubmitScoreScreen;
		private var hsScreen:HighScoreScreen;
		
		private var playerInfo:PlayerInfo;
				
		public function GameOverScreen(playerInfo:PlayerInfo) {
			this.playerInfo = playerInfo;
			//this.soundManager = soundManager;
		}
		
		public function initialize():void{
			createAssets();
			addInitAssets();
			positionAssets();
			createEvents();			
		}
		
		private function createAssets():void{
			subScoreScreen = new SubmitScoreScreen(playerInfo);
			hsScreen = new HighScoreScreen(playerInfo);
		}
		
		private function addInitAssets():void{
			subScoreScreen.showMe(this);			
		}
		
		private function positionAssets():void{
		}
		
		private function createEvents():void{
			subScoreScreen.addEventListener(SubmitScoreScreen.DONE, onInputDone);
			hsScreen.addEventListener(HighScoreScreen.QUIT, onHSQuit);
			hsScreen.addEventListener(HighScoreScreen.RETRY, onHSRetry);
		}
		
		private function removeEvents():void{
			subScoreScreen.removeEventListener(SubmitScoreScreen.DONE, onInputDone);
			hsScreen.removeEventListener(HighScoreScreen.QUIT, onHSQuit);
			hsScreen.removeEventListener(HighScoreScreen.RETRY, onHSRetry);
		}
		
		private function onInputDone(e:Event):void{
			hsScreen.showMe(this);
		}
		
		private function onHSQuit(e:Event):void{
			this.dispatchEvent(new Event(GameOverScreen.QUIT));
			killMe();
		}
		
		private function onHSRetry(e:Event):void{
			this.dispatchEvent(new Event(GameOverScreen.RETRY));
			killMe();
		}
		
		public function showMe(target:MovieClip):void{
			target.addChild(this);
			initialize();
		}
		
		public function killMe():void{
			removeEvents();
			parent.removeChild(this);
		}
	}	
}