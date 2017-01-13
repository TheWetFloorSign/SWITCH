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
	public class Kick implements IState 
	{
		private var actionTic:int;
		public function Kick() 
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
			if (actionTic == 10)
			{
				actor._scene.soundManager.playSound("wiff", 1.5);
				new Attack(actor,new Rectangle(30,12,15,12),new BitPoint(actor.getComponent(GraphicsComponent)._hFlip * 5,-2),new BitPoint(actor.getComponent(GraphicsComponent)._hFlip *9,-10));
			}
			return null;
		}
		
		public function enter(actor:*):void 
		{
			actionTic = 24;
			actor.aniMachine.changeVariables("action", true);
			actor.aniMachine.changeVariables("kick", true);
			
		}
		
		public function exit(actor:*):void 
		{
			actor.aniMachine.changeVariables("action", false);
			actor.aniMachine.changeVariables("kick", false);
		}
		
	}

}