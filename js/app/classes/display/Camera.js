/**
 * ...
 * @author Ben
 */

define(['Class','Display'], function(Class,Display){
	
	var Camera = Class.extend({
		init:function(_width,_height,_scale,_display){
			this._width = _width;
			this._height = _height;
			this._scale = _scale;
			this._gcList = [];
			if(_display == undefined)
			{
				_display = new Display(_width,_height,_scale);
			}
			this._graphics = _display.getGraphics();
			this.deadZone = {x:(_width/2)-_width/4,
							y:_height/8,
							width:_width/4,
							height:(_height/8)*5};
			this.cameraView = {x:0,y:0,width:_width,height:_height};
			this.scroll = {x:0,y:0};
		}
	});
	
	Camera.prototype.getWidth = function(){
		return this._width;
	};
	
	Camera.prototype.getHeight = function(){
		return this._height;
	};
	
	Camera.prototype.getGraphics = function(){
		return this._graphics;
	};
	
	Camera.prototype.addDraw = function(gc)
	{
		console.log(this);
		for (var i = this._gcList.length - 1; i >= 0; i--)
		{
			if (gc == this._gcList[i])
			{
				return;
			}
		}
		this._gcList.push(gc);
	}
		
	Camera.prototype.removeDraw = function(gc)
	{
		for (var i = this._gcList.length - 1; i >= 0; i--)
		{
			if (gc == this._gcList[i])
			{
				this._gcList.splice(i, 1);
				return;
			}
		}
	}
	
	Camera.prototype.follow = function(target){
		this.target = target;
	}
	
	Camera.prototype.update = function()
	{
		this._graphics.clearRect(0,0,this._width,this._height);
		if(this.target != null){
				
			//var offset = (target.facing & ExtraFunctions.RIGHT)?-1:1;
			var offset = 0;
			
			/** if the left 'edge' of the camera is less than it's current edge (scroll.x),
				scroll.x gets reduced to edge
				*/
			var edge = this.target.x - this.deadZone.x - (40 * offset);
			
			if(this.scroll.x > edge){
				this.scroll.x = edge;
			}
			edge = this.target.x - this.deadZone.width - this.deadZone.x - (40 * offset);
			if(this.scroll.x < edge){
				this.scroll.x = edge;
			}
			edge = this.target.y - this.deadZone.y;
			if(this.scroll.y > edge){
				this.scroll.y = edge;
			}
			edge = this.target.y - this.deadZone.height - this.deadZone.y;
			
			if(this.scroll.y < edge){
				this.scroll.y = edge;
			}
			
			/*if(edge != target.y){
				(target.y > edge)? scroll.y-=3: scroll.y+=3;
			}*/
			//scroll.x += movementBuffer;
			/*if(this.scroll.x <cameraBounds.x) scroll.x = cameraBounds.x;
			if(this.scroll.x >cameraBounds.width) scroll.x = cameraBounds.width;
			if(this.scroll.y <cameraBounds.y) scroll.y = cameraBounds.y;
			if(this.scroll.y >cameraBounds.height) scroll.y = cameraBounds.height;*/
			this.cameraView.x = this.scroll.x;
			this.cameraView.y = this.scroll.y;
		}
		for(var i = this._gcList.length -1;i>=0;i--)
		{
			this.render(this._gcList[i]);
		}
	}
	
	Camera.prototype.render = function(gc){
		this._graphics.myDrawImage(gc.currentDisplay(),gc.parent.x - this.cameraView.x,gc.parent.y- this.cameraView.y,gc.width(),gc.height());
	};
	
	return Camera;
});