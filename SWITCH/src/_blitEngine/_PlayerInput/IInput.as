package  _blitEngine._PlayerInput{
	
	import flash.events.*;
	
	
	public interface IInput {
		
		function createAssets():void;
		
		function stop():void;
		
		function start():void;
		
		function removeEvents():void;
		
		function checkKeysDown(e:KeyboardEvent):void;
		
		function checkKeysUp(e:KeyboardEvent):void;
		
		function addKeyboardActionBinding(_action:String, _keyCode:*):void;
		
		function addGamepadActionBinding(_action:String, _buttonID:String, _gamePadID:int = 212121):void;
		
		function isActionActivated(_action:String):Boolean;
		function isActionJustActivated(_action:String):Boolean;
		
		function getActionValue(_action:String, _gamepadIndex:int = 212121):Number;
		
		function updateAI():void;

	}
	
}
