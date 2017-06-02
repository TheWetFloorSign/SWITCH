define(['Class'],function(Class){
	var StateManager = Class.extend({
		init:function(_actor){
			this.stateList = [];
			this.currentState = null;
			this.actor = _actor;
		}
		
	});
	
	StateManager.prototype.addState = function(_name, _state)
	{
		this.stateList[_name] = _state;
	}
	
	StateManager.prototype.update = function(_dt)
	{
		var stateName = this.currentState.update(_dt);
		if(stateName != "") this.changeState(stateName);
	}
	
	StateManager.prototype.changeState = function(_name)
	{
		console.log(_name);
		if(this.stateList[_name])
		{
			this.currentState = new this.stateList[_name](this.actor);
			this.currentState.enter();
		}else{
			console.log("State:"+_name + " doesn't exist in this state machine");
		}
		
	}
	
	return StateManager;
});