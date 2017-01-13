package _lib._screens{
	
	import flash.display.MovieClip;
	import flash.events.*;
	import _lib.PlayerInfo;
	import _lib.SoundManager;
	import _lib._gameObjects._gui.*;
	
	public class InstructionScreen extends MovieClip{
		
		public static const BACK:String = "onInstructionReturn";
		
		private var playerInfo:PlayerInfo;
		//private var soundManager:SoundManager;
		
		private var titleText:SpriteText;
		private var option1Text:SpriteText;
		private var control1Text:SpriteText;
		private var control2Text:SpriteText;
		private var control3Text:SpriteText;
		private var control4Text:SpriteText;
		private var control5Text:SpriteText;
		
		private var rightArrow:RightArrow;
		
		private var optionsList:Array;
		
		private var selOption:int = 0;
		
		public function InstructionScreen(playerInfo:PlayerInfo) {
			this.playerInfo = playerInfo;
		}
		
		public function initialize():void{
			createAssets();
			addAssets();
			positionAssets();
			createEvents();
		}
		
		private function createAssets():void{
			titleText = new SpriteText("Controls");
			control1Text = new SpriteText("Shoot       L");
			control2Text = new SpriteText("Change");
			control3Text = new SpriteText("Weapon      K");
			control4Text = new SpriteText("Move        WASD");
			control5Text = new SpriteText("Pause       P");
			option1Text = new SpriteText("back");
			
			rightArrow = new RightArrow();
			
			optionsList = new Array(option1Text);
		}
		
		private function addAssets():void{
			addChild(titleText);
			addChild(option1Text);
			addChild(control1Text);
			addChild(control2Text);
			addChild(control3Text);
			addChild(control4Text);
			addChild(control5Text);
			addChild(rightArrow);
		}
		
		private function positionAssets():void{
			titleText.x = (stage.stageWidth - titleText.width)/2;
			titleText.y = 100;
			control1Text.x = 50;
			control1Text.y = titleText.y + 150;
			control2Text.x = control1Text.x;
			control2Text.y = control1Text.y + 40;
			control3Text.x = control2Text.x;
			control3Text.y = control2Text.y + 20;
			control4Text.x = control3Text.x;
			control4Text.y = control3Text.y + 40;
			control5Text.x = control4Text.x;
			control5Text.y = control4Text.y + 40;
			option1Text.x = control5Text.x + 50;
			option1Text.y = control5Text.y + 50;
			
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
			removeChild(control1Text);
			removeChild(control2Text);
			removeChild(control3Text);
			removeChild(control4Text);
			removeChild(control5Text);
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
				this.dispatchEvent(new Event(InstructionScreen.BACK));
			}
			killMe();
				
		}
	}	
}