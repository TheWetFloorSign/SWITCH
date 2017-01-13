package  _lib._screens{
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import _lib.PlayerInfo;
	import _lib.SoundManager;
	import _lib._gameObjects._gui.*;
	import flash.net.FileReference;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class HighScoreScreen extends MovieClip{
		
		public static const QUIT:String = "onGOQuit";
		public static const RETRY:String = "onGOReset";
		
		private const RETRIEVE_SCRIPT:String = "http://benjaminmccarthy.ca/_lib/retrieveScript.php";
		private const ADD_SCRIPT:String = "http://benjaminmccarthy.ca/_lib/insertScript.php";
		
		private var playerInfo:PlayerInfo;
		//private var soundManager:SoundManager;
		
		private var path:String = "_lib/_highScoreXML/";
		
		private var titleText:SpriteText;
		private var option1Text:SpriteText;
		private var option2Text:SpriteText;
		
		private var loader:URLLoader = new URLLoader();
		private var sendScoreRequest:URLRequest;
		private var dataPass:URLVariables;
		private var scoreXML:XML;
		private var sendXML:XML;
		private var scoreXMLArray:Array;
		
		private var file:FileReference;
		
		private var rightArrow:RightArrow;
		
		private var playerScore:int;
		
		private var optionsList:Array;
		
		private var highScoreArray:Array;
		
		private var loadingText:SpriteText;
		private var elipses:LoadingElipses;
		private var inputHS:PlayerInputText;
		
		private var timerInt:int = 0;
		private var scorePos:int = 0;
		private var selOption:int = 0;

		public function HighScoreScreen(playerInfo:PlayerInfo) {
			this.playerInfo = playerInfo;
			//this.soundManager = soundManager;
		}
		
		public function initialize():void{
			loadScoreList();
		}
		
		private function loadScoreList():void{
			
			loadingText = new SpriteText("Loading");
			addChild(loadingText);
			loadingText.x = 150;
			loadingText.y = 200;
			
			elipses = new LoadingElipses();
			addChild(elipses);
			elipses.x = loadingText.x + loadingText.width;
			elipses.y = loadingText.y;
			
			loader.addEventListener(Event.COMPLETE, xmlLoaded);
			loader.load(new URLRequest(RETRIEVE_SCRIPT));
		}
		
		private function xmlLoaded(e:Event):void{
			loader.removeEventListener(Event.COMPLETE, xmlLoaded);
			removeChild(loadingText);
			removeChild(elipses);
			scoreXML = new XML(e.target.data);
			addPlayerScore();
			sortXML();
			createAssets();
			addAssets();
			positionAssets();
			createEvents();
		}
		
		private function addPlayerScore():void{
			playerScore = playerInfo.pointsTotal;
			sendXML = new XML(<score><points>{playerScore}</points><initials>{playerInfo.playerName}</initials></score>);
			scoreXML.appendChild(sendXML);
		}
		
		private function sortXML():void{
			scoreXMLArray = new Array();
			for(var i:int=0; i<scoreXML.score.length();i++){
				scoreXMLArray.push(scoreXML.score[i]);
			}
			scoreXMLArray.sort(comparePoints);
			
		}
		
		private function createAssets():void{
			titleText = new SpriteText("game over");
			option1Text = new SpriteText("quit");
			option2Text = new SpriteText("retry");
			
			rightArrow = new RightArrow();
			
			optionsList = new Array(option1Text,option2Text);
			highScoreArray = new Array();
			selOption = 0;
			createHighScore();
		}
		
		private function createHighScore():void{
			
			var used:Boolean = false;
			
			for(var i:int = 0;i<10;i++){
				
				var tempArray:Array = new Array();
				var rankNum:SpriteText = new SpriteText((i + 1) + ".");
				var score:SpriteText;
				var initials:SpriteText;
				trace(scoreXMLArray[i] + " is " + i);
				if(scoreXMLArray[i] != undefined){
					score = new SpriteText(String(scoreXMLArray[i].points));
					initials = new SpriteText(String(scoreXMLArray[i].initials));	
				}else{
					score = new SpriteText("0000000");
					initials = new SpriteText("aaa");	
				}
								
				
				
				
				tempArray.push(rankNum);
				tempArray.push(score);
				tempArray.push(initials);
				highScoreArray.push(tempArray);
			}
		}
		
		private function addAssets():void{
			addChild(titleText);
			addChild(option1Text);
			addChild(option2Text);
			addChild(rightArrow);
			for(var i:int = 0; i< highScoreArray.length; i++){
				addChild(highScoreArray[i][0]);
				addChild(highScoreArray[i][1]);
				addChild(highScoreArray[i][2]);
			}
			
		}
		
		private function positionAssets():void{
			titleText.x = 128;
			titleText.y = 100;
			
			positionHighScore();
			
			option1Text.x = titleText.x + 20;
			option1Text.y = highScoreArray[highScoreArray.length - 1][1].y + 50;
			option2Text.x = option1Text.x;
			option2Text.y = option1Text.y + 20;
			
			rightArrow.y = optionsList[selOption].y;
			rightArrow.x = optionsList[selOption].x - 20;
		}
		
		private function positionHighScore():void{
			for(var i:int = 0; i< highScoreArray.length; i++){
				highScoreArray[i][0].x = titleText.x - 50;
				highScoreArray[i][1].x = highScoreArray[i][0].x - highScoreArray[i][1].width + 170;
				highScoreArray[i][2].x = highScoreArray[i][1].x + highScoreArray[i][1].width + 30;
				
				highScoreArray[i][0].y = titleText.y + ((i + 1) * 30);
				highScoreArray[i][1].y = highScoreArray[i][0].y;
				highScoreArray[i][2].y = highScoreArray[i][1].y;
				
				highScoreArray[i][0].alpha = 0;
				highScoreArray[i][1].alpha = 0;
				highScoreArray[i][2].alpha = 0;
			}
			this.addEventListener(Event.ENTER_FRAME, scoreTweens);
		}
		
		private function scoreTweens(e:Event):void{
			var delayInt:int = 10;
			timerInt++;
			if(timerInt % delayInt == 0){
				var tween1:Tween = new Tween(highScoreArray[scorePos][0], "alpha", None.easeIn, 0, 1, 30, false);
				var tween2:Tween = new Tween(highScoreArray[scorePos][1], "alpha", None.easeIn, 0, 1, 30, false);
				var tween3:Tween = new Tween(highScoreArray[scorePos][2], "alpha", None.easeIn, 0, 1, 30, false);
				scorePos++;
			}
			if(scorePos > 9){
				this.removeEventListener(Event.ENTER_FRAME, scoreTweens);
			}
		}
		
		private function createEvents():void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			//stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
		}
		
		private function removeEvents():void{
			if(stage && stage.hasEventListener(KeyboardEvent.KEY_DOWN)){
			   stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			}
			if(this.hasEventListener(Event.ENTER_FRAME)){
				this.removeEventListener(Event.ENTER_FRAME, scoreTweens);
			}
			
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
			removeChild(rightArrow);
			for(var i:int = 0; i< highScoreArray.length; i++){
				removeChild(highScoreArray[i][0]);
				removeChild(highScoreArray[i][1]);
				removeChild(highScoreArray[i][2]);
			}
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
		
		private function comparePoints(a:XML, b:XML):int{
			//trace("a is " + a + " b is " + b);
			if(Number(a.points) > Number(b.points)) return -1;
			if(Number(a.points) < Number(b.points)) return 1;
			return 0;
		}
		
		private function saveScores():void{
			dataPass = new URLVariables();
			dataPass.scoreXML = sendXML.toXMLString();
			dataPass.points = playerScore;
			dataPass.initials = playerInfo.playerName;
			dataPass.tricky = Math.random();
			sendScoreRequest = new URLRequest(ADD_SCRIPT);
			
			sendScoreRequest.data = dataPass;
      		sendScoreRequest.method = URLRequestMethod.POST;
			loader.addEventListener(Event.COMPLETE, xmlSent);
			loader.load(sendScoreRequest);
			//navigateToURL(sendScoreRequest,"_blank");
		}
		
		private function xmlSent(e:Event):void{
			loader.removeEventListener(Event.COMPLETE, xmlSent);
			killMe();
		}
		
		public function dispatchMenuEvent():void{
			removeEvents();
			if(selOption == 0){
				this.dispatchEvent(new Event(HighScoreScreen.QUIT));
			}
			
			if(selOption == 1){
				this.dispatchEvent(new Event(HighScoreScreen.RETRY));
			}
			saveScores();
		}
	}	
}