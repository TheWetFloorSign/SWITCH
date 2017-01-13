package _lib._States._SWITCH 
{
	import _blitEngine._States.IState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Idle implements IState 
	{
		
		private var canDash:Boolean;
		
		public function Idle() 
		{
			
		}
		
		
		/* INTERFACE _lib._States.IState */
		
		public function handleInput(actor:*):IState 
		{
			if ((!actor._left && actor._right) ||(actor._left && !actor._right))
			{
				return new Run();
			}
			if (((actor._dashRight && !actor._dashLeft) || (actor._dashLeft && !actor._dashRight)) && canDash)
			{
				return new Dash();
			}
			if (!actor._dashRight && !actor._dashLeft)
			{
				canDash = true;
			}
			return null;
		}
		
		public function update(actor:*):IState 
		{
			return null;
		}
		
		public function enter(actor:*):void 
		{
			
			actor._vector.x = 0;
			if (actor._dashRight || actor._dashLeft) canDash = false;
		}
		
		public function exit(actor:*):void 
		{
			
		}
		
	}

}