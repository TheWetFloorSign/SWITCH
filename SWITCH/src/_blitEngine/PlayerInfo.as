package  _blitEngine{
	
	import flash.events.*;
	
	public class PlayerInfo {
		
		public static const LEFT:int = 65;
		public static const UP:int = 87;
		public static const RIGHT:int = 68;
		public static const DOWN:int = 83;
		public static const BUTTON1:int = 76;
		public static const BUTTON2:int = 66;
		public static const BUTTON3:int = 75;
		public static const BUTTON4:int = 80;
		public static const BUTTON5:int = 32;
		public static const BUTTON6:int = 69;
		
		public static const DEVBUT1:int = 221;
		public static const DEVBUT2:int = 219;
		
		public static const BUTTONS:Array = [LEFT,UP,RIGHT,DOWN,BUTTON1,BUTTON2,BUTTON3,BUTTON4,DEVBUT1,DEVBUT2];
		
		private var _musicVol:Number = 1;
		private var _sfxVol:Number = 0.3;
		private var _menuVol:Number = 1;
		
		private var _playerX:Number = 0;
		private var _playerY:Number = 0;
		
		private var _gameBoundW:Number;
		private var _gameBoundH:Number;
		
		private var _pointsTotal:int = 0;
		private var _livesTotal:int = 0;
		private var _playerName:String = "AAA";
		
		//private var _soundManager:SoundManager;
		
		public function PlayerInfo() {
			_musicVol = 0.5;
			_sfxVol = 0.25;
			_menuVol = 1;
			
			//_soundManager = SoundManager.getInstance();
		}
		
		public function get playerName():String{
			return _playerName;
		}
		
		public function set playerName(value:String):void{
			_playerName = value;
		}
		
		public function get musicVol():Number{
			return _musicVol;
		}
		
		public function set musicVol(value:Number):void{
			_musicVol = value;
		}
		
		public function get sfxVol():Number{
			return _sfxVol;
		}
		
		public function set sfxVol(value:Number):void{
			_sfxVol = value;
		}
		
		public function get menuVol():Number{
			return _menuVol;
		}
		
		public function set menuVol(value:Number):void{
			_menuVol = value;
		}
		
		/*public function get soundManager():SoundManager{
			return _soundManager;
		}*/
		
		public function get playerX():Number{
			return _playerX;
		}
		
		public function set playerX(value:Number):void{
			_playerX = value;
		}
		
		public function get playerY():Number{
			return _playerY;
		}
		
		public function set playerY(value:Number):void{
			_playerY = value;
		}
		
		public function get gameBoundW():Number{
			return _gameBoundW;
		}
		
		public function set gameBoundW(value:Number):void{
			_gameBoundW = value;
		}
		
		public function get gameBoundH():Number{
			return _gameBoundH;
		}
		
		public function set gameBoundH(value:Number):void{
			_gameBoundH = value;
		}
		
		public function get pointsTotal():int{
			return _pointsTotal;
		}
		
		public function set pointsTotal(value:int):void{
			_pointsTotal = value;
		}
		
		public function get livesTotal():int{
			return _livesTotal;
		}
		
		public function set livesTotal(value:int):void{
			_livesTotal = value;
		}
	}
	
}
