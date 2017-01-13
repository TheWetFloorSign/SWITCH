package _blitEngine._blit
{
	
	/**
	 * ...
	 * @author Ben
	 */
	public class BlitSprite 
	{
		
		private var _sheet:String;
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		
		public function BlitSprite(sheet:String, xSheet:int, ySheet:int, width:int, height:int){
			_sheet = sheet;
			_x = xSheet;
			_y = ySheet;
			_width = width;
			_height = height;
			
		}
		
		public function get sheet():String
		{
			return _sheet;
		}
		
		public function get xSheet():int
		{
			return _x;
		}
		
		public function get ySheet():int
		{
			return _y;
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
		
	}
	
}