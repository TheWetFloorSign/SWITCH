package  _lib._gameObjects._components
{
	import _lib.BitPoint;
	import _lib.ExtraFunctions;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class ComboLite implements IComponent{
		
		private var actor:*;
		private var comboList:Array;
		private var trimmedList:Array;
		private var currentCombo:Array;
		private var timeout:int;
		private var inputBuffer:int;
		
		public function ComboLite(_actor:*):void
		{
			actor = _actor;
		}
		
		public function update():void
		{
			
		}
		
		private function reset():void
		{
			
		}
		
		public function pushInput(button:String)
		{
			if (comboList == undefined || comboList == null) return;
		}
	}
	
}