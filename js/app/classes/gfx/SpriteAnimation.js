define(['Class'],function(Class){
	var SpriteAnimation = Class.extend({
		init:function(_name, _library,_loop, _frameDelay){
			this.name = _name;
			this.library = _library;
			if(_loop == undefined)
			{
				_loop = false;
			}
			this.loop = _loop;
			if(_frameDelay == undefined)
			{
				_frameDelay = 6;
			}
			this.frameDelay = _frameDelay;
			this.animationSet = [];
		}
		
	});
		
	SpriteAnimation.prototype.length = function(){
		return this.animationSet.length;
	}
	
	SpriteAnimation.prototype.addFrame = function(... frames){
		for(i = 0;i<frames.length;i++){
			this.animationSet.push(this.library.getSprite(frames[i]));
		}
		console.log(this.animationSet[0]);
	}
	
	return SpriteAnimation;
});