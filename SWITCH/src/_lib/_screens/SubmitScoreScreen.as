package  _lib._screens{
	
	import flash.display.MovieClip;
	import flash.events.*;
	import _lib.PlayerInfo;
	import _lib.SoundManager;
	import _lib._gameObjects._gui.*;
	import flash.net.FileReference;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class SubmitScoreScreen extends MovieClip{
		
		public static const DONE:String = "onSSDone";
		
		private var playerInfo:PlayerInfo;
		//private var soundManager:SoundManager;
		
		private var titleText:SpriteText;
		private var scoreText:SpriteText;
		private var option2Text:SpriteText;
			
		private var rightArrow:RightArrow;
		
		private var playerScore:int;
		
		private var optionsList:Array;
		private var inputHS:PlayerInputText;
		
		
		private var scorePos:int = 0;
		private var selOption:int = 0;

		public function SubmitScoreScreen(playerInfo:PlayerInfo) {
			this.playerInfo = playerInfo;
		}
		
		public function initialize():void{
			loadInputHS();
			createAssets();
			addAssets();
			positionAssets();
			createEvents();
		}
		
		private function loadInputHS():void{
			inputHS = new PlayerInputText(playerInfo,3);
			inputHS.showMe(this);
			inputHS.x = stage.stageWidth/2 - inputHS.width/2;
			inputHS.y = 200;
		}
		
		private function createAssets():void{
			titleText = new SpriteText("Enter your name");
			scoreText = new SpriteText(String(playerInfo.pointsTotal));
			option2Text = new SpriteText("submit");
			
			rightArrow = new RightArrow();
			
			optionsList = new Array(inputHS,option2Text);
			selOption = 0;
		}
		
		private function addAssets():void{
			addChild(titleText);
			addChild(scoreText);
			addChild(option2Text);
			addChild(rightArrow);			
		}
		
		private function positionAssets():void{
			titleText.x = stage.stageWidth/2 - titleText.width/2;
			titleText.y = 100;
			
			scoreText.x = stage.stageWidth/2 - scoreText.width/2;
			scoreText.y = titleText.y + 50;
			
			inputHS.x = (stage.stageWidth/2 - inputHS.width/2) - 16;
			inputHS.y = scoreText.y + 50;
			
			option2Text.x = inputHS.x;
			option2Text.y = inputHS.y + 50;
			
			rightArrow.y = optionsList[selOption].y;
			rightArrow.x = optionsList[selOption].x - 20;
		}
		
		private function createEvents():void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			inputHS.addEventListener(PlayerInputText.DONE, onInputDone);
		}
		
		private function removeEvents():void{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			inputHS.removeEventListener(PlayerInputText.DONE, onInputDone);
		}
		
		private function onInputDone(e:Event):void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
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
		
		private function dispatchMenuEvent():void{
			if(selOption == 0){
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
				inputHS.giveFocus();
			}
			if(selOption == 1){
				this.dispatchEvent(new Event(SubmitScoreScreen.DONE));
				killMe();
			}
			
		}
		
		public function updateArrow():void{
			if(selOption > optionsList.length - 1) selOption = 0;
			if(selOption < 0) selOption = optionsList.length - 1;
			rightArrow.y = optionsList[selOption].y;
		}
		
		public function showMe(target:MovieClip):void{
			target.addChild(this);
			initialize();
		}
		
		private function killMe():void{
			
			removeEvents();
			removeChild(titleText);
			removeChild(scoreText);
			removeChild(option2Text);
			removeChild(rightArrow);	
			inputHS.killMe();
		
			parent.removeChild(this);
		}

	}
	
}
