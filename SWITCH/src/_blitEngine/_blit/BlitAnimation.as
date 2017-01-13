package  _blitEngine._blit{
	import _blitEngine._blit.FrameLibrary;
	public class BlitAnimation{
		
		private var _name:String;
		private var _loop:Boolean;
		private var _library:FrameLibrary;
		private var _frameDelay:int;
		
		
		public var animationSet:Array = new Array();
		
		public function BlitAnimation(name:String,library:FrameLibrary,loop:Boolean=false,frameDelay:int=6) {
			// constructor code
			_name = name;
			_library = library;
			_loop = loop;
			_frameDelay = frameDelay;
		}
		
		public function get name():String{
			return _name;
		}
		public function get loop():Boolean{
			return _loop;
		}
		
		public function get length():int{
			return animationSet.length;
		}
		
		public function get frameDelay():int{
			return _frameDelay;
		}
		
		public function set frameDelay(frames:int):void{
			_frameDelay = frames;
		}
		
		public function addFrame(... frames):void{
			for(var i:int = 0;i<frames.length;i++){
				animationSet.push(_library.getFrame(frames[i]));
			}
			//trace(animationSet[0] + "is aniSet");
			
		}
	}
	
}
