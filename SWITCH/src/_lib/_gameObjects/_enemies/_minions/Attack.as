package _lib._gameObjects._enemies._minions{
	
	import _blitEngine._gameObjects.BasicObject;
	import _lib._gameObjects._components.GraphicsComponent;
	import _lib._gameObjects._components.HitBox;
	import _lib._gameObjects._components.PhysicsLite;
	import _blitEngine.*;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public class Attack extends BasicObject{
        
		
		private var _stateTic:int;
		
		public var isHit:Boolean;
		
		private var _parent:BasicObject;
		
		private var soundManager:SoundManager = SoundManager.getInstance();
		
		private var _force:BitPoint;
		private var _offset:BitPoint;
		
		
		public function Attack(parent:BasicObject,size:Rectangle = null,force:BitPoint = null, offset:BitPoint = null){
			// initialization
			_xspeed = 1;
			_parent = parent;
			_alive = true;
			_force = force;
			_offset = offset;
			if (size == null) size = new Rectangle(16, 8, 8, 8);
			if (force == null) _force = new BitPoint(0, 0);
			if (offset == null) _offset = new BitPoint(0, 0);
			
			componentList.push(new HitBox(this,size.x, size.y, size.width, size.height));
			componentList.push(new GraphicsComponent(this));
			getComponent(HitBox).collision1 = enterCollision;
			//trace("new attack");
			//trace(offset);
			type = "attack";
			showMe(_parent._scene);
			
		}
		//
		//--------------------------- GET/SET METHODS
		//
		
		//
		//--------------------------- PUBLIC METHODS 
		//	
		
		//
		//--------------------------- EVENT HANDLERS
		//
		override public function updateMe():void{
			if (_alive){		
				last.x = x;
				last.y = y;
				x = _parent.x + _offset.x;
				y = _parent.y + _offset.y;
				_stateTic--;
				if (_stateTic <= 0){
					_alive = false;
				}
				
			}else{
				killMe();
			}
						
		}
		
		override public function onShowMe():void
		{
			_stateTic = 10;
			last.x = x = _parent.x + _offset.x;
			last.y = y = _parent.y + _offset.y;
			getComponent(GraphicsComponent)._camera = _camera;
		}
		
		override public function resetMe():void{
			
		}	
			
		public function enterCollision():void
		{
			var targ:BasicObject = getComponent(HitBox).target;
			trace(targ);
			if (targ != _parent && targ.getComponent(PhysicsLite) != null)
			{
				targ.getComponent(PhysicsLite).vector.x += _force.x;
				targ.getComponent(PhysicsLite).vector.y += _force.y;
			}
			
			soundManager.playSound("punch",0.5);
			//trace("in attack");
		}
	}
}