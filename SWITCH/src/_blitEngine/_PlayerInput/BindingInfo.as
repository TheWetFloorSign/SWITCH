package  _blitEngine._PlayerInput{
	
	import _blitEngine._PlayerInput.IBinding;
	import flash.utils.getTimer;
	public class BindingInfo {
		public var action:String;
		public var binding:Array = [];
		public var lastActivatedTime:uint;

		public function BindingInfo(_action:String ="",_binding:IBinding = null) {
			// constructor code
			action = _action;
			binding.push(_binding);
			lastActivatedTime = 0;
		}
		
		public function addBinding(_binding:IBinding):void{
			binding.push(_binding);
		}
		
		public function isActivated():Boolean{
			for (var i:int = 0; i < binding.length; i++)
			{
				if (binding[i].isActive) return true;
			}
			return false;
		}
		
		public function isJustActivated():Boolean{
			for (var i:int = 0; i < binding.length; i++)
			{
				if (binding[i].isActive && getTimer() - lastActivatedTime <=30) return true;
			}
			return false;
		}
		
		public function setKeyActive(_keyCode:int, state:Boolean):void{
			for (var i:int = 0; i < binding.length; i++)
			{
				if ((binding[i].keyCode && binding[i].keyCode == _keyCode) || _keyCode == -1)
				{
					binding[i].isActive = state;
					if (state)
					{
						lastActivatedTime = getTimer();
					}
				}
			}
		}
		
		public function setPadActive(_buttonID:String, state:Boolean):void{
			for (var i:int = 0; i < binding.length; i++)
			{
				if ((binding[i].buttonID && binding[i].buttonID == _buttonID) || _buttonID == "" ) binding[i].isActive = state;
			}
		}
		
		public function matchesKeyboardKey(_keyCode:int):Boolean{
			for (var i:int = 0; i < binding.length; i++)
			{
				if (binding[i].matchesKeyboardKey(_keyCode)) return true;
			}
			return false;
		}
		
		public function matchesGamepadControl(_buttonID:String, _gamePadID:int):Boolean{
			for (var i:int = 0; i < binding.length; i++)
			{
				if (binding[i].matchesGamepadControl(_buttonID,_gamePadID)) return true;
			}
			return false;
		}
		
		public function isValueTrigger(_buttonID:String, value:Number, _min:int, _max:int, _gamePadID:int = 212121):Boolean{
			for (var i:int = 0; i < binding.length; i++)
			{
				if (binding[i].matchesGamepadControl(_buttonID, _gamePadID))
				{
					if (_max > 0)
					{
						return value > _min + (_max + _min) / 2;
					}else
					{
						return value < _min + (_max + _min) / 2;
					}
					
					
				}
			}
			return false;
		}

	}
	
}
