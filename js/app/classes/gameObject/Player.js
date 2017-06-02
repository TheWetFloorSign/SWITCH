/**
 * ...
 * @author Ben
 */

define(['BasicObject',
		'GraphicsComponent',
		'Sprite',
		'KeyManager',
		'SpriteLibrary',
		'AnimationStateMachine',
		'SpriteAnimation',
		'StatePlayerFall',
		'StatePlayerIdle',
		'StatePlayerJump',
		'StatePlayerRun',
		'StatePlayerStand',
		'StateManager'], 
		function(BasicObject,
		GraphicsComponent,
		Sprite,
		KeyManager,
		SpriteLibrary,
		AnimationStateMachine,
		SpriteAnimation,
		StatePlayerFall,
		StatePlayerIdle,
		StatePlayerJump,
		StatePlayerRun,
		StatePlayerStand,
		StateManager){
	
	var Player = BasicObject.extend({
		init:function(){
			this._super();
			this.keyManager = null;
			this.createAnimations();
			this.moveState = new StateManager(this);
			this.moveState.addState("idle",StatePlayerIdle);
			this.moveState.addState("run",StatePlayerRun);
			this.moveState.changeState("idle");
			
			this.jumpState = new StateManager(this);
			this.jumpState.addState("stand",StatePlayerStand);
			this.jumpState.addState("fall",StatePlayerFall);
			this.jumpState.addState("jump",StatePlayerJump);
			this.jumpState.changeState("stand");
		}
	});
	
	Player.prototype.updateMe = function(_dt)
	{
		this.updateComponents(_dt);
		
		this.moveState.update(_dt);
		this.jumpState.update(_dt);
			
	}
	
	Player.prototype.createAnimations = function()
	{
		var gc = new GraphicsComponent(this);
		this.addComponent(gc);
		var aniMachine = new AnimationStateMachine();
		aniMachine.addVariables({left:false, ground:true, fall:false, dash:false, backdash:false, walk:false, crouch:false, action:false, kick:false});
			
		aniMachine.library.addSprite("idle1",new Sprite("test",0,2,26,24,0,1));
		aniMachine.library.addSprite("idle2",new Sprite("test",0,54,26,25));
		aniMachine.library.addSprite("idle3",new Sprite("test",27,54,26,25));
		aniMachine.library.addSprite("idle4",new Sprite("test", 54, 55, 26, 24));
		
		aniMachine.library.addSprite("idle1l",new Sprite("test",290,2,26,24,0,1));
		aniMachine.library.addSprite("idle2l",new Sprite("test",290,54,26,25));
		aniMachine.library.addSprite("idle3l",new Sprite("test",263,54,26,25));
		aniMachine.library.addSprite("idle4l",new Sprite("test", 236, 55, 26, 24));
		
		aniMachine.library.addSprite("run1",new Sprite("test",2,112,37,24,-3,-4));
		aniMachine.library.addSprite("run2",new Sprite("test",40,112,31,27,0,-3));
		aniMachine.library.addSprite("run3",new Sprite("test",74,112,25,28,6,-4));
		aniMachine.library.addSprite("run4",new Sprite("test",100,111,24,30,7,-6));
		aniMachine.library.addSprite("run5",new Sprite("test",126,113,32,28,0,-5));
		aniMachine.library.addSprite("run6",new Sprite("test",2,144,36,24,-2,-4));
		aniMachine.library.addSprite("run7",new Sprite("test",40,144,31,27,0,-3));
		aniMachine.library.addSprite("run8",new Sprite("test",73,144,26,28,5,-4));
		aniMachine.library.addSprite("run9",new Sprite("test",100,143,24,30,7,-6));
		aniMachine.library.addSprite("run10",new Sprite("test",126,145,32,28,0,-5));
		
		aniMachine.library.addSprite("run1l",new Sprite("test",277,112,37,24,-9,-4));
		aniMachine.library.addSprite("run2l",new Sprite("test",245,112,31,27,-6,-3));
		aniMachine.library.addSprite("run3l",new Sprite("test",217,112,25,28,-6,-4));
		aniMachine.library.addSprite("run4l",new Sprite("test",192,111,24,30,-6,-6));
		aniMachine.library.addSprite("run5l",new Sprite("test",158,113,32,28,-6,-5));
		aniMachine.library.addSprite("run6l",new Sprite("test",278,144,36,24,-9,-4));
		aniMachine.library.addSprite("run7l",new Sprite("test",245,144,31,27,-6,-3));
		aniMachine.library.addSprite("run8l",new Sprite("test",217,144,26,28,-6,-4));
		aniMachine.library.addSprite("run9l",new Sprite("test",192,143,24,30,-6,-6));
		aniMachine.library.addSprite("run10l",new Sprite("test",158,145,32,28,-6,-5));
		
		aniMachine.library.addSprite("fall",new Sprite("test",81,55,17,42,0,-18));
		aniMachine.library.addSprite("falll",new Sprite("test",218,55,17,42,0,-18));
		
		aniMachine.library.addSprite("jump1",new Sprite("test",86,0,21,34,0,-10));
		aniMachine.library.addSprite("jump1l",new Sprite("test",209,0,21,34,0,-10));
			
		var ani = new SpriteAnimation("idle",aniMachine.library,true,8);
		ani.addFrame("idle1","idle1","idle2","idle2","idle3","idle3");
		aniMachine.addAnimation(ani);
		aniMachine.addStateParams("idle", {left:false,ground:true, walk:false, dash:false, backdash:false, action:false});
		
		ani = new SpriteAnimation("idleL",aniMachine.library,true,8);
		ani.addFrame("idle1l","idle1l","idle2l","idle2l","idle3l","idle3l");
		aniMachine.addAnimation(ani);
		aniMachine.addStateParams("idleL", {left:true,ground:true, walk:false, dash:false, backdash:false, action:false});
			
		ani = new SpriteAnimation("walk",aniMachine.library,true,2);
		ani.addFrame("run10","run1","run2","run3","run4","run5","run6","run7","run8","run9");
		aniMachine.addAnimation(ani);
		aniMachine.addStateParams("walk", {left:false,ground:true, walk:true, action:false});
		
		ani = new SpriteAnimation("walkL",aniMachine.library,true,2);
		ani.addFrame("run10l","run1l","run2l","run3l","run4l","run5l","run6l","run7l","run8l","run9l");
		aniMachine.addAnimation(ani);
		aniMachine.addStateParams("walkL", {left:true,ground:true, walk:true, action:false});
		
		ani = new SpriteAnimation("jump",aniMachine.library,true);
		ani.addFrame("jump1");
		aniMachine.addAnimation(ani);
		aniMachine.addStateParams("jump", {left:false,ground:false, fall:false, action:false, dash:false, backdash:false});
		
		ani = new SpriteAnimation("jumpL",aniMachine.library,true);
		ani.addFrame("jump1l");
		aniMachine.addAnimation(ani);
		aniMachine.addStateParams("jumpL", {left:true,ground:false, fall:false, action:false, dash:false, backdash:false});
		
		ani = new SpriteAnimation("fall",aniMachine.library,true);
		ani.addFrame("fall");
		aniMachine.addAnimation(ani);
		aniMachine.addStateParams("fall", {left:false,ground:false, fall:true, action:false, dash:false, backdash:false});
		
		ani = new SpriteAnimation("fallL",aniMachine.library,true);
		ani.addFrame("falll");
		aniMachine.addAnimation(ani);
		aniMachine.addStateParams("fallL", {left:true,ground:false, fall:true, action:false, dash:false, backdash:false});
		
		aniMachine.defaultAnimation("idle");
		gc.spriteManager = aniMachine;
		console.log(window);
	}
	
	return Player;
});