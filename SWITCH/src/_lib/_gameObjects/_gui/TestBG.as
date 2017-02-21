package _lib._gameObjects._gui{
	
	import _blitEngine._gameObjects.BasicObject;
	import _lib._gameObjects._components.GraphicsComponent;
	import _lib._gameObjects._components.HitBox;
	import flash.display.Bitmap;
	import _blitEngine._blit.*;
	import _blitEngine.*;
	import _blitEngine.AnimationStateMachine;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class TestBG extends BasicObject{
        
		private var _canvas:Sprite;
		private var _bmdCanvas:BitmapData;
		private var _bmCanvas:Bitmap;
		public var sprite:GraphicsComponent;
		public var hitBox:HitBox;
		
		public function TestBG(){
			// initialization
			
			
			setAnimations();
			componentList.push(new GraphicsComponent(this));
			type = "bg";
		}
		//
		//--------------------------- GET/SET METHODS
		//
		
				
		//
		//--------------------------- PUBLIC METHODS 
		//	
		
		//
		//--------------------------- EVENT HANDLERS
		//
		override public function updateMe():void{
					
				this._x = this._x + _vector.x;
				this._y = this._y + _vector.y;
				//trace(getComponent(GraphicsComponent)._inView);
		}
		
		override public function resetMe():void{
			
		}	
		
		override public function onShowMe():void{
			sprite = getComponent(GraphicsComponent);
			sprite.zBuff = -1;
			sprite.sprite = _bmdCanvas;
			sprite.camera = _camera;
			sprite.scrollMod.x = 0.25;
			sprite.scrollMod.y = 0.25;
			
			x = sprite.width/2;
			y = 300;
		}
		
		public function setAnimations():void{
			_canvas = new Sprite();
			_bmdCanvas = new BitmapData(2000,2000);
			var i:int = 0;
			_canvas.graphics.lineStyle(2, 0x333399);
			_canvas.graphics.beginFill(0x3366cc);
			_canvas.graphics.drawRect(0,0,_bmdCanvas.width,_bmdCanvas.height);
			_canvas.graphics.endFill();
			while(i<41){
				_canvas.graphics.moveTo(0,i*50);
				_canvas.graphics.lineTo(_bmdCanvas.width,i*50);
				_canvas.graphics.moveTo(i*50,0);
				_canvas.graphics.lineTo(i*50,_bmdCanvas.height);
				//trace('looped');
				i++;
			}
			
			_bmdCanvas.draw(_canvas);
			
		}
	}
}