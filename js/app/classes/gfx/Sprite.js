define(['Class'],function(Class){
	var Sprite = Class.extend({
		init:function(_sheet,_x,_y,_width,_height,_offsetX,_offsetY){
			this.sheet = _sheet;
			this.x = _x;
			this.y = _y;
			this.width = _width;
			this.height = _height;
			if(_offsetX == undefined)
			{
				_offsetX = 0;
			}
			
			if(_offsetY == undefined)
			{
				_offsetY = 0;
			}
			this.offsetX = _offsetX;
			this.offsetY = _offsetY;
		}
		
	});
	
	return Sprite;
});