package _lib._States._SWITCH 
{
	import _blitEngine._States.IState;
	import _blitEngine.BitPoint;
	import _blitEngine.ExtraFunctions;
	import _lib._gameObjects._components.HitBox;
	import _lib._gameObjects._components.PhysicsLite;
	
	/**
	 * ...
	 * @author 
	 */
	public class Fall implements IState 
	{
		
		public function Fall() 
		{
			
		}
		
		
		/* INTERFACE _lib._States.IState */
		
		public function handleInput(actor:*):IState 
		{
			return null;
		}
		
		public function update(actor:*):IState 
		{
			if (actor.getComponent(PhysicsLite).vector.y >= 1)
			{
				actor.getComponent(HitBox).newHitBox(new BitPoint(16, 30),new BitPoint(8, 30));
				actor.aniMachine.changeVariables("fall", true);
			}
			if(actor.touching & ExtraFunctions.DOWN){
				
				return new Stand();
			}
			return null;
		}
		
		public function enter(actor:*):void 
		{
			
		}
		
		public function exit(actor:*):void 
		{
			actor.aniMachine.changeVariables("fall", false);
		}
		
	}

}