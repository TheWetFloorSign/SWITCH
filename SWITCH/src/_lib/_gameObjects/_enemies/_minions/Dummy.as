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
	
	public class Dummy extends BasicObject{
        
		
		private var _stateTic:int;
				
		public var moveState:IState;
		public var jumpState:IState;
		public var actionState:IState;
		
		public var isHit:Boolean;
		
		private var tempState:IState;
		
		public var sprite:GraphicsComponent;
		
		
		public function Dummy(){
			// initialization
			_xspeed = 1;
			componentList.push(new HitBox(this,12, 32,6,32));
			/*getComponent(HitBox).addEventListener(HitBox.COL_START, enterCollision);
			getComponent(HitBox).addEventListener(HitBox.COL_CONT, continuedCollision);
			getComponent(HitBox).addEventListener(HitBox.COL_END, exitCollision);*/
			getComponent(HitBox).collision1 = enterCollision;
			getComponent(HitBox).collision2 = continuedCollision;
			getComponent(HitBox).collision3 = exitCollision;
			
			componentList.push(new PhysicsLite(this));
			getComponent(PhysicsLite).termVel = 8;
			
			aniMachine = new AnimationStateMachine();
			componentList.push(new GraphicsComponent(this));
			getComponent(GraphicsComponent).spriteManager = aniMachine;
			
			_totalSpeed = 3;
			
			_alive = true;
			
			_stateTic = 0;
			// start moving by default
			
			actionState = new DummyIdle();
			
			setAnimations();
			actionState.enter(this);
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
				
				//trace("in dummy");
				
				
				tempState = null;
				tempState = actionState.handleInput(this);
				if (tempState != null)
				{
					actionState.exit(this);
					tempState.enter(this);
					actionState = tempState;
					
				}
				tempState = null;
				tempState = actionState.update(this);
				if (tempState != null)
				{
					actionState.exit(this);
					tempState.enter(this);
					actionState = tempState;
				}
				
				last.x = x;
				last.y = y;
				updateComponents();
				
				wasTouching = touching;
				touching = ExtraFunctions.NONE;
				
				aniMachine.updateAni();
			}
						
		}
		
		override public function resetMe():void{
			this._x = 200;
			this._y = 200;
		}		
		
		private function updateInputs():void{
			input.updateAI();
		}
		
		public function setAnimations():void{
			aniMachine.addVariables({damage:false});
			
			aniMachine._library.newFrame("idle1","dummy",0,0,13,31);
			aniMachine._library.newFrame("damage1","dummy",13,0,15,31,false,0,-4);
			
			
			var ani:BlitAnimation = new BlitAnimation("idle",aniMachine._library,true,8);
			ani.addFrame("idle1");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("idle", {damage:false});
			
			ani = new BlitAnimation("damage",aniMachine._library,true);
			ani.addFrame("damage1","idle1");
			aniMachine.animationList.push(ani);			
			aniMachine.addStateParams("damage", {damage:true});
			
			aniMachine.defaultAnimation = "idle";
			
			
		}
		
		override public function onShowMe():void{
			gc = getComponent(GraphicsComponent);
			gc._camera = _camera;
		}
			
		public function enterCollision():void
		{
			//trace(obj + " just touched " + this);
			if (!isHit)
			{
				isHit = true;
				getComponent(GraphicsComponent)._hFlip = (getComponent(HitBox).target.x > x)?-1:1;
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