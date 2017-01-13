package _blitEngine._PlayerInput
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IBinding 
	{
		function matchesKeyboardKey(_keyCode:int):Boolean;
		
		function matchesGamepadControl(_buttonID:String, _gamePadID:int):Boolean;
	}
	
}