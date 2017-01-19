package _lib._gameObjects._enemies._minions{
	
	import _blitEngine._gameObjects.BasicObject;
	import _lib._gameObjects._components.GraphicsComponent;
	import _lib._gameObjects._components.HitBox;
	import _lib._gameObjects._components.PhysicsLite;
	import flash.display.BitmapData;
	import _blitEngine._blit.*;
	import _blitEngine.*;
	import _blitEngine.AnimationStateMachine;
	import _blitEngine.DebugBox;
	import _blitEngine._States.IState;
	import _lib._States._Dummy.*;
	import _blitEngine._PlayerInput.AI;
	
	public class BeachBall extends BasicObject{
        
		
		private var _stateTic:int;
				
		public var moveState:IState;
		public var jumpState:IState;
		public var actionState:IState;
		
		public var isHit:Boolean;
		
		private var tempState:IState;
		
		public var sprite:GraphicsComponent;
		public var pl:PhysicsLite;
		
		
		public function BeachBall(){
			// initialization
			_xspeed = 1;
			
			componentList.push(new HitBox(this,18, 18,9,18));
			getComponent(HitBox).collision1 = enterCollision;
			getComponent(HitBox).collision2 = continuedCollision;
			getComponent(HitBox).collision3 = exitCollision;
			
			componentList.push(new PhysicsLite(this));
			pl = getComponent(PhysicsLite);
			pl.mass = .1;
			
			
			aniMachine = new AnimationStateMachine();
			componentList.push(new GraphicsComponent(this));
			getComponent(GraphicsComponent).spriteManager = aniMachine;
			
			_totalSpeed = 3;
			
			_alive = true;
			
			_stateTic = 0;
			// start moving by default
			
			setAnimations();
			
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
			if(_alive){
				last.x = x;
				last.y = y;
				updateComponents();
				wasTouching = touching;
				touching = ExtraFunctions.NONE;
			}						
		}
		
		override public function resetMe():void{
			//this._x = 200;
			//this._y = 200;
		}	
		
		public function setAnimations():void{
			aniMachine.addVariables({damage:false});
			
			aniMachine._library.newFrame("idle1","beachBall",0,0,18,18);
			
			
			var ani:BlitAnimation = new BlitAnimation("idle",aniMachine._library,true,8);
			ani.addFrame("idle1");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("idle", {damage:false});
			
			aniMachine.defaultAnimation = "idle";			
		}
		
		override public function onShowMe():void{
			gc = getComponent(GraphicsComponent);
			gc._camera = _camera;
		}
			
		public function enterCollision():void
		{
			//trace(obj + " just touched " + this);
			var targ:BasicObject = getComponent(HitBox).target;
			var phys:PhysicsLite = targ.getComponent(PhysicsLite);
			if (phys == null){
				return;
			}
			if (phys.vector.x != 0 && !isHit)
			{
				isHit = true;
				pl.vector.x = phys.vector.x;
				getComponent(GraphicsComponent)._hFlip = (targ.x > x)? -1:1;
				_scene.soundManager.playSound("ball", 1.5);
			}
		}
		
		public function continuedCollision():void
		{
			/*var targ:BasicObject = getComponent(HitBox).target;
			if (targ.type != "player") return;
			var phys:PhysicsLite = getComponent(PhysicsLite);
			var tarPhys:PhysicsLite = targ.getComponent(PhysicsLite);
			if(tarPhys.vector.x !=0)phys.vector.x = ((targ.x + targ.getComponent(HitBox).centerx) > (x + getComponent(HitBox).centerx))?Math.min(targ.x - targ.last.x, phys.vector.x):Math.max(targ.x - targ.last.x, phys.vector.x);
			if(tarPhys.vector.y <=-1 || tarPhys.vector.y >=1)phys.vector.y = (targ.y + targ.getComponent(HitBox).centery > y + getComponent(HitBox).centery)?Math.min(targ.y - targ.last.y, phys.vector.y):Math.max(targ.y - targ.last.y, phys.vector.y);*/
		}
		
		public function exitCollision():void
		{
			//trace(obj + " stopped touching " + this);
			isHit = false;
		}
	}
}