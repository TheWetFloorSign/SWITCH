package  _blitEngine._PlayerInput{
	
	import _blitEngine._PlayerInput.IBinding;
	
	public class ControlBinding implements IBinding{
		public var keyCode:int;
		public var isActive:Boolean = false;
		public function ControlBinding(_keyCode:int) {
			// constructor code
			keyCode = _keyCode;
		}
		
		public function matchesKeyboardKey(_keyCode:int):Boolean{
			return (keyCode == _keyCode);
		}
		
		public function matchesGamepadControl(_buttonID:String, _gamePadID:int):Boolean{
			return false;
		}

	}
	
}
