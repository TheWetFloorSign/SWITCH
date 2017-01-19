package  _blitEngine._gameObjects{
	
	import _blitEngine._PlayerInput.IInput;
	import _lib._gameObjects._components.GraphicsComponent;
	import _lib._gameObjects._components.HitBox;
	import _blitEngine._gameObjects._components.IComponent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import flash.events.*;
	import _blitEngine.*;
	import _blitEngine.BitCamera;
	
	public class BasicObject{		
				
		// storageArray stores the array that is passed into the worldObject on creation, where this object will be referenced.
		public var _storageArray:Array;
		
		public var _camera:BitCamera;
		
		public var _playerInfo:PlayerInfo;
		
		public var _scene:Object;
		
		public var _alive:Boolean;
		
		public var _exists:Boolean;
		
		public var _immovable:Boolean;
		
		public var touching:uint;
		public var facing:uint = ExtraFunctions.RIGHT;
		
		public var wasTouching:uint;
		
		protected var componentList:Array = new Array();
		
		// movement and physical information
		
		public var last:BitPoint;
		
		public var _x:Number = 0;
		public var _y:Number = 0;
		
		public var _yspeed:Number;
		public var _xspeed:Number;
		
		// xspeed and y speed change the WorldObject's position through updateMe().
		public var input:IInput;
		
		public var aniMachine:AnimationStateMachine;
		
		public var _left:Boolean;
		public var _right:Boolean;
		public var _up:Boolean;
		public var _down:Boolean;	
		
		public var _vector:BitPoint = new BitPoint(0, 0);
		
		public var type:String = "";
		
		public var gc:GraphicsComponent;
		
		/* 
		totalSpeed is used when x and y speeds are linked so that the speed vector doesn't 
		exceed the total intended speed.   */
		public var _totalSpeed:Number;
		
		//------------------------------constructor-------------------------------------------
		
		public function BasicObject() {
		// Define basic stats for new generic object: _tic(a counter) set to zero, lives forever, 
		// base points, dies on hit, only moves down, and basic audio.
			_alive = true;
			_exists = true;
			_immovable = false;
			touching = wasTouching = ExtraFunctions.NONE;
			last = new BitPoint();
			aniMachine = new AnimationStateMachine();
		}
		
		//------------------------------Gets and Sets-------------------------------------------
		public function get alive():Boolean{
			return _alive;
		}
		
		public function get exists():Boolean{
			return _exists;
		}
		
		public function get x():Number{
			return _x;
		}
		
		public function set x(value:Number):void{
			_x = value;
		}
		
		public function get y():Number{
			return _y;
		}
		
		public function set y(value:Number):void{
			_y = value;
		}
		
		//------------------------------Methods-------------------------------------------
		
				
		public function killMe():void{
			_scene.removeGameOb(this);	
			_alive = false;
			_exists = false;
			resetMe();
		}
		
		public function reviveMe():void{
			_alive = true;
			_exists = true;
		}
		
		public function addComponent(comp:IComponent):void{
			componentList.push(comp);
		}
		
		public function getComponent(comp:Class):*{
			if (_scene != null)_scene.incre++;
			for (var i:int = componentList.length -1; i >= 0; i--)
			{
				if (componentList[i] is comp)
				{
					return componentList[i];
				}
			}
			return null;
		}
		
		public function getComponents(comp:Class):Array{
			var compArray:Array = [];
			for (var i:int = componentList.length -1; i >= 0; i--)
			{
				if (componentList[i] is comp)
				{
					compArray.push(componentList[i]);
				}
			}
			if (compArray.length > 0) return compArray;
			return null;
		}
		
		public function updateComponents():void
		{
			
			for (var i:int = componentList.length -1; i >= 0; i--)
			{
				componentList[i].update();
			}
		}
		
		public function resetMe():void{}
		
		public function showMe(scene:Object, playerInfo:PlayerInfo = null):void{
			_camera = scene.camera;
			_scene = scene;
			_scene.addGameOb(this);		
			
			if(playerInfo != null){
				_playerInfo = playerInfo;
			}	
			resetMe();
			onShowMe();
		}
		
		public function onShowMe():void{}
		
		public function updateMe():void{}
		
		public function render():void
		{
			if (gc != null) gc.render();
		}
	}	
}