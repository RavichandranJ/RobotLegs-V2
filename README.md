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
