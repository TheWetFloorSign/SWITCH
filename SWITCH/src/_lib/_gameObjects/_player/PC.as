package _lib._gameObjects._player{
	
	import _blitEngine._gameObjects.BasicObject;
	import _lib._gameObjects._components.GraphicsComponent;
	import _lib._gameObjects._components.HitBox;
	import flash.display.BitmapData;
	import _blitEngine._blit.*;
	import _blitEngine.*;
	import _blitEngine.AnimationStateMachine;
	import _blitEngine.DebugBox;
	import _blitEngine._States.IState;
	import _lib._States._SWITCH.*;
	import flash.events.Event;
	import _lib._gameObjects._components.PhysicsLite;
	
	public class PC extends BasicObject{
        
		public var _fire:Boolean;
		public var _bomb:Boolean;
		public var _kick:Boolean;
		public var _jump:Boolean;
		public var _dashLeft:Boolean;
		public var _dashRight:Boolean;
		public var dashRemaining:int =1;
		public var dashMax:int;
		public var jumpRemaining:int;
		public var jumpMax:int;
		
		public var gc:GraphicsComponent;
		
		private var debug:DebugBox = new DebugBox();
		
		public var moveState:IState;
		public var jumpState:IState;
		public var actionState:IState;
		
		private var tempState:IState;
		
		private var _hitBox:HitBox;
		
		
		public function PC(){
			// initialization
			_xspeed = 1.5;
			
			type = "player";
			
			componentList.push(new HitBox(this,20, 20, 10, 20));
			_hitBox = getComponent(HitBox);
			
			componentList.push(new PhysicsLite(this));
			getComponent(PhysicsLite).mass = 1;
			getComponent(PhysicsLite).drag = .1;
			
			componentList.push(new GraphicsComponent(this));
			
			aniMachine = new AnimationStateMachine();
			
			getComponent(GraphicsComponent).spriteManager = aniMachine;
			_totalSpeed = 4;
			
			_alive = true;
			
			
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
				
				tempState = null;
				tempState = moveState.handleInput(this);
				if (tempState != null)
				{
					moveState.exit(this);
					tempState.enter(this);
					moveState = tempState;
					
				}
				tempState = null;
				tempState = moveState.update(this);
				if (tempState != null)
				{
					moveState.exit(this);
					tempState.enter(this);
					moveState = tempState;
				}
				
				
				
				tempState = null;
				tempState = jumpState.handleInput(this);
				if (tempState != null)
				{
					jumpState.exit(this);
					tempState.enter(this);
					jumpState = tempState;
					
				}
				tempState = null;
				tempState = jumpState.update(this);
				if (tempState != null)
				{
					jumpState.exit(this);
					tempState.enter(this);
					jumpState = tempState;
				}
				
				
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
				_playerInfo.playerX = x + _hitBox.centerx;
				_playerInfo.playerY = y + _hitBox.centery;
				if(y >= 1000){
					y = -100;
					x = 300;
					last.x = x;
					last.y = y;
				}
				wasTouching = touching;
				touching = ExtraFunctions.NONE;
			}						
		}
		
		override public function resetMe():void{
			this._x = 200;
			this._y = 200;
		}		
		
		private function updateInputs():void{
			((input.getActionValue("padUp") < -0.5 || input.isActionActivated("up")))? _jump = true : _jump = false;
			((input.getActionValue("padDown") > 0.5 || input.isActionActivated("down")))?_down = true:_down = false;
			((input.getActionValue("padLeft") < -0.5 || input.isActionActivated("left")))?_left = true:_left = false;
			((input.getActionValue("padRight") > 0.5 || input.isActionActivated("right")))?_right = true:_right = false;
			input.isActionActivated("action1")?_fire = true:_fire = false;
			input.isActionActivated("action3")?_bomb = true:_bomb = false;
			input.isActionActivated("action2")?_kick = true:_kick = false;
			input.isActionActivated("action4")?_dashLeft = true:_dashLeft = false;
			input.isActionActivated("action5")?_dashRight = true:_dashRight = false;
			
		}
		
		override public function onShowMe():void{
			gc = getComponent(GraphicsComponent);
			gc.camera = _camera;
			gc.zBuff = 1;
			moveState = new Idle();
			jumpState = new Stand();
			actionState = new ActionIdle();
			
			setAnimations();
			moveState.enter(this);
			jumpState.enter(this);
		}
		
		//public function enterCollision(e:Event):void
		//{
			//var targ:BasicObject = getComponent(HitBox).target;
			//targ.getComponent(PhysicsLite).vector.x += sprite._hFlip * 6;
			//if(targ.y < y)targ.getComponent(PhysicsLite).vector.y += -4 + Math.min(getComponent(PhysicsLite).vector.y,0);
		//}
		//
		//public function continuedCollision(e:Event):void
		//{
			//var targ:BasicObject = getComponent(HitBox).target;
			//targ.getComponent(PhysicsLite).vector.x += _vector.x - targ.getComponent(PhysicsLite).vector.x + (ExtraFunctions.sign(sprite._hFlip) * 0.5);
			////targ._vector.y += -4;
		//}
		
		public function setAnimations():void{
			aniMachine.addVariables({ground:false, fall:false, dash:false, backdash:false, walk:false, crouch:false, action:false, kick:false});
			
			aniMachine._library.newFrame("idle1","SWITCH",0,2,26,24);
			aniMachine._library.newFrame("idle2","SWITCH",0,54,26,25);
			aniMachine._library.newFrame("idle3","SWITCH",27,54,26,25);
			aniMachine._library.newFrame("idle4", "SWITCH", 54, 55, 26, 24);
			
			aniMachine._library.newFrame("float1","SWITCH",130,0,15,29,false,0,0,1);
			aniMachine._library.newFrame("float2","SWITCH",130,0,15,29,false,0,0,2);
			aniMachine._library.newFrame("float3","SWITCH",130,0,15,29,false,0,0,3);
			
			aniMachine._library.newFrame("run1","SWITCH",2,112,37,24,false,0,0,4);
			aniMachine._library.newFrame("run2","SWITCH",40,112,31,27,false,0,-1,0);
			aniMachine._library.newFrame("run3","SWITCH",74,112,25,28,false,0,-4,0);
			aniMachine._library.newFrame("run4","SWITCH",100,111,24,30,false,0,-4,0);
			aniMachine._library.newFrame("run5","SWITCH",126,113,32,28,false,0,-1,2);
			aniMachine._library.newFrame("run6","SWITCH",2,144,36,24,false,0,0,4);
			aniMachine._library.newFrame("run7","SWITCH",40,144,31,27,false,0,-1,0);
			aniMachine._library.newFrame("run8", "SWITCH", 73, 144, 26, 28, false, 0, -4, 0);
			aniMachine._library.newFrame("run9","SWITCH",100,143,24,30,false,0,-5,0);
			aniMachine._library.newFrame("run10","SWITCH",126,145,32,28,false,0,-1,2);
			
			aniMachine._library.newFrame("fall","SWITCH",81,55,17,42);
			aniMachine._library.newFrame("punch1", "SWITCH", 27, 2, 33, 24, false, 0, -3.5);
			aniMachine._library.newFrame("punch2","SWITCH",124,58,25,38,false,0,0.5);
			aniMachine._library.newFrame("lean1","SWITCH",61,0,24,26,false,0,3);
			aniMachine._library.newFrame("jump1","SWITCH",86,0,21,34);
			//aniMachine._library.newFrame("kick1",_spriteSheet,0,27,35,26,false,0,-4);
			aniMachine._library.newFrame("kick1", "SWITCH", 104, 31, 49, 26, false, 0, 1);
			aniMachine._library.newFrame("kick2","SWITCH",98,58,25,33,false,0,15);
			aniMachine._library.newFrame("duck1","SWITCH",72,35,31,16);
			aniMachine._library.newFrame("dash1", "SWITCH", 36, 27, 36, 21);
			aniMachine._library.newFrame("backDash1","SWITCH",108,0,21,30);
			
			
			var ani:BlitAnimation = new BlitAnimation("idle",aniMachine._library,true,8);
			ani.addFrame("idle1","idle1","idle2","idle2","idle3","idle3");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("idle", {ground:true, walk:false, dash:false, backdash:false, action:false});
			
			ani = new BlitAnimation("float",aniMachine._library,true,8);
			ani.addFrame("float1","float2","float3","float2");
			aniMachine.animationList.push(ani);
			//aniMachine.addStateParams("float", {ground:true, walk:false, dash:false, backdash:false, action:false});
			
			ani = new BlitAnimation("walk",aniMachine._library,true,4);
			ani.addFrame("run10","run1","run2","run3","run4","run5","run6","run7","run8","run9");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("walk", {ground:true, walk:true, action:false});
			
			ani = new BlitAnimation("punch",aniMachine._library,false);
			ani.addFrame("punch2","punch2","punch2","punch2");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("punch", {action:true});
			
			ani = new BlitAnimation("lean",aniMachine._library,false);
			ani.addFrame("lean1");
			aniMachine.animationList.push(ani);
			
			ani = new BlitAnimation("jump",aniMachine._library,true);
			ani.addFrame("jump1");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("jump", {ground:false, fall:false, action:false, dash:false, backdash:false});
			
			ani = new BlitAnimation("fall",aniMachine._library,true);
			ani.addFrame("fall");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("fall", {ground:false, fall:true, action:false, dash:false, backdash:false});
			
			ani = new BlitAnimation("kick",aniMachine._library,false,12);
			ani.addFrame("kick2","kick1");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("kick", {action:true, kick:true});
			
			ani = new BlitAnimation("airkick",aniMachine._library,true);
			ani.addFrame("kick1");
			aniMachine.animationList.push(ani);
			
			ani = new BlitAnimation("duck",aniMachine._library,true);
			ani.addFrame("duck1");
			aniMachine.animationList.push(ani);
			
			ani = new BlitAnimation("dash",aniMachine._library,true);
			ani.addFrame("dash1");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("dash", {dash:true, walk:false, action:false});
			
			ani = new BlitAnimation("backDash",aniMachine._library,true);
			ani.addFrame("backDash1");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("backDash", {backdash:true,walk:false, action:false});
			
			aniMachine.defaultAnimation = "idle";			
		}
	}
}