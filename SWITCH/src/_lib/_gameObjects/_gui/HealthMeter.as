package  _lib._gameObjects._gui{
	
	import _lib._gameObjects._components.GraphicsComponent;
	import _lib._gameObjects._components.HitBox;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.*;
	import _blitEngine.*;
	import _blitEngine._gameObjects.BasicObject;
	import _blitEngine._blit.BlitAnimation;
	import _blitEngine._blit.FrameLibrary;
	import flash.geom.Matrix;
	
	public class HealthMeter extends BasicObject{
		
		private var _buffer:BitmapData;
		private var lastHealth:int;
		public var _health:int;
		public var _healthCap:int;
		//------------------------------constructor-------------------------------------------
		
		public function HealthMeter(x:Number=0,y:Number=0) {
		// Define basic stats for new generic object: _tic(a counter) set to zero, lives forever, 
		// base points, dies on hit, only moves down, and basic audio.
			_buffer = new BitmapData(1,1);
			_healthCap = 30;
			_health = 21;
			_x = x;
			_y = y;
			lastHealth = _health;
			
			aniMachine = new AnimationStateMachine();
			componentList.push(new GraphicsComponent(this));
			getComponent(GraphicsComponent).clampY = true;
			getComponent(GraphicsComponent).clampX = true;
			setAnimations();
			type = "ui";
		}
		
		//------------------------------Gets and Sets-------------------------------------------
		
		//------------------------------Methods-------------------------------------------
		
				
		override public function killMe():void{
			for(var b:int = _storageArray.length - 1; b > -1; b--){
				if(_storageArray[b] == this){
					_storageArray.splice(b,1);
				}
			}
			resetMe();
		}
		
		override public function showMe(scene:Object, playerInfo:PlayerInfo = null):void{
			_camera = scene.camera;
			
			if(scene.storageArray != null){
				_storageArray = scene.storageArray;
				_storageArray.push(this);
			}		
			
			if(playerInfo != null){
				_playerInfo = playerInfo;
			}	
			
			resetMe();
			onShowMe();
			compileSprite();
		}
		
		private function compileSprite():void{
			if(_health <0)_health = 0;
			if(_health > _healthCap) _health = _healthCap;
			var fill:int = 3;
			var step:int = _healthCap / fill;
			_buffer = new BitmapData(4*(step + 4), 8,true,0x00000000);
			var rTemp:Rectangle = new Rectangle();
			_buffer.copyPixels(aniMachine._library.getFrame("end_l").sprite, new Rectangle(0,0,aniMachine._library.getFrame("end_l").width,aniMachine._library.getFrame("end_l").height), new Point(0,0),null,null,true);
			
			for(var i:int = 1; i<= step+2;i++){
				_buffer.copyPixels(aniMachine._library.getFrame("bar").sprite, new Rectangle(0,0,aniMachine._library.getFrame("bar").width,aniMachine._library.getFrame("bar").height), new Point(i * 4,0),null,null,true);
			}
			_buffer.copyPixels(aniMachine._library.getFrame("end_r").sprite, new Rectangle(0,0,aniMachine._library.getFrame("end_r").width,aniMachine._library.getFrame("end_r").height), new Point((_healthCap/3+3) * 4,0),null,null,true);
			_buffer.copyPixels(aniMachine._library.getFrame("heartR").sprite, new Rectangle(0,0,aniMachine._library.getFrame("heartB").width,aniMachine._library.getFrame("heartB").height), new Point(3,0),null,null,true);
			for( i = 1; i<= step;i++){
				if(i*3 <_health){
					fill = 3;
				}else{
					fill = 3 - (i*3 - _health);
				}
				if(fill<0) fill=0;
				_buffer.copyPixels(aniMachine._library.getFrame("blip"+fill).sprite, new Rectangle(0,0,aniMachine._library.getFrame("blip"+fill).width,aniMachine._library.getFrame("blip"+fill).height), new Point(8 + i * 4,1),null,null,true);
			}
			getComponent(GraphicsComponent).sprite = _buffer;
			getComponent(GraphicsComponent)._camera = _camera;
		}
		
		public function setAnimations():void{
			
			aniMachine._library.newFrame("end_l","healthMeter",0,80,4,8);
			aniMachine._library.newFrame("bar","healthMeter",5,80,4,8);
			aniMachine._library.newFrame("end_r","healthMeter",10,80,4,8);
			aniMachine._library.newFrame("heartB","healthMeter",0,89,8,7);
			aniMachine._library.newFrame("heartR","healthMeter",15,89,8,7);
			aniMachine._library.newFrame("heartU","healthMeter",15,81,8,7);
			aniMachine._library.newFrame("heartP","healthMeter",0,104,8,7);
			aniMachine._library.newFrame("blip3","healthMeter",9,90,5,6);
			aniMachine._library.newFrame("blip2","healthMeter",0,97,5,6);
			aniMachine._library.newFrame("blip1","healthMeter",6,97,5,6);
			aniMachine._library.newFrame("blip0","healthMeter",12,97,5,6);
		}
	}	
}