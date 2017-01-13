package _blitEngine 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class DebugBox extends Sprite
	{
		private var debugText:TextField;
		private var debugRoot:DisplayObjectContainer;
		public var displayNum:int = 10;
		private var debugLog:Array = [];
		
		public function DebugBox() 
		{
			debugText = new TextField();
			debugText.width = 300;
			debugText.height = 300;
			
		//	addChild(debugText);
		}
		
		public function newDebug(tar:DisplayObjectContainer):void{
			debugRoot = findRoot(tar);
			this.name = "debug";
			if (debugRoot.getChildByName("debug")) debugRoot.removeChild(debugRoot.getChildByName("debug"));
			debugRoot.addChild(this);
			debugText.textColor = 0xFFFFFF;
		}
		
		private function findRoot(tar:DisplayObjectContainer):DisplayObjectContainer{
			if (tar.parent)
			{
				debugRoot = findRoot(tar.parent);
			}else
			{
				debugRoot = tar;
			}
			return debugRoot;
		}
		
		public function debug(note:String, value:* = null):void{
			debugLog.push(note + ": " + value + "\n");
			debugText.text = "";
			for (var i:int = Math.max(0, debugLog.length - displayNum); i < debugLog.length; i++)
			{
				debugText.appendText(debugLog[i]);
			}
			
		}
		
	}

}