package _lib._States._SWITCH 
{
	import _blitEngine._States.IState;
	import _blitEngine.BitPoint;
	import _blitEngine._gameObjects.BasicObject;
	import _lib._gameObjects._enemies._minions.Attack;
	import flash.geom.Rectangle;
	import _lib._gameObjects._components.GraphicsComponent;
	
	/**
	 * ...
	 * @author 
	 */
	public class Punch implements IState 
	{
		private var actionTic:int;
		public function Punch() 
		{
			
		}
		
		
		/* INTERFACE _lib._States.IState */
		
		public function handleInput(actor:*):IState 
		{	
			return null;
		}
		
		public function update(actor:*):IState 
		{
			actionTic--;
			if (actionTic == 0) return new ActionIdle();
			return null;
		}
		
		public function enter(actor:*):void 
		{
			actionTic = 10;
			actor.aniMachine.changeVariables("action", true);
			actor._scene.soundManager.playSound("wiff", 1.5);
			new Attack(actor,new Rectangle(12,28,6,28),new BitPoint(0,-5),new BitPoint(actor.getComponent(GraphicsComponent)._hFlip *8,-10));
		}
		
		public function exit(actor:*):void 
		{
			actor.aniMachine.changeVariables("action", false);
		}
		
	}

}