package  _lib._screens{
	
	import _blitEngine.BitCamera;
	import _blitEngine.QuadTree;
	import _blitEngine._gameObjects.BasicObject;
	import _blitEngine._gameObjects.Scene;
	import _lib._gameObjects._components.GraphicsComponent;
	import flash.display.Bitmap;
	import _blitEngine.PlayerInfo;
	import _lib._gameObjects._gui.*;
	import _blitEngine._PlayerInput.KeyboardInput
	import _blitEngine.ExtraFunctions;
	
	public class TitleScreen extends Scene{
				
		[Embed(source="../../../bin/_sprites/TitleSplash.png")]
		private var TitleSplash:Class;
		private var title:Bitmap = new TitleSplash();
		
		private var input:KeyboardInput;
		
		public function TitleScreen(playerInfo:PlayerInfo) {
			this.playerInfo = playerInfo;
		}
		
		
		override public function createAssets():void{
			
			storageArray = [];
			collisionArray = [];
			camera = new BitCamera(1080, 720, 1);
			
			input = new KeyboardInput(ExtraFunctions._stage, playerInfo);
			input.addKeyboardActionBinding("select", PlayerInfo.BUTTON1);
						
			var titleSprite:BasicObject = new BasicObject();
			titleSprite.addComponent(new GraphicsComponent(titleSprite));
			var graph:GraphicsComponent = titleSprite.getComponent(GraphicsComponent);
			graph.sprite = title.bitmapData;
			graph._camera = camera;
			graph.clampX = graph.clampY = true;
			titleSprite.showMe(this);
		}
		
		override public function gameLoop():void
		{
			checkControl();
		}
		
		private function checkControl():void 
		{
			
			if (input.isActionActivated("select"))
			{
				input.stop();
				parent.changeScene("gameScene");
				
				killMe();
			}
		}
	}	
}