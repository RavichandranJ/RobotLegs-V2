package com.ravi.examples.mvc.view
{
	import com.ravi.examples.mvc.common.AbstractMediator;
	import com.ravi.examples.mvc.events.CommonEvents;
	import com.ravi.examples.mvc.model.AppModuleLocator;

	public class AuthorsViewMediator extends AbstractMediator
	{	
		
		
		[Inject]
		public var view:AuthorsView;
		
		[Inject]
		public var model:AppModuleLocator;
		
		override public function initialize():void
		{
			// This will listen to event dispatched by other Mediator in the application
			addContextListener(CommonEvents.GET_AUTHOR_LIST, getAuthorsListHandler, CommonEvents);			
			view.list.dataProvider = model.authorList;
		}
		
		
		public function getAuthorsListHandler(event:CommonEvents):void
		{
			view.list.selectedIndex = 0;
			logger.debug('[AuthorsViewPM] getAuthorsListHandler()');
		}		
		
	}
}