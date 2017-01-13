package _lib._States._SWITCH 
{
	import _blitEngine._States.IState;
	import _blitEngine.BitPoint;
	
	import _blitEngine.ExtraFunctions;
	import _lib._gameObjects._components.HitBox;
	import _lib._gameObjects._components.PhysicsLite;
	
	/**
	 * ...
	 * @author 
	 */
	public class Jump implements IState 
	{
		private var jumpTic:int;
		private var partialBonk:Boolean = true;
		private var fullBonk:Boolean = false;
		private var bonked:Boolean;
		private var groundTouch:Boolean;
		
		private var pl:PhysicsLite;
		private var hb:HitBox;
		
		public function Jump() 
		{
			
		}
		
		
		/* INTERFACE _lib._States.IState */
		
		public function handleInput(actor:*):IState 
		{
			if (!actor._jump){
				pl.vector.y = -2;
				return new Fall();	
			}
			return null;
		}
		
		public function update(actor:*):IState 
		{
			//if (pl.vector.y > -6 && !(actor.touching & ExtraFunctions.UP)) pl.vector.y =-5.5;
			if (actor.touching & ExtraFunctions.UP) bonked = true;
			if (bonked && (fullBonk || partialBonk)) pl.vector.y = 0;
			jumpTic--;
			if (jumpTic <= 0 || (bonked && fullBonk)) return new Fall();
			if (groundTouch == false && actor.touching & ExtraFunctions.DOWN) return new Stand();
			if (!(actor.touching & ExtraFunctions.DOWN)) groundTouch = false;
			return null;
		}
		
		public function enter(actor:*):void 
		{
			pl = actor.getComponent(PhysicsLite);
			hb = actor.getComponent(HitBox);
			pl.vector.y =-6.5;
			jumpTic = 15;
			if (hb.size.x != 16 || hb.size.y != 30){
				hb.newHitBox(new BitPoint(16, 26),new BitPoint(8, 30));
			}
			actor._scene.soundManager.playSound("jump", 0.5);
			actor.aniMachine.changeVariables("ground", false);
			bonked = false;
			groundTouch = (actor.touching & ExtraFunctions.DOWN) > 0;
		}
		
		public function exit(actor:*):void 
		{
		}
		
	}

}