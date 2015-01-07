# Robotlegs 2.2.1

Robotlegs is an ActionScript application framework for Flash and Flex. It offers:

+ Dependency injection
+ Module management
+ Command management
+ View management
+ Plug-and-play extensions

## Download

http://www.robotlegs.org/

# Quickstart

## Adding Context to Main App page.

To create a Robotlegs application or module you need to instantiate a Context. A context won't do much without some configuration.

We install the MVCSBundle, which in turn installs a number of commonly used Extensions. We then add some custom application configurations.

We pass the instance "this" through as the "contextView" which is required by many of the view related extensions. It must be installed after the bundle or it won't be processed. Also, it should always be added as the final configuration as it may trigger context initialization.

Note: You must hold on to the context instance or it will be garbage collected.

Flex:

```xml
<?xml version="1.0" encoding="utf-8"?>
<s:WindowedApplication xmlns:fx="http://ns.adobe.com/mxml/2009"
					   xmlns:s="library://ns.adobe.com/flex/spark"
					   xmlns:mx="library://ns.adobe.com/flex/mx"
					   xmlns:rl2="http://ns.robotlegs.org/flex/rl2"
					   xmlns:mvcs="robotlegs.bender.bundles.mvcs.*"
					   xmlns:context="com.ravi.examples.mvc.context.*"
					   xmlns:view="com.ravi.examples.mvc.view.*"
					   xmlns:utils="com.ravi.examples.mvc.utils.*">
	<s:layout>
		<s:VerticalLayout gap="10" paddingLeft="10" paddingRight="10" paddingTop="10" paddingBottom="10" />
	</s:layout>
	<fx:Style source="styles.css" />
	<fx:Script>
		<![CDATA[
			import mx.logging.LogEventLevel;
		]]>
	</fx:Script>
	<fx:Declarations>
		<rl2:ContextBuilder>
			<mvcs:MVCSBundle/>
			<context:ContextMain/>
		</rl2:ContextBuilder>

		<utils:EncriptApplicationLog filters="com.ravi.*"
									 includeDate="true"
									 includeTime="true"
									 includeLevel="true"
									 includeCategory="true"
									 level="{LogEventLevel.ALL}"/>
	</fx:Declarations>
	
	<s:Label 
		x="10" y="30"
		fontSize="36"
		text="RobotLegs V2- MVC Framework"/>
	<view:HomeView/>
</s:WindowedApplication>

```

## Context Initialization

If a ContextView is provided the Context is automatically initialized when the supplied view lands on stage. Be sure to install the ContextView last, as it may trigger context initialization.

If a ContextView is not supplied then the Context must be manually initialized.

```as3
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

```
## AbstractConfigure

```as3
package com.ravi.examples.mvc.common
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;

	public class AbstractConfigure extends AbstractClass implements IConfig
	{
		[Inject]
		public var injector:IInjector;

		[Inject]
		public var mediatorMap:IMediatorMap;

		[Inject]
		public var commandMap:IEventCommandMap;

		[Inject]
		public var contextView:ContextView;		
		
		public function configure():void
		{
			
		}
	}
}

```

## Mediators

