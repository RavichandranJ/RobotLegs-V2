package com.ravi.examples.mvc.commands
{
	import com.ravi.examples.mvc.common.AbstractCommand;
	import com.ravi.examples.mvc.delegate.CommonDelegate;
	import com.ravi.examples.mvc.events.CommonEvents;
	import com.ravi.examples.mvc.model.AppModuleLocator;
	
	public class GetAuthorListCommand extends AbstractCommand
	{
		
		[Inject]
		public var delegate:CommonDelegate;
		
		[Inject]
		public var model:AppModuleLocator;
		
		[Inject]
		public var event:CommonEvents;
		
		override public function execute():void
		{
			logger.debug('[GetAuthorListCommand] execute()');
			delegate.getAuthorList().addResponder(this);
		}
		
		override public function result(event:Object):void
		{
			var result:XML = event.result as XML;
			logger.debug('[GetAuthorListCommand] result() = {0}', result);		
		}	
		
	}
}
