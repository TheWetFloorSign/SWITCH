package _lib._gameObjects{
	import _blitEngine.BitPoint;
	import _blitEngine._gameObjects.BasicObject;
	import _blitEngine._gameObjects.Scene;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import _blitEngine._Managers.IManager;
	
	/**
	 * The SoundManager is a singleton that allows you to have various ways to control sounds in your project.
	 * <p />
	 * The SoundManager can load external or library sounds, pause/mute/stop/control volume for one or more sounds at a time, 
	 * fade sounds up or down, and allows additional control to sounds not readily available through the default classes.
	 * <p />
	 * This class is dependent on TweenLite (http://www.tweenlite.com) to aid in easily fading the volume of the sound.
	 * 
	 * @author Matt Przybylski [http://www.reintroducing.com]
	 * @version 1.0
	 */
	public class LevelManager implements IManager
	{
//- PRIVATE & PROTECTED VARIABLES -------------------------------------------------------------------------

//- PUBLIC & INTERNAL VARIABLES ---------------------------------------------------------------------------
		
		private var levelList:Dictionary = new Dictionary();
		private var currentLevel:BasicObject = new BasicObject;
		private var _scene:Object;
		private var targetName:String;
		private var targetPosition:BitPoint;
//- CONSTRUCTOR	-------------------------------------------------------------------------------------------
	
		// singleton instance of SoundManager
		
		public function LevelManager(scene:Object, level:BasicObject) 
		{
			currentLevel = level;
			_scene = scene;
		}
		
//- PRIVATE & PROTECTED METHODS ---------------------------------------------------------------------------
		
		
		
//- PUBLIC & INTERNAL METHODS -----------------------------------------------------------------------------
	
		/**
		 * Adds a sound from the library to the sounds dictionary for playing in the future.
		 * 
		 * @param $linkageID The class name of the library symbol that was exported for AS
		 * @param $name The string identifier of the sound to be used when calling other methods on the sound
		 * 
		 * @return Boolean A boolean value representing if the sound was added successfully
		 */
		public function add(targ:*):void
		{
		}
		
		public function update():void
		{
		}
		
		public function addLevel(name:String,targ:BasicObject):Boolean
		{
			if (levelList[name] != null) return false;
			levelList[name] = targ;
			return true;
		}
		
		/**
		 * Removes a sound from the sound dictionary.  After calling this, the sound will not be available until it is re-added.
		 * 
		 * @param $name The string identifier of the sound to remove
		 * 
		 * @return void
		 */
		public function changeLevel($name:String, position:BitPoint = null):void
		{
			if (levelList[$name] != undefined)
			{
				targetName = $name;
				targetPosition = position;
				_scene.camera.fadeOut(10, 0x000000, swapLevel);
				_scene.pauseScene = true;
				
			}
			
		}
		
		private function swapLevel():void
		{
			currentLevel.killMe();
			currentLevel = levelList[targetName];
			levelList = new Dictionary();
			currentLevel.showMe(_scene, _scene.playerInfo);
			
			
			
			var list:Array = _scene.getTagged("player");
			var i:Number = 0;
			while (list[i] != undefined)
			{
				if (targetPosition != null)
				{
					list[i].x = list[i].last.x = targetPosition.x;
					list[i].y = list[i].last.y = targetPosition.y;
				}
				
				i++;
			}
			
			_scene.camera.fadeIn(10, 0x000000);
			_scene.pauseScene = false;
		}

//- EVENT HANDLERS ----------------------------------------------------------------------------------------
	
		

//- GETTERS & SETTERS -------------------------------------------------------------------------------------
	
		public function remove(targ:*):void
		{
			
		}
	
//- END CLASS ---------------------------------------------------------------------------------------------
	}
}