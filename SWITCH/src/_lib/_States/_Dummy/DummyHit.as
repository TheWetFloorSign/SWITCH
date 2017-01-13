package _lib._States._Dummy 
{
	import _blitEngine._States.IState;
	import _lib._gameObjects._components.GraphicsComponent;
	
	/**
	 * ...
	 * @author 
	 */
	public class DummyHit implements IState 
	{
		
		private var _tic:int;
		private var gc:GraphicsComponent;
		
		public function DummyHit() 
		{
			
		}
		
		
		/* INTERFACE _lib._States.IState */
		
		public function handleInput(actor:*):IState 
		{
			
			return null;
		}
		
		public function update(actor:*):IState 
		{
			if (_tic <=0)
			{
				return new DummyIdle();
			}
			
			_tic--;
			gc = actor.getComponent(GraphicsComponent);
			if (_tic % 12 == 0 && gc != null) gc._hFlip = -gc._hFlip;
			return null;
		}
		
		public function enter(actor:*):void 
		{
			actor.aniMachine.changeVariables("damage", true);
			_tic = 36;
		}
		
		public function exit(actor:*):void 
		{
			actor.aniMachine.changeVariables("damage", false);
		}
		
	}

}