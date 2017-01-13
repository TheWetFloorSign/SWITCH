package  _blitEngine._PlayerInput{
	
	import flash.display.Stage;
	import flash.events.*;
	import flash.system.Capabilities;
	import _lib.PlayerInfo;
	import flash.ui.GameInput;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	import _lib.DebugBox;	
	
	public class PlayerInput implements IInput{
		
		private var _stage:Stage;
		private var _playerInfo:PlayerInfo;
		private var bindings:Array;
		private var values:Object = new Object();
		private var currentDevice:GameInputDevice = null;
		private var refController:Object;
		private var gameInput:GameInput = null;
		private var debug:DebugBox;
		private var deviceControl:GameInputControl;

		public function PlayerInput(stage:Stage, playerInfo:PlayerInfo)
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
			debug = new DebugBox();
			debug.newDebug(_stage);
			debug.debug("Creating assets");
		}
		
		private function deviceUnusable(e:GameInputEvent):void 
		{}
		
		private function deviceRemoved(e:GameInputEvent):void 
		{}
		
		private function deviceAdded(e:GameInputEvent):void 
		{
			refreshDevice();
		}
		
		private function refreshDevice():void
		{
			debug.debug("Current number of devices",GameInput.numDevices);
			if (GameInput.numDevices > 0){
				currentDevice = GameInput.getDeviceAt(0);
				currentDevice.enabled = true;
				debug.debug("Control events set");
				setCurrentController();
				for (var iNC:int = 0; iNC < currentDevice.numControls; iNC++){
					currentDevice.getControlAt(iNC).addEventListener(Event.CHANGE, controlChange);
				}
			}			
		}
		
		private function controlChange(e:Event):void 
		{
			deviceControl = e.target as GameInputControl;
			debug.debug(String(deviceControl.id), deviceControl.value);
			interpretGamePadChange(deviceControl.id, deviceControl.value);
		}
		
		private function interpretGamePadChange(id:String, value:Number):void 
		{
			var filteredGamepadControls:Array = filterGamepadControls(refController[id]["target"]);
						
			var isActivated:Boolean;
			
			for (var i:int = 0; i < filteredGamepadControls.length; i++){
				debug.debug(filteredGamepadControls[i].action);
				values[filteredGamepadControls[i].action] = value;
				isActivated  = filteredGamepadControls[i].isValueTrigger(refController[id]["target"], value,refController[id]["Min"],refController[id]["Max"]);
				if (filteredGamepadControls[i].isActivated() != isActivated)
				{
					filteredGamepadControls[i].setPadActive(refController[id]["target"], isActivated);
										
				}
			}
		}
		
		public function stop():void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
			
			if (gameInput != null)
			{	debug.debug("removing events");
				gameInput.removeEventListener(GameInputEvent.DEVICE_ADDED, deviceAdded);
				gameInput.removeEventListener(GameInputEvent.DEVICE_REMOVED, deviceRemoved);
				gameInput.removeEventListener(GameInputEvent.DEVICE_UNUSABLE, deviceUnusable);
			}
			if (currentDevice != null)
			{
				for (var iNC:int = 0; iNC < currentDevice.numControls; iNC++){
					currentDevice.getControlAt(iNC).removeEventListener(Event.CHANGE, controlChange);
				}
			}			
		}
		
		public function start():void
		{
			// Starts listening to keyboard events
			if (GameInput.isSupported)
			{
				gameInput = new GameInput();
			}
			debug.debug(Capabilities.manufacturer);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, checkKeysUp);

			// Starts listening to device addition events
			if (gameInput != null) {
				gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, deviceAdded);
				gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, deviceRemoved);
				gameInput.addEventListener(GameInputEvent.DEVICE_UNUSABLE, deviceUnusable);
				debug.debug("player is supported, creating device events");
				refreshDevice();
			}			
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
		
		private function filterGamepadControls(_controlId:String):Array
		{
			var filteredControls:Array = new Array();

			for (var i:int = 0; i < bindings.length; i++) {
				if (bindings[i].matchesGamepadControl(_controlId, 212121)) filteredControls.push(bindings[i]);
			}

			return filteredControls;
		}
		
		public function addKeyboardActionBinding(_action:String, _keyCode:int):void
		{
			bindings.push(new BindingInfo(_action, new ControlBinding(_keyCode)));
		}
		
		public function addGamepadActionBinding(_action:String, _buttonID:String, _gamePadID:int = 212121):void
		{
			bindings.push(new BindingInfo(_action, new GamepadBinding(_buttonID, _gamePadID)));
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
		
		public function updateAI():void
		{}
		
		
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
			return values.hasOwnProperty(_action) ? values[_action] : 0;
		}
		
		private function setCurrentController():void
		{
			debug.debug(Capabilities.os);
			var cnt:Object = new Object();
			if (Capabilities.os.substr(0, 3).toLowerCase() == "win")
			{
				
				if (/*Capabilities.manufacturer.toLowerCase().indexOf("pepper")*/ 1 == 1)
				{
					if (GameInput.getDeviceAt(0).id.indexOf("Logitech(R) Precision(TM) Gamepad") > -1)
					{
						//contrLogiPrecision
						cnt["AXIS_0"] = [];
						cnt["AXIS_0"]["target"] = "Dpad_x";
						cnt["AXIS_0"]["Min"] = -1;
						cnt["AXIS_0"]["Max"] = 1;
						
						cnt["AXIS_1"] = [];
						cnt["AXIS_1"]["target"] = "Dpad_y";
						cnt["AXIS_1"]["Min"] = -1;
						cnt["AXIS_1"]["Max"] = 1;
						
						cnt["BUTTON_2"] = [];
						cnt["BUTTON_2"]["target"] = "LeftAction";
						cnt["BUTTON_2"]["Min"] = 0;
						cnt["BUTTON_2"]["Max"] = 1;
						
						cnt["BUTTON_3"] = [];
						cnt["BUTTON_3"]["target"] = "BottomAction";
						cnt["BUTTON_3"]["Min"] = 0;
						cnt["BUTTON_3"]["Max"] = 1;
						
						cnt["BUTTON_4"] = [];
						cnt["BUTTON_4"]["target"] = "RightAction";
						cnt["BUTTON_4"]["Min"] = 0;
						cnt["BUTTON_4"]["Max"] = 1;
						
						cnt["BUTTON_5"] = [];
						cnt["BUTTON_5"]["target"] = "TopAction";
						cnt["BUTTON_5"]["Min"] = 0;
						cnt["BUTTON_5"]["Max"] = 1;
						
						cnt["BUTTON_6"] = [];
						cnt["BUTTON_6"]["target"] = "LeftShoulder";
						cnt["BUTTON_6"]["Min"] = 0;
						cnt["BUTTON_6"]["Max"] = 1;
						
						cnt["BUTTON_7"] = [];
						cnt["BUTTON_7"]["target"] = "RightShoulder";
						cnt["BUTTON_7"]["Min"] = 0;
						cnt["BUTTON_7"]["Max"] = 1;
						
						cnt["BUTTON_8"] = [];
						cnt["BUTTON_8"]["target"] = "LeftTrigger";
						cnt["BUTTON_8"]["Min"] = 0;
						cnt["BUTTON_8"]["Max"] = 1;
						
						cnt["BUTTON_9"] = [];
						cnt["BUTTON_9"]["target"] = "RightTrigger";
						cnt["BUTTON_9"]["Min"] = 0;
						cnt["BUTTON_9"]["Max"] = 1;
						
						cnt["BUTTON_10"] = [];
						cnt["BUTTON_10"]["target"] = "MetaSelect";
						cnt["BUTTON_10"]["Min"] = 0;
						cnt["BUTTON_10"]["Max"] = 1;
						
						cnt["BUTTON_11"] = [];
						cnt["BUTTON_11"]["target"] = "MetaStart";
						cnt["BUTTON_11"]["Min"] = 0;
						cnt["BUTTON_11"]["Max"] = 1;
						
						refController = cnt;
					}
					
					if (GameInput.getDeviceAt(0).id.indexOf("Xbox 360 Controller") > -1)
					{
						//Xbox 360 
						cnt["AXIS_0"] = [];
						cnt["AXIS_0"]["target"] = "Dpad_x";
						cnt["AXIS_0"]["Min"] = -1;
						cnt["AXIS_0"]["Max"] = 1;
						
						cnt["AXIS_1"] = [];
						cnt["AXIS_1"]["target"] = "Dpad_y";
						cnt["AXIS_1"]["Min"] = -1;
						cnt["AXIS_1"]["Max"] = 1;
						
						cnt["AXIS_2"] = [];
						cnt["AXIS_2"]["target"] = "Stick_Right_x";
						cnt["AXIS_2"]["Min"] = 0;
						cnt["AXIS_2"]["Max"] = 1;
						
						cnt["AXIS_3"] = [];
						cnt["AXIS_3"]["target"] = "Stick_Right_y";
						cnt["AXIS_3"]["Min"] = 0;
						cnt["AXIS_3"]["Max"] = 1;
						
						cnt["BUTTON_4"] = [];
						cnt["BUTTON_4"]["target"] = "BottomAction";
						cnt["BUTTON_4"]["Min"] = 0;
						cnt["BUTTON_4"]["Max"] = 1;
						
						cnt["BUTTON_5"] = [];
						cnt["BUTTON_5"]["target"] = "RightAction";
						cnt["BUTTON_5"]["Min"] = 0;
						cnt["BUTTON_5"]["Max"] = 1;
						
						cnt["BUTTON_6"] = [];
						cnt["BUTTON_6"]["target"] = "LeftAction";
						cnt["BUTTON_6"]["Min"] = 0;
						cnt["BUTTON_6"]["Max"] = 1;
						
						cnt["BUTTON_7"] = [];
						cnt["BUTTON_7"]["target"] = "TopAction";
						cnt["BUTTON_7"]["Min"] = 0;
						cnt["BUTTON_7"]["Max"] = 1;
						
						cnt["BUTTON_8"] = [];
						cnt["BUTTON_8"]["target"] = "LeftShoulder";
						cnt["BUTTON_8"]["Min"] = 0;
						cnt["BUTTON_8"]["Max"] = 1;
						
						cnt["BUTTON_9"] = [];
						cnt["BUTTON_9"]["target"] = "RightShoulder";
						cnt["BUTTON_9"]["Min"] = 0;
						cnt["BUTTON_9"]["Max"] = 1;
						
						cnt["BUTTON_10"] = [];
						cnt["BUTTON_10"]["target"] = "LeftTrigger";
						cnt["BUTTON_10"]["Min"] = 0;
						cnt["BUTTON_10"]["Max"] = 1;
						
						cnt["BUTTON_11"] = [];
						cnt["BUTTON_11"]["target"] = "RightTrigger";
						cnt["BUTTON_11"]["Min"] = 0;
						cnt["BUTTON_11"]["Max"] = 1;
						
						cnt["BUTTON_12"] = [];
						cnt["BUTTON_12"]["target"] = "MetaSelect";
						cnt["BUTTON_12"]["Min"] = 0;
						cnt["BUTTON_12"]["Max"] = 1;
						
						cnt["BUTTON_13"] = [];
						cnt["BUTTON_13"]["target"] = "MetaStart";
						cnt["BUTTON_13"]["Min"] = 0;
						cnt["BUTTON_13"]["Max"] = 1;
						
						cnt["BUTTON_14"] = [];
						cnt["BUTTON_14"]["target"] = "Stick_Left_Press";
						cnt["BUTTON_14"]["Min"] = 0;
						cnt["BUTTON_14"]["Max"] = 1;
						
						cnt["BUTTON_15"] = [];
						cnt["BUTTON_15"]["target"] = "Stick_Right_Press";
						cnt["BUTTON_15"]["Min"] = 0;
						cnt["BUTTON_15"]["Max"] = 1;
						
						cnt["BUTTON_16"] = [];
						cnt["BUTTON_16"]["target"] = "Dpad_up";
						cnt["BUTTON_16"]["Min"] = 0;
						cnt["BUTTON_16"]["Max"] = 1;
						
						cnt["BUTTON_17"] = [];
						cnt["BUTTON_17"]["target"] = "Dpad_down";
						cnt["BUTTON_17"]["Min"] = 0;
						cnt["BUTTON_17"]["Max"] = 1;
						
						cnt["BUTTON_18"] = [];
						cnt["BUTTON_18"]["target"] = "Dpad_left";
						cnt["BUTTON_18"]["Min"] = 0;
						cnt["BUTTON_18"]["Max"] = 1;
						
						cnt["BUTTON_19"] = [];
						cnt["BUTTON_19"]["target"] = "Dpad_right";
						cnt["BUTTON_19"]["Min"] = 0;
						cnt["BUTTON_19"]["Max"] = 1;
						
						refController = cnt;
					}					
				}
			}			
		}
	}	
}
