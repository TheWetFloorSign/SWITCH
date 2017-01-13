package _blitEngine._blit
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class SpriteLibrary
	{
		
		// singleton instance
		private static var _instance:SpriteLibrary;
		private static var _allowInstance:Boolean;
		
		private var _spriteDict:Dictionary;
		
		// singleton instance of SoundManager
		public static function getInstance():SpriteLibrary 
		{
			if (SpriteLibrary._instance == null)
			{
				SpriteLibrary._allowInstance = true;
				SpriteLibrary._instance = new SpriteLibrary();
				SpriteLibrary._allowInstance = false;
			}
			
			return SpriteLibrary._instance;
		}
		
		public function SpriteLibrary() 
		{
			this._spriteDict = new Dictionary(true);
			
			if (!SpriteLibrary._allowInstance)
			{
				throw new Error("Error: Use SpriteLibrary.getInstance() instead of the new keyword.");
			}
		}
		
		public function getSprite(sheet:String):BitmapData
		{
			if (_spriteDict[sheet] != null)
			{
				return _spriteDict[sheet];
			}else{
				throw new Error("No sprite sheet of name " + sheet + " has been added");
				return null;
			}
		}
		
		public function addSprite(sheet:String, bitmap:Bitmap):void
		{
			if (_spriteDict[sheet] != null)
			{
				throw new Error("Sprite sheet of name " + sheet + " has already been added");
			}else{
				_spriteDict[sheet] = bitmap.bitmapData;
			}
		}
		
	}
	
}