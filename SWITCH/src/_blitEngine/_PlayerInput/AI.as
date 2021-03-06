package _blitEngine._PlayerInput{
	
	import _blitEngine._PlayerInput.IInput;
	import flash.events.KeyboardEvent;
	import _lib._gameObjects._components.HitBox;
	import _blitEngine.ExtraFunctions;
	
	/**
	 * ...
	 * @author Ben
	 */
	
	
	public class AI implements IInput 
	{
		private var _aiObject:*;
		private var _actions:Array = [];
		private var centerX:Number;
		
		private var hb:HitBox;
		
		private var _tic:int = 0;
		public function AI(aiObject:*):void
		{
			_aiObject = aiObject;
			hb = _aiObject.getComponent(HitBox);
		}
		
		public function createAssets():void
		{}
		
		public function stop():void
		{}
		
		public function start():void
		{}
		
		public function removeEvents():void
		{}
		
		public function checkKeysDown(e:KeyboardEvent):void
		{}
		
		public function checkKeysUp(e:KeyboardEvent):void
		{}
		
		public function addKeyboardActionBinding(_action:String, _keyCode:*):void
		{}
		
		public function addGamepadActionBinding(_action:String, _buttonID:String, _gamePadID:int = 212121):void
		{}
		
		public function isActionActivated(_action:String):Boolean
		{
			return _actions[_action];
		}
		
		public function isActionJustActivated(_action:String):Boolean
		{
			return false;
		}
		
		public function getActionValue(_action:String, _gamepadIndex:int = 212121):Number
		{
			return (_actions[_action])?1:0;
		}
		
		public function updateAI():void
		{
			if (hb != null && _aiObject._playerInfo != null)
			{
				_aiObject._left = false;
				_aiObject._right = false;
				if (_tic >= 47 && _aiObject.touching & ExtraFunctions.DOWN){
					centerX = _aiObject.x + hb.centerx;
					if (Math.abs(_aiObject._playerInfo.playerX -centerX)<100){
						(_aiObject._playerInfo.playerX -centerX < 0)? _aiObject._left = true:_aiObject._right = true;
						_aiObject.aniMachine.changeVariables("idle", false);
					}else
					{
						_aiObject.aniMachine.changeVariables("idle", true);	
					}
					_tic = 0;
				}
				_tic++;
			}
			
		}
	}
	
}