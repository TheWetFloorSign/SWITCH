package _lib._gameObjects._player{
	
	import _blitEngine._gameObjects.BasicObject;
	import _lib._gameObjects._components.GraphicsComponent;
	import _lib._gameObjects._components.HitBox;
	import flash.display.BitmapData;
	import _blitEngine._blit.*;
	import _blitEngine.*;
	import _blitEngine.AnimationStateMachine;
	import _blitEngine._States.IState;
	import _lib._States._SWITCH.*;
	import _lib._gameObjects._components.PhysicsLite;
	
	public class SOG extends BasicObject{
        
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
		
		public var sprite:GraphicsComponent;
		
		private var debug:DebugBox = new DebugBox();
		
		public var moveState:IState;
		public var jumpState:IState;
		public var actionState:IState;
		
		private var tempState:IState;
		
		private var _hitBox:HitBox;
		
		public function SOG(){
			// initialization
			_xspeed = 1.5;
			
			type = "player";
			
			componentList.push(new HitBox(this,20, 20, 10, 20));
			_hitBox = getComponent(HitBox);
			
			componentList.push(new PhysicsLite(this));
			getComponent(PhysicsLite).drag = 1;
			getComponent(PhysicsLite).mass = 3;
			getComponent(PhysicsLite).termVel = 5;
			
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
				/*switch(moveState){
					case "walkLeft":
						_lastDir = "l";
						if(jumpState == "")aniMachine.addState("walk"+_lastDir,5);
						_vector.x -= _xspeed;
						if (touching & ExtraFunctions.LEFT) _vector.x = 0;
						if(Math.abs(_vector.x) > _totalSpeed) _vector.x = -_totalSpeed;
						if(!_left || actionState != ""){
							//aniMachine.popState();
							moveState = "";
						}
						break;
					
					case "walkRight":
						_lastDir = "r";
						if(jumpState == "")aniMachine.addState("walk"+_lastDir,5);
						_vector.x += _xspeed;
						if (touching & ExtraFunctions.RIGHT) _vector.x = 0;
						if(Math.abs(_vector.x) > _totalSpeed) _vector.x = _totalSpeed;
						if(!_right || actionState != ""){
							//aniMachine.popState();
							moveState = "";
						}
						break;
						
					case "dashLeft":
						_vector.x-=_xspeed;
						if(Math.abs(_vector.x) > _totalSpeed) _vector.x = -_totalSpeed;
						_lastDir = "l";
						break;
					
					case "dashRight":
						_vector.x+=_xspeed;
						if(Math.abs(_vector.x) > _totalSpeed) _vector.x = _totalSpeed;
						_lastDir = "r";
						break;
						
					/*case "crawlLeft":
						_vector.x-=_xIncrement/2;
						if(Math.abs(_vector.x) > _totalSpeed) _vector.x = -_totalSpeed;
						_lastDir = "l";
						aniMachine.addState(findAni("duck"+_lastDir));
						if(!_left){
							aniMachine.popState();
							moveState = "crouch";
						}
						if(!_down){
							aniMachine.popState();
							moveState = "walkLeft";
						}
						break;
					
					case "crawlRight":
					
						_vector.x+=_xIncrement/2;
						if(Math.abs(_vector.x) > _totalSpeed) _vector.x = _totalSpeed;
						_lastDir = "r";
						aniMachine.addState(findAni("duck"+_lastDir));
						if(!_right){
							aniMachine.popState();
							moveState = "crouch";
						}
						if(!_down){
							aniMachine.popState();
							moveState = "walkRight";
						}
						break;
						
					case "crouchr":
						if(jumpState == ""){
							//aniMachine.addState(findAni("duck"+_lastDir));
							if(_vector.x >0)_vector.x-=_xspeed;
							else if(_vector.x <0)_vector.x+=_xspeed;
							//if(_left)moveState = "crawlLeft";
							//if(_right)moveState = "crawlRight";
							
							if(!_down){
								moveState = "";
								
							}
						}
						
						break;
						
					case "crouchl":
						if(jumpState == ""){
							//aniMachine.addState(findAni("duck"+_lastDir));
							if(_vector.x >0)_vector.x--;
							else if(_vector.x <0)_vector.x++;
							//if(_left)moveState = "crawlLeft";
							//if(_right)moveState = "crawlRight";
							
							if(!_down){
								moveState = "";
							}
						}
						
						break;
					
					default:
						if(jumpState=="" && actionState =="")aniMachine.addState("idle"+_lastDir,7);
						if(_vector.x >0){
							_vector.x-=2;
							if(_vector.x<0) _vector.x = 0;
						}
						else if(_vector.x <0){
							_vector.x+=2;
							if(_vector.x>0) _vector.x = 0;
						}
						if(actionState == ""){
							if(_left){
							moveState = "walkLeft";
							facing = ExtraFunctions.LEFT;
							}
							if(_right){
								moveState = "walkRight";
								facing = ExtraFunctions.RIGHT;
							}
							/*if(_down){
								moveState = "crouch"+_lastDir;
							}
						}
						break;
				}
				switch(jumpState){
					case "jump":
						if(_vector.y > -8)_vector.y=-8;
						aniMachine.addState("jump"+_lastDir);
						if(_jumpTic >0) _jumpTic--;
						if(!_jump || _jumpTic == 0)jumpState = "fall";
						
						break;
					
					case "fall":
						if(_jump && _vector.y>4)_vector.y = 4;
						if(_down && _vector.y>12) _vector.y = 12;
						if(_vector.y >= 3 && actionState == "")aniMachine.addState("fall"+_lastDir);
						if(touching & ExtraFunctions.DOWN){
							jumpState = "land";
							_vector.y =0;
							_jumpTic = 36;
						}
						break;
						
					case "land":
						if(moveState =="" && actionState =="")aniMachine.addState("land"+_lastDir);
						_jumpTic --;
						if(moveState !="" || actionState !="" || _jumpTic == 0){
							jumpState = "";
							if(_jumpTic != 12)_jumpTic =12;
						}
						if(_jump && _canJump){
							jumpState = "jump";
							trace("land jump");
							_jumpTic =12;
							_canJump = false;
						}
						if(!_jump) _canJump = true;
						break;
						
					default:
						//trace(aniMachine.states);
						//aniMachine.addState(findAni("idle"+_lastDir));
						
						if(_jumpTic != 12)_jumpTic =12;
						if(_jump && _canJump){
							jumpState = "jump";
							trace("def Jump");
							_canJump = false;
						}else if(!(wasTouching & ExtraFunctions.DOWN) && !(touching & ExtraFunctions.DOWN)) jumpState = "fall";
						if(!_jump) _canJump = true;
						break;
				}
				
				
				
				switch(actionState){
					case "punch":
						if(!_punchCharge)aniMachine.addState("punch"+_lastDir,4);
						(_stateTic >0)? _stateTic--:_stateTic = 16;
						if( _stateTic == 0)actionState = "";
						break;
					
					/*case "kick":
						if(jumpState != ""){
							aniMachine.addState(findAni("airkick"+_lastDir));
						}else{
							aniMachine.addState(findAni("kick"+_lastDir));
						}
						(_stateTic >0)? _stateTic--:_stateTic = 16;
						if( _stateTic == 0)actionState = "";
						break;
						
					case "lean":
						aniMachine.addState(findAni("lean"+_lastDir));
						_stateTic = 16;
						actionState = "";
						break;
					
					default:
						if(_fire && _canAttack){
							actionState = "punch";
							_canAttack = false;
						}
						/*if(_kick && _canAttack){
							actionState = "kick";
							_canAttack = false;
						}
						if(_bomb)actionState = "lean";
						if(!_kick && !_fire) _canAttack = true;
						break;
				}*/
				
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
				
				aniMachine.updateAni();
			}
						
		}
		
		override public function resetMe():void{
			this._x = 200;
			this._y = -800;
		}		
		
		override public function onShowMe():void{
			gc = getComponent(GraphicsComponent);
			gc.camera = _camera;
			moveState = new Idle();
			jumpState = new Stand();
			
			setAnimations();
			moveState.enter(this);
			jumpState.enter(this);
		}
		
		private function updateInputs():void{
			((input.getActionValue("padUp") < -0.5 || input.isActionActivated("up")))? _jump = true : _jump = false;
			((input.getActionValue("padDown") > 0.5 || input.isActionActivated("down")))?_down = true:_down = false;
			((input.getActionValue("padLeft") < -0.5 || input.isActionActivated("left")))?_left = true:_left = false;
			((input.getActionValue("padRight") > 0.5 || input.isActionActivated("right")))?_right = true:_right = false;
			input.isActionActivated("action1")?_fire = true:_fire = false;
			input.isActionActivated("action3")?_bomb = true:_bomb = false;
			input.isActionActivated("action2")?_kick = true:_kick = false;
		}
		
		public function setAnimations():void{
			
			aniMachine.addVariables({ground:false, fall:false, walk:false, crouch:false});
			
			aniMachine._library.newFrame("idle1","SOG",415,0,26,47);
			aniMachine._library.newFrame("idle2","SOG",442,0,26,46);
			aniMachine._library.newFrame("idle3","SOG",469,0,26,45);
			aniMachine._library.newFrame("idle4","SOG",496,0,26,46);
			
			aniMachine._library.newFrame("jump1","SOG",429,57,36,43);
			aniMachine._library.newFrame("jump2","SOG",466,57,36,43);
			aniMachine._library.newFrame("jump3","SOG",503,57,36,43);
			aniMachine._library.newFrame("jump4","SOG",540,57,36,43);
			
			aniMachine._library.newFrame("fall1","SOG",523,0,36,56);
			aniMachine._library.newFrame("fall2","SOG",560,0,36,56);
			aniMachine._library.newFrame("fall3","SOG",597,0,36,56);
			aniMachine._library.newFrame("fall4","SOG",634,0,36,56);
			
			aniMachine._library.newFrame("punch1","SOG",577,57,35,42,true,0,-8,-1);
			aniMachine._library.newFrame("punch2","SOG",613,57,34,42,true,0,-4,-1);
			aniMachine._library.newFrame("punch3","SOG",648,57,57,37,true,0,-16,-1);
			aniMachine._library.newFrame("punch4","SOG",671,0,45,37,true,0,-11,-1);
			
			aniMachine._library.newFrame("run1","SOG",0,0,43,41);
			aniMachine._library.newFrame("run2","SOG",43,0,34,31);
			aniMachine._library.newFrame("run3","SOG",79,0,39,43);
			aniMachine._library.newFrame("run4","SOG",119,0,44,37,false,0,0,5);
			aniMachine._library.newFrame("run5","SOG",164,0,43,37,false,0,0,5);
			aniMachine._library.newFrame("run6","SOG",207,0,42,41);
			aniMachine._library.newFrame("run7","SOG",250,0,34,31);
			aniMachine._library.newFrame("run8","SOG",285,0,39,43);
			aniMachine._library.newFrame("run9","SOG",325,0,44,37,false,0,0,5);
			aniMachine._library.newFrame("run10","SOG",370,0,43,37,false,0,0,5);
			
			aniMachine._library.newFrame("land1","SOG",0,47,36,55);
			aniMachine._library.newFrame("land2","SOG",37,47,39,47,false,0,0,-1);
			aniMachine._library.newFrame("land3","SOG",77,47,43,38,false,0,0,-1);
			aniMachine._library.newFrame("land4","SOG",121,48,43,32,false,0,0,-1);
			aniMachine._library.newFrame("land5","SOG",165,48,43,33,false,0,0,-1);
			aniMachine._library.newFrame("land6","SOG",209,48,43,33,false,0,0,-1);
			aniMachine._library.newFrame("land7","SOG",253,48,43,33,false,0,0,-1);
			aniMachine._library.newFrame("land8","SOG",297,48,43,33,false,0,0,-1);
			aniMachine._library.newFrame("land9","SOG",341,48,43,33,false,0,0,-1);
			aniMachine._library.newFrame("land10","SOG",385,48,43,33,false,0,0,-1);
			
			var ani:BlitAnimation = new BlitAnimation("idle",aniMachine._library,true,12);
			ani.addFrame("idle1","idle2","idle3","idle4");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("idle", {ground:true, walk:false});
			
			ani = new BlitAnimation("jump",aniMachine._library,true);
			ani.addFrame("jump1","jump2","jump3","jump4");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("jump", {ground:false, fall:false});
			
			ani = new BlitAnimation("punch",aniMachine._library,false);
			ani.addFrame("punch1","punch2","punch3","punch4");
			aniMachine.animationList.push(ani);
			
			ani = new BlitAnimation("fall",aniMachine._library,true);
			ani.addFrame("fall1","fall2","fall3","fall4");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("fall", {ground:false, fall:true});
			
			ani = new BlitAnimation("land",aniMachine._library,false);
			ani.addFrame("land1","land2","land3","land4","land5","land6","land7","land8","land9","land10");
			aniMachine.animationList.push(ani);
			
			ani = new BlitAnimation("walk",aniMachine._library,true,8);
			ani.addFrame("run1","run2","run3","run4","run5","run6","run7","run8","run9","run10");
			aniMachine.animationList.push(ani);
			aniMachine.addStateParams("walk", {ground:true, walk:true});
			
			aniMachine.defaultAnimation = "idle";
		}
	}
}