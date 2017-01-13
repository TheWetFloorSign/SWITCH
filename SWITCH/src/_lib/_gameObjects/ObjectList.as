package _lib._gameObjects
{
	
	/**
	 * ...
	 * @author Ben
	 */
	import flash.utils.getDefinitionByName;
	import _lib._gameObjects._enemies._minions.*;
	import _lib._gameObjects._other.Door;
	import _lib.*;
	public class ObjectList 
	{
		private static const _classList:Array = [];
		
		RubDummy;
		Dummy;
		BeachBall;
		Door;
		TestJSON2;
		
		_classList["RubDummy"] = getDefinitionByName("_lib._gameObjects._enemies._minions.RubDummy") as Class;
		_classList["Dummy"] = getDefinitionByName("_lib._gameObjects._enemies._minions.Dummy") as Class;
		_classList["BeachBall"] = getDefinitionByName("_lib._gameObjects._enemies._minions.BeachBall") as Class;
		_classList["Door"] = getDefinitionByName("_lib._gameObjects._other.Door") as Class;
		_classList["Level2"] = getDefinitionByName("_lib.TestJSON2") as Class;
		
		public static function classByID(id:String):Class{
			if (_classList[id] == undefined)
			{
				return null;
			}
			return _classList[id];
		}
	}
	
}