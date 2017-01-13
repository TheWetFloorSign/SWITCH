package  _blitEngine._PlayerInput{
	
	import flash.display.Stage;
	import flash.events.*;
	import flash.utils.getTimer;
	import _blitEngine.PlayerInfo;
	import _blitEngine.DebugBox;
	import flash.ui.Keyboard;
		
	public class KeyboardInput implements IInput {
		
		private var _stage:Stage;
		private var _playerInfo:PlayerInfo;
		private var bindings:Array;
		private var debug:DebugBox;

		public function KeyboardInput(stage:Stage, playerInfo:PlayerInfo) 
		{
			// constructor code
			_stage = stage;
			_playerInfo = playerInfo;
			
			createAssets();
			start();
		}
		
		public function createAssets():void
		{
			bindings = new Array();
		}
		
		private function deviceUnusable(e:GameInputEvent):void 
		{}
		
		private function deviceRemoved(e:GameInputEvent):void 
		{}
		
		private function deviceAdded(e:GameInputEvent):void 
		{}
		
		public function stop():void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, checkKeysUp);			
		}
		
		public function start():void
		{
			// Starts listening to keyboard events
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
		}
		
		public function removeEvents():void
		{}
		
		public function checkKeysDown(e:KeyboardEvent):void
		{
			var filteredKeys:Array = filterKeyBindings(e.keyCode);
			for(var i:int=0;i<filteredKeys.length;i++){
				if(!filteredKeys[i].isActivated()){
					filteredKeys[i].setKeyActive(e.keyCode,true);
				}
			}			
		}
		
		public function checkKeysUp(e:KeyboardEvent):void
		{
			var filteredKeys:Array = filterKeyBindings(e.keyCode);
			for(var i:int=0;i<filteredKeys.length;i++){
				if(filteredKeys[i].isActivated()){
					filteredKeys[i].setKeyActive(e.keyCode,false);
				}
			}
		}
		
		private function filterKeyBindings(_keyCode:int):Array
		{
			var filteredKeys:Array = new Array();
			for(var i:int = 0;i<bindings.length;i++){
				if(bindings[i].matchesKeyboardKey(_keyCode)) filteredKeys.push(bindings[i]);
			}
			return filteredKeys;
		}
		
		public function addKeyboardActionBinding(_action:String, _keyCode:*):void
		{
			var keyInt:int;
			if (_keyCode is int || _keyCode is String)
			{
				if (_keyCode is String) keyInt = Keyboard[_keyCode.toUpperCase()];
				else keyInt = _keyCode;
				bindings.push(new BindingInfo(_action, new ControlBinding(keyInt)));
			}else{
				Error("Button was not provided in proper format. Please use int or String");
			}
			
			
		}
		
		public function addGamepadActionBinding(_action:String, _buttonID:String, _gamePadID:int = 212121):void
		{
			trace("Current IInput component does not allow gamepad mapping");
		}
		
		private function addActionBinding(_action:String, _binding:IBinding):void
		{
			var newBinding:Boolean = true;
			for (var i:int = 0; i < bindings.length; i++)
			{
				if (bindings[i].action == _action)
				{
					bindings[i].addBinding(_binding);
					newBinding = false;
					break;
				}
			}
			if(newBinding)bindings.push(new BindingInfo(_action, _binding));
		}
				
		public function isActionActivated(_action:String):Boolean
		{
			for (var i:int = 0; i < bindings.length; i++)
			{
				if (bindings[i].action == _action && bindings[i].isActivated()) return true;
			}
			return false;
		}
		
		public function isActionJustActivated(_action:String):Boolean
		{
			for (var i:int = 0; i < bindings.length; i++)
			{
				if (bindings[i].action == _action && bindings[i].isJustActivated()) return true;
			}
			return false;
		}
		
		public function getActionValue(_action:String, _gamepadIndex:int = 212121):Number
		{
			Error("Current IInput component does not allow gamepad mapping; Return default of 0");
			return 0;
		}
		
		public function updateAI():void
		{}
		
	}
	
}