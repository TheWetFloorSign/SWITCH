package _lib._gameObjects._other{
	
	import _blitEngine.BitPoint;
	import _blitEngine._gameObjects.BasicObject;
	import _lib._gameObjects.LevelManager;
	import _lib._gameObjects.ObjectList;
	import _lib._gameObjects._components.GraphicsComponent;
	import _lib._gameObjects._components.HitBox;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class Door extends BasicObject{
        
		private var _canvas:Sprite;
		private var _bmdCanvas:BitmapData;
		private var _bmCanvas:Bitmap;
		public var sprite:GraphicsComponent;
		public var hitBox:HitBox;
		
		public var target:String;
		public var position:BitPoint;
		
		public function Door(levelTarget:String = null, positionTarget:BitPoint = null ){
			// initialization
			setAnimations();
			if (levelTarget != null)
			{
				target = levelTarget;
				position = positionTarget;
			}
			
			componentList.push(new GraphicsComponent(this));
			componentList.push(new HitBox(this, 24, 48, 12, 48));
			getComponent(HitBox).collision1 = enterCollision;
			getComponent(HitBox).collision2 = continueCollision;
			type = "";
		}
		//
		//--------------------------- GET/SET METHODS
		//				
		//
		//--------------------------- PUBLIC METHODS 
		//			
		//
		//--------------------------- EVENT HANDLERS
		//
		override public function updateMe():void
		{			
			updateComponents();
			//trace(getComponent(GraphicsComponent)._inView);
		}
		
		override public function resetMe():void{
			
		}	
		
		override public function onShowMe():void{
			
			getComponent(GraphicsComponent).sprite = _bmdCanvas;
			getComponent(GraphicsComponent)._camera = _camera;
		}
		
		public function setAnimations():void{
			_canvas = new Sprite();
			_bmdCanvas = new BitmapData(24,48);
			_canvas.graphics.lineStyle(2, 0x000000);
			_canvas.graphics.beginFill(0x000000);
			_canvas.graphics.drawRect(0,0,_bmdCanvas.width,_bmdCanvas.height);
			_canvas.graphics.endFill();
			
			_bmdCanvas.draw(_canvas);
			
		}
		
		public function enterCollision():void
		{
			var targ:BasicObject = getComponent(HitBox).target;
			if (targ.type == "player" && targ.input.isActionJustActivated("action1"))
			{
			}
		}
		
		public function continueCollision():void
		{
			var targ:BasicObject = getComponent(HitBox).target;
			if (targ.type == "player" && targ.input.isActionActivated("action1"))
			{
				var levelManager:LevelManager = _scene.getManager(LevelManager);
				if (levelManager != null)
				{
					trace("manager is good");
					levelManager.changeLevel(target,position);
				}
			}
		}
	}
}