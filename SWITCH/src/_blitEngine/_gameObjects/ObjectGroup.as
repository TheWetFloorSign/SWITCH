package  _blitEngine._gameObjects{
	
	import flash.events.*;
	import _lib.*;
	
	public class ObjectGroup extends BasicObject{
		
		
		
		//------------------------------constructor-------------------------------------------
		public var members:Array;
		public function ObjectGroup() {
		// Define basic stats for new generic object: _tic(a counter) set to zero, lives forever, 
		// base points, dies on hit, only moves down, and basic audio.
			members = [];
		}
		
		//------------------------------Gets and Sets-------------------------------------------
						
		
		//------------------------------Methods-------------------------------------------
			
		public function add(bo:BasicObject):void{
			members.push(bo);
		}
		
		public function remove(bo:BasicObject):void{
			
		}
		
		override public function killMe():void
		{
			while (members.length != 0)
			{
				members[members.length - 1].killMe();
				members.pop();
			}
			trace("in super");
		}
	}	
}