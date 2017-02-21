package _blitEngine._blit
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	public class BlitFrame
	{
		
		private var _name:String;
		private var _sheet:String;
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		private var _rotation:Number;
		private var _xOff:Number;
		private var _yOff:Number;
		
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
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get sheet():String
		{
			return _sheet;
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
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function get xOff():Number
		{
			return _xOff;
		}
		
		public function get yOff():Number
		{
			return _yOff;
		}
	}

}
