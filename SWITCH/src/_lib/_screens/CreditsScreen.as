package _lib._screens{
	
	import flash.display.MovieClip;
	import flash.events.*;
	import _lib.PlayerInfo;
	import _lib.SoundManager;
	import _lib._gameObjects._gui.*;
	
	public class CreditsScreen extends MovieClip{
		
		public static const BACK:String = "onCreditsReturn";
		
		private var playerInfo:PlayerInfo;
		//private var soundManager:SoundManager;
		
		private var titleText:SpriteText;
		private var option1Text:SpriteText;
		private var credits1Text:SpriteText;
		private var credits2Text:SpriteText;
		private var credits3Text:SpriteText;
		private var credits4Text:SpriteText;
		private var credits5Text:SpriteText;
		
		private var rightArrow:RightArrow;
		
		private var optionsList:Array;
		
		private var selOption:int = 0;
		
		public function CreditsScreen(playerInfo:PlayerInfo) {
			this.playerInfo = playerInfo;
		}
		
		public function initialize():void{
			createAssets();
			addAssets();
			positionAssets();
			createEvents();
		}
		
		private function createAssets():void{
			titleText = new SpriteText("Credits");
			credits1Text = new SpriteText("Code   Ben McCarthy");
			credits2Text = new SpriteText("Art    Ben McCarthy");
			credits3Text = new SpriteText("Sound  Tom Vian");
			credits4Text = new SpriteText("Music  Low Frequency");
			credits5Text = new SpriteText("          Ocelot");
			option1Text = new SpriteText("back");
			
			rightArrow = new RightArrow();
			
			optionsList = new Array(option1Text);
		}
		
		private function addAssets():void{
			addChild(titleText);
			addChild(option1Text);
			addChild(credits1Text);
			addChild(credits2Text);
			addChild(credits3Text);
			addChild(credits4Text);
			addChild(credits5Text);
			addChild(rightArrow);
		}
		
		private function positionAssets():void{
			titleText.x = (stage.stageWidth - titleText.width)/2;
			titleText.y = 100;
			credits1Text.x = 50;
			credits1Text.y = titleText.y + 150;
			credits2Text.x = credits1Text.x;
			credits2Text.y = credits1Text.y + 40;
			credits3Text.x = credits2Text.x;
			credits3Text.y = credits2Text.y + 40;
			credits4Text.x = credits3Text.x;
			credits4Text.y = credits3Text.y + 40;
			credits5Text.x = credits4Text.x;
			credits5Text.y = credits4Text.y + 20;
			option1Text.x = credits5Text.x + 50;
			option1Text.y = credits5Text.y + 50;
			
			rightArrow.y = optionsList[selOption].y;
			rightArrow.x = option1Text.x - 20;
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
			removeChild(titleText);
			removeChild(option1Text);
			removeChild(credits1Text);
			removeChild(credits2Text);
			removeChild(credits3Text);
			removeChild(credits4Text);
			removeChild(credits5Text);
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
				this.dispatchEvent(new Event(CreditsScreen.BACK));
			}
			killMe();
				
		}
	}	
}