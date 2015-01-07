package com.ravi.examples.mvc.common
{
	import com.ravi.examples.mvc.utils.getLogger;	
	import mx.logging.ILogger;	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	
	public class AbstractMediator extends Mediator
	{
		
		public function get logger():ILogger
		{
			return getLogger(this);
		}
		
		// init
		override public function initialize():void
		{
			
		}
	}
}