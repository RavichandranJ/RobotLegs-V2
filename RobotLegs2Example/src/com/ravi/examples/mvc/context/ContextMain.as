package com.ravi.examples.mvc.context
{
	import com.ravi.examples.mvc.commands.GetAuthorListCommand;
	import com.ravi.examples.mvc.commands.GetBookListCommand;
	import com.ravi.examples.mvc.delegate.CommonDelegate;
	import com.ravi.examples.mvc.events.CommonEvents;
	import com.ravi.examples.mvc.model.AppModuleLocator;
	import com.ravi.examples.mvc.view.AuthorsView;
	import com.ravi.examples.mvc.view.AuthorsViewMediator;
	import com.ravi.examples.mvc.view.BooksView;
	import com.ravi.examples.mvc.view.BooksViewMediator;
	import com.ravi.examples.mvc.common.AbstractConfigure;
	
	public class ContextMain extends AbstractConfigure
	{	
		override public function configure():void
		{			
			mapInjector();
			mapMediators();
			mapCommands();
			dispatch(new CommonEvents(CommonEvents.GET_BOOK_LIST));
		}
		
		/**
		 * 	Injection Mapping with the Injector Class
		 */
		private function mapInjector():void
		{
			injector.map(AppModuleLocator).asSingleton();
			injector.map(CommonDelegate).asSingleton();
		}
		
		/**
		 * Injection Mapping with the MediatorMap Class
		 */
		private function mapMediators():void
		{
			mediatorMap.map(AuthorsView).toMediator(AuthorsViewMediator);
			mediatorMap.map(BooksView).toMediator(BooksViewMediator);
		}
		
		
		/**
		 *	Injection Mapping with the CommandMap Class
		 */
		private function mapCommands():void
		{
			commandMap.map(CommonEvents.GET_BOOK_LIST).toCommand(GetBookListCommand);
			commandMap.map(CommonEvents.GET_AUTHOR_LIST).toCommand(GetAuthorListCommand);
		}
	}
}
