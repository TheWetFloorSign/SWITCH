package  _blitEngine{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import _blitEngine.SpritePool;
	import _blitEngine._gameObjects.BasicObject;
	public class PoolManager {
		
		private var poolList:Array = new Array();
		private var counter:int;
		
		public function PoolManager(){
		}
		
		public function createPool(type:Class, len:int = 10):void{
			if(poolExists(type)){
				trace("already exists");
			}else{
				var spritePool:SpritePool = new SpritePool(type, len);
				spritePool.classType = type;
				trace("Making new " + spritePool.classType + " pool.");
				poolList.push(spritePool);
			}
		}
		
		public function getSprite(type:Class):Object{
			if(poolExists(type)){
				return poolList[counter].getSprite();
			}else{
				createPool(type);
				return poolList[poolList.length -1].getSprite();
			}
		}
		
		public function returnSprite(s:Object):void{
			if(poolExists(getClass(s))){
				poolList[counter].returnSprite(s);
			}else{
				trace("Pool doesn't exist.");
			}
		}
		
		private function poolExists(type:Class):Boolean{
			var exists:Boolean = false;
			if(poolList.length > 0){
				for(var i:int = poolList.length - 1; i>-1; i--){
					if(poolList[i].classType == type){
						exists = true;
						counter = i;
						break;
					}
				}
			}
			return exists;
		}
		
		private function getClass(obj:Object):Class{
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
	}	
}