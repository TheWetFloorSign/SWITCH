package  _lib._gameObjects._other{
	
	import _blitEngine._gameObjects.BasicObject;
	import _lib._gameObjects._components.GraphicsComponent;
	import _lib._gameObjects._components.HitBox;
	import _lib._gameObjects._components.PhysicsLite;
	import flash.geom.Rectangle;
	
	import _blitEngine._blit.BlitAnimation;
	import _blitEngine._blit.FrameLibrary;
	import _blitEngine.*;
	import flash.display.BitmapData;
	import _blitEngine.AnimationStateMachine;
	import flash.geom.Point;
	import _blitEngine.ExtraFunctions;
	
	public class Tile extends BasicObject{
		
		private var _slope:Array =[];
		private var _slopePosition:String = "";
		public var allowCollision:uint = 0x0000;
		public var sprite:GraphicsComponent;
		
		private var hitBox1:HitBox;
		private var hitBox2:HitBox;
		
		private var target:BasicObject;
		
		//------------------------------constructor-------------------------------------------
		
		public function Tile() {
		// Define basic stats for new generic object: _tic(a counter) set to zero, lives forever, 
		// base points, dies on hit, only moves down, and basic audio.
			aniMachine = new AnimationStateMachine();
			
		//	getComponent(HitBox).addEventListener(HitBox.COL_END, collisionResolution);
			componentList.push(new GraphicsComponent(this));
			type = "tile";
		}
		
		//------------------------------Gets and Sets-------------------------------------------
		public function get slope():Array{
			return _slope;
		}
		
		public function set slope(a:Array):void{
			_slope = a;
		}
		
		public function get slopePosition():String{
			return _slopePosition;
		}
		
		public function set slopePosition(a:String):void{
			_slopePosition = a;
		}
		
		//------------------------------Methods-------------------------------------------
		
		override public function updateMe():void{
			aniMachine.updateAni();
		}
		
		public function loadAnimation(frames:Array):void{
			var frameNum:int = 0;
			for each(var foo:* in frames){
				aniMachine._library.newFrame("tile"+(frameNum+1),"tileSheet",frames[frameNum].framePosition[0],frames[frameNum].framePosition[1],frames[frameNum].frameSize[0],frames[frameNum].frameSize[1],frames[frameNum].flip);
				
				frameNum++;
			}
			var ani:BlitAnimation = new BlitAnimation("tile",aniMachine._library,true);
			var counter:int = 1;
			while(counter <= frameNum){
				ani.addFrame("tile"+counter);
				//trace(counter + "  is frame num");
				counter++;
			}
			aniMachine.animationList.push(ani);
			aniMachine.defaultAnimation = "tile";
			
		}
		
		public function addHitBox(w:Number, h:Number):void
		{
			//trace("in add");
			componentList.push(new HitBox(this,24, 24, 12, 24));
			getComponent(HitBox).collision1 = collisionResolution;
			getComponent(HitBox).collision2 = collisionResolution;			
		}
		
		override public function onShowMe():void
		{
			gc = getComponent(GraphicsComponent);
			gc.spriteManager = aniMachine;
			gc.camera = _scene.camera;
		}
		
		public function collisionResolution():void
		{
			hitBox2 = getComponent(HitBox);
			target = hitBox2.target;
			hitBox1 = target.getComponent(HitBox);
			collisionResolutionX(target);
			collisionResolutionY(target);
			
		}
		
		public function collisionResolutionX(obj:BasicObject):void {
			var overlap:Number = 0;
			
			if (slopePosition) return;
			
			var ob1Delta:Number = obj.x - obj.last.x;
			var ob2Delta:Number = x - last.x;
			if (ob1Delta != ob2Delta)
			{
				var ob1DeltaAbs:Number = (ob1Delta > 0)?ob1Delta: -ob1Delta;
				var ob2DeltaAbs:Number = (ob2Delta > 0)?ob2Delta: -ob2Delta;
				var ob1Rect:Rectangle = new Rectangle(obj.x + hitBox1.left - ((ob1Delta > 0)?ob1Delta:0),
														obj.last.y + hitBox1.lastTop,
														hitBox1.size.x + ((ob1Delta > 0)?ob1Delta: -ob1Delta),
														hitBox1.lastSize.y);
														
				var ob2Rect:Rectangle = new Rectangle(x + hitBox2.left - ((ob2Delta > 0)?ob2Delta:0),
														last.y + hitBox2.lastTop,
														hitBox2.size.x + ((ob2Delta > 0)?ob2Delta: -ob2Delta),
														hitBox2.lastSize.y);
														
				if ((ob1Rect.x + ob1Rect.width > ob2Rect.x) && (ob1Rect.x < ob2Rect.x + ob2Rect.width) && (ob1Rect.y + ob1Rect.height > ob2Rect.y) && (ob1Rect.y < ob2Rect.y + ob2Rect.height))
				{
					var maxOverlap:Number = ob1DeltaAbs + ob2DeltaAbs + 4;
					if (ob1Delta > ob2Delta)
					{
						overlap = (ob1Rect.x + ob1Rect.width) - (ob2Rect.x);
						if (overlap<=maxOverlap && allowCollision & ExtraFunctions.LEFT && (obj.last.x + hitBox1.lastCenterx < last.x + hitBox2.lastCenterx))
						{
							obj.touching |=  ExtraFunctions.RIGHT;
						}else
						{
							overlap = 0;
						}
					}
					else if (ob1Delta < ob2Delta)
					{
						overlap = (ob1Rect.x) -(ob2Rect.x + ob2Rect.width);
						if (overlap<=maxOverlap && allowCollision & ExtraFunctions.RIGHT && (obj.last.x + hitBox1.lastCenterx > last.x + hitBox2.lastCenterx))
						{
							obj.touching |=  ExtraFunctions.LEFT;
						}else
						{
							overlap = 0;
						}
					}
				}
				
				obj.x -= overlap;
			}
			
		}
		
		public function collisionResolutionY(obj:BasicObject):void {
			var overlap:Number = 0;
			
			if (slopePosition){
				slopeFormY(obj);
				return;
			}
			
			var ob1Delta:Number = obj.y - obj.last.y;
			var ob2Delta:Number = y - last.y;
			
			if (ob1Delta != ob2Delta)
			{
				var ob1DeltaAbs:Number = (ob1Delta > 0)?ob1Delta: -ob1Delta;
				var ob2DeltaAbs:Number = (ob2Delta > 0)?ob2Delta: -ob2Delta;
				var ob1Rect:Rectangle = new Rectangle(obj.x + hitBox1.left, 
														obj.y + Math.min(hitBox1.top,hitBox1.lastTop) - ((ob1Delta > 0)?ob1Delta:0), 
														hitBox1.size.x , 
														Math.max(hitBox1.size.y,hitBox1.lastSize.y) + ((ob1Delta > 0)?ob1Delta: -ob1Delta));
														
				var ob2Rect:Rectangle = new Rectangle(x + hitBox2.left,
														y + Math.min(hitBox2.top,hitBox2.lastTop) - ((ob2Delta > 0)?ob2Delta:0),
														hitBox2.size.x,
														Math.max(hitBox2.size.y,hitBox2.lastSize.y) + ((ob2Delta > 0)?ob2Delta: -ob2Delta));
														
				if ((ob1Rect.x + ob1Rect.width > ob2Rect.x) && (ob1Rect.x < ob2Rect.x + ob2Rect.width) && (ob1Rect.y + ob1Rect.height > ob2Rect.y) && (ob1Rect.y < ob2Rect.y + ob2Rect.height))
				{
					var maxOverlap:Number = ob1DeltaAbs + ob2DeltaAbs + 4;
					if (ob1Delta > ob2Delta)
					{
						overlap = (ob1Rect.y + ob1Rect.height) - (ob2Rect.y);
						if (overlap<=maxOverlap && allowCollision & ExtraFunctions.DOWN)
						{
							obj.touching |=  ExtraFunctions.DOWN;
						}else
						{
							overlap = 0;
						}
					}
					else if (ob1Delta < ob2Delta)
					{
						overlap = (ob1Rect.y) - (ob2Rect.y + ob2Rect.height);
						if (overlap<=maxOverlap && allowCollision & ExtraFunctions.UP)
						{
							obj.touching |=  ExtraFunctions.UP;
						}else
						{
							overlap = 0;
						}
					}
				}
				obj.y -= overlap;
			}		
			
		}
		
		private function slopeFormY(ob1:BasicObject):Boolean {
			var slopePoint:Number = ob1.x + hitBox1.centerx - (x + hitBox2.left);	
			var lastSlopePoint:Number = ob1.last.x + hitBox1.lastCenterx - (last.x + hitBox2.lastLeft);
			var yChange:Number = slope[1] - slope[0];
			var slopeCol:Boolean = false;
			var pointHeight:Number = (yChange / hitBox2.size.x) * slopePoint + slope[0];
			var lastPointHeight:Number = (yChange / hitBox2.lastSize.x) * lastSlopePoint + slope[0];
			
			if ((ob1.x + hitBox1.centerx >= x + hitBox2.left) && (ob1.x + hitBox1.centerx <= x + hitBox2.right))
			{
				
				if ((slopePoint >= 0 && slopePoint <=hitBox2.size.x ) || (pointHeight <= Math.max(slope[0],slope[1]) && pointHeight>= Math.min(slope[0],slope[1]))) {
					if (ob1.y +hitBox1.bottom >= y + hitBox2.bottom - pointHeight -2 /*&& (ob1.y - ob1.last.y >=0)*/ && (ob1.y +hitBox1.bottom <= y + hitBox2.bottom - pointHeight +4 || ob1.last.y + hitBox1.lastBottom<= y+hitBox2.bottom -lastPointHeight)){
						slopeCol = true;
					}
				}
			}
			if (slopeCol == true)
			{				
				ob1.y = y - pointHeight;
				ob1.touching |=  ExtraFunctions.DOWN;
				//trace("collide");
			}
			return slopeCol;
			
		}		
	}	
}