package _lib._States._SWITCH 
{
	import _blitEngine._States.IState;	
	import _blitEngine._gameObjects.BasicObject;
	import _lib._gameObjects._components.PhysicsLite;
	import _lib._gameObjects._components.GraphicsComponent;
	import _blitEngine.ExtraFunctions;
	
	/**
	 * ...
	 * @author 
	 */
	public class Run implements IState 
	{
		
		private var canDash:Boolean;
		private var _tic:int;
		
		private var pl:PhysicsLite;
		private var gc:GraphicsComponent;
		
		public function Run() 
		{
			
		}
		
		
		/* INTERFACE _lib._States.IState */
		
		public function handleInput(actor:*):IState 
		{
			if ((actor._left && actor._right)||(!actor._left && !actor._right))
			{
				return new Idle();
			}else if (actor._left && !actor._right)
			{
				gc._hFlip = -1;
			}else if (!actor._left && actor._right)
			{
				gc._hFlip = 1;
			}
			if (((actor._dashRight && !actor._dashLeft) || (actor._dashLeft && !actor._dashRight)) && actor.dashRemaining && canDash)
			{
				trace("new dash");
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
			pl.vector.x = gc._hFlip * actor._totalSpeed;
			_tic--;
			if (_tic <= 0){
				if(actor.touching & ExtraFunctions.DOWN)actor._scene.soundManager.playSound("punch", 0.1);
				_tic = 24;
			}
			return null;
		}
		
		public function enter(actor:*):void 
		{
			pl = actor.getComponent(PhysicsLite);
			gc = actor.getComponent(GraphicsComponent);
			if (actor._left && !actor._right)
			{
				gc._hFlip = -1;
			}else if (!actor._left && actor._right)
			{
				gc._hFlip = 1;
			}
			if (actor._dashRight || actor._dashLeft) canDash = false;
			actor.aniMachine.changeVariables("walk", true);
			_tic = 8;
		}
		
		public function exit(actor:*):void 
		{
			actor.aniMachine.changeVariables("walk", false);
			pl.vector.x = 0;
		}
		
	}

}