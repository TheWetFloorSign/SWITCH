package  _lib._gameObjects._components
{
	import _blitEngine.AnimationStateMachine;
	import _blitEngine.BitPoint;
	import _blitEngine.BitCamera;
	import _blitEngine._blit.BlitSprite;
	import _blitEngine._gameObjects._components.IComponent;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class GraphicsComponent implements IComponent
	{
		public var _inView:Boolean;
		
		public var _vFlip:int = 1;
		public var _hFlip:int = 1;
		
		private var mx:Matrix = new Matrix();
		private var rec:Rectangle = new Rectangle();
		
		public var renderPoint:Point = new Point(0,0);
		
		public var scrollMod:BitPoint = new BitPoint(1,1);
		
		public var _camera:BitCamera;
		
		public var spriteManager:AnimationStateMachine;
		public var sprite:BitmapData;
		
		public var clampY:Boolean = false;
		public var clampX:Boolean = false;
		private var actHB:HitBox
		private var debug:BitmapData
		
		private var actor:*;
		
		public function GraphicsComponent(_actor:*):void
		{
			actor = _actor;
		}
		
		public function get currentDisplay(): BitmapData
		{
			if (spriteManager) return spriteManager.aniFrame.sprite;
			if (sprite == null) sprite =  new BitmapData(10, 10, true, 0x00000000);
			return sprite;
		}
		
		public function get width():int
		{
			if (spriteManager) return spriteManager.aniFrame.width;
			if (sprite == null) return 10;
			return sprite.width;
		}
		
		public function get height():int
		{
			if (spriteManager) return spriteManager.aniFrame.height;
			if (sprite == null) return 10;
			return sprite.height;
		}
		
		public function get xOff():Number
		{
			if (spriteManager) return spriteManager.aniFrame.xOff;
			return 0;
		}
		
		public function get yOff():Number
		{
			if (spriteManager) return spriteManager.aniFrame.yOff;
			return 0;
		}
		
		public function render():void{
			if (_camera != null)
			{
				_inView = true;
				if (actor.x - width > (_camera.cameraView.x * scrollMod.x) + _camera.cameraView.width ||
				actor.x + width < (_camera.cameraView.x * scrollMod.x) ||
				actor.y - height > (_camera.cameraView.y * scrollMod.y) + _camera.cameraView.height ||
				actor.y < (_camera.cameraView.y * scrollMod.y)) _inView = false;
				if (clampX && clampY) _inView = true;
				
				if (_inView)
				{
					renderPoint.x = (clampX)?actor.x:int((actor.x - (width / 2) - (xOff * _hFlip)) - (_camera.scroll.x * scrollMod.x));
					renderPoint.y = (clampY)?actor.y:int((actor.y - height - (yOff * _vFlip)) - (_camera.scroll.y * scrollMod.y));
					rec.setTo(0, 0, width, height);
					_camera.canvas.copyPixels(renderFlip(currentDisplay), rec, renderPoint, null, null, true);
					if (_camera.debugHB)
					{
						renderPoint.x = renderPoint.y = 0;
						actHB = actor.getComponent(HitBox);
						if (actHB == null) return;
						renderPoint.x = (actor.x + actHB.left) - (_camera.scroll.x * scrollMod.x);
						renderPoint.y = (actor.y + actHB.top) - (_camera.scroll.y * scrollMod.x);
						debug = new BitmapData(actHB.size.x, actHB.size.y, true, 0xFFAA0000);
						debug.fillRect(new Rectangle(1, 1, debug.width - 2, debug.height - 2), 0x00000000);
						_camera.canvas.copyPixels(debug, debug.rect, renderPoint, null, null, true);
					}
				}
			}
			
		}
		
		private function renderFlip(_sprite:BitmapData):BitmapData
		{
			if (_hFlip < 0 || _vFlip < 0)
			{
				var newSprite:BitmapData = new BitmapData(_sprite.width, _sprite.height, true, 0x00ffffff);
				mx.identity();
				mx.scale(_hFlip, _vFlip);
				mx.translate((_hFlip < 0)?width:0, (_vFlip < 0)?height:0);
				newSprite.draw(_sprite, mx);
				return newSprite;
			}
			return _sprite;
		}
		
		
		
		public function update():void
		{
			if(spriteManager)spriteManager.updateAni();
		}
	}
	
}