package  _lib._gameObjects._components
{
	import _blitEngine.BitPoint;
	import _blitEngine.ExtraFunctions;
	import _blitEngine._gameObjects._components.IComponent;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class PhysicsLite implements IComponent
	{
		public var vector:BitPoint = new BitPoint(0,0);
		
		private var _mass:Number = 1;
		
		private var _gravity:Number = .21;
		
		private var _drag:Number = .5;
		
		public var friction:Number = .1;
		
		private var _termVel:Number = Math.sqrt((2*(mass * gravity))/drag);
		
		private var actor:*;
		
		public function PhysicsLite(_actor:*):void
		{
			actor = _actor;
		}
		
		public function set mass(val:Number):void
		{
			termVel = Math.sqrt((2*(mass * gravity))/drag);
			_mass = val;
		}
		
		public function get mass():Number
		{
			return _mass;
		}
		
		public function set gravity(val:Number):void
		{
			termVel = Math.sqrt((2*(mass * gravity))/drag);
			_gravity = val;
		}
		
		public function get gravity():Number
		{
			return _gravity;
		}
		
		public function set drag(val:Number):void
		{
			termVel = Math.sqrt((2*(mass * gravity))/drag);
			_drag = val;
		}
		
		public function get drag():Number
		{
			return _drag;
		}
		
		public function set termVel(val:Number):void
		{
			_termVel = val;
		}
		
		public function get termVel():Number
		{
			return _termVel;
		}
		
		public function update():void
		{
			if (actor.touching & ExtraFunctions.DOWN)
			{
				vector.y = Math.min(1, vector.y);
			}
			else
			{
				vector.y += gravity;
				if (vector.y > 30 * gravity * mass) vector.y = 30 * gravity * mass;
			}
			if (vector.x != 0)
			{
				if (actor.touching & ExtraFunctions.DOWN)
				{
					vector.x -= ExtraFunctions.sign(vector.x) * Math.min(Math.abs(vector.x), friction);
				}
				else
				{
					vector.x -= ExtraFunctions.sign(vector.x) * Math.min(Math.abs(vector.x), friction/(mass * 4));
				}
			}
			if (actor.touching & ExtraFunctions.RIGHT) vector.x = Math.min(drag, vector.x);
			if (actor.touching & ExtraFunctions.LEFT) vector.x = Math.max(-drag, vector.x);
			
			actor.x += vector.x;
			actor.y += vector.y;
		}
		
		public function kill():void{}
	}
	
}