package _blitEngine._blit
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	public class BlitFrame
	{
		
		private var _name:String;
		private var _sprite:BlitSprite;
		private var _sheet:String;
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		private var _rotation:Number;
		private var _xOff:Number;
		private var _yOff:Number;
		private var spriteLibrary:SpriteLibrary;
		private var nullPoint:Point = new Point(0, 0);
		
		public function BlitFrame(name:String, sheet:String, xSheet:int, ySheet:int, width:int, height:int, reverse:Boolean = false, rotation:Number = 0, xOff:Number = 0, yOff:Number = 0)
		{
			// constructor code
			_name = name;
			_sheet = sheet;
			_x = xSheet;
			_y = ySheet;
			_width = width;
			_height = height;
			_rotation = rotation;
			_xOff = xOff;
			_yOff = yOff;
			spriteLibrary = SpriteLibrary.getInstance();
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get sprite():BitmapData
		{
			return createBitmapData();
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function get xOff():Number
		{
			return _xOff;
		}
		
		public function get yOff():Number
		{
			return _yOff;
		}
		
		private function createBitmapData():BitmapData
		{
			var newSprite:BitmapData = new BitmapData(_width, _height, true);
			newSprite.copyPixels(spriteLibrary.getSprite(_sheet), new Rectangle(_x, _y, _width, _height),nullPoint);
			return newSprite;
		}
	}

}
