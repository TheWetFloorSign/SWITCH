package  _blitEngine{
	import _blitEngine._blit.*;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class AnimationStateMachine {
		
		private var stateList:Array;
		
		public var _curFrame:int =0;
		public var aniTic:int=0;
		public var defAnimationDelay:int = 4;
		public var animationDelay:int = 0;
		
		public var _default:BlitAnimation;
		public var _sprite:BitmapData;
		public var _library:FrameLibrary;
		public var animationList:Array;
		public var _transitionVars:Array;
		public var _stateVars:Array;
		private var spriteLibrary:SpriteLibrary;
		
		public function AnimationStateMachine() {
			// constructor code
			stateList = new Array();
			animationList = new Array();
			_library = new FrameLibrary();
			_transitionVars = [];
			_stateVars = [];
			_sprite = new BitmapData(1, 1);
			spriteLibrary = SpriteLibrary.getInstance();
		}
		
		public function get aniState():BlitAnimation{
			return (stateList.length>0)?stateList[stateList.length-1]:_default;
		}
		
		public function get sprite():BitmapData
		{
			return _sprite;
		}
		
		public function set defaultAnimation(_def:String):void{
			_default = findAni(_def);
			_sprite = new BitmapData(aniFrame.width, aniFrame.height,true,0x00000000);
			_sprite.copyPixels(spriteLibrary.getSprite(aniFrame.sheet), new Rectangle(aniFrame.x, aniFrame.y, aniFrame.width, aniFrame.height), new Point(), null, null, true);
		}
		
		public function get aniFrame():BlitFrame{
			if(stateList.length>0) return stateList[stateList.length-1].animationSet[_curFrame];
			else return _default.animationSet[_curFrame];
		}
		
		public function get stateName():String{
			return stateList[stateList.length-1].name;
		}
		public function get states():String{
			var sStates:String = "";
			for(var i:int = 0;i<stateList.length;i++){
				sStates+= stateList[i].name + " ";
			}
			return sStates;
		}
		
		public function updateAni():void{
			aniTic++;
			if(aniTic>=aniState.frameDelay || aniTic ==-1){
				aniTic=-1;
				_curFrame++;
				if(stateList.length<=0){
					stateList.push(_default);
					_curFrame = 0;
				}
				if(_curFrame>=stateList[stateList.length-1].animationSet.length){
					if(stateList[stateList.length-1].loop ==false){
						popState(true);
					}
					_curFrame = 0;
				}
				_sprite = new BitmapData(aniFrame.width, aniFrame.height,true,0x00000000);
				_sprite.copyPixels(spriteLibrary.getSprite(aniFrame.sheet), new Rectangle(aniFrame.x, aniFrame.y, aniFrame.width, aniFrame.height), new Point(), null, null, true);
					
			}
			
		}
		
		public function changeVariables(variable:String, value:*):void
		{
			if (_transitionVars[variable] == undefined)
			{
				return;
			}
			//if (value is typeof(_transitionVars[variable]))
			//{
				_transitionVars[variable] = value;
			//}
			parseTransVars();
		}
		
		public function addVariables(variableObj:Object):void
		{
			for (var tranVar:String in variableObj)
			{
				_transitionVars[tranVar] = variableObj[tranVar];
			}
		}
		
		public function addStateParams(state:String,variableObj:Object):void
		{
			if (findAni(state) == null)
			{
				return;
			}			
			
			_stateVars[state] = variableObj;
		}
		
		public function addState(blit:String, frameBuffer:int = -1, priority:int = 0):void{
			var exists:Boolean = false;
			(frameBuffer ==-1)?animationDelay = defAnimationDelay:animationDelay = frameBuffer;
			for(var i:int = 0; i<stateList.length;i++){
				if(stateList[i] != null && stateList[i].name == blit){
					exists = true;
				}
			}
			if (!exists && blit != ""){
				popState();
				stateList.push(findAni(blit));
				_curFrame = 0;
				aniTic = -1;
				_sprite = new BitmapData(aniFrame.width, aniFrame.height,true,0x00000000);
				_sprite.copyPixels(spriteLibrary.getSprite(aniFrame.sheet), new Rectangle(aniFrame.x, aniFrame.y, aniFrame.width, aniFrame.height), new Point(), null, null, true);
			}
		}
		
		public function popState(all:Boolean = false):void{
			var i:int;
			(all)? i=stateList.length-1 : i=1;
			for(i;i>0;i--){
				stateList.pop();
			}
			
		}
		
		private function parseTransVars():void
		{
			var isMatch:Boolean = true;
			var longest:String;
			var curLength:int;
			var potentialStates:Array = [];
			for (var iState:String in _stateVars) 
			{
				isMatch = true;
				for (var iVar:String in _stateVars[iState])
				{
					if (_stateVars[iState][iVar] != _transitionVars[iVar]){
						isMatch = false;
					}
				}
				if (isMatch)
				{
					potentialStates[iState] = _stateVars[iState];
				}
			}
			//trace(potentialStates);
			for (var iState2:String in potentialStates) 
			{
				var length:int = 0;
				for (var iVar2:String in potentialStates[iState2])
				{
					length++;
				}
				if (length >= curLength)
				{
					longest = iState2;
					curLength = length;
				}
			}
			addState(longest);
			
		}
		
		public function findAni(ani:String):BlitAnimation{
			for (var i:int = 0; i < animationList.length; i++){
				if (animationList[i].name == ani){
					return animationList[i];
				}
			}
			return null;
		}

	}
	
}
