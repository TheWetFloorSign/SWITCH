package  _blitEngine{
	import _lib._gameObjects._components.GraphicsComponent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import _blitEngine._gameObjects.BasicObject;
	import flash.geom.Rectangle;
	
	public class BitCamera extends Bitmap{
		
		private var _width:int;
		private var _height:int;
		private var _zoom:int;
		
		private var edge:int;
		private var targetPos:int;
		private var tarHeight:int;
		private var tic:int;
		private var fadeColor:uint;
		private var fadeCallBack:Function;
		
		private var lowZ:int = 0;
		private var highZ:int = 0;
		
		private var gcList:Array;
		
		private var dirtyBMD:BitmapData;
		
		private var maxVal:int;
		
		private var _fadeOut:Boolean = false;
		private var _fadeIn:Boolean = false;
		
		private var movementBuffer:Number;
		
		public var scroll:Point;
		public var deadZone:Rectangle;
		public var cameraView:Rectangle;
		public var cameraBounds:Rectangle;
		public var levelBounds:Rectangle;		
		
		public var debugHB:Boolean = false;
		
		private var target:BasicObject;
		
		public var canvas:BitmapData;
		
		public var renderPoint:Point = new Point(0, 0);
		private var mx:Matrix = new Matrix();
		private var rec:Rectangle = new Rectangle();
		
		private var r_inView:Boolean;
		private var r_x:int;
		private var r_y:int;
		private var r_width:int;
		private var r_height:int;
		private var mod:BitPoint;
			
		private var clampx:Boolean;
		private var clampy:Boolean;
		
		public function BitCamera(width:int = 800,height:int = 600, zoom:Number = 1) {
			// constructor code
			_width = width/zoom;
			_height = height/zoom;
			_zoom = zoom;
			
			ExtraFunctions._stage.addChild(this);
			
			gcList = new Array();
			
			canvas = new BitmapData(_width, _height, false, 0x000000);
			dirtyBMD = new BitmapData(_width, _height, false, 0x00ff00);
			this.scaleX = this.scaleY = zoom;
			this.bitmapData = canvas;
			scroll = new Point(0,0);
			movementBuffer = 0;
			cameraView = new Rectangle(scroll.x,scroll.y,_width,_height);
			var w:Number = _width/8;
			var h:Number = _height/6;
			deadZone = new Rectangle(Math.round((_width-w)/2),Math.round((_height-(3*h))),Math.round(w),Math.round(h));
			
			cameraBounds = new Rectangle(0,-200,552,500);
			levelBounds = new Rectangle(cameraBounds.x,cameraBounds.y,cameraBounds.width+_width,cameraBounds.height+_height);
			//trace(levelBounds.width);
			//deadZone = new Rectangle(_width/2,_height/2,0,0);
		}
		
		public function addDraw(gc:GraphicsComponent):void
		{
			for (var i:int = gcList.length - 1; i >= 0; i--)
			{
				if (gc == gcList[i])
				{
					return;
				}
			}
			gcList.push(gc);
			if (gc.zBuff < lowZ)
			{
				lowZ = gc.zBuff;
			}
			
			if (gc.zBuff > highZ)
			{
				highZ = gc.zBuff;
			}
		}
		
		public function removeDraw(gc:GraphicsComponent):void
		{
			for (var i:int = gcList.length - 1; i >= 0; i--)
			{
				if (gc == gcList[i])
				{
					gcList.splice(i, 1);
					return;
				}
			}
		}
		
		public function updateBounds(rec:Rectangle):void{
			cameraBounds = new Rectangle(rec.x,rec.y,rec.width - _width,rec.height - _height);
			levelBounds = new Rectangle(cameraBounds.x,cameraBounds.y,cameraBounds.width+_width,cameraBounds.height+_height);
		}
		
		public function fadeOut(time:int, color:uint = 0x000000, fadeCB:Function = null):void
		{
			tic = time;
			fadeColor = color;
			fadeCallBack = fadeCB;
			maxVal = time;
			_fadeOut = true;
		}
		
		public function fadeIn(time:int, color:uint = 0x000000, fadeCB:Function = null):void
		{
			tic = time;
			fadeColor = color;
			fadeCallBack = fadeCB;
			maxVal = time;
			_fadeIn = true;
		}
		
		public function update():void{
			this.bitmapData.lock();
			canvas.copyPixels(dirtyBMD, dirtyBMD.rect, new Point());
			//canvas.fillRect(canvas.rect, 0x00ff00);
			if(target != null){
				
				var offset:int = (target.facing & ExtraFunctions.RIGHT)?-1:1;
				offset = 0;
				
				/** if the left 'edge' of the camera is less than it's current edge (scroll.x),
					scroll.x gets reduced to edge
					*/
				edge = target.x - deadZone.x - (40 * offset);
				
				if(scroll.x > edge){
					scroll.x = edge;
				}
				edge = target.x - deadZone.width - deadZone.x - (40 * offset);
				if(scroll.x < edge){
					scroll.x = edge;
				}
				edge = target.y - deadZone.y;
				if(scroll.y > edge){
					scroll.y = edge;
				}
				edge = target.y - deadZone.height - deadZone.y;
				
				if(scroll.y < edge){
					scroll.y = edge;
				}
				
				/*if(edge != target.y){
					(target.y > edge)? scroll.y-=3: scroll.y+=3;
				}*/
				//scroll.x += movementBuffer;
				if(scroll.x <cameraBounds.x) scroll.x = cameraBounds.x;
				if(scroll.x >cameraBounds.width) scroll.x = cameraBounds.width;
				if(scroll.y <cameraBounds.y) scroll.y = cameraBounds.y;
				if(scroll.y >cameraBounds.height) scroll.y = cameraBounds.height;
				cameraView = new Rectangle(scroll.x as int,scroll.y as int,_width,_height);
			}
			var z:int = lowZ;
			while (z <= highZ)
			{
				for (var i:int = gcList.length - 1; i >= 0; i--)
				{
					if (gcList[i].zBuff == z)
					{
						render(gcList[i]);
					}
					//trace("here");
				}
				z++;
			}
			updateEffects();
			this.bitmapData.unlock();
			
			
		}
		
		private function render(gc:GraphicsComponent):void{
			r_inView = true;
			r_x = gc.parent.x;
			r_y = gc.parent.y;
			r_width = gc.width;
			r_height = gc.height;
			mod = gc.scrollMod;
			
			clampx = gc.clampX;
			clampy = gc.clampY;
			
			if (r_x - r_width > (cameraView.x * mod.x) + cameraView.width ||
			r_x + r_width < (cameraView.x * mod.x) ||
			r_y - r_height > (cameraView.y * mod.y) + cameraView.height ||
			r_y < (cameraView.y * mod.y)) r_inView = false;
			if (clampx && clampy) r_inView = true;
			
			if (r_inView)
			{
				renderPoint.x = (clampx)?r_x:((r_x - (r_width / 2) - (gc.xOff * gc._hFlip)) - (scroll.x * mod.x));
				renderPoint.y = (clampy)?r_y:((r_y - r_height - (gc.yOff * gc._vFlip)) - (scroll.y * mod.y));
				rec.setTo(0, 0, r_width, r_height);
				//trace(renderPoint);
				r_x = renderPoint.x;
				r_y = renderPoint.y;
				renderPoint.x = r_x;
				renderPoint.y = r_y;
				canvas.copyPixels(gc.currentDisplay, rec, renderPoint, null, null, true);
				/*if (_camera.debugHB)
				{
					renderPoint.x = renderPoint.y = 0;
					actHB = actor.getComponent(HitBox);
					if (actHB == null) return;
					renderPoint.x = (actor.x + actHB.left) - (_camera.scroll.x * scrollMod.x);
					renderPoint.y = (actor.y + actHB.top) - (_camera.scroll.y * scrollMod.x);
					debug = new BitmapData(actHB.size.x, actHB.size.y, true, 0xFFAA0000);
					debug.fillRect(new Rectangle(1, 1, debug.width - 2, debug.height - 2), 0x00000000);
					_camera.canvas.copyPixels(debug, debug.rect, renderPoint, null, null, true);
				}*/
			}			
			
		}
		
		public function updateEffects():void
		{
			if (_fadeOut)
			{
				var fill:BitmapData = new BitmapData(this._width, this._height, true, rgbaConcat(0x000000,((maxVal-tic)/maxVal)));
				canvas.copyPixels(fill, fill.rect, new Point(0, 0), null, null, true);
				tic--;
				if (tic <= 0)
				{
					fadeCallBack();
					_fadeOut = false;
				}
			}else if (_fadeIn)
			{
				var fill:BitmapData = new BitmapData(this._width, this._height, true, rgbaConcat(0x000000,(tic/maxVal)));
				canvas.copyPixels(fill, fill.rect, new Point(0, 0), null, null, true);
				tic--;
				if (tic <= 0) _fadeIn = false;
			}
		}
		
		
		private function rgbaConcat(hexStr:uint,alpha:Number):uint{
			var a:uint = ((alpha) * 255);
			trace(alpha);
			return (a << 24 | hexStr);
		}
		public function follow(target:BasicObject):void{
			this.target = target;
		}

	}
	
}
