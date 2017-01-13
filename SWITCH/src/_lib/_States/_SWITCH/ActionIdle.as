package _lib._States._SWITCH 
{
	import _blitEngine._States.IState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ActionIdle implements IState 
	{
		private var canAction:Boolean;
		
		public function ActionIdle() 
		{			
		}
		
		
		/* INTERFACE _lib._States.IState */
		
		public function handleInput(actor:*):IState 
		{
			if (actor._fire && canAction)
			{
				return new Punch();
			}
			if (actor._kick && canAction)
			{
				return new Kick();
			}
			if (!actor._fire && !actor._kick)
			{
				canAction = true;
			}
			return null;
		}
		
		public function update(actor:*):IState 
		{
			return null;
		}
		
		public function enter(actor:*):void 
		{
			if (actor._fire || actor._kick) canAction = false;
		}
		
		public function exit(actor:*):void 
		{
		}
		
	}

}