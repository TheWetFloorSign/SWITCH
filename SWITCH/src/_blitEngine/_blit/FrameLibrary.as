package  _blitEngine._blit{
	import _blitEngine._blit.BlitFrame;
	public class FrameLibrary {
		
		private var frameList:Array = new Array();
		
		public function FrameLibrary(){
		}
		
		public function newFrame(name:String, sheet:String, xSheet:int, ySheet:int, width:int, height:int, reverse:Boolean = false, rotation:Number = 0, xOff:Number = 0, yOff:Number = 0):void{
			if(frameExists(name)){
				trace("Name already taken");
			}else{
				var frame:BlitFrame = new BlitFrame(name,sheet,xSheet,ySheet,width,height,reverse,rotation,xOff,yOff);
				//trace("Making new " + name + " frame. Y sheet is " + ySheet);
				frameList.push(frame);
			}
		}
		
		public function getFrame(name:String):BlitFrame{
			var iFrame:int = 0;
			if(frameList.length > 0){
				for(var i:int = frameList.length - 1; i>-1; i--){
					if(frameList[i].name == name){
						iFrame = i;
						break;
					}
				}
			}
				
			else{
				trace("Frame name doesn't exist");
			}
			return frameList[i];
		}
		
		private function frameExists(name:String):Boolean{
			var exists:Boolean = false;
			if(frameList.length > 0){
				for(var i:int = frameList.length - 1; i>-1; i--){
					if(frameList[i].name == name){
						exists = true;
						break;
					}
				}
			}
			return exists;
		}
	}	
}