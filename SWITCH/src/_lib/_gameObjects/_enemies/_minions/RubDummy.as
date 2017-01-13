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
	
	public class RubDummy extends BasicObject{
        
		
		private var _stateTic:int;
				
		public var moveState:IState;
		public var jumpState:IState;
		public var actionState:IState;
		
		public var isHit:Boolean;
		
		private var tempState:IState;
		
		public var gC:GraphicsComponent;
		public var pL:PhysicsLite;
		public var hB:HitBox;
		
		
		public function RubDummy(){
			// initialization
			_xspeed = 1;
			componentList.push(new HitBox(this, 16, 24, 8, 24));
			hB = getComponent(HitBox);
			hB.collision1 = enterCollision;
			hB.collision2 = continuedCollision;
			hB.collision3 = exitCollision;
			
			componentList.push(new PhysicsLite(this));
			pL = getComponent(PhysicsLite);
			pL.termVel = 8;
			pL.mass = 2;
			
			aniMachine = new AnimationStateMachine();
			componentList.push(new GraphicsComponent(this));
			gC = getComponent(GraphicsComponent);
			gC.spriteManager = aniMachine;
			
			_totalSpeed = 3;
			
			_alive = true;
			
			_stateTic = 0;
			
			setAnimations();
			input = new AI(this);
			
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
				updateInputs();
				
				if (_left)
				{
					pL.vector.x = -2;
					gC._hFlip = -1;
				}
				if (_right)
				{
					pL.vector.x = 2;
					gC._hFlip = 1;
				}
				
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
		
		private function updateInputs():void{
			input.updateAI();
		}
		
		public function setAnimations():void{
			aniMachine.addVariables({idle:false});
			
			aniMachine._library.newFrame("idle1","rubDummy",0,0,26,28,false,0,-5);
			aniMachine._library.newFrame("idle2","rubDummy",27,0,22,30,false,0,5);
			
			
			var ani:BlitAnimation = new BlitAnimation("idle",aniMachine._library,true);
			ani.addFrame("idle2");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("idle", {idle:true});
			
			ani = new BlitAnimation("lurch",aniMachine._library,true,48);
			ani.addFrame("idle1","idle2");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("lurch", {idle:false});
			
			aniMachine.defaultAnimation = "idle";
			
			
		}
		
		override public function onShowMe():void{
			getComponent(GraphicsComponent)._camera = _camera;
		}
			
		public function enterCollision():void
		{
			//trace(obj + " just touched " + this);
			if (!isHit)
			{
				isHit = true;
				gC._hFlip = (hB.target.x > x)?-1:1;
			}
		}
		
		public function continuedCollision():void
		{
			//trace(obj + " is still touching " + this);
		}
		
		public function exitCollision():void
		{
			//trace(obj + " stopped touching " + this);
		}
	}
}