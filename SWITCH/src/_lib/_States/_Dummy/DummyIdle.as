package _lib._States._Dummy 
{
	import _blitEngine._States.IState;
	import _lib._gameObjects._components.PhysicsLite;
	
	/**
	 * ...
	 * @author 
	 */
	public class DummyIdle implements IState 
	{
		
		public function DummyIdle() 
		{
			
		}
		
		
		/* INTERFACE _lib._States.IState */
		
		public function handleInput(actor:*):IState 
		{
			//if (actor._left) actor.getComponent(PhysicsLite).vector.x += Math.min(-.5,actor.getComponent(PhysicsLite).vector.x);
			//if (actor._right) actor.getComponent(PhysicsLite).vector.x += Math.max(.5,actor.getComponent(PhysicsLite).vector.x);
			return null;
		}
		
		public function update(actor:*):IState 
		{
			if (actor.isHit)
			{
				return new DummyHit();
			}
			return null;
		}
		
		public function enter(actor:*):void 
		{
			actor.isHit = false;
		}
		
		public function exit(actor:*):void 
		{
			
		}
		
	}

}