```as3

package com.ravi.examples.mvc.view
{
	import com.ravi.examples.mvc.commands.GetBookListCommand;
	import com.ravi.examples.mvc.common.AbstractMediator;
	import com.ravi.examples.mvc.events.CommonEvents;
	import com.ravi.examples.mvc.model.AppModuleLocator;
	
	import flash.events.MouseEvent;
	
	import spark.events.GridEvent;

	public class BooksViewMediator extends AbstractMediator
	{

		//-------------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------------
		
		[Inject]
		public var model:AppModuleLocator;

		[Inject]
		public var view:BooksView;


		//-------------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------------

		override public function initialize():void
		{
			// addEventListener - Listening for mouse click evnts
			view.datagrid.addEventListener(GridEvent.GRID_CLICK, gridClickHandler);
			view.btnGetAuthors.addEventListener(MouseEvent.CLICK, getAuthorsList);
			view.btnGetBooks.addEventListener(MouseEvent.CLICK, getBookList);
			
			// addContextListener - Listening for Custom Events dispatched by other views
			addContextListener(CommonEvents.RESET_GRID_INDEX, resetHandler);

			// add dataProvider
			view.datagrid.dataProvider=model.bookList;
		}

		public function gridClickHandler(event:GridEvent):void
		{
			logger.debug('[BooksViewPM] gridClickHandler() rowIndex = {0}', event.rowIndex);
			if (event.rowIndex != -1)
				model.setAuthors(model.bookList[event.rowIndex].authors);
		}

		public function getAuthorsList(event:MouseEvent):void
		{
			logger.debug('[BooksViewPM] getAuthorsList()');
			dispatch(new CommonEvents(CommonEvents.GET_AUTHOR_LIST));
		}
		
		private function getBookList(event:MouseEvent):void
		{
			logger.debug('[BooksViewPM] getBookList()');
			dispatch(new CommonEvents(CommonEvents.GET_BOOK_LIST));
		}
		
		private function resetHandler(event:CommonEvents):void
		{
			logger.debug('[BooksViewPM] resetHandler()');
			view.datagrid.selectedIndex = 0;
		}
		

	}
}


```

## AbstractMediator

```as3

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

```


## Command

```as3

package com.ravi.examples.mvc.commands
{
	import com.ravi.examples.mvc.common.AbstractCommand;
	import com.ravi.examples.mvc.delegate.CommonDelegate;
	import com.ravi.examples.mvc.events.CommonEvents;
	import com.ravi.examples.mvc.model.AppModuleLocator;
	import com.ravi.examples.mvc.vo.BookVO;	
	import mx.collections.ArrayCollection;
	
	public class GetBookListCommand extends AbstractCommand
	{
		
		[Inject]
		public var delegate:CommonDelegate;
		
		[Inject]
		public var model:AppModuleLocator;
		
		[Inject]
		public var event:CommonEvents;
		
		override public function execute():void
		{
			logger.debug('[GetBookListCommand] execute()');
			delegate.getBookList().addResponder(this);
		}
		
		override public function result(event:Object):void
		{
			model.bookList.source = [];
			
			var result:XML = event.result as XML;
			logger.debug('[GetBookListCommand] result() = {0}', result);
			
			var xmlList:XMLList = result..book as XMLList;
			
			for each (var item:XML in xmlList)
			{
				var vo:BookVO = new BookVO();
				vo.authors = getAuthorsList(item..author as XMLList);
				vo.category = item.@category;
				vo.price = item.price;
				vo.title = item.title;
				vo.year = item.year;
				model.bookList.addItem(vo);
			}
			
			model.setAuthors(model.bookList[0].authors);
			dispatch(new CommonEvents(CommonEvents.RESET_GRID_INDEX));
		}
		
		private function getAuthorsList(authorList:XMLList):Array
		{
			var array:Array = [];			
			for each (var item:Object in authorList) 
			{
				array.push(item);
			}
			return array;
		}		
	}
}


```

## Abstract Command

```as3

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


```


## Singleton

```as3

package com.ravi.examples.mvc.model
{
    import com.ravi.examples.mvc.common.AbstractClass;
    import com.ravi.examples.mvc.common.AbstractMediator;
    
    import mx.collections.ArrayCollection;
    import mx.collections.ArrayList;

    [Bindable]
    public class AppModuleLocator extends AbstractClass
    {
        //-------------------------------------------------------------------------
        //
        //	Data Providers
        //
        //-------------------------------------------------------------------------

        public var bookList:ArrayCollection = new ArrayCollection();
        public var authorList:ArrayCollection = new ArrayCollection();

		//-------------------------------------------------------------------------
		//
		//	Functions
		//
		//-------------------------------------------------------------------------
		
        public function setAuthors(array:Array):void
        {
            authorList.source = [];
			
            for (var i:int = 0; i < array.length; i++)
            {
                var item:Object = new Object();
                item.label = array[i].toString();
                authorList.addItem(item);
            }
			logger.debug('[AppModuleLocator] setAuthors() authorList = {0}', array);
        }

    }
}

```

## Abstract Class

```as3

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

```
