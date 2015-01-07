package com.ravi.examples.mvc.common
{
	import com.ravi.examples.mvc.utils.getLogger;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import mx.logging.ILogger;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;

	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class AbstractCommand extends AbstractClass implements ICommand, IResponder
	{

		public function execute():void
		{
			logger.debug('execute()');
		}	

		public function result(event:Object):void
		{
			logger.debug('result()');
		}

		public function fault(event:Object):void
		{
			logger.error("fault() faultString = {0}, faultDetail = {1}", event.fault.faultString, event.fault.faultDetail);
		}



	}
}
