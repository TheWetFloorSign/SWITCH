package _blitEngine{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import _lib._gameObjects._components.HitBox;
	
	public class ExtraFunctions {
			
		public static const UP:uint = 0x0001;
		
		public static const DOWN:uint = 0x0010;
		
		public static const LEFT:uint = 0x0100;
		
		public static const RIGHT:uint = 0x1000;
		
		public static const NONE:uint = 0x0000;
		
		private static var hitbox1:HitBox;
		private static var hitbox2:HitBox;
		
		private static var rec1:Rectangle;
		private static var rec2:Rectangle;
		
		private static var ob1X:Number;
		private static var ob1Y:Number;
		private static var ob1Width:Number;
		private static var ob1Height:Number;
		
		private static var ob2X:Number;
		private static var ob2Y:Number;
		private static var ob2Width:Number;
		private static var ob2Height:Number;
		
		public static var _stage:Stage;

		public function ExtraFunctions() {
			// constructor code
		}
		
		public static function randomRange(min:Number, max:Number, round:Boolean = false):Number{
			if(round){
				return Math.round((Math.random() * (max - min)) + min);
			}else{
				return (Math.random() * (max - min)) + min;
			}
		}
		
		public static function broadCollision(ob1:HitBox, ob2:HitBox):Boolean
		{			
			ob1X = (ob1.parent.x + ob1.left < ob1.parent.last.x + ob1.lastLeft)? ob1.parent.x + ob1.left:ob1.parent.last.x + ob1.lastLeft;
			ob1Y = (ob1.parent.y + ob1.top < ob1.parent.last.y + ob1.lastTop)? ob1.parent.y + ob1.top:ob1.parent.last.y + ob1.lastTop;
			
			ob1Width = (ob1.parent.x + ob1.right > ob1.parent.last.x + ob1.lastRight)? ob1.parent.x + ob1.right - ob1X:ob1.parent.last.x + ob1.lastRight - ob1X;
			ob1Height = (ob1.parent.y + ob1.bottom > ob1.parent.last.y + ob1.lastBottom)? ob1.parent.y + ob1.bottom - ob1Y:ob1.parent.last.y + ob1.lastBottom - ob1Y;
			
			ob2X = (ob2.parent.x + ob2.left < ob2.parent.last.x + ob2.lastLeft)? ob2.parent.x + ob2.left:ob2.parent.last.x + ob2.lastLeft;
			ob2Y = (ob2.parent.y + ob2.top < ob2.parent.last.y + ob2.lastTop)? ob2.parent.y + ob2.top:ob2.parent.last.y + ob2.lastTop;
			
			ob2Width = (ob2.parent.x + ob2.right > ob2.parent.last.x + ob2.lastRight)? ob2.parent.x + ob2.right - ob2X:ob2.parent.last.x + ob2.lastRight - ob2X;
			ob2Height = (ob2.parent.y + ob2.bottom > ob2.parent.last.y + ob2.lastBottom)? ob2.parent.y + ob2.bottom - ob2Y:ob2.parent.last.y + ob2.lastBottom - ob2Y;
			
			if((ob1X + ob1Width > ob2X) && (ob2X + ob2Width > ob1X) && (ob1Y + ob1Height > ob2Y) && (ob2Y + ob2Height > ob1Y))
			{
				return true;
			}
			return false;
		}
		
		public static function broadPhaseRect(ob:HitBox):Rectangle
		{
			var rect:Rectangle = new Rectangle(ob.parent.x + ob.left,
						ob.parent.y + ob.top,
						ob.size.x,
						ob.size.y);
			var xDif:Number = ob.parent.x - ob.parent.last.x;
			var yDif:Number = ob.parent.y - ob.parent.last.y;
			(xDif > 0)?	rect.left -= xDif: rect.right -= xDif;
			(yDif > 0)?	rect.top -= yDif: rect.bottom -= yDif;
			return rect;
		}
		
		
		public static function valueInRange(value:Number, min:Number, max:Number):Boolean{
			return (value >= min) && (value <= max);
		}
		
		public static function sign(value:Number):int
		{
			return (value < 0)? -1:1;
		}

	}
	
}
