package  _blitEngine._PlayerInput{
	
	import flash.utils.getTimer;
	import flash.utils.Dictionary;
	
	public class ActivationInfo {
		
		private var activations:Array;
		private var sensitiveValues:Dictionary;					// Dictionary with IBinding
		private var sensitiveValuesGamepadIndexes:Dictionary;
		
		private var iix:int;
		private var iic:int;
		private var iit:int;
		private var iii:int;
		private var iiv:int;
		private var iis:Object;	

		public function ActivationInfo() {
			// constructor code
			activations = new Array();
		}
		
		public function addActivation(__bindingInfo:BindingInfo):void {
			activations.push(__bindingInfo);
		}
	
		public function removeActivation(__bindingInfo:BindingInfo):void {
			iix = activations.indexOf(__bindingInfo);
			if (iix > -1) {
				activations.splice(iix, 1);
			}
		}
		
		public function getNumActivations(__timeToleranceSeconds:Number = 0, __gamepadIndex:int = 212121):int {
			// If not time-sensitive, just return it
			if ((__timeToleranceSeconds <= 0 && __gamepadIndex < 0) || activations.length == 0) return activations.length;
			// Otherwise, actually check for activation time and gamepad index
			iit = getTimer() - __timeToleranceSeconds * 1000;
			iic = 0;
			for (iii = 0; iii < activations.length; iii++) {
				if ((__timeToleranceSeconds <= 0 || activations[iii].lastActivatedTime >= iit) ) iic++;
			}
			return iic;
		}
	
		public function resetActivations():void {
			activations.length = 0;
		}
		
		public function addSensitiveValue(__actionId:String, __value:Number, __gamepadIndex:int = 212121):void {
			sensitiveValues[__actionId] = __value;
		}

		public function getValue(__gamepadIndex:int = 212121):Number {
			iiv = NaN;
			for (iis in sensitiveValues) {
				// NOTE: this may be a problem if two different axis control the same action, since -1 is not necessarily better than +0.5
				if ((isNaN(iiv) || Math.abs(sensitiveValues[iis]) > Math.abs(iiv))) iiv = sensitiveValues[iis];
			}
			if (isNaN(iiv)) return getNumActivations(0) == 0 ? 0 : 1;
			return iiv;
		}

	}
	
}
