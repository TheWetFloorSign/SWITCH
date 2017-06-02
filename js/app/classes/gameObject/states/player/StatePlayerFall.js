define(['Class'],function(Class){
	var StatePlayerFall = Class.extend({
		init:function(_actor){
			this.fallTic = 10;
			this.actor = _actor;
			this.enter();
		}
		
	});
	
	StatePlayerFall.prototype.handleInput = function()
	{
		
	}
	
	StatePlayerFall.prototype.update = function(_dt)
	{
		this.fallTic--;
		this.actor.y += (13-this.fallTic) *40 * _dt;
		//this.actor.y += 390 *_dt;
		if (this.actor.y >100)
		{
			this.actor.y = 100;
			return "stand";	
		}			
		return "";
	}
	
	StatePlayerFall.prototype.enter = function()
	{
		this.fallTic = 15;
		this.actor.getComponent("GraphicsComponent").spriteManager.changeVariables("fall", true);
	}
	
	StatePlayerFall.prototype.exit = function()
	{
	}
	
	return StatePlayerFall;
});