package _lib._gameObjects._components
{
	import _blitEngine.BitPoint;
	import _blitEngine._gameObjects.BasicObject;
	import _blitEngine._gameObjects._components.IComponent;
	import flash.utils.Dictionary;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	/**
	 * ...
	 * @author Ben
	 */
	public class HitBox implements IComponent
	{
		public static const COL_START:String = "collisionStart";
		public static const COL_CONT:String = "collisionContinue";
		public static const COL_END:String = "collisionEnd";
		
		public var offset:BitPoint = new BitPoint();
		public var size:BitPoint = new BitPoint();
		private var internalCollisionList:Dictionary;
		
		public var lastOffset:BitPoint = new BitPoint();
		public var lastSize:BitPoint = new BitPoint();
		
		private var tempOffset:BitPoint = new BitPoint();
		private var tempSize:BitPoint = new BitPoint();
		
		private var _target:BasicObject;
		private var _parent:BasicObject;
		
		public var collision1:Function;
		public var collision2:Function;
		public var collision3:Function;
		
		public function HitBox(parent:BasicObject,width:Number = 0, height:Number = 0, offsetX:Number = 0, offsetY:Number = 0){
			size = new BitPoint(width, height);
			offset = new BitPoint(offsetX, offsetY);
			tempSize = lastSize = size;
			tempOffset = lastOffset = offset;
			_parent = parent;
			
			internalCollisionList = new Dictionary();
		}
		
		public function get target():BasicObject
		{
			return _target;
		}
		
		public function get parent():BasicObject
		{
			return _parent;
		}
		
		public function newHitBox(sze:BitPoint, offst:BitPoint):void
		{
			tempOffset = offst;
			tempSize = sze;
		}
		
		public function get left():Number
		{
			return -offset.x
		}
		
		public function get right():Number
		{
			return size.x - offset.x;
		}
		
		public function get top():Number
		{
			return -offset.y;
		}
		
		public function get bottom():Number
		{
			return size.y - offset.y;
		}
		
		public function get centerx():Number
		{
			return size.x/2 - offset.x;
		}
		
		public function get centery():Number
		{
			return size.y/2 - offset.y;
		}
		
		public function get lastLeft():Number
		{
			return -lastOffset.x
		}
		
		public function get lastRight():Number
		{
			return lastSize.x - lastOffset.x;
		}
		
		public function get lastTop():Number
		{
			return -lastOffset.y;
		}
		
		public function get lastBottom():Number
		{
			return lastSize.y - lastOffset.y;
		}
		
		public function get lastCenterx():Number
		{
			return lastSize.x/2 - lastOffset.x;
		}
		
		public function get lastCentery():Number
		{
			return lastSize.y/2 - lastOffset.y;
		}
		
		public function update():void
		{
			lastSize = size;
			lastOffset = offset;
			
			size = tempSize;
			offset = tempOffset;
		}
		
		public function collisionResolution(ob:BasicObject):void {	
			_target = ob;
			if (internalCollisionList[ob] == false)
			{
				//this.dispatchEvent(new Event(COL_CONT));
				if(collision2 != null)collision2();
				internalCollisionList[ob] = true;
			}else if(internalCollisionList[ob] == undefined)
			{
				//this.dispatchEvent(new Event(COL_START));
				if(collision1 != null)collision1();
				internalCollisionList[ob] = true;
			}
		}
		
		public function exitCollision():void
		{
			for (var obj:* in internalCollisionList)
			{
				if (internalCollisionList[obj] == false)
				{
					_target = obj;
					//this.dispatchEvent(new Event(COL_END));
					if(collision3 != null)collision3();
					delete internalCollisionList[obj];
				}else{
					internalCollisionList[obj] = false;
				}
				
			}
			
		}
	}
	
}