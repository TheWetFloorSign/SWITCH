/**
 * ...
 * @author Ben
 */

define(['Class','Display'], function(Class,Display){

	var BasicObject = Class.extend({
		init:function(){
			
			this._camera, this._scene, this._alive, this._exists, this._immovable, this._touching, this._wasTouching, this._last, this.x = 0, this.y = 0, this._yspeed, this._xspeed, this._input, this._aniMachine, this._left, this._right, this._up, this._down, this._vector, this._type, this._totalSpeed;
			
			this._componentList = [];
			this._alive = true;
			this._exists = true;
			this.name = "name";
			console.log(this.name);
		}
	});
	
	BasicObject.prototype.killMe = function()
	{
		this._scene.removeGameOb(this);	
		removeComponents();
		this._alive = false;
		this._exists = false;
		resetMe();
	}
	
	BasicObject.prototype.reviveMe = function()
	{
		this._alive = true;
		this._exists = true;
	}
	
	BasicObject.prototype.addComponent = function(comp)
	{
		this._componentList.push(comp);
	}
	
	BasicObject.prototype.getComponent = function(comp)
	{
		//if (this._scene != null)this._scene.incre++;
		for (var i = this._componentList.length -1; i >= 0; i--)
		{
			if (this._componentList[i].id == comp)
			{
				return this._componentList[i];
			}
		}
		return null;
	}
	
	BasicObject.prototype.getComponents = function(comp)
	{
		var compArray = [];
		for (var i = this._componentList.length -1; i >= 0; i--)
		{
			if (this._componentList[i].id == comp)
			{
				compArray.push(this._componentList[i]);
			}
		}
		if (compArray.length > 0) return compArray;
		return null;
	}
	
	BasicObject.prototype.updateComponents = function(_dt)
	{
		
		for (var i = this._componentList.length -1; i >= 0; i--)
		{
			this._componentList[i].update(_dt);
		}
	}
	
	BasicObject.prototype.removeComponents = function()
	{
		
		for (var i = this._componentList.length -1; i >= 0; i--)
		{
			this._componentList[i].kill();
			this._componentList.splice(i, 1);
		}
	}
	
	BasicObject.prototype.resetMe = function(){}
	
	BasicObject.prototype.showMe = function(scene, playerInfo)
	{
		_camera = scene.camera;
		_scene = scene;
		_scene.addGameOb(this);		
		
		if(playerInfo != undefined){
			_playerInfo = playerInfo;
		}	
		resetMe();
		onShowMe();
	}
	
	BasicObject.prototype.onShowMe = function(){}
	
	BasicObject.prototype.updateMe = function(_dt){}
	
	return BasicObject;
});