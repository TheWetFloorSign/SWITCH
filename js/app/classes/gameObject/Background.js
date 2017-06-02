/**
 * ...
 * @author Ben
 */

define(['BasicObject',
		'GraphicsComponent',
		'Sprite',
		'SpriteLibrary',
		'AnimationStateMachine',
		'SpriteAnimation'], 
		function(BasicObject,
		GraphicsComponent,
		Sprite,
		SpriteLibrary,
		AnimationStateMachine,
		SpriteAnimation){
	
	var Player = BasicObject.extend({
		init:function(){
			this._super();
			this.createAnimations();
		}
	});
	
	Player.prototype.updateMe = function(_dt)
	{
		this.updateComponents(_dt);			
	}
	
	Player.prototype.createAnimations = function()
	{
		var gc = new GraphicsComponent(this);
		this.addComponent(gc);
		gc.sprite = new Sprite("bg",0,120,500,300);
	}
	
	return Player;
});