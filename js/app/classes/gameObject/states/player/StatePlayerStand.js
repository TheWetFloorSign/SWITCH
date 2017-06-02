define(['Class'],function(Class){
	var StatePlayerStand = Class.extend({
		init:function(_actor){
			this.actor = _actor;
			this.enter();
		}
		
	});
	
	StatePlayerStand.prototype.handleInput = function()
	{
		
	}
	
	StatePlayerStand.prototype.update = function(_dt)
	{
		var up = this.actor.keyManager.isActionActivated("up");
		if (up) return "jump";		
		return "";
	}
	
	StatePlayerStand.prototype.enter = function()
	{
		this.actor.getComponent("GraphicsComponent").spriteManager.changeVariables("ground", true);
		this.actor.getComponent("GraphicsComponent").spriteManager.changeVariables("fall", false);
	}
	
	StatePlayerStand.prototype.exit = function()
	{
	}
	
	return StatePlayerStand;
});