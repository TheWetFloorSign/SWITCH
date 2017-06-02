define(['Class','IBinding'],function(Class,IBinding)
{
	var BindingInfo = Class.extend({
		init:function(_action,_binding){
			this.action = _action;
			this.binding = [];
			this.binding.push(_binding);
			this.lastActivatedTime = 0;
		}
	});
	BindingInfo.prototype.addBinding = function(_binding)
	{
		this.binding.push(_binding);
	}
	
	BindingInfo.prototype.isActivated = function()
	{
		for (i = this.binding.length -1; i >=0; i--)
		{
			if (this.binding[i].isActive) return true;
		}
		return false;
	}
	
	BindingInfo.prototype.setKeyActive = function(_keyCode, _state, _time){
		for (i = this.binding.length -1; i >=0; i--)
		{
			if ((this.binding[i].keyCode && this.binding[i].keyCode == _keyCode) || _keyCode == -1)
			{
				this.binding[i].isActive = _state;
				if(_state)this.lastActivatedTime = _time;
			}
		}
	}
	
	BindingInfo.prototype.matchesKeyboardKey = function(_keyCode)
	{
		for(var i = this.binding.length -1;i>=0;i--)
		{
			if(this.binding[i].keyCode == _keyCode) return true;
		}
		return false;
	}
	
	return BindingInfo;
});