package _lib._screens{
	
	import flash.display.MovieClip;
	import flash.events.*;
	import _lib.PlayerInfo;
	import _lib.SoundManager;
	import _lib._gameObjects._gui.*;
	
	public class OptionsScreen extends MovieClip{
		
		public static const VOLUME:String = "onOptionsVolume";
		public static const CONTROLS:String = "onOptionsControls";
		public static const INSTRUCTIONS:String = "onOptionsInstructions";
		public static const CREDITS:String = "onOptionsCredits";
		public static const BACK:String = "onOptionsBack";
		
		private var playerInfo:PlayerInfo;
		//private var soundManager:SoundManager;
		
		private var titleText:SpriteText;
		private var option1Text:SpriteText;
		private var option2Text:SpriteText;
		private var option3Text:SpriteText;
		private var option4Text:SpriteText;
		private var option5Text:SpriteText;
		
		private var rightArrow:RightArrow;
		
		private var optionEnabled:Array;
		private var optionsList:Array;
		
		private var selOption:int = 0;
		
		public function OptionsScreen(playerInfo:PlayerInfo) {
			this.playerInfo = playerInfo;
			//this.soundManager = soundManager;
		}
		
		public function initialize():void{
			createAssets();
			addAssets();
			positionAssets();
			createEvents();
		}
		
		private function createAssets():void{
			titleText = new SpriteText("Options");
			option1Text = new SpriteText("Volume");
			option2Text = new SpriteText("Controls");
			option3Text = new SpriteText("Instructions");
			option4Text = new SpriteText("Credits");
			option5Text = new SpriteText("Back");
			
			rightArrow = new RightArrow();
			
			optionEnabled = new Array(1,1,1,1,1);
			optionsList = new Array(option1Text,option2Text,option3Text,option4Text,option5Text);
			
			selOption = 0;
		}
		
		private function addAssets():void{
			addChild(titleText);
			addChild(option1Text);
			addChild(option2Text);
			addChild(option3Text);
			addChild(option4Text);
			addChild(option5Text);
			addChild(rightArrow);
		}
		
		private function positionAssets():void{
			titleText.x = (stage.stageWidth - titleText.width)/2;
			titleText.y = 100;
			option1Text.x = 100;
			option1Text.y = titleText.y + 200;
			option2Text.x = option1Text.x;
			option2Text.y = option1Text.y + 20;
			option3Text.x = option1Text.x;
			option3Text.y = option2Text.y + 20;
			option4Text.x = option1Text.x;
			option4Text.y = option3Text.y + 20;
			option5Text.x = option1Text.x;
			option5Text.y = option4Text.y + 40;
			
			
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
			removeChild(option2Text);
			removeChild(option3Text);
			removeChild(option4Text);
			removeChild(option5Text);
			removeChild(rightArrow);
			parent.removeChild(this);
		}
		
		public function onKeyboardDown(e:KeyboardEvent):void{
			trace(playerInfo.menuVol);
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
			if(selOption == 0 && optionEnabled[selOption] == 1){
				this.dispatchEvent(new Event(OptionsScreen.VOLUME));
			}
			if(selOption == 1 && optionEnabled[selOption] == 1){
				this.dispatchEvent(new Event(OptionsScreen.CONTROLS));
			}
			if(selOption == 2 && optionEnabled[selOption] == 1){
				this.dispatchEvent(new Event(OptionsScreen.INSTRUCTIONS));
			}
			if(selOption == 3 && optionEnabled[selOption] == 1){
				this.dispatchEvent(new Event(OptionsScreen.CREDITS));
			}
			if(selOption == 4 && optionEnabled[selOption] == 1){
				this.dispatchEvent(new Event(OptionsScreen.BACK));
			}
			if(optionEnabled[selOption] == 1)killMe();
				
		}
	}	
}