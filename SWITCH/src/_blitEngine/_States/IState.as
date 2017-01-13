package _blitEngine._States
{
	import _lib._States.*;
	import _lib._States._SWITCH.*;
	/**
	 * ...
	 * @author 
	 */
	public interface IState 
	{
		function handleInput(actor:*):IState;
		
		function update(actor:*):IState;
		
		function enter(actor:*):void;
		
		function exit(actor:*):void;
	}
	
}