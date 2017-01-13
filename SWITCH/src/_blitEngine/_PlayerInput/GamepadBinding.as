package  _blitEngine._PlayerInput{
	
	import _lib._PlayerInput.IBinding;
	
	public class GamepadBinding implements IBinding{
		public var buttonID:String;
		public var gamePadID:int;
		public var isActive:Boolean = false;
		public function GamepadBinding(_buttonID:String, _gamePadID:int = 212121) {
			// constructor code
			buttonID = _buttonID;
			gamePadID = _gamePadID;
		}
		
		public function matchesKeyboardKey(_keyCode:int):Boolean{
			return false;
		}
		
		public function matchesGamepadControl(_buttonID:String, _gamePadID:int):Boolean{
			return buttonID == _buttonID && gamePadID == _gamePadID;
		}

	}
	
}
