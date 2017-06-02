/**
 * ...
 * @author Ben
 */

define(['Class','Camera'], function(Class,Camera){
	
	var GraphicsComponent = Class.extend({
		init:function(actor,camera){
			this.id = "GraphicsComponent";
			this._alive = true;
			this._exists = true;
				
			this._vFlip = 1;
			this._hFlip = 1;
			
			this.debug = false;
				
			this.renderPoint = {x:0,y:0};
				
			this.scrollMod = {x:0,y:0};
				
			this._camera;
				
			this.spriteManager;
			this.sprite;
				
			this.zBuff = 0;
				
			this.parent = actor;
			if(camera != undefined)
			{
				camera.addDraw(this);
				this._camera = camera;
			}
		}
	});
	
	GraphicsComponent.prototype.currentDisplay = function()
	{
		if (this.spriteManager != undefined)
		{
			//console.log(this.spriteManager.aniFrame());
			return this.spriteManager.aniFrame();
			
			//return (this._hFlip != 1 || this._vFlip != 1)? this.renderFlip(this.spriteManager.sprite): this.spriteManager.sprite;
		}
		if (this.sprite == null) sprite =  new Image(10,10);
		return this.sprite;
	}
	
	GraphicsComponent.prototype.sheet = function()
	{
		console.log(this.sprite);
		return this.sprite.sheet;
	}
	
	GraphicsComponent.prototype.width = function()
	{
		if (this.spriteManager) return this.spriteManager.aniFrame().width;
		if (this.sprite == null) return 10;
		return this.sprite.width;
	}
	
	GraphicsComponent.prototype.height = function()
	{
		if (this.spriteManager) return this.spriteManager.aniFrame().height;
		if (this.sprite == null) return 10;
		return this.sprite.height;
	}
	
	GraphicsComponent.prototype.xOff = function()
	{
		if (this.spriteManager) return this.spriteManager.aniFrame.xOff;
		return 0;
	}
	
	GraphicsComponent.prototype.yOff = function()
	{
		if (this.spriteManager) return this.spriteManager.aniFrame.yOff;
		return 0;
	}
	
	GraphicsComponent.prototype.camera = function(cam)
	{
		this._camera = cam;
		cam.addDraw(this);
	}
	
	GraphicsComponent.prototype.renderFlip = function(_sprite)
	{
		/*var newSprite:BitmapData = new BitmapData(_sprite.width, _sprite.height, true, 0x00ffffff);
			mx.identity();
			mx.scale(_hFlip, _vFlip);
			mx.translate((_hFlip < 0)?width:0, (_vFlip < 0)?height:0);
			newSprite.draw(_sprite, mx);
			return newSprite;*/
	}
	
	
	GraphicsComponent.prototype.update = function(_dt)
	{
		if(this.spriteManager)this.spriteManager.updateAni(_dt);
	}
	
	GraphicsComponent.prototype.kill = function()
	{
		if (this._camera) this._camera.removeDraw(this);
	}
	
	return GraphicsComponent;
});