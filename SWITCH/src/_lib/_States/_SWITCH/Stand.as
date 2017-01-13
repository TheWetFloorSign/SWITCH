package _lib._States._SWITCH 
{
	import _blitEngine._States.IState;
	import _blitEngine._gameObjects.BasicObject;
	import _blitEngine.ExtraFunctions;
	import _blitEngine.BitPoint;
	
	import _lib._gameObjects._components.HitBox;
	import _lib._gameObjects._components.PhysicsLite;
	
	/**
	 * ...
	 * @author 
	 */
	public class Stand implements IState 
	{
		private var canJump:Boolean;
		
		public function Stand() 
		{
			
		}
		
		
		/* INTERFACE _lib._States.IState */
		
		public function handleInput(actor:*):IState 
		{
			if (actor._jump && canJump)
			{
				return new Jump();
			}
			if (!actor._jump)
			{
				canJump = true;
			}
			return null;
		}
		
		public function update(actor:*):IState 
		{
			if (!(actor.wasTouching & ExtraFunctions.DOWN) && !(actor.touching & ExtraFunctions.DOWN))
			{
				return new Fall();
			}
			return null;
		}
		
		public function enter(actor:*):void 
		{
			if (actor._jump) canJump = false;
			actor.aniMachine.changeVariables("ground", true);
			actor.getComponent(HitBox).newHitBox(new BitPoint(20, 20),new BitPoint(10, 20));
			actor._scene.soundManager.playSound("land", 0.5);
		}
		
		public function exit(actor:*):void 
		{
			actor.aniMachine.changeVariables("ground", false);
		}
		
	}

}