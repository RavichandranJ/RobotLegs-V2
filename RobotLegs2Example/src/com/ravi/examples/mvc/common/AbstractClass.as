package com.ravi.examples.mvc.common
{
	import com.ravi.examples.mvc.utils.getLogger;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.logging.ILogger;
	
	
	public class AbstractClass
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function get logger():ILogger
		{
			return getLogger(this);
		}
		
		protected function dispatch(event:Event):void
		{
			if (eventDispatcher.hasEventListener(event.type))
				eventDispatcher.dispatchEvent(event);
		}
	}
}