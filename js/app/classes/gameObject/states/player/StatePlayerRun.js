define(['Class'],function(Class){
	var StatePlayerRun = Class.extend({
		init:function(_actor){
			this.canDash = true;
			this.actor = _actor;
			this.enter();
		}
		
	});
	
	StatePlayerRun.prototype.handleInput = function()
	{
		
	}
	
	StatePlayerRun.prototype.update = function(_dt)
	{
		var left = this.actor.keyManager.isActionActivated("left");
		var right = this.actor.keyManager.isActionActivated("right");
		if(!left && !right)
			{
				return "idle";
			}
		if(left)
		{
			this.actor.x-= 240 *_dt;
			this.actor.getComponent("GraphicsComponent").spriteManager.changeVariables("left", true);
		}else{
			this.actor.x+= 240 *_dt;
			this.actor.getComponent("GraphicsComponent").spriteManager.changeVariables("left", false);
		}
		
		return "";
	}
	
	StatePlayerRun.prototype.enter = function()
	{
		this.actor.getComponent("GraphicsComponent").spriteManager.changeVariables("walk", true);
		var left = this.actor.keyManager.isActionActivated("left");
		var right = this.actor.keyManager.isActionActivated("right");
		
		if(left)
		{
			this.actor.getComponent("GraphicsComponent").spriteManager.changeVariables("left", true);
		}else{
			this.actor.getComponent("GraphicsComponent").spriteManager.changeVariables("left", false);
		}
	}
	
	StatePlayerRun.prototype.exit = function()
	{
	}
	
	return StatePlayerRun;
});