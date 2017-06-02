define(['Class'],function(Class){
	var StatePlayerJump = Class.extend({
		init:function(_actor){
			this.jumpTic = 10;
			this.actor = _actor;
			this.enter();
		}
		
	});
	
	StatePlayerJump.prototype.handleInput = function()
	{
		
	}
	
	StatePlayerJump.prototype.update = function(_dt)
	{
		this.jumpTic--;
		this.actor.y -= 390 *_dt;
		console.log(this.actor.keyManager.isActionActivated("up"));
		if (this.jumpTic <= 0 || !this.actor.keyManager.isActionActivated("up")) return "fall";		
		return "";
	}
	
	StatePlayerJump.prototype.enter = function()
	{
		this.jumpTic = 20;
		this.actor.getComponent("GraphicsComponent").spriteManager.changeVariables("ground", false);
	}
	
	StatePlayerJump.prototype.exit = function()
	{
	}
	
	return StatePlayerJump;
});