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
