package _lib._States._SWITCH 
{
	import _blitEngine._States.IState;
	import _blitEngine._gameObjects.BasicObject;
	import _lib._gameObjects._components.PhysicsLite;
	import _lib._gameObjects._components.GraphicsComponent;
	/**
	 * ...
	 * @author 
	 */
	public class Dash implements IState 
	{
		
		private var _dashVec:int = 0;
		private var _tic:int = 0;
		private var _canDash:Boolean;
		private var phys:PhysicsLite;
		private var gc:GraphicsComponent;
		
		public function Dash() 
		{
			
		}
		
		
		/* INTERFACE _lib._States.IState */
		
		public function handleInput(actor:*):IState 
		{
			if ((_tic < 5) && ((actor._dashRight && !actor._dashLeft) || (actor._dashLeft && !actor._dashRight)) && actor.dashRemaining >=1 && _canDash)
			{
				return new Dash();
			}
			return null;
		}
		
		public function update(actor:*):IState 
		{
			
			phys.vector.x = (4 * _dashVec) +((Math.floor( -6 * Math.sqrt(1 - (_tic / 20) * (_tic / 20)) + 6)) * _dashVec);
			//phys.vector.y = -(phys.gravity * phys.mass);
			//if(Math.abs(phys.vector.x) > 7) phys.vector.x = -7;
			if (_tic > 0)_tic--;
			if (!actor._dashRight && !actor._dashLeft)
			{
				_canDash = true;
			}
			if (_tic <= 0) return new Idle();
			return null;
		}
		
		public function enter(actor:*):void 
		{
			phys = actor.getComponent(PhysicsLite);
			if (actor.getComponent(GraphicsComponent)._hFlip >0)
			{
				actor.aniMachine.changeVariables((actor._dashRight)?"dash":"backdash", true);
			}else{
				actor.aniMachine.changeVariables((actor._dashRight)?"backdash":"dash", true);
			}
			
			if ((actor._dashRight && !actor._dashLeft) || (actor._dashLeft && !actor._dashRight))
			{
				_canDash = false;
			}else{
				_canDash = true;
			}
			_dashVec = (actor._dashRight)?1: -1;
			_tic = 20;
			actor._scene.soundManager.playSound("dash", 0.5);
			phys.vector.y = Math.min(phys.vector.y, 0);
		}
		
		public function exit(actor:*):void 
		{
			actor.aniMachine.changeVariables("dash", false);
			actor.aniMachine.changeVariables("backdash", false);
			phys.vector.x = 0;
		}
		
	}

}