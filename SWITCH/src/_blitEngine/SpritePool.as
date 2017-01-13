package  _blitEngine{
	import flash.display.DisplayObject;
	public class SpritePool {
		
		private var pool:Array;
		private var counter:int;
		public var classType:Class;
		
		public function SpritePool(type:Class, len:int){
			pool = new Array();
			counter = len;
			
			var i:int = len;
			while(--i > -1){
				pool[i] = new type();
				pool[i].name = String(type)+i;
			}
		}
		
		public function getSprite():DisplayObject{
			if(counter > 0)
				return pool[--counter];
			else
				return null;
		}
		public function returnSprite(s:DisplayObject):void{
			pool[counter++] = s;
		}
	}
	
}
