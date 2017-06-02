/**
 * ...
 * @author Ben
 */

define(['Jquery','Class','Assets'], function($,Class,Assets){
	var canvas,width,height,graphics,scale;
	var Display = Class.extend({
		init:function(_width,_height,_scale){
			width = _width;
			height = _height;
			scale = _scale
			createDisplay();
		}
	});
	
	function createDisplay(){
		var body = document.body;
		/*canvas = document.createElement("CANVAS");
		canvas.setAttribute("id", "canvas");
		body.appendChild(canvas);*/
		body.innerHTML = ("<canvas id='canvas' width='"+(width*scale)+"' height='"+(height*scale)+"'></canvas>");
		graphics = document.getElementById('canvas').getContext("2d");
		graphics.scale(scale,scale);
		graphics.webkitImageSmoothingEnabled = false;
		//graphics.mozImageSmoothingEnabled = false;
		graphics.imageSmoothingEnabled = false;
	}
	
	Display.prototype.getWidth = function(){
		return width;
	};
	
	Display.prototype.getHeight = function(){
		return height;
	};
	
	Display.prototype.getTitle = function(){
		return title;
	};
	
	Display.prototype.getGraphics = function(){
		return graphics;
	};
	
	CanvasRenderingContext2D.prototype.myDrawImage = function(asset,_x,_y,_width,_height){
		//console.log(_y + asset.offsetY);
		this.drawImage(Assets.getAssets(asset.sheet).sheet,Math.floor(asset.x),Math.floor(asset.y),_width,_height,_x + asset.offsetX,_y + asset.offsetY,_width,_height);
	}
	
	return Display;
});