# Robotlegs 2.2.1

The example applciation will help you to development flex application using Robotlegs 2.2.1 framework.

Please refer to http://www.robotlegs.org/ for downloading and to know more features.

## Adding Context to Main App page.

The configuration wiill added in the main applciation. MVCSBundle is added for installing commonly used extends and configured at ContextMain.as

AppMain.mxml

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

## Configuration

All the classes like Commonds, Mediators, Singletons etc will be registered here for depency injection and event mapping.

ContextMain.as

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

This helps in seperating the common code for implementing Configuration. It extends Abtract class for dispatching events from its subclass and logging.

AbstractConfigure.as

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


## Abstract Class

This is helper class which is extended by other classes like commands abd model classes for dispatching events and log.

AbstractClass.as

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


## Mediators

Mediators plays major roles by seperating the logics from view classes. This will be responsible to registering all the events and dispatching events in the application life cycle.

BooksViewMediator.as

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

AbstractMediator.as

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

BooksView.mxml:

No script tags in mxml views. The will be registered to mediator in config file. Each view will have one mediator associated with view.

```xml
<?xml version="1.0" encoding="utf-8"?>
<s:Panel xmlns:fx="http://ns.adobe.com/mxml/2009"
		 xmlns:s="library://ns.adobe.com/flex/spark"
		 xmlns:mx="library://ns.adobe.com/flex/mx"
		 xmlns:parsley="http://www.spicefactory.org/parsley">
	<s:DataGrid id="datagrid"
				left="10"
				right="10"
				top="10"
				bottom="10"/>

	<s:controlBarContent>
		<s:Button id="btnGetAuthors"
				  label="Get Authors"/>
		<s:Button id="btnGetBooks"
				  label="Get Books"/>		
	</s:controlBarContent>
</s:Panel>

```

## Command



GetBookListCommand.as

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

AbstractCommand.as

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

AppModuleLocator.as

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

